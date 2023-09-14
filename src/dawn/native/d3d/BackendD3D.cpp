// Copyright 2023 The Dawn Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "dawn/native/d3d/BackendD3D.h"

#include <utility>

#include "dawn/common/HashUtils.h"
#include "dawn/common/Log.h"
#include "dawn/native/ChainUtils.h"
#include "dawn/native/D3DBackend.h"
#include "dawn/native/Instance.h"
#include "dawn/native/d3d/D3DError.h"
#include "dawn/native/d3d/PhysicalDeviceD3D.h"
#include "dawn/native/d3d/PlatformFunctions.h"
#include "dawn/native/d3d/UtilsD3D.h"

namespace dawn::native::d3d {

namespace {

ResultOrError<ComPtr<IDXGIFactory4>> CreateFactory(const PlatformFunctions* functions,
                                                   BackendValidationLevel validationLevel) {
    ComPtr<IDXGIFactory4> factory;

    uint32_t dxgiFactoryFlags = 0;
    if (validationLevel != BackendValidationLevel::Disabled) {
        // Enable additional debug layers.
        dxgiFactoryFlags |= DXGI_CREATE_FACTORY_DEBUG;
    }

    if (FAILED(functions->createDxgiFactory2(dxgiFactoryFlags, IID_PPV_ARGS(&factory)))) {
        return DAWN_INTERNAL_ERROR("Failed to create a DXGI factory");
    }

    DAWN_ASSERT(factory != nullptr);
    return std::move(factory);
}

}  // anonymous namespace

Backend::Backend(InstanceBase* instance, wgpu::BackendType type)
    : BackendConnection(instance, type) {}

MaybeError Backend::Initialize(std::unique_ptr<PlatformFunctions> functions) {
    mFunctions = std::move(functions);

    // Check if DXC is available and cache DXC version information
    if (!mFunctions->IsDXCBinaryAvailable()) {
        // DXC version information is not available if DXC binaries are not available.
        mDxcVersionInfo = DxcUnavailable{"DXC binary is not available"};
    } else {
        // Check the DXC version information and validate them being not lower than pre-defined
        // minimum version.
        AcquireDxcVersionInformation();

        // Check that DXC version information is acquired successfully.
        if (std::holds_alternative<DxcVersionInfo>(mDxcVersionInfo)) {
            const DxcVersionInfo& dxcVersionInfo = std::get<DxcVersionInfo>(mDxcVersionInfo);

            // The required minimum version for DXC compiler and validator.
            // Notes about requirement consideration:
            //   * DXC version 1.4 has some known issues when compiling Tint generated HLSL program,
            //   please
            //     refer to crbug.com/tint/1719
            //   * Windows SDK 20348 provides DXC compiler and validator version 1.6
            // Here the minimum version requirement for DXC compiler and validator are both set
            // to 1.6.
            constexpr uint64_t minimumCompilerMajorVersion = 1;
            constexpr uint64_t minimumCompilerMinorVersion = 6;
            constexpr uint64_t minimumValidatorMajorVersion = 1;
            constexpr uint64_t minimumValidatorMinorVersion = 6;

            // Check that DXC compiler and validator version are not lower than minimum.
            if (dxcVersionInfo.DxcCompilerVersion <
                    MakeDXCVersion(minimumCompilerMajorVersion, minimumCompilerMinorVersion) ||
                dxcVersionInfo.DxcValidatorVersion <
                    MakeDXCVersion(minimumValidatorMajorVersion, minimumValidatorMinorVersion)) {
                // If DXC version is lower than required minimum, set mDxcVersionInfo to
                // DxcUnavailable to indicate that DXC is not available.
                std::ostringstream ss;
                ss << "DXC version too low: dxil.dll required version 1.6, actual version "
                   << (dxcVersionInfo.DxcValidatorVersion >> 32) << "."
                   << (dxcVersionInfo.DxcValidatorVersion & ((uint64_t(1) << 32) - 1))
                   << ", dxcompiler.dll required version 1.6, actual version "
                   << (dxcVersionInfo.DxcCompilerVersion >> 32) << "."
                   << (dxcVersionInfo.DxcCompilerVersion & ((uint64_t(1) << 32) - 1));
                mDxcVersionInfo = DxcUnavailable{ss.str()};
            }
        }
    }

    const auto instance = GetInstance();

    DAWN_TRY_ASSIGN(mFactory,
                    CreateFactory(mFunctions.get(), instance->GetBackendValidationLevel()));

    return {};
}

IDXGIFactory4* Backend::GetFactory() const {
    return mFactory.Get();
}

MaybeError Backend::EnsureDxcLibrary() {
    if (mDxcLibrary == nullptr) {
        DAWN_TRY(CheckHRESULT(
            mFunctions->dxcCreateInstance(CLSID_DxcLibrary, IID_PPV_ARGS(&mDxcLibrary)),
            "DXC create library"));
        DAWN_ASSERT(mDxcLibrary != nullptr);
    }
    return {};
}

MaybeError Backend::EnsureDxcCompiler() {
    if (mDxcCompiler == nullptr) {
        DAWN_TRY(CheckHRESULT(
            mFunctions->dxcCreateInstance(CLSID_DxcCompiler, IID_PPV_ARGS(&mDxcCompiler)),
            "DXC create compiler"));
        DAWN_ASSERT(mDxcCompiler != nullptr);
    }
    return {};
}

MaybeError Backend::EnsureDxcValidator() {
    if (mDxcValidator == nullptr) {
        DAWN_TRY(CheckHRESULT(
            mFunctions->dxcCreateInstance(CLSID_DxcValidator, IID_PPV_ARGS(&mDxcValidator)),
            "DXC create validator"));
        DAWN_ASSERT(mDxcValidator != nullptr);
    }
    return {};
}

ComPtr<IDxcLibrary> Backend::GetDxcLibrary() const {
    DAWN_ASSERT(mDxcLibrary != nullptr);
    return mDxcLibrary;
}

ComPtr<IDxcCompiler> Backend::GetDxcCompiler() const {
    DAWN_ASSERT(mDxcCompiler != nullptr);
    return mDxcCompiler;
}

ComPtr<IDxcValidator> Backend::GetDxcValidator() const {
    DAWN_ASSERT(mDxcValidator != nullptr);
    return mDxcValidator;
}

void Backend::AcquireDxcVersionInformation() {
    DAWN_ASSERT(std::holds_alternative<DxcUnavailable>(mDxcVersionInfo));

    auto tryAcquireDxcVersionInfo = [this]() -> ResultOrError<DxcVersionInfo> {
        DAWN_TRY(EnsureDxcValidator());
        DAWN_TRY(EnsureDxcCompiler());

        ComPtr<IDxcVersionInfo> compilerVersionInfo;

        DAWN_TRY(CheckHRESULT(mDxcCompiler.As(&compilerVersionInfo),
                              "D3D12 QueryInterface IDxcCompiler to IDxcVersionInfo"));
        uint32_t compilerMajor, compilerMinor;
        DAWN_TRY(CheckHRESULT(compilerVersionInfo->GetVersion(&compilerMajor, &compilerMinor),
                              "IDxcVersionInfo::GetVersion"));

        ComPtr<IDxcVersionInfo> validatorVersionInfo;

        DAWN_TRY(CheckHRESULT(mDxcValidator.As(&validatorVersionInfo),
                              "D3D12 QueryInterface IDxcValidator to IDxcVersionInfo"));
        uint32_t validatorMajor, validatorMinor;
        DAWN_TRY(CheckHRESULT(validatorVersionInfo->GetVersion(&validatorMajor, &validatorMinor),
                              "IDxcVersionInfo::GetVersion"));

        // Pack major and minor version number into a single version number.
        uint64_t compilerVersion = MakeDXCVersion(compilerMajor, compilerMinor);
        uint64_t validatorVersion = MakeDXCVersion(validatorMajor, validatorMinor);
        return DxcVersionInfo{compilerVersion, validatorVersion};
    };

    auto dxcVersionInfoOrError = tryAcquireDxcVersionInfo();

    if (dxcVersionInfoOrError.IsSuccess()) {
        // Cache the DXC version information.
        mDxcVersionInfo = dxcVersionInfoOrError.AcquireSuccess();
    } else {
        // Error occurs when acquiring DXC version information, set the cache to unavailable and
        // record the error message.
        std::string errorMessage = dxcVersionInfoOrError.AcquireError()->GetFormattedMessage();
        dawn::ErrorLog() << errorMessage;
        mDxcVersionInfo = DxcUnavailable{errorMessage};
    }
}

// Return both DXC compiler and DXC validator version, assert that DXC version information is
// acquired succesfully.
DxcVersionInfo Backend::GetDxcVersion() const {
    DAWN_ASSERT(std::holds_alternative<DxcVersionInfo>(mDxcVersionInfo));
    return DxcVersionInfo(std::get<DxcVersionInfo>(mDxcVersionInfo));
}

// Return true if and only if DXC binary is avaliable, and the DXC version is validated to
// be no older than a pre-defined minimum version.
bool Backend::IsDXCAvailable() const {
    // mDxcVersionInfo hold DxcVersionInfo instead of DxcUnavailable if and only if DXC binaries and
    // version are validated in `Initialize`.
    return std::holds_alternative<DxcVersionInfo>(mDxcVersionInfo);
}

// Return true if and only if IsDXCAvailable() return true, and the DXC compiler and validator
// version are validated to be no older than the minimium version given in parameter.
bool Backend::IsDXCAvailableAndVersionAtLeast(uint64_t minimumCompilerMajorVersion,
                                              uint64_t minimumCompilerMinorVersion,
                                              uint64_t minimumValidatorMajorVersion,
                                              uint64_t minimumValidatorMinorVersion) const {
    // mDxcVersionInfo hold DxcVersionInfo instead of DxcUnavailable if and only if DXC binaries and
    // version are validated in `Initialize`.
    if (std::holds_alternative<DxcVersionInfo>(mDxcVersionInfo)) {
        const DxcVersionInfo& dxcVersionInfo = std::get<DxcVersionInfo>(mDxcVersionInfo);
        // Check that DXC compiler and validator version are not lower than given requirements.
        if (dxcVersionInfo.DxcCompilerVersion >=
                MakeDXCVersion(minimumCompilerMajorVersion, minimumCompilerMinorVersion) &&
            dxcVersionInfo.DxcValidatorVersion >=
                MakeDXCVersion(minimumValidatorMajorVersion, minimumValidatorMinorVersion)) {
            return true;
        }
    }
    return false;
}

const PlatformFunctions* Backend::GetFunctions() const {
    return mFunctions.get();
}

ResultOrError<Ref<PhysicalDeviceBase>> Backend::GetOrCreatePhysicalDeviceFromLUID(LUID luid) {
    auto it = mPhysicalDevices.find(luid);
    if (it != mPhysicalDevices.end()) {
        // If we've already discovered this physical device, return it.
        return it->second;
    }

    ComPtr<IDXGIAdapter1> dxgiAdapter = nullptr;
    DAWN_TRY(CheckHRESULT(GetFactory()->EnumAdapterByLuid(luid, IID_PPV_ARGS(&dxgiAdapter)),
                          "EnumAdapterByLuid"));

    Ref<PhysicalDeviceBase> physicalDevice;
    DAWN_TRY_ASSIGN(physicalDevice, CreatePhysicalDeviceFromIDXGIAdapter(dxgiAdapter));
    mPhysicalDevices.emplace(luid, physicalDevice);
    return physicalDevice;
}

ResultOrError<Ref<PhysicalDeviceBase>> Backend::GetOrCreatePhysicalDeviceFromIDXGIAdapter(
    ComPtr<IDXGIAdapter> dxgiAdapter) {
    DXGI_ADAPTER_DESC desc;
    DAWN_TRY(CheckHRESULT(dxgiAdapter->GetDesc(&desc), "IDXGIAdapter::GetDesc"));

    auto it = mPhysicalDevices.find(desc.AdapterLuid);
    if (it != mPhysicalDevices.end()) {
        // If we've already discovered this physical device, return it.
        return it->second;
    }

    Ref<PhysicalDeviceBase> physicalDevice;
    DAWN_TRY_ASSIGN(physicalDevice, CreatePhysicalDeviceFromIDXGIAdapter(dxgiAdapter));
    mPhysicalDevices.emplace(desc.AdapterLuid, physicalDevice);
    return physicalDevice;
}

std::vector<Ref<PhysicalDeviceBase>> Backend::DiscoverPhysicalDevices(
    const RequestAdapterOptions* options) {
    if (options->forceFallbackAdapter) {
        return {};
    }

    FeatureLevel featureLevel =
        options->compatibilityMode ? FeatureLevel::Compatibility : FeatureLevel::Core;

    const RequestAdapterOptionsLUID* luidOptions = nullptr;
    FindInChain(options->nextInChain, &luidOptions);

    // Get or create just the physical device matching the dxgi adapter.
    if (luidOptions != nullptr) {
        Ref<PhysicalDeviceBase> physicalDevice;
        if (GetInstance()->ConsumedErrorAndWarnOnce(
                GetOrCreatePhysicalDeviceFromLUID(luidOptions->adapterLUID), &physicalDevice) ||
            !physicalDevice->SupportsFeatureLevel(featureLevel)) {
            return {};
        }
        return {std::move(physicalDevice)};
    }

    // Enumerate and discover all available physicalDevices.
    std::vector<Ref<PhysicalDeviceBase>> physicalDevices;
    for (uint32_t adapterIndex = 0;; ++adapterIndex) {
        ComPtr<IDXGIAdapter1> dxgiAdapter = nullptr;
        if (GetFactory()->EnumAdapters1(adapterIndex, &dxgiAdapter) == DXGI_ERROR_NOT_FOUND) {
            break;  // No more physicalDevices to enumerate.
        }

        Ref<PhysicalDeviceBase> physicalDevice;
        if (GetInstance()->ConsumedErrorAndWarnOnce(
                GetOrCreatePhysicalDeviceFromIDXGIAdapter(std::move(dxgiAdapter)),
                &physicalDevice) ||
            !physicalDevice->SupportsFeatureLevel(featureLevel)) {
            continue;
        }
        physicalDevices.push_back(std::move(physicalDevice));
    }
    return physicalDevices;
}

void Backend::ClearPhysicalDevices() {
    mPhysicalDevices.clear();
}

size_t Backend::GetPhysicalDeviceCountForTesting() const {
    return mPhysicalDevices.size();
}

size_t Backend::LUIDHashFunc::operator()(const LUID& luid) const {
    size_t hash = 0;
    dawn::HashCombine(&hash, luid.LowPart, luid.HighPart);
    return hash;
}

bool Backend::LUIDEqualFunc::operator()(const LUID& a, const LUID& b) const {
    return std::tie(a.LowPart, a.HighPart) == std::tie(b.LowPart, b.HighPart);
}

}  // namespace dawn::native::d3d
