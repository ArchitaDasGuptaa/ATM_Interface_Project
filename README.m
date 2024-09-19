# ATM_Interface_Project
import tkinter as tk
import pyttsx3
import threading
from tkinter import messagebox, simpledialog

# Initialize the text-to-speech engine
engine = pyttsx3.init()
voices=engine.getProperty("voices")
engine.setProperty("voice",voices[1].id)
# Function to handle speech and update UI afterward
def speak_message(message, callback=None):
    def on_speech_end():
        if callback:
            root.after(100, callback)  # Execute callback after speech finishes
    threading.Thread(target=lambda: run_speech(message, on_speech_end)).start()

def run_speech(message, on_speech_end):
    engine.say(message)
    engine.runAndWait()
    on_speech_end()

# Function to center the window on the screen
def center_window(window):
    window.update()
    window_width = window.winfo_width()
    window_height = window.winfo_height()
    screen_width = window.winfo_screenwidth()
    screen_height = window.winfo_screenheight()
    x = int((screen_width / 2) - (window_width / 2))
    y = int((screen_height / 2) - (window_height / 2))
    window.geometry(f"{window_width}x{window_height}+{x}+{y}")

# Function to show the buttons after the speech
def show_card_insertion_ui():
    yes_button.pack(pady=20)
    no_button.pack(pady=20)

# Function to handle card insertion with sound first
def handle_card_insertion():
    speak_message("Dear user, please insert your card", callback=show_card_insertion_ui)

# Function to enter PIN after speaking
def enter_pin():
    speak_message("Enter your PIN number", callback=show_pin_ui)

# Function to display the PIN UI
def show_pin_ui():
    pin_var = tk.StringVar()
    pin_window = tk.Toplevel(root)
    pin_window.title("PIN Entry")
    pin_window.geometry("600x600")
    pin_window.resizable(False, False)
    pin_window.configure(bg='lightblue')
    center_window(pin_window)

    tk.Label(pin_window, text="Enter your PIN number", bg='lightblue', font=('Helvetica', 16)).pack(pady=20)

    buttons_frame = tk.Frame(pin_window)
    buttons_frame.pack(pady=20)

    def add_button(text, row, column, command=None, color='white', text_color='black'):
        tk.Button(buttons_frame, text=text, command=command, width=10, height=2, font=('Helvetica', 16), bg=color, fg=text_color).grid(row=row, column=column, padx=10, pady=10)

    # Define PIN pad layout
    add_button("1", 0, 0, lambda: pin_var.set(pin_var.get() + "1"))
    add_button("2", 0, 1, lambda: pin_var.set(pin_var.get() + "2"))
    add_button("3", 0, 2, lambda: pin_var.set(pin_var.get() + "3"))
    add_button("Cancel", 0, 3, lambda: pin_var.set(pin_var.get()[:-1]), color='red', text_color='white')

    add_button("4", 1, 0, lambda: pin_var.set(pin_var.get() + "4"))
    add_button("5", 1, 1, lambda: pin_var.set(pin_var.get() + "5"))
    add_button("6", 1, 2, lambda: pin_var.set(pin_var.get() + "6"))
    add_button("Clear", 1, 3, lambda: pin_var.set(''), color='yellow', text_color='black')

    add_button("7", 2, 0, lambda: pin_var.set(pin_var.get() + "7"))
    add_button("8", 2, 1, lambda: pin_var.set(pin_var.get() + "8"))
    add_button("9", 2, 2, lambda: pin_var.set(pin_var.get() + "9"))
    add_button("Enter", 2, 3, lambda: submit_pin(pin_var), color='green', text_color='white')

    add_button("0", 3, 1, lambda: pin_var.set(pin_var.get() + "0"))

def submit_pin(pin_var):
    pin = pin_var.get()
    if pin == "1234":  # Example correct PIN
        show_message("PIN accepted")
        show_atm_interface()
    else:
        show_message("Incorrect PIN. Try again.")
        pin_var.set('')

# Function to show the main ATM interface (updated with green and red buttons)
def show_atm_interface():
    root.withdraw()  # Hide the current window
    atm_window = tk.Toplevel(root)
    atm_window.title("ATM Interface")
    atm_window.geometry("600x600")
    center_window(atm_window)

    def balance_inquiry():
        show_message("Your balance is $50000")  # Example balance

    def deposit_funds():
        amount = simpledialog.askfloat("Deposit Funds", "Enter amount to deposit:")
        if amount:
            show_message(f"Deposited ${amount:.2f}")

    def withdraw_funds():
        amount = simpledialog.askfloat("Withdraw Funds", "Enter amount to withdraw:")
        if amount:
            show_message(f"Withdrew ${amount:.2f}")

    def transfer_funds():
        recipient = simpledialog.askstring("Transfer Funds", "Enter recipient's account:")
        amount = simpledialog.askfloat("Transfer Funds", "Enter amount to transfer:")
        if recipient and amount:
            show_message(f"Transferred ${amount:.2f} to {recipient}")

    def change_pin():
        new_pin = simpledialog.askstring("Change PIN", "Enter new PIN:", show='*')
        if new_pin:
            show_message("PIN changed successfully")

    def exit_atm():
        root.destroy()  # Close the main window and exit the application

    buttons_frame = tk.Frame(atm_window)
    buttons_frame.pack(pady=20)

    # Buttons with green background and white text
    tk.Button(buttons_frame, text="Balance Inquiry", command=balance_inquiry, width=20, bg='green', fg='white').grid(row=0, column=0, padx=10, pady=10)
    tk.Button(buttons_frame, text="Deposit Funds", command=deposit_funds, width=20, bg='green', fg='white').grid(row=0, column=1, padx=10, pady=10)
    tk.Button(buttons_frame, text="Withdraw Funds", command=withdraw_funds, width=20, bg='green', fg='white').grid(row=1, column=0, padx=10, pady=10)
    tk.Button(buttons_frame, text="Transfer Funds", command=transfer_funds, width=20, bg='green', fg='white').grid(row=1, column=1, padx=10, pady=10)
    tk.Button(buttons_frame, text="Change PIN", command=change_pin, width=20, bg='green', fg='white').grid(row=2, column=0, padx=10, pady=10)

    # Exit button with red background and white text
    tk.Button(buttons_frame, text="Exit", command=exit_atm, width=20, bg='red', fg='white').grid(row=2, column=1, padx=10, pady=10)

# Functions for message display
def show_message(message):
    messagebox.showinfo("ATM", message)

# Initialize the main window
root = tk.Tk()
root.title("ATM")
root.geometry("600x600")
root.resizable(False, False)
center_window(root)

# Buttons for the first interface (Yes and No buttons)
yes_button = tk.Button(root, text="Yes", command=enter_pin, bg="green", fg="white", width=20)
no_button = tk.Button(root, text="No", command=root.quit, bg="red", fg="white", width=20)

# Start the program by handling card insertion (sound first, then buttons)
handle_card_insertion()

# Main loop
root.mainloop()
