use <Segment.scad>;

//Horn's length
HornLength = 300;
//Trought diameter
HornTrought = 12.75;
//Mouth diameter
HornMouth = 250;
//Wall thickness
Thickness = 1.25;
//Resolution
Resolution = 3;

$fa=($preview)?$fa:1;
$fs=($preview)?$fs:Resolution;

module horn(HornMouthRadius, HornTroughtRadius, HornLength, Thickness, HornAngle){
    HornRadius = HornLength / (HornAngle * PI / 180);
    RadiusFlare = ln(HornMouthRadius/HornTroughtRadius)/HornLength;
    H = [HornRadius*(1-cos($fa)),0,HornRadius*sin($fa)];
    Delta = HornRadius * $fa * PI / 180;
    for (a = [0 : $fa : HornAngle - $fa / 2]){
        x = HornRadius * a * PI / 180;
        R1i = HornTroughtRadius*exp(RadiusFlare*x);
        R2i = HornTroughtRadius*exp(RadiusFlare*(x+Delta));
        R1e = R1i + sqrt(pow(Thickness, 2)                  //pluss the thickness added to itself times the 
                + pow(Thickness*RadiusFlare*R1i,2));      // derivative of the exponential
        R2e = R2i + sqrt(pow(Thickness, 2)                  //pluss the thickness added to itself times the 
                + pow(Thickness*RadiusFlare*R2i,2));      // derivative of the exponential

        rotate([0,a,0])
            translate([-HornRadius,0,0])
                pipeSegment(r1e = R1e, r1i = R1i, r2e = R2e, r2i = R2i, h = H, theta = $fa);
    }
}

//echo(PI);
rotate([0,-90,0])
horn(HornMouth/2, HornTrought/2, HornLength, Thickness, 180, $fa=6);
/*
//a=45;
h=8;
rc = 10;
a = 10;//2 * asin(h / (2*rc));
pipeSegment(5,4,5,4,[rc*(1-cos(a)),0,rc*sin(a)],a);*/
