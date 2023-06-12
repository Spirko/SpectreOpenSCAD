
// OpenSCAD geometry of Tile(1,1) which leads to the spectre tile
// Jeffery Spirko, spirko@gmail.com, GPL 3.0

// Ref: https://arxiv.org/pdf/2305.17743.pdf
//      authors: David Smith, Joseph Samuel Myers,
//               Craig S. Kaplan, and Chaim Goodman-Strauss
//      Figure 1.1, left


// According to the paper, each side is the same length.
// Each side is along an axis or at a 30 degree angle to an axis.
// So each displacement is at an angle of 30*k, where k is an integer.
// kvals was determined visupally from the figure.
kvals = [ 0, -2, 1, 3, 3, 5, 2, 4, 7, 9, 6, 8, 11, 9 ];
sines = [ for (angle = kvals*30) sin(angle) ];
cosines = [ for (angle = kvals*30) cos(angle) ];
displacements = [ for(i=0; i<len(kvals); i=i+1) 
                    [ cosines[i], sines[i] ] ];

// Roughly based on cumulative sum from
//  https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks
//  and requires version 2019.05 or newer.
//  Modifications:
//    This starts at [0,0] not the first element.
//    Each curpos is calculated from the current displacement.
//  Note: the result of adding the last displacement isn't returned.
points = [ for(i=0, curpos=[0,0];
               i<len(kvals);
               curpos=curpos+displacements[i], i=i+1)
             curpos ];
echo(len(displacements));
echo(displacements);
echo(len(points));
echo(points);

spectre();

module spectre() {
  polygon(points);
}
