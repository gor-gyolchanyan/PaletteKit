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

// MARK: - DefaultAllocatorPalette

/// An `AllocatorPalette` that provides highly optimized operations.
public struct DefaultAllocatorPalette<Sample>: AllocatorPalette {

	fileprivate typealias Samples = ContiguousArray<Sample?>

	private typealias ClearedPresets = ContiguousArray<Preset.Index>

	////// Creates an empty `DefaultAllocatorPalette`
	public init() {
		self.samples = .init()
		self.recycledIndices = .init()
	}

	private var samples: Samples

	private var recycledIndices: ClearedPresets

	// MARK: Palette

	public subscript(preset preset: Preset) -> Sample {
		get {
			assert(self.isPresetAllocated(preset), "Attempted to access the sample for preset \(preset) that is not allocated.")
			return self.samples[preset.index]!
		}

		set {
			assert(self.isPresetAllocated(preset), "Attempted to access the sample for preset \(preset) that is not allocated.")
			self.samples[preset.index] = newValue
		}
	}

	// MARK: AllocatorPalette

	public typealias Preset = DefaultAllocatorPalettePreset

	public func isPresetAllocated(_ preset: Preset) -> Bool {
		return self.samples.indices.contains(preset.index) && self.samples[preset.index] != nil
	}

	public mutating func allocatePreset(for sample: Sample) -> Preset {
		let index: Preset.Index
		if let recycledIndex = self.recycledIndices.popLast() {
			index = recycledIndex
		} else {
			index = self.samples.endIndex
			self.samples.append(nil)
		}
		self.samples[index] = sample
		return .init(index)
	}

	public mutating func deallocatePreset(_ preset: Preset) {
		guard self.isPresetAllocated(preset) else {
			return
		}
		self.samples[preset.index] = nil
		self.recycledIndices.append(preset.index)
	}
}

// MARK: DefaultAllocatorPalettePreset

/// The `Preset` of a `DefaultAllocatorPalette`.
public struct DefaultAllocatorPalettePreset: Hashable, CustomStringConvertible {

	fileprivate typealias Index = Int

	fileprivate init(_ index: Index) {
		self.index = index
	}

	fileprivate let index: Index

	// MARK: Self: CustomStringConvertible

	public var description: String {
		return "#\(self.index)"
	}
}
