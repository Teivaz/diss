import os

files = os.listdir()

for current in files:
	[name, ext] = os.path.splitext(current)
	if ext == '.ASC':
		infile = open(current, 'r')
		outfile = open(name+'.m', 'w')

		for line in infile:
			if ';  S21' in line:
				break

		outfile.write(name+' = [')
		for line in infile:
			ln = line.replace(' ', '')
			ln = ln.replace(';', ',')
			ln = ln.replace('\n', ';\n')
			outfile.write(ln)
		outfile.seek(outfile.tell()-3, 0)
		outfile.write('];')

		infile.close()
		outfile.close()



