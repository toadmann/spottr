function [toads, toadcnt,toadids] = get_toads(comparisons)
G = comparisons.hand.match&comparisons.hand.done;
G(boolean(eye(size(G)))) = true;
G = sparse(G);
[n,toadids] = graphconncomp(G,'Weak',true);
toadcnt = arrayfun(@(x)sum(x==toadids),1:n);

toads = cell(1,n);
for i=1:n
    toads{i} = comparisons.pics(toadids==i);
end