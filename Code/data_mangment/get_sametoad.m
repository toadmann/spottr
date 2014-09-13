function [sametoad,id2toad] = get_sametoad(comparisons)
npics = length(comparisons.pics);
G = comparisons.hand.done&comparisons.hand.match;
G(boolean(eye(size(G)))) = true;
G = sparse(G);
[n,id2toad] = graphconncomp(G,'Weak',true);
toadmat = repmat(id2toad,[npics,1]);
sametoad = toadmat==(toadmat');