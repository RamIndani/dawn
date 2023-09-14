// Copyright 2022 The Dawn Authors
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

#include <vector>

#include "dawn/native/Buffer.h"
#include "dawn/native/CommandEncoder.h"
#include "dawn/tests/DawnTest.h"
#include "dawn/tests/white_box/GPUTimestampCalibrationTests.h"
#include "dawn/utils/ComboRenderPipelineDescriptor.h"
#include "dawn/utils/WGPUHelpers.h"

namespace dawn {
namespace {

using FeatureName = wgpu::FeatureName;
enum class EncoderType { NonPass, ComputePass, RenderPass };

std::ostream& operator<<(std::ostream& o, EncoderType type) {
    switch (type) {
        case EncoderType::NonPass:
            o << "NonPass";
            break;
        case EncoderType::ComputePass:
            o << "ComputePass";
            break;
        case EncoderType::RenderPass:
            o << "RenderPass";
            break;
        default:
            UNREACHABLE();
            break;
    }

    return o;
}

DAWN_TEST_PARAM_STRUCT(GPUTimestampCalibrationTestParams, FeatureName, EncoderType);

class ExpectBetweenTimestamps : public detail::Expectation {
  public:
    ~ExpectBetweenTimestamps() override = default;

    ExpectBetweenTimestamps(uint64_t minValue, uint64_t maxValue, float errorToleranceRatio = 0.0f)
        : mMinValue(minValue), mMaxValue(maxValue), mErrorToleranceRatio(errorToleranceRatio) {}

    // Expect the actual results are between mMinValue and mMaxValue with error tolerance ratio.
    testing::AssertionResult Check(const void* data, size_t size) override {
        const uint64_t* actual = static_cast<const uint64_t*>(data);

        if (mErrorToleranceRatio != 0.0f) {
            mMinValue -=
                static_cast<uint64_t>(static_cast<double>(mMinValue * mErrorToleranceRatio));
            mMaxValue +=
                static_cast<uint64_t>(static_cast<double>(mMaxValue * mErrorToleranceRatio));
        }

        for (size_t i = 0; i < size / sizeof(uint64_t); ++i) {
            if (actual[i] < mMinValue || actual[i] > mMaxValue) {
                return testing::AssertionFailure()
                       << "Expected data[" << i << "] to be between " << mMinValue << " and "
                       << mMaxValue << ", actual " << actual[i] << std::endl;
            }
        }

        return testing::AssertionSuccess();
    }

  private:
    uint64_t mMinValue;
    uint64_t mMaxValue;
    float mErrorToleranceRatio;
};

class GPUTimestampCalibrationTests : public DawnTestWithParams<GPUTimestampCalibrationTestParams> {
  protected:
    void SetUp() override {
        DawnTestWithParams<GPUTimestampCalibrationTestParams>::SetUp();

        DAWN_TEST_UNSUPPORTED_IF(UsesWire());
        // Requires that timestamp query feature is enabled and timestamp query conversion is
        // disabled.
        DAWN_TEST_UNSUPPORTED_IF(!mIsFeatureSupported);
        // The "timestamp-query-inside-passes" feature is not supported on command encoder.
        DAWN_TEST_UNSUPPORTED_IF(GetParam().mFeatureName ==
                                     wgpu::FeatureName::TimestampQueryInsidePasses &&
                                 GetParam().mEncoderType == EncoderType::NonPass);

        mBackend = GPUTimestampCalibrationTestBackend::Create(device);
        DAWN_TEST_UNSUPPORTED_IF(!mBackend->IsSupported());
    }

    void TearDown() override {
        mBackend = nullptr;
        DawnTestWithParams::TearDown();
    }

    std::vector<wgpu::FeatureName> GetRequiredFeatures() override {
        std::vector<wgpu::FeatureName> requiredFeatures = {};
        if (SupportsFeatures({GetParam().mFeatureName})) {
            requiredFeatures.push_back(GetParam().mFeatureName);
            mIsFeatureSupported = true;
        }
        return requiredFeatures;
    }

    wgpu::ComputePipeline CreateComputePipeline() {
        wgpu::ShaderModule module = utils::CreateShaderModule(device, R"(
            @compute @workgroup_size(1)
            fn main() {
            })");

        wgpu::ComputePipelineDescriptor descriptor;
        descriptor.compute.module = module;
        descriptor.compute.entryPoint = "main";

        return device.CreateComputePipeline(&descriptor);
    }

    wgpu::RenderPipeline CreateRenderPipeline() {
        utils::ComboRenderPipelineDescriptor descriptor;
        descriptor.vertex.module = utils::CreateShaderModule(device, R"(
                @vertex
                fn main(@builtin(vertex_index) VertexIndex : u32) -> @builtin(position) vec4f {
                    var pos = array(
                        vec2f( 1.0,  1.0),
                        vec2f(-1.0, -1.0),
                        vec2f( 1.0, -1.0));
                    return vec4f(pos[VertexIndex], 0.0, 1.0);
                })");
        descriptor.cFragment.module = utils::CreateShaderModule(device, R"(
                @fragment fn main() -> @location(0) vec4f {
                    return vec4f(0.0, 1.0, 0.0, 1.0);
                })");

        return device.CreateRenderPipeline(&descriptor);
    }

    void EncodeTimestampQueryOnComputePass(const wgpu::CommandEncoder& encoder,
                                           const wgpu::QuerySet& querySet) {
        switch (GetParam().mFeatureName) {
            case wgpu::FeatureName::TimestampQuery: {
                std::vector<wgpu::ComputePassTimestampWrite> timestampWrites;
                timestampWrites.push_back(
                    {querySet, 0, wgpu::ComputePassTimestampLocation::Beginning});
                timestampWrites.push_back({querySet, 1, wgpu::ComputePassTimestampLocation::End});

                wgpu::ComputePassDescriptor descriptor;
                descriptor.timestampWriteCount = timestampWrites.size();
                descriptor.timestampWrites = timestampWrites.data();

                wgpu::ComputePassEncoder pass = encoder.BeginComputePass(&descriptor);
                pass.SetPipeline(CreateComputePipeline());
                pass.DispatchWorkgroups(1);
                pass.End();
                break;
            }
            case wgpu::FeatureName::TimestampQueryInsidePasses: {
                wgpu::ComputePassEncoder pass = encoder.BeginComputePass();
                pass.WriteTimestamp(querySet, 0);
                pass.SetPipeline(CreateComputePipeline());
                pass.DispatchWorkgroups(1);
                pass.WriteTimestamp(querySet, 1);
                pass.End();
                break;
            }
            default:
                break;
        }
    }

    void EncodeTimestampQueryOnRenderPass(const wgpu::CommandEncoder& encoder,
                                          const wgpu::QuerySet& querySet) {
        constexpr static unsigned int kRTSize = 4;
        utils::BasicRenderPass renderPass = utils::CreateBasicRenderPass(device, kRTSize, kRTSize);

        switch (GetParam().mFeatureName) {
            case wgpu::FeatureName::TimestampQuery: {
                std::vector<wgpu::RenderPassTimestampWrite> timestampWrites;
                timestampWrites.push_back(
                    {querySet, 0, wgpu::RenderPassTimestampLocation::Beginning});
                timestampWrites.push_back({querySet, 1, wgpu::RenderPassTimestampLocation::End});

                renderPass.renderPassInfo.timestampWriteCount = timestampWrites.size();
                renderPass.renderPassInfo.timestampWrites = timestampWrites.data();

                wgpu::RenderPassEncoder pass = encoder.BeginRenderPass(&renderPass.renderPassInfo);
                pass.SetPipeline(CreateRenderPipeline());
                pass.Draw(3);
                pass.End();
                break;
            }
            case wgpu::FeatureName::TimestampQueryInsidePasses: {
                wgpu::RenderPassEncoder pass = encoder.BeginRenderPass(&renderPass.renderPassInfo);
                pass.WriteTimestamp(querySet, 0);
                pass.SetPipeline(CreateRenderPipeline());
                pass.Draw(3);
                pass.WriteTimestamp(querySet, 1);
                pass.End();
                break;
            }
            default:
                break;
        }
    }

    void RunTest() {
        constexpr uint32_t kQueryCount = 2;

        // Create query set
        wgpu::QuerySetDescriptor querySetDescriptor;
        querySetDescriptor.count = kQueryCount;
        querySetDescriptor.type = wgpu::QueryType::Timestamp;
        wgpu::QuerySet querySet = device.CreateQuerySet(&querySetDescriptor);

        // Create resolve buffer
        wgpu::BufferDescriptor bufferDescriptor;
        bufferDescriptor.size = kQueryCount * sizeof(uint64_t);
        bufferDescriptor.usage = wgpu::BufferUsage::QueryResolve | wgpu::BufferUsage::CopySrc |
                                 wgpu::BufferUsage::CopyDst;
        wgpu::Buffer destination = device.CreateBuffer(&bufferDescriptor);

        // Encode timestamp query
        wgpu::CommandEncoder encoder = device.CreateCommandEncoder();
        switch (GetParam().mEncoderType) {
            case EncoderType::NonPass: {
                // The "timestamp-query-inside-passes" feature is not supported on command encoder
                DAWN_ASSERT(GetParam().mFeatureName !=
                            wgpu::FeatureName::TimestampQueryInsidePasses);
                encoder.WriteTimestamp(querySet, 0);
                encoder.WriteTimestamp(querySet, 1);
                break;
            }
            case EncoderType::ComputePass: {
                EncodeTimestampQueryOnComputePass(encoder, querySet);
                break;
            }
            case EncoderType::RenderPass: {
                EncodeTimestampQueryOnRenderPass(encoder, querySet);
                break;
            }
        }
        wgpu::CommandBuffer commands = encoder.Finish();

        // Start calibration between GPU timestamp and CPU timestamp
        uint64_t gpuTimestamp0, gpuTimestamp1;
        uint64_t cpuTimestamp0, cpuTimestamp1;
        mBackend->GetTimestampCalibration(&gpuTimestamp0, &cpuTimestamp0);
        queue.Submit(1, &commands);
        WaitForAllOperations();
        mBackend->GetTimestampCalibration(&gpuTimestamp1, &cpuTimestamp1);

        // Separate resolve queryset to reduce the execution time of the queue with WriteTimestamp,
        // so that the timestamp in the querySet will be closer to both gpuTimestamps from
        // GetClockCalibration.
        wgpu::CommandEncoder resolveEncoder = device.CreateCommandEncoder();
        resolveEncoder.ResolveQuerySet(querySet, 0, kQueryCount, destination, 0);
        wgpu::CommandBuffer resolveCommands = resolveEncoder.Finish();
        queue.Submit(1, &resolveCommands);

        float errorToleranceRatio = 0.0f;
        if (!HasToggleEnabled("disable_timestamp_query_conversion")) {
            float period = mBackend->GetTimestampPeriod();
            gpuTimestamp0 = static_cast<uint64_t>(static_cast<double>(gpuTimestamp0 * period));
            gpuTimestamp1 = static_cast<uint64_t>(static_cast<double>(gpuTimestamp1 * period));

            // We have 15 bits of precision in the timestamp query conversion so we
            // expect that for the error tolerance.
            errorToleranceRatio = 1.0 / (1 << 15);  // about 3e-5.
        }

        EXPECT_BUFFER(
            destination, 0, kQueryCount * sizeof(uint64_t),
            new ExpectBetweenTimestamps(gpuTimestamp0, gpuTimestamp1, errorToleranceRatio));
    }

  private:
    std::unique_ptr<GPUTimestampCalibrationTestBackend> mBackend;
    bool mIsFeatureSupported = false;
};

// Check that the timestamps got by timestamp query are between the two timestamps from
// GetClockCalibration() with the 'disable_timestamp_query_conversion' toggle disabled or enabled.
TEST_P(GPUTimestampCalibrationTests, TimestampsCalibration) {
    RunTest();
}

DAWN_INSTANTIATE_TEST_P(
    GPUTimestampCalibrationTests,
    // Test with the disable_timestamp_query_conversion toggle forced on and off.
    {D3D12Backend({"disable_timestamp_query_conversion"}, {}),
     D3D12Backend({}, {"disable_timestamp_query_conversion"}),
     MetalBackend({"disable_timestamp_query_conversion"}, {}),
     MetalBackend({}, {"disable_timestamp_query_conversion"})},
    {wgpu::FeatureName::TimestampQuery, wgpu::FeatureName::TimestampQueryInsidePasses},
    {EncoderType::NonPass, EncoderType::ComputePass, EncoderType::RenderPass});

}  // anonymous namespace
}  // namespace dawn
