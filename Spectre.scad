
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

spectre2();

module spectre() {
  polygon(points);
}

// In the Smith, et al. paper, Figure 1.1, right, it looks like
//   they modified the sides to be a cubic,
//   for example f(x) = x*(x-1)*(x-2)/2.
// n is the number of minor points between major points
module spectre2(n=8) {
  polygon([ for (i=[0:len(points)-1])
    each let(p_i = points[i], p_j = points[(i+1)%len(points)])
      spoosh(p_i, p_j, n, order=(i%2==0))
  ]);
}

// Named spoosh to avoid a possible trademark.
function spoosh(p1, p2, n=20, order=0) = 
  [for(i=[0:n-1])
    spoosh_i(p1, p2, n, i, order)
  ];

// spoosh_i interpolates between p1 and p2, adding a sideways
//   swing according to spoosh_f(x).  Every other point has
//   the swing inverted.
function spoosh_i(p1, p2, n, i, order=0) = 
  let(displacement = p2 - p1,
      perp = [displacement.y, -displacement.x])
    p1 + displacement * i/n +
      (order?1:-1) * perp * spoosh_f(order?i/n:((n-i)/n));

function spoosh_f(x) = x*(x-1)*(x-2)/2;


