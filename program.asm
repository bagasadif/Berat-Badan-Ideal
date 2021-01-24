;Author     : Bagas Adi Firdaus              
;Tanggal    : 26 Mei 2020
;Deksripsi  : Progam menghitung berat badan ideal

org 0x100
global start
section .text   

%macro cetak_string 1           ; macro untuk mencetak string
    mov   dx, %1                ; string dipindah ke dx
    mov   ah, 0x9               ; interupt untuk print string
    int   0x21                  ; string yang ada di dx diprint
%endmacro

start:   
    cetak_string pembukaan      
   
    mov dl, 10                 ; dl disini untuk perkalian
    mov bl, 0                   ; untuk menyimpan angka berat badan

input_bb:               ; disini user akan menginput berat badannya dengan cara 1 char 1 char
    mov ah, 01h         ; interupt untuk menginput char dan menyimpan di al
    int 21h             ; user input 1 char

    cmp al, 13          ; mengecek apakah user menekan tombol 'enter', jika iya maka program akan lompat ke mengecek jenis kelamin
    je jenis_kelamin    ; ini dikarenakan cara menginputnya adalah dengan 1 char 1 char lalu dijadikan sebuah angka
                        ; contoh: input 169
                        ; kondisi awal: al = gatau, bl = 0, cl = gatau, dl = 10
                        ; iterasi 1: user menekan 1 -> cek apakah user menekan 'enter'? -> Tidak
                        ; iterasi 2: user menekan 6 -> cek apakah user menekan 'enter'? -> Tidak
                        ; iterasi 3: user menekan 9 -> cek apakah user menekan 'enter'? -> Tidak
                        ; iterasi 4: user menekan 'enter' -> cek apakah user menekan 'enter'? -> Ya -> jump ke jenis_kelamin
    
    sub al, 48          ; mengubah ascii menjadi desimal karena inputan user dalam ascii
                        ; iterasi 1: al = 1, bl = 0, cl = gatau, dl = 10
                        ; iterasi 1: al = 6, bl = 1, cl = 1, dl = 10
                        ; iterasi 1: al = 9, bl = 16, cl = 6, dl = 10

    mov cl, al          ; angka yang baru diinput dipindah ke cl
                        ; iterasi 1: al = 1, bl = 0, cl = 1, dl = 10
                        ; iterasi 1: al = 6, bl = 1, cl = 6, dl = 10
                        ; iterasi 1: al = 9, bl = 16, cl = 9, dl = 10

    mov al, bl          ; angka-angka yang sudah diinput sebelumnya dipindah ke al
                        ; iterasi 1: al = 0, bl = 0, cl = 1, dl = 10
                        ; iterasi 1: al = 1, bl = 1, cl = 6, dl = 10
                        ; iterasi 1: al = 16, bl = 16, cl = 9, dl = 10

    mul dl              ; angka-angka sebelumnya dikalikan 10
                        ; iterasi 1: al = 0, bl = 0, cl = 1, dl = 10
                        ; iterasi 1: al = 10, bl = 1, cl = 6, dl = 10
                        ; iterasi 1: al = 160, bl = 16, cl = 9, dl = 10

    add al, cl          ; angka-angka sebelumnya yang sudah dikalikan 10 ditambahkan dengan angka yang diinput 
                        ; iterasi 1: al = 1, bl = 0, cl = 1, dl = 10
                        ; iterasi 1: al = 16, bl = 1, cl = 6, dl = 10
                        ; iterasi 1: al = 169, bl = 16, cl = 9, dl = 10

    mov bl, al          ; simpan angkanya di bl
                        ; iterasi 1: al = 1, bl = 1, cl = 1, dl = 10
                        ; iterasi 1: al = 16, bl = 16, cl = 6, dl = 10
                        ; iterasi 1: al = 169, bl = 169, cl = 9, dl = 10

    jmp input_bb        ; user menginput 1 char lagi

jenis_kelamin:              ; disini user akan menekan angka yang sesuai dengan jenis kelaminnya karena nanti perhitungan
                            ; berat badan idealnya akan berbeda
    cetak_string kelamin    

loop_1:                     ; untuk error_handling jikalau user menekan selain angka 1 atau 2
    cetak_string petunjuk
    mov ah, 01h
    int 21h                 ; user menekan angka

    cmp al, 49              ; cek apakah user menekan angka 1 (ASCII 1 = DESIMAL 49)
    je laki_laki            ; jika ya maka akan loncat ke laki_laki

    cmp al, 50              ; cek apakah user menekan angka 2 (ASCII 2 = DESIMAL 50) 
    jne loop_1              ; jika tidak, maka akan loncat ke loop_1 (error_handling)

perempuan:          ; menghitung rumus berat badan ideal untuk wanita
                    ; rumusnya:  (tinggi badan - 100) - (15% x (tinggi badan - 100))
                    ; misal : 169
                    ; al = 13, bl = 169, ax = 256 + al = 269, bx = gatau, cx = gatau, dx = gatau

    mov al, bl      ; al = 169, bl = 169, ax = 425, bx = gatau, cx = gatau, dx = gatau

    sub ax, 356     ; ax = 69, bx = gatau, cx = gatau, dx = gatau
    mov cx, ax      ; ax = 69, bx = gatau, cx = 69, dx = gatau
    mov bx, 15      ; ax = 69, bx = 15, cx = 69, dx = gatau
    mul bx          ; ax = 1035, bx = 15, cx = 69, dx = gatau
    mov bx, 100     ; ax = 1035, bx = 100, cx = 69, dx = gatau
    mov dx, 0x0     ; ax = 1035, bx = 100, cx = 69, dx = 0
    div bx          ; ax = 10, bx = 100, cx = 69, dx = 0
    sub cx, ax      ; ax = 10, bx = 100, cx = 59, dx = 0
                    ; berarti berat badan idealnya = 59 kg

    jmp print_dec   ; jump ke print_dec untuk ngeprint "59"

laki_laki:          ; menghitung rumus berat badan ideal untuk wanita
                    ; rumusnya:  (tinggi badan - 100) - (10% x (tinggi badan - 100))
                    ; misal : 169
                    ; al = 13, bl = 169, ax = 256 + al = 269, bx = gatau, cx = gatau, dx = gatau

    mov al, bl      ; al = 169, bl = 169, ax = 425, bx = gatau, cx = gatau, dx = gatau

    sub ax, 356     ; ax = 69, bx = gatau, cx = gatau, dx = gatau
    mov cx, ax      ; ax = 69, bx = gatau, cx = 69, dx = gatau
    mov bx, 10      ; ax = 69, bx = 10 cx = 69, dx = gatau
    mov dx, 0x0     ; ax = 69, bx = 10 cx = 69, dx = 0
    div bx          ; ax = 6, bx = 10 cx = 69, dx = 0
    sub cx, ax      ; ax = 6, bx = 10 cx = 63, dx = 0
                    ; berarti berat badan idealnya = 63 kg

print_dec:
    mov ax, cx      ; pindahin berat badan idealnya dari cx ke ax lalu print
	mov bx, 10		; buat ngebagi (dividend)
	mov cx, 0x0		; buat ngitung jumlah digit

div_by_ten:			; bagi 10 buat setiap digitnya
					; terus ambil sisanya. TAPI, kalo langsung
					; di print entar kebalik misal 169 jadi 961
    mov dx, 0x0		; nol-kan dx
    div bx			; bagi 10, sisa bakal ada di dx
    push dx			; biar ga kebalik, push sisa ke stack
					; misal buat 169
					; sebelum iterasi: <- stack top
					; iterasi 1: 9 <- stack top
					; iterasi 2: 6 9 <- stack top
					; iterasi 3: 1 6 9 <- stack top
    inc cx			; increment jumlah digit
    cmp ax, 0x0		; kalo angka udah abis semua berarti ax = 0
    jne div_by_ten	; Jump Not Equal. kalo ax != 0, masih ada angka
					; jadi jump lagi keatas

print_kata:
    cetak_string berat
    
print:
	pop dx			; karena stack sifatnya LIFO maka yang di ambil
					; adalah digit yang terakhir di push.
					; pop (ambil dan hapus) dari stack ke dx
					; misal buat 169
					; sebelum iterasi: 1 6 9 <- stack top; dx = gatau apa
					; iterasi 1: 6 9 <- stack top; dx = 1
					; iterasi 2: 9 <- stack top; dx = 6
					; iterasi 3: <- stack top; dx = 9
    add dl, 48		; char '0' dalam ascii adalah 0x30
					; jadi misal kalo 6 berarti 0x36 atau 0x6 + 0x30.
					; Masukan ke dl buat di print
    mov ah, 0x2		; interrupt buat print 1 character
    int 0x21
    dec cx			; decrement jumlah digit
    jnz print		; kalo masih ada digit (cx != 0), loop lagi buat print

    cetak_string kg

pilihan_akhir:              ; nanti di akhir program user diberi pilihan mau keluar program apa jalanin program lagi
    cetak_string pilihan
loop_2:
    cetak_string petunjuk   
    mov ah, 01h
    int 21h

    cmp al, 49              ; cek apakah user menekan angka 1 (ASCII 1 = DESIMAL 49)
    je start                ; jika ya, maka akan loncat ke start

    cmp al, 50              ; cek apakah user menekan angka 2 (ASCII 2 = DESIMAL 50) 
    jne loop_2              ; jika tidak, maka akan loncat ke loop_2 (error_handling)

exit:
    cetak_string penutup
    mov ah, 0x4C	; interrupt buat exit
	mov al, 0x0     ; return 0
	int 0x21        ; exit program

section .data
pembukaan: db 0xD, 0xA, 0xD, 0xA, "PROGRAM PENGHITUNG BERAT BADAN IDEAL BERDASARKAN RUMUS BROCA",  0xD, 0xA, "Masukkan tinggi badan anda : ", "$"
kelamin: db "Apa jenis kelamin anda?", 0xD, 0xA, "1. Laki-Laki", 0xD, 0xA, "2. Perempuan", 0xD, 0xA, "$"
berat: db 0xD, 0xA, "Berat badan ideal anda adalah : $"
kg: db " kg", 0xD, 0xA, 0xD, 0xA, "$"
pilihan: db "Apakah anda ingin menjalankan program lagi?", 0xD, 0xA, "1. Ya", 0xD, 0xA, "2. Tidak", 0xD, 0xA, "$"
penutup: db 0xD, 0xA, 0xD, 0xA, "TERIMA KASIH SUDAH MENGGUNAKAN PROGRAM INI", 0xD, 0xA, "$"
petunjuk: db "[TEKAN ANGKA 1 ATAU 2]", 0xD, 0xA, "$"
