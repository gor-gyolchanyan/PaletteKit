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

// MARK: - AllocatorPalette

/// A `Palette` that is also a `Preset` allocator.
public protocol AllocatorPalette: Palette {

	/// Checks if `preset` is allocated.
	/// - parameter preset: The `Preset` to be checked.
	/// - returns: If the check succeeds: `true`, otherwise: `false`.
	func isPresetAllocated(_ preset: Preset) -> Bool

	/// Allocates a `Preset` and corresponds `sample` with it.
	/// - parameter sample: The `Sample` corresponding to the allocated `Preset`.
	/// - returns: The allocated `Preset`.
	mutating func allocatePreset(for sample: Sample) -> Preset

	/// Deallocates `preset`, removing the sample that corresponds to it. Does nothing if `preset` is not allocated.
	/// - parameter preset: The `Preset` to be deallocated.
	mutating func deallocatePreset(_ preset: Preset)
}
