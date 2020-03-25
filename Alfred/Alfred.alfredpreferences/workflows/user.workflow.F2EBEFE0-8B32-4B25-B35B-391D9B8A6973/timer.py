import os
import subprocess
import sys
import re
#reload(sys)
sys.path.append('/usr/local/lib/python3.7/site-packages')
#sys.setdefaultencoding('utf-8') #Japanese
import rumps
import tempfile
import matplotlib.pyplot as plt
import matplotlib.patches as pat
from datetime import datetime, timezone, timedelta

JST = timezone(timedelta(hours=+9), 'JST')
startTime = datetime.now().timestamp()
startmsg = os.environ.get('startmsg','test_startmsg')
seconds = os.environ.get('seconds','30')
timermode = os.environ.get('timermode','interval')
endTime = startTime + float(seconds)
startDate = datetime.fromtimestamp(startTime, JST).strftime("%H:%M")
untilDate = datetime.fromtimestamp(endTime, JST).strftime("%H:%M")
AUTO_RESUME_SEC = 60

colors = {'interval':'orangered', 'alarm':'dodgerblue', 'paused':'gray'}
actTmColor, deactTmColor = colors.get(timermode), colors.get('paused')

class Timer(rumps.App):

	def __init__(self):
		super(Timer, self).__init__('Timer', quit_button=None)
		#rumps.debug_mode(True)
		self.menu = [startDate+' .......... '+untilDate]
		self.menu = ['Pause']
		self.menu = ['Extend']
		self.menu = ['Quit']

		self.timerActive = True
		self.sec = int(seconds)
		self.titleMsg = startmsg
		self.start = startTime
		self.end = endTime
		self.suspensionPeriod = 0
		self.hfTmNtfcnIsDone = False
		self.lst3minNtfcnIsDone = False if self.sec>180 else True
		self.hhmmss = ''
		
		self.isScreenOn = True
		self.suspendedAutomatically = False
		self.autoResumeTime = AUTO_RESUME_SEC
		
		self.fig = plt.figure(figsize=(1, 1), dpi=100)
		self.ax = self.fig.add_subplot(111)

		self.tmp_dir = tempfile.mkdtemp()
		self.img_path = os.path.join(self.tmp_dir, 'moving_timer.png')
	
	
	@rumps.clicked(startDate+' .......... '+untilDate)
	def modifyTitle(self, sender=''):
		rescode, resmsg = self.changeTitle("You can change the title.", self.titleMsg, self.titleMsg)
		if rescode == 0:
			self.titleMsg = resmsg
			self.exportEnv(key="START_MSG",value=self.titleMsg)
			self.update()
			self.displayNtfctn(self.titleMsg,'Change Title','Tink')

	@rumps.clicked('Pause')
	def pause_resume(self,sender=''):
		now = datetime.now().timestamp()
		self.menu['Pause'].title = 'Resume' if self.timerActive else 'Pause'
		if self.timerActive:
			#Pause timer
			self.pauseTime = now
			self.timerActive = False
			self.update()
			self.displayNtfctn(self.titleMsg,'Pause','Tink')
		else:
			#Resume timer
			self.end += now - self.pauseTime
			self.updateProgressBar(now)
			self.timerActive = True
			self.update()
			self.displayNtfctn(self.titleMsg,'Resume','Tink')

	@rumps.clicked('Extend','60 min')
	@rumps.clicked('Extend','30 min')
	@rumps.clicked('Extend','15 min')
	@rumps.clicked('Extend','10 min')
	@rumps.clicked('Extend','5 min')
	@rumps.clicked('Extend','3 min')
	@rumps.clicked('Extend','1 min')
	def extend(self,sender='',extendTime=''):
		now = datetime.now().timestamp()
		if not extendTime:
			extendTimeMin = re.findall('\d+\smin', str(sender.items))[0].replace(' min', '')
		else:
			extendTimeMin = extendTime
		self.start = now
		self.end += int(extendTimeMin) * 60 + now - self.pauseTime if not self.timerActive else int(extendTimeMin) * 60
		self.pauseTime = now
		self.updateProgressBar(now)
		self.lst3minNtfcnIsDone= False if self.end-self.start>180 else True
		self.hfTmNtfcnIsDone = False
		self.update()
		self.displayNtfctn(self.titleMsg, "Extended " + extendTimeMin + " Min",'Tink')

	@rumps.clicked('Quit')
	def quit(self,sender):
		rescode, resbtn = self.quitConfirmation("Are you sure you want to quit?",self.titleMsg,"Yes !","Cancel","Abort","Yes !")
		if rescode == 0:
			self.exportEnv(key="ABORT",value="1") if resbtn == 'Abort' else None
			self.timerFinish()

	@rumps.timer(1)
	def count(self,sender):
		if self.timerActive:
			if timermode == 'interval' and not self.checkScreenBrightness():
				self.suspendedAutomatically = True
				self.autoResumeTime = AUTO_RESUME_SEC
				self.pause_resume()
			else:
				self.update()
		else:
			self.suspensionPeriod += 1
			if self.suspendedAutomatically and self.checkScreenBrightness():
				if self.autoResumeTime < 0:
					self.suspendedAutomatically = False
					self.pause_resume()
				else:
					self.autoResumeTime -= 1
			else:
				self.autoResumeTime = AUTO_RESUME_SEC

	def update(self):
		now = datetime.now().timestamp()
		self.updateIcon(now)
		self.updateTime(now)
		self.updateProgressBar(now)

	def updateTime(self,now):
		if now >= self.end:
			# Time's up
			if timermode == 'alarm':
				self.timerFinish()
			self.displayNtfctn(self.titleMsg,"Time\'\\''s up!",'Tink')
			# Check whether screen is on, before take quit confirmation.
			if self.isScreenOn:
				rescode, resbtn = self.quitConfirmation("Time\'\\''s up!\n\n -  Have you finished?",self.titleMsg,"Yes !","More 3min","Abort","More 3min")
				if rescode == 0:
					self.exportEnv(key="ABORT",value="1") if resbtn == 'Abort' else None
					self.timerFinish()
			else:
				self.timerFinish()
			self.extend(extendTime='3')
		if not self.hfTmNtfcnIsDone and now >= (self.start + self.end)/2:
			# Half time notification
			self.displayNtfctn(self.titleMsg,"Half time left!",'Tink')
			self.hfTmNtfcnIsDone = not self.hfTmNtfcnIsDone
		if not self.lst3minNtfcnIsDone and now > self.end-180:
			# Last 3min notification
			self.displayNtfctn(self.titleMsg+" - If needed, you can extend time.","Last 3min left!",'Tink')
			self.lst3minNtfcnIsDone = not self.lst3minNtfcnIsDone

		self.sec = int(self.end - now)
		hh = str(self.sec // 3600).zfill(2)
		mm = str(self.sec % 3600 // 60).zfill(2)
		ss = str(self.sec % 3600 % 60).zfill(2)
		if timermode == 'interval':
			if hh == '00':
				self.hhmmss =          mm +'\''+ ss
			else:
				#self.hhmmss = hh +':'+ mm +'\''+ ss
				self.hhmmss = hh +':'+ mm if self.sec%2==0 else hh +' '+ mm
		elif timermode == 'alarm':
				self.hhmmss = hh +':'+ mm if self.sec%2==0 else hh +' '+ mm

		self.title = self.hhmmss +'_'+ self.titleMsg

	def updateIcon(self,now):
		self.timePassedAngle = int((now-self.start+0.5) / (self.end-self.start) * 360)
		#self.fig = plt.figure(figsize=(1, 1), dpi=100)
		#self.fig.delaxes(self.ax)
		#self.ax = self.fig.add_subplot(111)
		if self.timePassedAngle < 360:
			#self.w1 = pat.Wedge(center = (0.5, 0.5), r = 0.5, theta1 = 0, theta2 = 360, color = 'black', width=0.03 )
			self.w2 = pat.Wedge(center = (0.5, 0.5), r = 0.45, theta1 = 90, theta2 = 450-self.timePassedAngle, color = actTmColor if self.timerActive else deactTmColor)
			#self.ax.add_patch(self.w1)
			self.ax.add_patch(self.w2)
		plt.axis('off')
		plt.savefig(self.img_path, transparent=True, dpi=100)
		self.icon = self.img_path
		self.ax.clear()
	
	def updateProgressBar(self,now):
		progress = int((now-startTime)/(self.end-startTime)*10 if now < self.end else 9) + 1 # :1~10
		progresslist = ['◆' if i < progress else ' . ' for i in range(10)] # ◆,◆,◆,.,.,.,.,.
		
		initend = int((endTime-startTime)/(self.end-startTime)*10) # :0~10
		if initend < 10:
			progresslist[initend]='◇'
		self.menu[startDate+' .......... '+untilDate].title = startDate + ' ' + ''.join(progresslist) + ' ' + datetime.fromtimestamp(self.end, JST).strftime("%H:%M")
	

	def displayNtfctn(self,msg='',title='',sound='Tink'):
		subprocess.run(["osascript -e 'display notification \"" + msg + "\" with title \"" + title + "\" sound name \"" + sound + "\"'"],shell =True)

	def quitConfirmation(self,msg='',title='',okBtn='OK',cnclBtn='Cancel',abrtBtn='Abort',dfltBtn='OK'):
		response = subprocess.run(["osascript -e 'display dialog \"" + msg + "\" with title \"" + title + "\" with icon 1 buttons {\""+okBtn+"\",\""+cnclBtn+"\",\""+abrtBtn+"\"} default button \"" + dfltBtn + "\" cancel button \"" + cnclBtn + "\"'"],shell =True, stdout=subprocess.PIPE)
		rescode = response.returncode
		resbtn = re.findall('button\sreturned:.*\n$', response.stdout.decode('utf-8'))[0].replace('button returned:', '').replace('\n', '') if rescode == 0 else None
		return rescode, resbtn
		
	def changeTitle(self,msg='',title='',dfltAnswr='',okBtn='OK',cnclBtn='Cancel',dfltBtn='OK'):
		response = subprocess.run(["osascript -e 'display dialog \"" + msg + "\" with title \"" + title + "\" default answer \"" + dfltAnswr + "\" with icon 1 buttons {\""+okBtn+"\",\""+cnclBtn+"\"} default button \"" + dfltBtn + "\" cancel button \"" + cnclBtn + "\"'"], shell=True, stdout=subprocess.PIPE)
		rescode = response.returncode
		resmsg = re.findall('text\sreturned:.*\n$', response.stdout.decode('utf-8'))[0].replace('text returned:', '').replace('\n', '') if rescode == 0 else None
		return rescode, resmsg

	def checkScreenBrightness(self):
		self.isScreenOn = subprocess.run(["./isScreenOn.sh"],shell=True).returncode == 0
		return self.isScreenOn

	def timerFinish(self):
		self.exportEnv(key="SUSPENSION_PERIOD",value=str(self.suspensionPeriod))
		rumps.quit_application()
		
	def exportEnv(self,key,value):
		subprocess.run(["echo " + key + "=\\\"" + value + "\\\" >> './tmp/"+ startmsg + ".txt'"],shell =True)
		
		
app = Timer()
app.run()