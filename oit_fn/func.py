import io
import json
import logging
from subprocess import check_output
import os

from fdk import response


def handler(ctx, data: io.BytesIO=None):
    name = "World"
    output = "Divyaksh"
    try:
        body = json.loads(data.getvalue())
        name = body.get("name")
    except (Exception, ValueError) as ex:
        logging.getLogger().info('error parsing json payload: ' + str(ex))

    # output = check_output('echo \"Hello World\"').decode('utf-8')
    # output = os.popen('echo \"Hello World\"').read().strip()
    # command = "/function/oit-fi/sdk/demo/fisimple /function/oit-fi/sdk/samplefiles/adobe-acrobat.pdf"
    
    output = os.popen("/function/oit-fi/sdk/demo/fisimple /function/oit-fi/sdk/samplefiles/adobe-acrobat.pdf").read().strip()

    logging.getLogger().info("Inside Python Hello World function")
    return response.Response(
        ctx, response_data=json.dumps(
            {"output": "{}".format(output)}),
        headers={"Content-Type": "application/json"}
    )
