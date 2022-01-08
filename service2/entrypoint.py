import requests
import sys
import os

SERVICE1_NAME = os.environ['SERVICE1_NAME']
SERVICE1_URL = "http://" + SERVICE1_NAME + ":8080"
inp = sys.stdin.readline()

message = requests.get(inp).text
data = ["md5", message]
body = "\n".join(data).encode(encoding='utf-8')
print(requests.post(SERVICE1_URL, data=body).text)

