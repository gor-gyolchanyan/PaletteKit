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

// MARK: - AnyRegistryPalette

/// A `RegistryPalette` that type-erases an arbitrary `RegistryPalette`.
public struct AnyRegistryPalette<Preset, Sample>: RegistryPalette {

	/// Creates an `AnyRegistryPalette` by type-erasing `base`.
	///
	/// - parameter base: The `RegistryPalette` to be type-erased.
	public init<Base: RegistryPalette>(_ base: Base) where Base.Preset == Preset, Base.Sample == Sample {
		self.init(AnyRegistryPaletteSpecificCore(base))
	}

	/// The type-erased `RegistryPalette`.
	public var base: Any {
		return self.core.base
	}

	// MARK: RegistryPalette

	public func isPresetRegistered(_ preset: Preset) -> Bool {
		return self.core.isPresetRegistered(preset)
	}

	public mutating func registerPreset(_ preset: Preset, for sample: Sample) {
		self.mutating()
		self.core.registerPreset(preset, for: sample)
	}

	public mutating func unregisterPreset(_ preset: Preset) {
		self.mutating()
		self.core.unregisterPreset(preset)
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

	private init(_ core: AnyRegistryPaletteCore<Preset, Sample>) {
		self.core = core
	}

	fileprivate var core: AnyRegistryPaletteCore<Preset, Sample>

	private mutating func mutating() {
		if !isKnownUniquelyReferenced(&self.core) {
			self.core = self.core.copy()
		}
	}
}

extension RegistryPalette {

	/// Creates a `Self` by extracting it from `any` if the type-erased `RegistryPalette` in `any` is actually a `Self`.
	///
	/// - parameter any: The `AnyRegistryPalette` to extract `Self` from.
	public init?(_ any: AnyRegistryPalette<Preset, Sample>) {
		guard let result = any.core.base as? Self else {
			return nil
		}
		self = result
	}
}

// MARK: - AnyRegistryPaletteCore

fileprivate class AnyRegistryPaletteCore<Preset, Sample>: RegistryPalette {

	fileprivate var base: Any {
		fatalError()
	}

	fileprivate func copy() -> AnyRegistryPaletteCore<Preset, Sample> {
		fatalError()
	}

	// MARK: RegistryPalette

	fileprivate func isPresetRegistered(_ preset: Preset) -> Bool {
		fatalError()
	}

	fileprivate func registerPreset(_ preset: Preset, for sample: Sample) {
		fatalError()
	}

	fileprivate func unregisterPreset(_ preset: Preset) {
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

// MARK: - AnyRegistryPaletteSpecificCore

fileprivate final class AnyRegistryPaletteSpecificCore<Base: RegistryPalette>: AnyRegistryPaletteCore<Base.Preset, Base.Sample> {

	fileprivate init(_ base: Base) {
		self._base = base
	}

	private var _base: Base

	// MARK: AnyRegistryPalettePresetCore

	fileprivate override var base: Any {
		return self._base
	}

	fileprivate override func copy() -> AnyRegistryPaletteCore<Base.Preset, Base.Sample> {
		return AnyRegistryPaletteSpecificCore(self._base)
	}

	// MARK: RegistryPalette

	fileprivate override func isPresetRegistered(_ preset: Preset) -> Bool {
		return self._base.isPresetRegistered(preset)
	}

	fileprivate override func registerPreset(_ preset: Preset, for sample: Sample) {
		self._base.registerPreset(preset, for: sample)
	}

	fileprivate override func unregisterPreset(_ preset: Preset) {
		self._base.unregisterPreset(preset)
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
