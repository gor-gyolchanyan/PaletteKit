//
// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.
//
// In jurisdictions that recognize copyright laws, the author or authors
// of this software dedicate any and all copyright interest in the
// software to the public domain. We make this dedication for the benefit
// of the public at large and to the detriment of our heirs and
// successors. We intend this dedication to be an overt act of
// relinquishment in perpetuity of all present and future rights to this
// software under copyright law.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
// OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// For more information, please refer to <http://unlicense.org/>
//

// MARK: - DefaultRegistryPalette

public struct DefaultRegistryPalette<Preset: Hashable, Sample>: RegistryPalette {

	private typealias Samples = Dictionary<Preset, Sample>

	/// Creates a `DefaultRegistryPalette` given `defaultSample`.
	/// - parameter defaultSample: The sample to be used when a preset has no corresponding sample.
	public init(defaultSample: Sample) {
		self.defaultSample = defaultSample
		self.samples = .init()
	}

	/// The sample to be used when a preset has no corresponding sample.
	public let defaultSample: Sample

	private var samples: Samples

	// MARK: Palette

	public subscript(preset preset: Preset) -> Sample {
		get {
			assert(self.isPresetRegistered(preset), "Attempted to access the sample for preset \(preset) that is not registered.")
			return self.samples[preset, default: self.defaultSample]
		}

		set {
			assert(self.isPresetRegistered(preset), "Attempted to access the sample for preset \(preset) that is not registered.")
			return self.samples[preset, default: self.defaultSample] = newValue
		}
	}

	// MARK: RegistryPalette

	public func isPresetRegistered(_ preset: Preset) -> Bool {
		return self.samples.keys.contains(preset)
	}

	public mutating func registerPreset(_ preset: Preset, for sample: Sample) {
		assert(!self.isPresetRegistered(preset), "Attempted to register the preset \(preset) that is already registered.")
		self.samples.updateValue(sample, forKey: preset)
	}

	public mutating func unregisterPreset(_ preset: Preset) {
		self.samples.removeValue(forKey: preset)
	}
}
