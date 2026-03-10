#===============================================================================
#====================R Coding Basics============================================
# One could use R to perform some Mathematics Basics============================
#e.g
1 / 200 * 30
(59 + 73 + 2) / 3
sin(pi / 2)
#============Creation of Objects================================================
# Assigning varibles or objects using object_name <- value
x <- 3 * 4
x
#============Combining multiple elements into a vector==========================
primes <- c(2, 3, 5, 7, 11, 13)
primes

#===========We can perform basic arithmetic on the vector such as===============
primes * 2
primes2 <- primes - 1
primes2

# ==============================================================================
# COMMENTS IN R
# -------------------------------------------------------------
# - Use '#' to write comments (ignored by R, read by humans)
# - Comment the WHY, not the what/how (those are readable from code)
# - For data analysis: document your plan and key insights
# - Update comments when you change code to avoid confusion
# - Example: note why you changed span from 0.75 to 0.9,
#   not just that you changed it
# ==============================================================================
# =============================================================
# OBJECT NAMING IN R
# -------------------------------------------------------------
# - Names must start with a letter; can contain letters,
#   numbers, _ and .
# - Use descriptive names with snake_case (recommended):
#   e.g. my_variable, not myVariable or my.variable
# - Inspect an object by typing its name and running it
# - RStudio tip: press TAB to autocomplete object names
# - To edit a previous command: press ↑ to recall it,
#   or type a prefix + Cmd/Ctrl+↑ to search command history
# =============================================================
# =============================================================
# CALLING FUNCTIONS IN R
# -------------------------------------------------------------
# - Syntax: function_name(argument1 = value1, argument2 = value2)
# - Example: seq(from = 1, to = 10) generates a number sequence
# - Argument names can be omitted for leading args:
#   seq(1, 10) is the same as seq(from = 1, to = 10)
# - RStudio tips:
#     - TAB after typing: autocompletes function name
#     - TAB after selecting function: adds matching parentheses
#     - Floating tooltip shows arguments and purpose
#     - F1 opens full function documentation in Help pane
# =============================================================
seq(1,10)

# =============================================================
# 2.5 EXERCISES
# =============================================================

# EXERCISE 1: Spot the error
# ---------------------------------------------------------------
# The code below throws an error — why?
#
# my_variable <- 10
# my_varıable        # uses 'ı' (dotless i) instead of 'i'
#
# R is character-sensitive: 'my_variable' and 'my_varıable'
# are two different objects. Always check for subtle typos!


# EXERCISE 2: Fix the broken code
# ---------------------------------------------------------------
# Original (broken):
#   libary(todyverse)
#   ggplot(dTA = mpg) +
#     geom_point(maping = aes(x = displ y = hwy)) +
#     geom_smooth(method = "lm)
#
# Corrected:
#   - libary()     → library()
#   - todyverse    → tidyverse
#   - dTA          → data
#   - maping       → mapping
#   - missing comma between x = displ and y = hwy
#   - unclosed quote "lm → "lm"

library(tidyverse)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(method = "lm")


# EXERCISE 3: Keyboard shortcut
# ---------------------------------------------------------------
# Press Option+Shift+K (Mac) or Alt+Shift+K (Windows/Linux)
# → Opens the RStudio Keyboard Shortcut Quick Reference sheet
# → Same as: Help > Keyboard Shortcuts Help in the menu bar


# EXERCISE 4: Which plot does ggsave() save?
# ---------------------------------------------------------------
# ggsave() saves my_bar_plot because it is explicitly passed
# via the plot = argument. Without it, ggsave() would default
# to the most recently displayed plot (my_scatter_plot).

my_bar_plot <- ggplot(mpg, aes(x = class)) +
  geom_bar()
my_scatter_plot <- ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave(filename = "mpg-plot.png", plot = my_bar_plot)
# =============================================================






