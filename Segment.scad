

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
module nautilusSegment(r1=5, r2=4, h=1){
    bottonFace = circularFace(r1);
    topFace = [for (i=circularFace(r2)) i + [0,0,h]];
    lenB = len(bottonFace);
    lenT = len(topFace);
//    echo([for (i=[lenB-1:-1:0]) i, for (i=[lenB:lenB+lenT-1]) i]);
//    echo([for (i=[0:lenT-2]) [i,nearest(bottonFace,midPoint(topFace[i],topFace[i+1])),distances(bottonFace,midPoint(topFace[i],topFace[i+1]))]]);
    polyhedron(points = [for (i=[0:lenB-1]) bottonFace[i], 
                        for (i=[0:lenT-1]) topFace[i]],
                faces = [[for (i=[0:lenB-1]) i],  //botton face
                        [for (i=[lenB+lenT-1:-1:lenB]) i],    //top face
                        //triangular faces with base on the botto
                        for (i=[0:lenB-2]) [i+1,i,lenB + max(nearest(topFace,midPoint(bottonFace[i],bottonFace[i+1])))],
                        [0,lenB-1,lenB + min(nearest(topFace,midPoint(bottonFace[0],bottonFace[lenB-1])))],
                        //triangular faces with base on top
                        for (i=[0:lenT-2]) [lenB+i,lenB+i+1,min(nearest(bottonFace,midPoint(topFace[i],topFace[i+1])))],
                        [lenB+lenT-1,lenB,max(nearest(bottonFace,midPoint(topFace[0],topFace[lenT-1])))]
                        ], 
                        convexity = 1);

}

nautilusSegment(5,4,1);
/*
N=10;
E=1;
R=10;
P=2;
    for (i=[0:N]){
        translate([0,0,i*P])
            nautilusSegment(r1=R*exp(-i/N),r2=R*exp(-(i+1)/N),h=P);
    }
*/