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

// MARK: - AnyAllocatorPalette

/// A `AllocatorPalette` that type-erases an arbitrary `AllocatorPalette`.
public struct AnyAllocatorPalette<Preset, Sample>: AllocatorPalette {

	/// Creates an `AnyAllocatorPalette` by type-erasing `base`.
	///
	/// - parameter base: The `AllocatorPalette` to be type-erased.
	public init<Base: AllocatorPalette>(_ base: Base) where Base.Preset == Preset, Base.Sample == Sample {
		self.init(AnyAllocatorPaletteSpecificCore(base))
	}

	/// The type-erased `AllocatorPalette`.
	public var base: Any {
		return self.core.base
	}

	// MARK: AllocatorPalette

	public func isPresetAllocated(_ preset: Preset) -> Bool {
		return self.core.isPresetAllocated(preset)
	}

	public mutating func allocatePreset(for sample: Sample) -> Preset {
		self.mutating()
		return self.core.allocatePreset(for: sample)
	}

	public mutating func deallocatePreset(_ preset: Preset) {
		self.mutating()
		self.core.deallocatePreset(preset)
	}

	public subscript(preset preset: Preset) -> Sample {
		get {
			return self.core[preset: preset]
		}

		set {
			self.mutating()
			self.core[preset: preset] = newValue
		}
	}

	// MARK: Details

	private init(_ core: AnyAllocatorPaletteCore<Preset, Sample>) {
		self.core = core
	}

	fileprivate var core: AnyAllocatorPaletteCore<Preset, Sample>

	private mutating func mutating() {
		if !isKnownUniquelyReferenced(&self.core) {
			self.core = self.core.copy()
		}
	}
}

extension AllocatorPalette {

	/// Creates a `Self` by extracting it from `any` if the type-erased `AllocatorPalette` in `any` is actually a `Self`.
	///
	/// - parameter any: The `AnyAllocatorPalette` to extract `Self` from.
	public init?(_ any: AnyAllocatorPalette<Preset, Sample>) {
		guard let result = any.core.base as? Self else {
			return nil
		}
		self = result
	}
}

// MARK: - AnyAllocatorPaletteCore

fileprivate class AnyAllocatorPaletteCore<Preset, Sample>: AllocatorPalette {

	fileprivate var base: Any {
		fatalError()
	}

	fileprivate func copy() -> AnyAllocatorPaletteCore<Preset, Sample> {
		fatalError()
	}

	// MARK: AllocatorPalette

	fileprivate func isPresetAllocated(_ preset: Preset) -> Bool {
		fatalError()
	}

	fileprivate func allocatePreset(for sample: Sample) -> Preset {
		fatalError()
	}

	fileprivate func deallocatePreset(_ preset: Preset) {
		fatalError()
	}

	fileprivate subscript(preset preset: Preset) -> Sample {
		get {
			fatalError()
		}

		set {
			fatalError()
		}
	}
}

// MARK: - AnyAllocatorPaletteSpecificCore

fileprivate final class AnyAllocatorPaletteSpecificCore<Base: AllocatorPalette>: AnyAllocatorPaletteCore<Base.Preset, Base.Sample> {

	fileprivate init(_ base: Base) {
		self._base = base
	}

	private var _base: Base

	// MARK: AnyAllocatorPalettePresetCore

	fileprivate override var base: Any {
		return self._base
	}

	fileprivate override func copy() -> AnyAllocatorPaletteCore<Base.Preset, Base.Sample> {
		return AnyAllocatorPaletteSpecificCore(self._base)
	}

	// MARK: AllocatorPalette

	fileprivate override func isPresetAllocated(_ preset: Preset) -> Bool {
		return self._base.isPresetAllocated(preset)
	}

	fileprivate override func allocatePreset(for sample: Sample) -> Preset {
		return self._base.allocatePreset(for: sample)
	}

	fileprivate override func deallocatePreset(_ preset: Preset) {
		self._base.deallocatePreset(preset)
	}

	fileprivate override subscript(preset preset: Preset) -> Sample {
		get {
			return self._base[preset: preset]
		}

		set {
			self._base[preset: preset] = newValue
		}
	}
}
