# 文件关联工具
可以用来为你的便携程序添加文件关联，比如 nodepad2.exe 、 vscode 或其他图片处理程序，而不仅仅是 sublime text， 修改自 [Sublime-Text-Portable-Tool](https://github.com/loo2k/Sublime-Text-Portable-Tool) 。
由于程序路径是由自己输入的，所以理论上支持关联任意程序，这就样免去了复制本工具到便携程序目录的步骤。另外，分开了 ext.txt 文件，他保存在你的便携程序目录，这样做的好处是比如你可以为不同的编辑器配置不同的关联类型。

- [x] 添加右键菜单
- [x] 关联扩展名(与程序同目录的 ext.txt 文件中)
- [x] 关联图标
- [x] 取消关联扩展名
- [x] 取消添加右键菜单
- [ ] 图标叠加

## 使用方法
把要关联的程序比如 nodepad2.exe 拖入本工具的窗口即可进行操作。

![](2018-01-27_09-46-45.gif)

## 其他
想实现图标叠加效果，类似下图。当一些文件关联某个软件以后，这些文件除了拥有本身类型的图标以外，还叠加一个小图标，也就是当前关联的程序。
![](2018-01-27-19-33-04.png)

谷歌了半天，好像没有可以直接使用的方法。叠加的图标要调用 shell 接口先进行注册……
