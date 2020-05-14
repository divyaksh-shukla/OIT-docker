from subprocess import check_output
import os

# print(check_output('ls').decode("utf-8"))
print(os.popen('ls').read())
