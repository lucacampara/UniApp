/*
 Copyright 2016-present the Material Components for iOS authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <UIKit/UIKit.h>

/** The name of the tint 50 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteTint50Name;

/** The name of the tint 100 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteTint100Name;

/** The name of the tint 200 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteTint200Name;

/** The name of the tint 300 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteTint300Name;

/** The name of the tint 400 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteTint400Name;

/** The name of the tint 500 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteTint500Name;

/** The name of the tint 600 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteTint600Name;

/** The name of the tint 700 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteTint700Name;

/** The name of the tint 800 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteTint800Name;

/** The name of the tint 900 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteTint900Name;

/** The name of the accent 100 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteAccent100Name;

/** The name of the accent 200 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteAccent200Name;

/** The name of the accent 400 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteAccent400Name;

/** The name of the accent 700 color when creating a custom palette. */
CG_EXTERN const NSString *_Nonnull MDCPaletteAccent700Name;

/**
 A palette of Material colors.

 Material palettes have a set of named tint colors and an optional set of named accent colors. This
 class provides access to the pre-defined set of Material palettes. MDCPalette objects are
 immutable; it is safe to use them from multiple threads in your app.

 @see https://material.io/guidelines/style/color.html#color-color-palette
 */
@interface MDCPalette : NSObject

/** The red palette. */
+ (nonnull MDCPalette *)redPalette;

/** The pink palette. */
+ (nonnull MDCPalette *)pinkPalette;

/** The purple palette. */
+ (nonnull MDCPalette *)purplePalette;

/** The deep purple palette. */
+ (nonnull MDCPalette *)deepPurplePalette;

/** The indigo palette. */
+ (nonnull MDCPalette *)indigoPalette;

/** The blue palette. */
+ (nonnull MDCPalette *)bluePalette;

/** The light blue palette. */
+ (nonnull MDCPalette *)lightBluePalette;

/** The cyan palette. */
+ (nonnull MDCPalette *)cyanPalette;

/** The teal palette. */
+ (nonnull MDCPalette *)tealPalette;

/** The green palette. */
+ (nonnull MDCPalette *)greenPalette;

/** The light green palette. */
+ (nonnull MDCPalette *)lightGreenPalette;

/** The lime palette. */
+ (nonnull MDCPalette *)limePalette;

/** The yellow palette. */
+ (nonnull MDCPalette *)yellowPalette;

/** The amber palette. */
+ (nonnull MDCPalette *)amberPalette;

/** The orange palette. */
+ (nonnull MDCPalette *)orangePalette;

/** The deep orange palette. */
+ (nonnull MDCPalette *)deepOrangePalette;

/** The brown palette (no accents). */
+ (nonnull MDCPalette *)brownPalette;

/** The grey palette (no accents). */
+ (nonnull MDCPalette *)greyPalette;

/** The blue grey palette (no accents). */
+ (nonnull MDCPalette *)blueGreyPalette;

/**
 Returns a palette generated from a single target 500 tint color.

 TODO(ajsecord): Document the algorithm used to generate the palette.

 @param target500Color The target "500" color in the palette.
 @return A palette generated with a 500 color matching the target color.
 */
+ (nonnull instancetype)paletteGeneratedFromColor:(nonnull UIColor *)target500Color;

/**
 Returns a palette with a custom set of tints and accents.

 The tints dictionary must have values for each key matching MDCPaletteTint.*Name. The accents
 dictionary, if specified, may have entries for each key matching MDCPaletteAccent.*Name. Missing
 accent values will cause an assert in debug mode and will return +[UIColor clearColor] in release
 mode when the corresponding property is acccessed.

 @param tints A dictionary mapping MDCPaletteTint.*Name keys to UIColors.
 @param accents An optional dictionary mapping MDCPaletteAccent.*Name keys to UIColors.
 @return An palette containing the custom colors.
 */
+ (nonnull instancetype)paletteWithTints:(nonnull NSDictionary<const NSString *, UIColor *> *)tints
                                 accents:
                                     (nullable NSDictionary<const NSString *, UIColor *> *)accents;

/**
 Returns an initialized palette object with a custom set of tints and accents.

 The tints dictionary must have values for each key matching MDCPaletteTint.*Name. The accents
 dictionary, if specified, may have entries for each key matching MDCPaletteAccent.*Name. Missing
 accent values will cause an assert in debug mode and will return +[UIColor clearColor] in release
 mode when the corresponding property is acccessed.

 @param tints A dictionary mapping MDCPaletteTint.*Name keys to UIColors.
 @param accents An optional dictionary mapping MDCPaletteAccent.*Name keys to UIColors.
 @return An initialized MDCPalette object containing the custom colors.
 */
- (nonnull instancetype)initWithTints:(nonnull NSDictionary<const NSString *, UIColor *> *)tints
                              accents:(nullable NSDictionary<const NSString *, UIColor *> *)accents;

/** The 50 tint color, the lightest tint of the palette. */
@property(nonatomic, nonnull, readonly) UIColor *tint50;

/** The 100 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint100;

/** The 200 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint200;

/** The 300 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint300;

/** The 400 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint400;

/** The 500 tint color, the representative tint of the palette. */
@property(nonatomic, nonnull, readonly) UIColor *tint500;

/** The 600 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint600;

/** The 700 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint700;

/** The 800 tint color. */
@property(nonatomic, nonnull, readonly) UIColor *tint800;

/** The 900 tint color, the darkest tint of the palette. */
@property(nonatomic, nonnull, readonly) UIColor *tint900;

/** The A100 accent color, the lightest accent color. */
@property(nonatomic, nullable, readonly) UIColor *accent100;

/** The A200 accent color. */
@property(nonatomic, nullable, readonly) UIColor *accent200;

/** The A400 accent color. */
@property(nonatomic, nullable, readonly) UIColor *accent400;

/** The A700 accent color, the darkest accent color. */
@property(nonatomic, nullable, readonly) UIColor *accent700;

@end
