import math
exact = 0.0001
print("log2("+str(exact)+"):", math.log2(exact))
rounded = math.floor(math.log2(exact))
print("round(log2("+str(exact)+")):", rounded)
for exp in range(-1, rounded-1, -1):
    print("2^"+str(exp), pow(2, exp))
    pass

num = 3.1415
toPrint = num * pow(2,abs(rounded))
print(str(num)+"=>" ,round(toPrint))