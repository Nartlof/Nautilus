

//returns the number of segments a circle must be cut.
function nOfFaces(r) = ($fn>0?($fn>=3?$fn:3):ceil(max(min(360/$fa,r*2*PI/$fs),5)));

//returns a list of points on the plane XY that make a circle
function circularFace(r)=[for (i = [0:360/nOfFaces(r):360-360/nOfFaces(r)]) r * [cos(i),sin(i),0]];

//returns the mid point of a segment
function midPoint(p1=[0,0,0], p2=[0,0,0]) = (p1 + p2)/2;

//returns the distance between two points
function dist(p1=[0,0,0], p2=[0,0,0]) = sqrt((p1-p2)*(p1-p2));

//returns a list with the distances from each point in l to p
function distances(l=[[0,0,0],[1,1,1],[5,5,5]],p=[3,3,3]) = [for (i=l) dist(i,p)];

//returns the index in the list for the point closest to p
function nearest(l=[[0,0,0],[1,1,1],[5,5,5]],p=[3,3,3]) = ([for (i=[0:len(l)-1]) if (distances(l,p)[i] == min(distances(l,p))) i][0]);

//This module creates a segment of the Nautilus shell
module nautilusSegment(r1=5, r2=5, h=1){
    bottonFace = circularFace(r1);
    topFace = [for (i=circularFace(r2)) i + [0,0,1]];


    polyhedron(points = [for (i=[0:len(bottonFace)-1]) bottonFace[i],
                         for (i=[0:len(topFace)-1]) topFace[i]], 
                faces = [[for (i=[0:len(bottonFace)-1]) i],
                         [for (i=[len(bottonFace)+len(topFace)-1:-1:len(bottonFace)]) i],
                          for (i=[0:len(bottonFace)-2]) [i+1,i,len(bottonFace) + nearest(topFace,midPoint(bottonFace[i],bottonFace[i+1]))],
                          [0,len(bottonFace)-1,len(bottonFace) + nearest(topFace,midPoint(bottonFace[0],bottonFace[len(bottonFace)-1]))]
                          ], 
                        convexity = 1);

}

nautilusSegment();