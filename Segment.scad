//This module creates a segment of the pipe to be composed
module pipeSegment(r1e = 4, r1i = 3, r2e = 4, r2i = 3, h = [0,0,1], theta = 0){
    //All functions are kept inside the module for encapsulation
    //returns the number of segments a circle must be cut.
    function nOfFaces(r) = (
        $fn>0?($fn>=3?$fn:3):
        ceil(max(min(360/$fa,r*2*PI/$fs),5))
    );

    //returns a list of points on the plane XY that make a circle
    function circularFace(r) = let(stepAngle = 360 / nOfFaces(r)) [
        for (i = [0:stepAngle:360-stepAngle/2]) 
            r * [cos(i),sin(i),0]
    ];

    //This function creates triangles that connect two circular lines
    function generateFaces(L1Str, L1End, L2Str, L2End) = 
        let(
            Scale1 = (L2End - L2Str + 1) / (L1End - L1Str + 1),
            Scale2 = (L1End - L1Str + 1) / (L2End - L2Str + 1)
        ) [
        for (i = [L1Str:L1End-1]) [
            i + 1,
            i,
            L2Str + ceil((i - L1Str + 1) * Scale1) - 1
        ],
        [
            L1Str,
            L1End,
            L2End
        ],
        for (i = [L2Str:L2End-1]) [
            i,
            i + 1,
            L1Str + floor((i - L2Str + 1) * Scale2) 
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
    H = (h[0] == undef) ? [0, 0 , h] : h;
    rotationMatrix = [
        [cos(theta), 0, sin(theta)],
        [0, 1, 0],
        [-sin(theta), 0, cos(theta)]
    ];
    polyhedron(
        points = [
                    for (i = circularFace(r1e)) i,
                    for (i = circularFace(r1i)) i,
                    for (i = circularFace(r2e)) rotationMatrix * i + H,
                    for (i = circularFace(r2i)) rotationMatrix * i + H
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
