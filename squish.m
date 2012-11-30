function squished = squish(str)
bls = find(str ~= ' ');
squished = str(bls);
end