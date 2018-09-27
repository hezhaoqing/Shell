sed -i 's#'$1'#'"$PATH"'#' ./test.txt      ### 把$1的值替换为环境变量$PATH的值
sed -i 's#$1#'"$PATH"'#' ./test.txt        ### 把字符串$1替换为环境变量的值

sed 引用变量，见wx_mn里的expect.sh
