#my_tasks/tasks.py
from os.path import expanduser
from os.path import basename
from fabric.api import run, put
from cloudify import ctx

def container(blueprint, image, container_name):
    ctx.logger.info('container creation')
    run('if [ ! -d ~/' + blueprint + ' ]; then mkdir ~/' + blueprint + '; fi')
    run('sudo docker run -P --name '+ container_name+ ' -v ~/' + blueprint + ':/root/' + blueprint + ' -it -d ' + image + ' bin/bash')

def java(container_name):
    ctx.logger.info('java installation')
    Java = run('sudo docker exec -it ' + container_name +' which java')
    if not Java: 
       run('sudo docker exec -it ' + container_name + ' apt-get update')
       run('sudo docker exec -it ' + container_name + ' apt-get -y install default-jre')

def get_input(blueprint, container_name):
    file_name = 'file1.txt' #ctx.node.properties.Source
    #sourcefile = expanduser("~") + '/input/' + file_name
    #run('sudo docker exec -it ' + container_name + ' [ ! -d ' + blueprint + '/' +' ] && sudo docker exec -it ' + container_name + ' mkdir ' + blueprint)
    ctx.logger.info('copy the input')
    #filename = basename(sourcefile)
    #run('cat ' + blueprint + '/' + sourcefile + ' | docker exec -i ' + container_name + ' sh -c cat > /root/' + blueprint + '/' +filename)

def block_deploy(blueprint, container_name, block_url):
    block = ctx.node.name
    block_name = ctx.node.properties['block_name']
    
    run('sudo docker exec -it ' + container_name + ' [ ! -d ' + blueprint + ' ] && sudo docker exec -it ' + container_name + ' mkdir ' + blueprint)
    run('sudo docker exec -it ' + container_name + ' [ ! -f ' + blueprint + '/' + block_name + ' ] && sudo docker exec -it ' + container_name + ' wget -O ' + blueprint + '/' + block_name + ' ' + block_url)
    ctx.logger.info('Execute the block')
    run('sudo docker exec -it ' + container_name + ' java -jar ' + blueprint + '/' + block_name + ' ' + blueprint + ' ' + block)

