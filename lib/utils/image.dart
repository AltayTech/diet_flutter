import 'dart:io';

import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logifan/widgets/space.dart';

abstract class ImageUtils {
  /// [backOffSizing] determine whether to use backOff dimension if not set
  /// eg. if width is not set, use height instead
  static Widget fromFile(
    File file, {
    double? width,
    double? height,
    Color? color,
    BoxDecoration? decoration,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool isCircle = false,
    BoxFit fit = BoxFit.contain,
    bool backOffSizing = true,
  }) {
    double? measuredHeight = height ?? (backOffSizing ? width : null);
    double? measuredWidth = width ?? (backOffSizing ? height : null);
    Widget image = Image.file(
      file,
      width: measuredWidth,
      height: measuredHeight,
      color: color,
      fit: fit,
    );
    return Container(
      padding: padding,
      margin: margin,
      clipBehavior: Clip.antiAlias,
      decoration: isCircle == true ? AppDecorations.circle : decoration,
      child: image,
    );
  }

  /// [backOffSizing] determine whether to use backOff dimension if not set
  /// eg. if width is not set, use height instead
  static Widget fromLocal(
    String assetName, {
    double? width,
    double? height,
    Color? color,
    BoxDecoration? decoration,
    EdgeInsets? padding,
    EdgeInsets? margin,
    String? placeholder,
    String? package,
    bool isCircle = false,
    BoxFit fit = BoxFit.contain,
    bool backOffSizing = true,
  }) {
    bool isSvg = assetName.split('\.')[1] == 'svg';
    double? measuredHeight = height ?? (backOffSizing ? width : null);
    double? measuredWidth = width ?? (backOffSizing ? height : null);
    Widget image;
    if (isSvg) {
      image = SvgPicture.asset(
        assetName,
        height: measuredHeight,
        width: measuredWidth,
        color: color,
        fit: fit,
        /* errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            placeholder ?? "assets/images/registry/app_logo.svg",
            width: measuredWidth,
            height: measuredHeight,
            color: color,
            fit: fit,
          );
        },*/
        placeholderBuilder: (context) {
          return placeholder != null
              ? SvgPicture.asset(
                  placeholder,
                  width: measuredWidth,
                  height: measuredHeight,
                  color: color,
                  fit: fit,
                )
              : Space(width: measuredWidth, height: measuredHeight);
        },
      );
    } else {
      image = Image.asset(
        assetName,
        width: measuredWidth,
        height: measuredHeight,
        package: package,
        color: color,
        fit: fit,
      );
    }
    return Container(
      padding: padding,
      margin: margin,
      decoration: isCircle == true ? AppDecorations.circle : decoration,
      child: image,
    );
  }

  /// [backOffSizing] determine whether to use backOff dimension if not set
  /// eg. if width is not set, use height instead
  static Widget fromNetwork(
    String? url, {
    double? width,
    double? height,
    Color? color,
    BoxDecoration? decoration,
    EdgeInsets? padding,
    EdgeInsets? margin,
    String? placeholder,
    bool showPlaceholder = true,
    bool isCircle = false,
    BoxFit fit = BoxFit.contain,
    BoxFit placeholderFit = BoxFit.contain,
    bool backOffSizing = true,
  }) {
    double? measuredHeight = height ?? (backOffSizing ? width : null);
    double? measuredWidth = width ?? (backOffSizing ? height : null);
    Widget placeholderImage = fromLocal(
      placeholder ?? 'assets/images/registry/app_logo.svg',
      width: width,
      height: height,
      decoration: decoration,
      padding: padding,
      margin: margin,
      isCircle: isCircle,
      fit: placeholderFit,
      backOffSizing: backOffSizing,
    );
    Widget emptySpace = Container(
      height: measuredHeight,
      width: measuredWidth,
      color: Colors.white70,
      child: Progress(
        size: 3.w,
      ),
    );
    if (url == null) {
      return showPlaceholder ? placeholderImage : emptySpace;
    }
    if (url.endsWith('.svg')) {
      return SvgPicture.network(
        url,
        height: measuredHeight,
        width: measuredWidth,
        color: color,
        fit: fit,
        placeholderBuilder: (context) {
          return showPlaceholder ? placeholderImage : emptySpace;
        },
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      color: color,
      imageBuilder: (context, imageProvider) {
        final decorationImage = DecorationImage(image: imageProvider, fit: fit);
        return Container(
          padding: padding,
          margin: margin,
          width: measuredWidth,
          height: measuredHeight,
          decoration: isCircle == true
              ? AppDecorations.circle.copyWith(image: decorationImage)
              : (decoration ?? AppDecorations.boxNoRadius).copyWith(image: decorationImage),
        );
      },
      errorWidget: (context, url, _) => showPlaceholder ? placeholderImage : emptySpace,
      placeholder: (context, url) => showPlaceholder ? placeholderImage : emptySpace,
    );
  }

  static Widget fromString(
      String assetName, {
        double? width,
        double? height,
        Color? color,
        BoxDecoration? decoration,
        EdgeInsets? padding,
        EdgeInsets? margin,
        String? placeholder,
        bool isCircle = false,
        BoxFit fit = BoxFit.contain,
        bool backOffSizing = true,
      }) {

    double? measuredHeight = height ?? (backOffSizing ? width : null);
    double? measuredWidth = width ?? (backOffSizing ? height : null);
    Widget image;
      image = SvgPicture.string(
        assetName,
        height: measuredHeight,
        width: measuredWidth,
        color: color,
        fit: fit,
        /* errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            placeholder ?? "assets/images/registry/app_logo.svg",
            width: measuredWidth,
            height: measuredHeight,
            color: color,
            fit: fit,
          );
        },*/
        placeholderBuilder: (context) {
          return placeholder != null
              ? SvgPicture.asset(
            placeholder,
            width: measuredWidth,
            height: measuredHeight,
            color: color,
            fit: fit,
          )
              : Space(width: measuredWidth, height: measuredHeight);
        },
      );
    return Container(
      padding: padding,
      margin: margin,
      decoration: isCircle == true ? AppDecorations.circle : decoration,
      child: image,
    );
  }

  static DecorationImage decorationImage(
    String assetName, {
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) {
    return DecorationImage(
      image: AssetImage(assetName),
      alignment: alignment,
      repeat: repeat,
      fit: fit,
    );
  }
}
