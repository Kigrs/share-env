#-*- coding:utf-8 -*-
import rumps
from matplotlib import pyplot as plt
import numpy as np
import psutil #cpu使用率の取得用
import tempfile
import shutil
import os

class CpuUsageApp(rumps.App):

    def __init__(self):
        super(CpuUsageApp, self).__init__("CPU Usage App")
        rumps.debug_mode(False)
        self.menu = ['Show text']
        self.enable_text = True

        #CPU使用率グラフ作成
        self.time = np.arange(10)
        self.usage = np.zeros_like(self.time)
        self.mem = np.zeros_like(self.time)
        self.fig = plt.figure(figsize=(1, 1), dpi=100)
        self.ax = self.fig.add_subplot(111)
        self.ax.set_xlim(0, 9)
        self.ax.set_ylim(0, 100)
        self.ax.plot(self.time, self.usage, color="blue", lw=3)
        self.ax.plot(self.time, self.mem, color="gray", lw=3)
        plt.axis('off')

        #iconは一時保存ディレクトリに入れてアプリ終了後に消す
        self.tmp_dir = tempfile.mkdtemp()
        self.img_path = os.path.join(self.tmp_dir, 'cpu_usage.png')
        plt.savefig(self.img_path, transparent=True, dpi=100)

        #iconをセット
        self.icon = self.img_path

    def __del__(self):
        shutil.rmtree(self.tmp_dir)

    #テキスト表示の有無
    @rumps.clicked("Show text")
    def show_text(self, sender):
        self.enable_text = not self.enable_text
        sender.state = self.enable_text
        if not self.enable_text:
            self.title = None

    #1秒毎に更新
    @rumps.timer(1)
    def update(self, _):
        #CPU使用率取得
        usage = psutil.cpu_percent()
        mem = psutil.virtual_memory().percent
        self.usage = np.roll(self.usage, 1)
        self.mem = np.roll(self.mem, 1)
        self.usage[0] = usage
        self.mem[0] = mem
        #左へ遷移するよう配列を反転
        print(self.time,self.usage[::-1],np.zeros_like(self.time))
        self.ax.lines[0].set_ydata(self.usage[::-1])
        self.ax.lines[1].set_ydata(self.mem[::-1])
        self.ax.fill_between(self.time, self.usage[::-1], np.zeros_like(self.time), facecolor="orange", alpha=0.1)
        #iconファイル出力
        plt.savefig(self.img_path, transparent=True, dpi=100)
        self.icon = self.img_path

        #テキスト表示
        if self.enable_text:
            self.title = ' '+str(self.usage[0])+' %' if self.usage[0]<10 else str(self.usage[0])+' %'

if __name__ == "__main__":
    app = CpuUsageApp()
    app.run()
