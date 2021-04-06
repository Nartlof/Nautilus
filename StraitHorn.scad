use <Segment.scad>;

//Horn's length
HornLength = 240;
//Trought diameter
HornTrought = 12.75;
//Mouth diameter
HornMouth = 150;
//Wall thickness
Thickness = 1.25;
//Resolution
Resolution = 1;

$fa=($preview)?$fa:1;
$fs=($preview)?$fs:Resolution;

module horn(HornMouthRadius, HornTroughtRadius, HornLength, Thickness){
    RadiusFlare = ln(HornMouthRadius/HornTroughtRadius)/HornLength;
    for (x = [0 : $fs : HornLength - $fs]){
        //echo(x);
        R1i = HornTroughtRadius*exp(RadiusFlare*x);
        R2i = HornTroughtRadius*exp(RadiusFlare*(x+$fs));
        R1e = R1i + sqrt(pow(Thickness, 2)                  //pluss the thickness added to itself times the 
                + pow(Thickness*RadiusFlare*R1i,2));      // derivative of the exponential
        R2e = R2i + sqrt(pow(Thickness, 2)                  //pluss the thickness added to itself times the 
                + pow(Thickness*RadiusFlare*R2i,2));      // derivative of the exponential
        translate([0,0,x])
            pipeSegment(r1e = R1e, r1i = R1i, r2e = R2e, r2i = R2i, h = $fs);
    }
}

horn(HornMouth/2, HornTrought/2, HornLength, Thickness);