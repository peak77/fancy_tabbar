/*
 *  Copyright 2020 Chaobin Wu <chaobinwu89@gmail.com>
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/painting.dart';
import 'dart:math' as math;

/// A convex shape which implemented [NotchedShape].
///
/// It's used to draw a convex shape for [ConvexAppBar], If you are interested about
/// the math calculation, please refer to [CircularNotchedRectangle], it's based
/// on Bezier curve;
///
/// See also:
///
///  * [CircularNotchedRectangle], a rectangle with a smooth circular notch.
class ConvexNotchedRectangle extends NotchedShape {
  /// Draw the background with topLeft and topRight corner
  final double radius;
  final bool needNotched;

  /// Create Shape instance
  const ConvexNotchedRectangle({this.radius = 0, this.needNotched});

  @override
  Path getOuterPath(Rect host, Rect guest) {
    if (guest == null || !host.overlaps(guest)) return Path()..addRect(host);

    // The guest's shape is a circle bounded by the guest rectangle.
    // So the guest's radius is half the guest width.
    final notchRadius = guest.width / 2.0;

    const s1 = 15.0;
    const s2 = 1.0;

    final r = notchRadius;
    final a = -1.0 * r - s2;
    final b = host.top - guest.center.dy;

    final n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final p2yA = -math.sqrt(r * r - p2xA * p2xA);
    final p2yB = -math.sqrt(r * r - p2xB * p2xB);

    final p = List<Offset>.filled(6, Offset.zero, growable: false);
    // p0, p1, and p2 are the control points for segment A.
    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    final cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    // p3, p4, and p5 are the control points for segment B, which is a mirror
    // of segment A around the y axis.
    p[3] = Offset(-1.0 * p[2].dx, p[2].dy);
    p[4] = Offset(-1.0 * p[1].dx, p[1].dy);
    p[5] = Offset(-1.0 * p[0].dx, p[0].dy);

    // translate all points back to the absolute coordinate system.
    for (var i = 0; i < p.length; i += 1) {
      p[i] = p[i] + guest.center;
      //p[i] += padding;
    }

    Path path = Path();

    if (radius > 0) {
      path
        ..moveTo(host.left, host.top + radius)
        ..arcToPoint(Offset(host.left + radius, host.top),
            radius: Radius.circular(radius))
        ..lineTo(p[0].dx, p[0].dy);
      if (needNotched) {
        path
          ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
          ..arcToPoint(
            p[3],
            radius: Radius.circular(notchRadius),
            clockwise: true,
          )
          ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy);
      }
      path
        ..lineTo(host.right - radius, host.top)
        ..arcToPoint(Offset(host.right, host.top + radius),
            radius: Radius.circular(radius))
        ..lineTo(host.right, host.bottom)
        ..lineTo(host.left, host.bottom)
        ..close();
    } else {
      path
        ..moveTo(host.left, host.top)
        ..lineTo(p[0].dx, p[0].dy);
      if (needNotched) {
        path
          ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
          ..arcToPoint(
            p[3],
            radius: Radius.circular(notchRadius),
            clockwise: true,
          )
          ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy);
      }
      path
        ..lineTo(host.right, host.top)
        ..lineTo(host.right, host.bottom)
        ..lineTo(host.left, host.bottom)
        ..close();
    }

    return path;
  }
}

class CircularOuterNotchedRectangle extends NotchedShape {
  /// Creates a [CircularOuterNotchedRectangle].
  ///
  /// The same object can be used to create multiple shapes.
  const CircularOuterNotchedRectangle({this.extraOffset = 10.0});

  final double extraOffset;

  /// Creates a [Path] that describes a rectangle with a smooth circular notch.
  ///
  /// `host` is the bounding box for the returned shape. Conceptually this is
  /// the rectangle to which the notch will be applied.
  ///
  /// `guest` is the bounding box of a circle that the notch accommodates. All
  /// points in the circle bounded by `guest` will be outside of the returned
  /// path.
  ///
  /// The notch is curve that smoothly connects the host's top edge and
  /// the guest circle.
  // TODO(amirh): add an example diagram here.
  @override
  Path getOuterPath(Rect host, Rect guest) {
    if (guest == null || !host.overlaps(guest)) return Path()..addRect(host);

    // The guest's shape is a circle bounded by the guest rectangle.
    // So the guest's radius is half the guest width.
    final double notchRadius = guest.width / 2.0;

    // We build a path for the notch from 3 segments:
    // Segment A - a Bezier curve from the host's top edge to segment B.
    // Segment B - an arc with radius notchRadius.
    // Segment C - a Bezier curve from segment B back to the host's top edge.
    //
    // A detailed explanation and the derivation of the formulas below is

    const double s1 = 15.0;
    const double s2 = 1.0;

    final double r = notchRadius + extraOffset / 2;
    final double a = -1.0 * r - s2;
    final double b = host.top + guest.center.dy;

    final double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = math.sqrt(r * r - p2xA * p2xA) - extraOffset / 2;
    final double p2yB = math.sqrt(r * r - p2xB * p2xB) - extraOffset / 2;

    final List<Offset> p = List<Offset>(6);

    // p0, p1, and p2 are the control points for segment A.
    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    p[2] = p2yA > p2yB ? Offset(p2xA, -p2yA) : Offset(p2xB, p2yB);

    // p3, p4, and p5 are the control points for segment B, which is a mirror
    // of segment A around the y axis.
    p[3] = Offset(-1.0 * p[2].dx, -p[2].dy);
    p[4] = Offset(-1.0 * p[1].dx, p[1].dy);
    p[5] = Offset(-1.0 * p[0].dx, p[0].dy);

    // translate all points back to the absolute coordinate system.
    for (int i = 0; i < p.length; i += 1) p[i] += guest.center;

    return Path()
      ..moveTo(host.left, -host.top)
      ..lineTo(p[0].dx, p[0].dy)
      ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, -p[2].dy)
      ..arcToPoint(
        p[3],
        radius: Radius.circular(notchRadius),
        clockwise: true,
      )
      ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}
