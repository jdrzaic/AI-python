from __future__ import division
from tictactoe_aima_gui import *
import gi
gi.require_version("Gtk",  "3.0")
from gi.repository import Gtk
from gi.repository import GLib, GObject 
from Queue import Queue
from threading import Thread
import time

class GuiPlayerData:
    def __init__(self, thread, app):
        self.thread = thread
        self.app = app
    
    def player(self, game, state):
        "Make a move by querying standard input."
        self.thread.needs_move.get()
        GLib.idle_add(app.update_board, state)
        move = self.thread.player_queue.get()
        GLib.idle_add(app.update_board, game.result(state, move))
        return move

class ThreadWorker(Thread):
    def __init__(self, app):
        Thread.__init__(self)
        self.setDaemon(True)
        self.queue = Queue(1)
        self.player_queue = Queue(1)
        self.needs_move = Queue(1)
        self.needs_move.put(True)
        self.app = app
    
    def run(self):
        while True:
            repeat, item, pl1, pl2 = self.queue.get()
            test = Test(repeat)
            result = test.test_game(*item)
            GLib.idle_add(app.update_gui, result, pl1, pl2)
            
            
class App:
    
    def __init__(self):
        
        #creating thread
        self.t = ThreadWorker(self)
        self.t.start()
        
        self.gui_player = GuiPlayerData(self.t, self)
        
        builder = Gtk.Builder.new_from_file("gui.glade")
        
        self.window = builder.get_object("window1")
        self.window.connect("delete-event",  Gtk.main_quit)
        self.start_button = builder.get_object("button1")
        self.rows = builder.get_object("spinbutton4")
        self.columns = builder.get_object("spinbutton2")
        self.columns.set_value(3)
        self.rows.set_value(3)
        self.k = builder.get_object("spinbutton3")
        self.k.set_value(3)
        self.repeat = builder.get_object("spinbutton1")
        self.repeat.set_value(1)
        self.board = builder.get_object("grid1")
        self.statistics = builder.get_object("liststore1")
        self.start_button.connect("clicked", self.play_game)
        
        self.players = {"igrac slucajnih poteza": random_player, 
                    "ljudski igrac": self.gui_player.player, 
                    "igrac alfa-beta podrezivanja": alphabeta_player, 
                    "igrac minimax pretrazivanja": minimax_player} 

        self.player1_list = builder.get_object("comboboxtext1")
        self.player2_list = builder.get_object("comboboxtext2")
        for x, y in self.players.items():
            self.player1_list.append_text(x)
            self.player2_list.append_text(x)
    
        self.window.show_all()
        
        
    def play_game(self,  button):
        
        k = self.k.get_value_as_int()
        rows = self.rows.get_value_as_int()
        columns = self.columns.get_value_as_int()
        repeat = self.repeat.get_value_as_int()
        pl1_desc = self.player1_list.get_active_text()
        pl2_desc = self.player2_list.get_active_text()
        pl1 = self.players[pl1_desc]
        pl2 = self.players[pl2_desc]
        if repeat == 0:
            dialog = Gtk.Dialog("Izaberite barem jedno ponavljanje", self.window)
        
        if pl1 == self.gui_player.player or pl2 == self.gui_player.player:
            self.create_board(rows, columns)
        elif hasattr(self, 'buttons'):
            self.remove_board(len(self.buttons))
            
        self.start_button.set_sensitive(False)
        self.t.queue.put((repeat, (rows, columns, k, pl1, pl2), pl1_desc, pl2_desc))
        
    def create_board(self, rows, columns):
        if hasattr(self, 'buttons'):
            self.remove_board(len(self.buttons))
            
        self.buttons = [[None] * columns for _ in range(rows)]
        for i in range(0, rows):
            for j in range(0,  columns):
                self.buttons[i][j] = Gtk.Button()
                (self.buttons[i][j]).set_size_request(50, 50) 
                self.board.attach(self.buttons[i][j], i, j, 1, 1)
                self.buttons[i][j].connect("clicked", self.on_button_click, i + 1, j + 1)
    
        self.board.show_all()
    
    def remove_board(self, rows):
        for i in range(rows - 1, -1, -1):
            self.board.remove_row(i)
           
    #todo
    def update_gui(self, result, pl1, pl2):
        
        self.statistics.insert(0, [pl1, result[1][0], result[0][0] * 100, 
            pl2, result[1][2], result[0][2] * 100, result[1][1], result[0][1] * 100])
        self.start_button.set_sensitive(True)
    
    def on_button_click(self,  widget,  i,  j):
        if self.t.needs_move.empty():
            self.t.needs_move.put(True)
            self.t.player_queue.put((i,  j))

    def update_board(self,  state):
        for i, button_row in enumerate(self.buttons):
            for j, button in enumerate(button_row):
                button.set_label(state.board.get((i + 1, j + 1),  ' '))
        
class Test:
    
    def __init__(self, n):
        """n je broj ponavljanja igre"""
        self.repeat = n
        
    def test_game(self, rows, columns, k, player1,  player2):
        """metoda "repeat" puta izvrsava igru TicTacToe na ploci rows * columns, u kojoj je cilj spojiti k pozicija. 
        Igre se izvrsavaju za strategije player1 i player2, respektivno"""
        status = [0, 0, 0]
        for i in xrange(0, self.repeat):
            outcome = play_game(TicTacToe(rows, columns, k), player1, player2)
            if  outcome > 0:
                print "player1 won"
                status[0] += 1
            elif outcome == 0:
                status[1] += 1
                print "tie"
            else:
                status[2] += 1
                print "player2 won"
        return (tuple(x / self.repeat for x in status), tuple(status))
    
#radi do kraja
app = App()
Gtk.main()
