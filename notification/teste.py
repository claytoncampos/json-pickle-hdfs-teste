from win10toast import ToastNotifier

toaster = ToastNotifier()

toaster.show_toast('Notificação', 'Olá Luiz \n Parabéns você vai ser papai', threaded=True,
icon_path=None,
duration=25)