import sys
import hashlib

inp = sys.stdin.readlines()
if inp:
    hash_func = inp[0].strip()
    message = '\n'.join(inp[1:]).strip()

    h = hashlib.new(hash_func)
    h.update(str.encode(message))

    print (h.hexdigest())
else:
    print("input is empty")