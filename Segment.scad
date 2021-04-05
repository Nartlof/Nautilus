$fa=($preview)?$fa:1;
$fs=($preview)?$fs:1;

//returns the number of segments a circle must be cut.
function nOfFaces(r) = ($fn>0?($fn>=3?$fn:3):ceil(max(min(360/$fa,r*2*PI/$fs),5)));

//returns a list of points on the plane XY that make a circle
function circularFace(r)=[for (i = [0:360/nOfFaces(r):360-360/nOfFaces(r)/2]) r * [cos(i),sin(i),0]];

//returns the mid point of a segment
function midPoint(p1=[0,0,0], p2=[0,0,0]) = (p1 + p2)/2;

//returns the distance between two points
function dist(p1=[0,0,0], p2=[0,0,0]) = sqrt((p1-p2)*(p1-p2));

//returns a list with the distances from each point in l to p
function distances(l=[[0,0,0],[1,1,1],[5,5,5]],p=[3,3,3]) = [for (i=l) dist(i,p)];

//returns the index in the list for the point closest to p
function nearest(l=[[0,0,0],[1,1,1],[5,5,5]],p=[3,3,3]) = ([for (i=[0:len(l)-1]) 
    if (min(distances(l,p)) * 0.99999 < distances(l,p)[i] && 
            distances(l,p)[i] < min(distances(l,p))*1.00001) i]);

//This module creates a segment of the Nautilus shell
module nautilusSegment(r1e=4, r1i=3, r2e=4, r2i=3, h=1){
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

    bottonFaceExternal = circularFace(r1e);
    bottonFaceInternal = circularFace(r1i);
    topFaceExternal = [for (i=circularFace(r2e)) i + [0,0,h]];
    topFaceInternal = [for (i=circularFace(r2i)) i + [0,0,h]];
    lenBE = len(bottonFaceExternal);
    lenBI = len(bottonFaceInternal);
    lenTE = len(topFaceExternal);
    lenTI = len(topFaceInternal);
    StartBE = 0;
    StartBI = lenBE;
    StartTE = StartBI + lenBI;
    StartTI = StartTE + lenTE;
    EndBE = StartBI - 1;
    EndBI = StartTE - 1;
    EndTE = StartTI - 1;
    EndTI = StartTI + lenTI - 1;
    polyhedron(points = [for (i = bottonFaceExternal) i,
                        for (i = bottonFaceInternal) i,
                        for (i = topFaceExternal) i,
                        for (i = topFaceInternal) i],
                        //Botton ring from external to internal
                faces = concat(
                            generateFaces(StartBI, EndBI, StartBE, EndBE),
                            generateFaces(StartBE, EndBE, StartTE, EndTE),
                            generateFaces(StartTE, EndTE, StartTI, EndTI),
                            generateFaces(StartTI, EndTI, StartBI, EndBI)
                        ),
                convexity = 1);
}




//nautilusSegment();



//Horn's length
HornLength = 200;
//Trought diameter
HornTroughtRadius = 10;
//Mouth diameter
HornMouthRadius = 100;
//Wall thickness
Thickness = 5;

RadiusFlare = ln(HornMouthRadius/HornTroughtRadius)/HornLength;
for (x = [0 : $fs : HornLength - $fs]){
    echo(x);
    R1i = HornTroughtRadius*exp(RadiusFlare*x);
    R2i = HornTroughtRadius*exp(RadiusFlare*(x+$fs));
    R1e = R1i + sqrt(pow(Thickness, 2)                  //pluss the thickness added to itself times the 
              + pow(Thickness*RadiusFlare*R1i,2));      // derivative of the exponential
    R2e = R2i + sqrt(pow(Thickness, 2)                  //pluss the thickness added to itself times the 
              + pow(Thickness*RadiusFlare*R2i,2));      // derivative of the exponential
    translate([0,0,x])
        nautilusSegment(R1e,R1i,R2e,R2i,$fs);
}
//*/