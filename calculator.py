import math
exact = 0.01
print("log2("+str(exact)+"):", math.log2(exact))
rounded = math.floor(math.log2(exact))
print("round(log2("+str(exact)+")):", rounded)
for exp in range(-1, rounded-1, -1):
    print("2^"+str(exp), pow(2, exp))
    pass
