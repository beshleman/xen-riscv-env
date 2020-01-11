with open('features.sh', 'r') as f:
    cmd = ''
    for line in f:
        cmd += '--disable-{} \\\n'.format(line.strip())


print(cmd)
