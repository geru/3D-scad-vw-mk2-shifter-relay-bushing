/* MIT License

Copyright (c) 2024 Hugh Kern <hkern0@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. */

/* Volkswagen (VW) MK2 stick-shift (manual shift) shifter relay bushing (ball)
Slides on over outside of well-worn OEM shifter relay ball on 1988 Jetta.
An M3 set-screw holds it on.
 */

include <BOSL2/std.scad>;
include <BOSL2/shapes3d.scad>;
include <BOSL2/screws.scad>;

$fn=70;

// measured values existing mount
mt_od1 = 17;
mt_od2 = 22;
mt_spline_n = 12; // number of splines
mt_spline_w = 2;  // width
mt_spline_d = (mt_od2-mt_od1) / 2;  // depth
mt_h_total = 26;

// actuator dims
act_od = 32;       // guess
act_or = act_od / 2;
act_end_extra = 2; // guess
act_h = mt_h_total;

_slop = 0.2;

module act_cut_setscrew() {
  translate([-act_or*0.1, act_or*0.65, act_h-3])
    yrot(90)
      screw_hole( "M3", "socket", thread=true, l=act_od, counterbore=10 );
}

module act_cut() {
  module _spline() {
    cuboid([mt_spline_d*2+_slop*2, mt_spline_w+_slop, mt_h_total+_slop], anchor=BOT);
  }
  module _main() {
    cyl( l=mt_h_total, d=mt_od1-_slop, anchor=BOT );
    zrot_copies( n=mt_spline_n, d=mt_od1+_slop )
      _spline( );
  }
  intersection() {
    _main();
    cyl( l=mt_h_total+_slop, d=mt_od2+_slop, chamfer1=mt_spline_d+_slop, anchor=BOT );
  }
  act_cut_setscrew();
  translate([0,0,-act_end_extra])
    cyl(l=act_h+act_end_extra, d=mt_od1, anchor=BOT);
}

module act_body() {
  module _main_cyl() {
    translate([0,0,-act_end_extra])
      cyl( l=act_h+act_end_extra, d=act_od, /*chamfer1=3,*/ anchor=BOT );
  }
  _main_cyl();
}

module act() {
  difference() {
    act_body();
    #act_cut();
  }
}

act();
