# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: llegrand <llegrand@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/11/10 16:55:55 by llegrand          #+#    #+#              #
#    Updated: 2024/01/07 13:38:19 by llegrand         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Used by cross-compatibility
UNAME := $(shell uname)

# Linux-OSX cross-compatibility
ifeq ($(UNAME), Linux)
	CHECKER := checker_linux
	CHECKERURL := https://cdn.intra.42.fr/document/document/14174/checker_linux
endif
ifeq ($(UNAME), Darwin)
	CHECKER := checker_Mac
	CHECKERURL := https://cdn.intra.42.fr/document/document/14173/checker_Mac
endif

# Compiler variables
CC := gcc
CCARGS := -o3 #-Wall -Werror -Wextra

VGARG := --log-file=valgrind.txt --leak-check=full --show-leak-kinds=all --track-origins=yes -s

PIPEX := pipex
PIPARGS := 

SRCS := srcs/utils.c

$(PIPEX) : libft.a pipex.c $(SRCS) $(INCLS)
	$(CC) pipex.c  $(SRCS) $(CCARGS) -L. -lft -o $(PIPEX)

# Dependencies
dep : libft.a
	
# Libft compilation
libft.a : libft/Makefile
	cd libft && $(MAKE) -j16
	cp libft/libft.a .

# Get libft submodule from my github
libft/Makefile :
	git submodule update --init libft

# Partial clean
clean :
	cd libft && $(MAKE) clean
	rm -rf build

# Full clean
fclean : clean
	rm -f $(PIPEX) libft.a
	cd libft && $(MAKE) fclean

all : $(PIPEX)

# Recompile
re : fclean all

# Automated valgrind run
vg : ${PIPEX}
	valgrind $(VGARG) ./$(PIPEX) $(PIPARGS)

tester :
	git clone https://github.com/vfurmane/pipex-tester

test :
	cd pipex-tester && ./run.sh
