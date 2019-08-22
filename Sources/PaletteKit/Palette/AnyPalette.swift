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

// MARK: - AnyPalette

/// A `Palette` that type-erases an arbitrary `Palette`.
public struct AnyPalette<Preset, Sample>: Palette {

	/// Creates an `AnyPalette` by type-erasing `base`.
	///
	/// - parameter base: The `Palette` to be type-erased.
	public init<Base: Palette>(_ base: Base) where Base.Preset == Preset, Base.Sample == Sample {
		self.init(AnyPaletteSpecificCore(base))
	}

	/// The type-erased `Palette`.
	public var base: Any {
		return self.core.base
	}

	// MARK: Palette

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

	private init(_ core: AnyPaletteCore<Preset, Sample>) {
		self.core = core
	}

	fileprivate var core: AnyPaletteCore<Preset, Sample>

	private mutating func mutating() {
		if !isKnownUniquelyReferenced(&self.core) {
			self.core = self.core.copy()
		}
	}
}

extension Palette {

	/// Creates a `Self` by extracting it from `any` if the type-erased `Palette` in `any` is actually a `Self`.
	///
	/// - parameter any: The `AnyPalette` to extract `Self` from.
	public init?(_ any: AnyPalette<Preset, Sample>) {
		guard let result = any.core.base as? Self else {
			return nil
		}
		self = result
	}
}

// MARK: - AnyPaletteCore

fileprivate class AnyPaletteCore<Preset, Sample>: Palette {

	fileprivate var base: Any {
		fatalError()
	}

	fileprivate func copy() -> AnyPaletteCore<Preset, Sample> {
		fatalError()
	}

	// MARK: Palette

	fileprivate subscript(preset preset: Preset) -> Sample {
		get {
			fatalError()
		}

		set {
			fatalError()
		}
	}
}

// MARK: - AnyPaletteSpecificCore

fileprivate final class AnyPaletteSpecificCore<Base: Palette>: AnyPaletteCore<Base.Preset, Base.Sample> {

	fileprivate init(_ base: Base) {
		self._base = base
	}

	private var _base: Base

	// MARK: AnyPalettePresetCore

	fileprivate override var base: Any {
		return self._base
	}

	fileprivate override func copy() -> AnyPaletteCore<Base.Preset, Base.Sample> {
		return AnyPaletteSpecificCore(self._base)
	}

	// MARK: Palette

	fileprivate override subscript(preset preset: Preset) -> Sample {
		get {
			return self._base[preset: preset]
		}

		set {
			self._base[preset: preset] = newValue
		}
	}
}
