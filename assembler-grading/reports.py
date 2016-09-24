#!/usr/bin/env python

import subprocess
import re
import os
import shutil
import hashlib
import string
import sys
import random
import signal

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
import time

if len(sys.argv) != 2:
	print 'Usage: ./reports.py <roster>'
	sys.exit(1)
	
try:
	print 'Making directories...'
	os.makedirs('reports')
except:
	# Ignore
	print 'WARNING: Results directory already exists. Move to reports.backup, just to be sure.'
	subprocess.call(['rm', '-rf', 'reports.backup'])
	subprocess.call(['mv', 'reports', 'reports.backup'])
	os.makedirs('reports')

print 'Generate reports...'

ansi_escape = re.compile('\033\[\d+(?:;\d+)?m')

def load_results(login, hw, longhw):
	if not os.path.isfile('results' + '/' + login + '.txt'):
		return (-1, ['> NO SUBMISSION FOR %s\n' % longhw])
 
	with open('results' + '/' + login + '.txt', 'r') as fin:
		lines = fin.readlines()
		reportlines = [('> ' + ansi_escape.sub('', x)) for x in lines if x.startswith('')]
		score = float([x for x in lines if x.startswith('$ ')][0].split(',')[1])

	return (score, reportlines)

with open(sys.argv[1], 'r') as froster:
	with open('roster.txt', 'w') as hw1_froster:
			lines = froster.readlines()
			for i,l in enumerate(lines):
				login = l.split(",")[0]
				name = l.split(",")[1]
				sys.stdout.write('[ %3d%% ] Generating report: %s' % (i*100/len(lines), login))
				sys.stdout.flush()

				myhash = hashlib.sha224(login + "1BKg9NgnYxKJCKxutbVY" + login + "YNTGOSeRvqPyo1C9cYJR").hexdigest()
				(proj1_score, proj1_report) = load_results(login, 'proj2-1', 'PROJECT 2-1')

				final_hw1_score = proj1_score
				# Write roster
				if (final_hw1_score < 0):
					hw1_froster.write(l)
					final_hw1_score = 0
				else:
					hw1_froster.write('%s %.2f %s\n' % (l.rstrip(), final_hw1_score, 'http://inst.eecs.berkeley.edu/~cs61c/su15/reports/proj2/' + myhash + '.txt'))

				# Write report
				with open('reports/' + myhash + '.txt', 'w') as freport:
					freport.write('===============================================================================\n')
					freport.write(' PROJECT 2-1 GRADING SUMMARY\n')
					freport.write('===============================================================================\n')
					freport.write('\n')
					freport.write(' * PROJECT 2-1 SCORE: %.2f\n' % final_hw1_score)
					freport.write('\n')
					freport.write('===============================================================================\n')
					freport.write('\n')
					for l in proj1_report:
						freport.write(l[1:])
					freport.write('\n')
					freport.write('===============================================================================\n')
					freport.write('\n')
					
				sys.stdout.write('\r')
				sys.stdout.flush()

sys.stdout.write('\n')
sys.stdout.flush()
print '[ 100% ] DONE GRADING'
