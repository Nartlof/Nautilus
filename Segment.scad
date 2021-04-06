/*$fa=($preview)?$fa:1;
$fs=($preview)?$fs:1;*/

//This module creates a segment of the pipe to be composed
module pipeSegment(r1e=4, r1i=3, r2e=4, r2i=3, h=1){
    //All functions are kept inside the module for encapsulation
    //returns the number of segments a circle must be cut.
    function nOfFaces(r) = (
        $fn>0?($fn>=3?$fn:3):
        ceil(max(min(360/$fa,r*2*PI/$fs),5))
    );

    //returns a list of points on the plane XY that make a circle
    function circularFace(r)=[
        for (i = [0:360/nOfFaces(r):360-360/nOfFaces(r)/2]) 
            r * [cos(i),sin(i),0]
    ];

    //This function creates triangles that connect two circular lines
    function generateFaces(L1Str, L1End, L2Str, L2End) = [
        for (i = [L1Str:L1End-1]) [
            i + 1,
            i,
            L2Str + ceil((i - L1Str + 1) * (L2End - L2Str + 1) / (L1End - L1Str + 1)) - 1
        ],
        [
            L1Str,
            L1End,
            L2End
        ],
        for (i = [L2Str:L2End-1]) [
            i,
            i + 1,
            L1Str + floor((i - L2Str + 1) * (L1End - L1Str + 1) / (L2End - L2Str + 1)) 
        ],
        [
            L2End,
            L2Str,
            L1Str
        ]
    ];
    //Four circles must be created.
    //BE = Botton External circle
    //BI = Botton Internal circle
    //TE = Top External circle
    //TI = Top Internal circle
    lenBE = nOfFaces(r1e);
    lenBI = nOfFaces(r1i);
    lenTE = nOfFaces(r2e);
    lenTI = nOfFaces(r2i);
    //This are the indices for each circle in the list of points
    StartBE = 0;
    StartBI = lenBE;
    StartTE = StartBI + lenBI;
    StartTI = StartTE + lenTE;
    EndBE = StartBI - 1;
    EndBI = StartTE - 1;
    EndTE = StartTI - 1;
    EndTI = StartTI + lenTI - 1;
    polyhedron(
        points = [
                    for (i = circularFace(r1e)) i,
                    for (i = circularFace(r1i)) i,
                    for (i = circularFace(r2e)) i + [0,0,h],
                    for (i = circularFace(r2i)) i + [0,0,h]
                ],
        faces = concat(
                    generateFaces(StartBI, EndBI, StartBE, EndBE),
                    generateFaces(StartBE, EndBE, StartTE, EndTE),
                    generateFaces(StartTE, EndTE, StartTI, EndTI),
                    generateFaces(StartTI, EndTI, StartBI, EndBI)
                ),
        convexity = 1
    );
}

$fa=1;
$fs=1;

//nautilusSegment();

//Horn's length
HornLength = 500;
//Trought diameter
HornTroughtRadius = 2;
//Mouth diameter
HornMouthRadius = 200;
//Wall thickness
Thickness = 1;

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
        pipeSegment(R1e,R1i,R2e,R2i,$fs);
}
//*/