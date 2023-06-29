(defun read-file(filename)		; Read File Function
	(with-open-file (file filename)
		(let ((chars (make-string (file-length file))))
			(read-sequence chars file) chars
		)
	)
)

(defun is_in_alphabet(alpha)		; is_alphabet Function
	(if (not(or (and (> (char-int alpha) 96) (< (char-int alpha) 123))
			(and (> (char-int alpha) 64) (< (char-int alpha) 91))
		))
		nil
		t
	)
)

(defun digit_control(digit)		; Digit Control Function
	(if (not(and (> (char-int digit) 47) (< (char-int digit) 58)))
		nil
		t)
)
(defun my_lexer(whole_input size)
	
	(setq i 0)
	(setq j 0)
	(setq flag nil)
	(setq which_curly 1)
	(loop while (< i size) do ; Loop for all sourceCode
		
		(setq one_char (char whole_input i))	; Each character of string input

		(cond((or (is_in_alphabet one_char) (digit_control one_char))
			(setq temp (string ""))
			(setf j i)

			(loop while (or (digit_control one_char) (is_in_alphabet one_char)) do 	; Saving the all characters or digits.
				(setq temp (concatenate 'string temp (string one_char)))
				(setq j (+ j 1))
				(setq i (+ i 1))
				(setq one_char (char whole_input j))
			)
			(cond
				;;controling keywords
			 	((string-equal temp "exit")   (exit)(setq flag nil))
			 	((string-equal temp "and")    (print "KW_AND")(setq flag t))
			 	((string-equal temp "or")     (print "KW_OR")(setq flag t))
			 	((string-equal temp "not")    (print "KW_NOT")(setq flag t))
			 	((string-equal temp "equal")  (print "KW_EQUAL")(setq flag t))
			 	((string-equal temp "less")   (print "KW_LESS")(setq flag t))
			 	((string-equal temp "nil")    (print "KW_NIL")(setq flag t))
			 	((string-equal temp "list")   (print "KW_LIST")(setq flag t))
			 	((string-equal temp "append") (print "KW_APPEND")(setq flag t))
			 	((string-equal temp "concat") (print "KW_CONCAT")(setq flag t))
			 	((string-equal temp "set")    (print "KW_SET")(setq flag t))
			 	((string-equal temp "deffun") (print "KW_DEFFUN")(setq flag t))
			 	((string-equal temp "for")    (print "KW_FOR")(setq flag t))
			 	((string-equal temp "if")     (print "KW_IF")(setq flag t))
			 	((string-equal temp "laod")   (print "KW_LOAD")(setq flag t))
			 	((string-equal temp "disp")   (print "KW_DISP")(setq flag t))
			 	((string-equal temp "true")   (print "KW_TRUE")(setq flag t))
			 	((string-equal temp "false")  (print "KW_FALSE")(setq flag t))
			 	
			 	;;controlling the value which should not start with zero value
			 	((eq (char temp 0) #\0)
					(if (and ( > (length temp) 1)(digit_control (char temp 1)))
						(progn
							(print "SYNTAX ERRORE Value Can't Start With Zero !!!")
							(return-from my_lexer nil)
						)
					)
				)
			 	((digit_control (char temp 0))(print "VALUE")(setq flag t));;detect the value in a string
			 	((is_in_alphabet (char temp 0)) (print "IDENTIFIER") (setq flag t));;detect the indetifier in a string

			)
		))			 

		(cond
			((equal one_char #\+) (print "OP_PLUS")(setq flag t))
			((equal one_char #\-) (print "OP_MINUS")(setq flag t))
			((equal one_char #\/) (print "OP_DIV")(setq flag t))
			((equal one_char #\*)
				(if(equal (char whole_input (+ i 1)) #\*)
					(progn
						(print "OP_DBLMULT")
						(setq flag t)
						(setq i (+ i 1))
					)
					(progn
						(setq flag t)
						(print "OP_MULT")
					)
				)
			)
			((equal one_char #\() (print "OP_OP")(setq flag t))	
			((equal one_char #\)) (print "OP_CP")(setq flag t))
			((equal one_char #\")
				(if(equal which_curly 1)
					(progn
						(print"OP_OC")
						(setq flag t)
					 	(setf which_curly 0)
					)
					(progn
						(print "OP_CC")
						(setq flag t)
					  	(setf which_curly 1)
					)
				)
			)	
		)
		(if(equal one_char #\;)
			(if(equal (char whole_input (+ i 1)) #\;)
				(progn
					(print "COMMENT")
					(setq flag t)
					(return-from my_lexer flag)
				)
		))
		(setf i (+ i 1))
	) 	
	(return-from my_lexer flag)
)

(defun read_from_file(my_file)

	(let ((in (open my_file :if-does-not-exist nil)))
	 	(when in
	    	(loop for line = (read-line in nil)
	       		while line do
					
					(setq source_code (coerce line 'string))
					(setq size (length source_code)); text length.
					(setq test (my_lexer source_code size))
					(if (eq nil test)
						(progn
							(print "Syntax Errore !! Enter Right Input ")
							(return-from read_from_file)
						)
					)
	    	)
	  	)
	  	(close in)
	 )
)
(defun gpp_interpreter() ;; gpp_interpreter function to start interpreter

	;;starting interpreter as terminal or file reading input >>>
	(setq st(read-line))
	(if(> 5 (length st))
		(progn;;input from terminal
			(loop
			
				(print "_>")
				(setf st(read-line))
				(setq size (length st)); text length.
				(setq test(my_lexer st size))
				(if(equal test nil)
					(progn
						(print "Syntax Errore !!! Enter Right Input :)")
						(return-from gpp_interpreter)
					)
				)
			)
		)
		(progn;;input from filename.g++
			(print"_>")
			(setq filename(subseq st 5));;get the filename from the string stored in st
			(read_from_file filename))
	)
)
;;calling gpp_interpreter
(gpp_interpreter)