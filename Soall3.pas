program Soal3;
uses crt; 

const
    MAX_MHS = 50;   //batas maksimal jumlah mahasiswa 
    MAX_MK  = 20;   //batas maksimal mata kuliah per mahasiswa 

type 
  TMataKuliah = record  // record untuk menyimpan satu mata kuliah
    nama  : string;   
    sks   : integer;  
    nilai : string;    
    skor  : real;      
end;

    TMahasiswa = record    // record untuk menyimpan satu mahasiswa
    nama : string;
    nim  : string;
    jml  : integer;                           
    mk   : array[1..MAX_MK] of TMataKuliah;  
end;

var
    mhs        : array[1..MAX_MHS] of TMahasiswa;  
    jmlMhs     : integer;                           //jumlah mahasiswa yang diinput 
    i, j       : integer;                           //variabel perulangan 
    nilaiInput : string;                            //penampung sementara nilai huruf 

function KeHurufBesar(s: string): string;   //Mengubah nilai huruf jadi bobot angka sesuai soal.Kalau hurufnya tidak dikenali, hasilnya -1 (tanda tidak valid)
var
    k: integer;
begin
    for k := 1 to length(s) do
    s[k] := UpCase(s[k]);   { ubah huruf satu per satu }
    KeHurufBesar := s;
end;

function Bobot(n: string): real;    // Mengubah nilai huruf jadi bobot angka sesuai soal.Kalau hurufnya tidak dikenali, hasilnya -1 (tanda tidak valid) 
begin
    if      n = 'A'  then Bobot := 4
    else if n = 'B+' then Bobot := 3.5
    else if n = 'B'  then Bobot := 3
    else if n = 'C+' then Bobot := 2.5
    else if n = 'C'  then Bobot := 2
    else if n = 'D'  then Bobot := 1
    else if n = 'E'  then Bobot := 0
    else                  Bobot := -1;   //nilai tidak valid 
end;

procedure Tampil(const m: TMahasiswa);  //Menampilkan hasil studi SATU mahasiswa dalam bentuk tabel 
var
    k         : integer;
    totalSkor : real;      
    totalSKS  : integer;   
    ip        : real;      
begin
    totalSkor := 0;
    totalSKS  := 0;

//Cetak identitas mahasiswa 
    writeln('Nama : ', m.nama);
    writeln('NIM  : ', m.nim);

//Cetak header tabel 
    writeln('-------------------------------------------------------');
    writeln('| No | Mata Kuliah          | SKS | Nilai | Skor   |');
    writeln('-------------------------------------------------------');

//Cetak tiap mata kuliah, sambil menjumlahkan total skor dan total SKS 
    for k := 1 to m.jml do
    begin
        writeln('| ', k:2, ' | ', m.mk[k].nama:-20, ' | ', m.mk[k].sks:3,
                ' | ', m.mk[k].nilai:-5, ' | ', m.mk[k].skor:6:1, ' |');
        totalSkor := totalSkor + m.mk[k].skor;   { tambah skor mata kuliah ini }
        totalSKS  := totalSKS + m.mk[k].sks;     { tambah SKS mata kuliah ini }
    end;

//Cetak baris total 
    writeln('-------------------------------------------------------');
    writeln('| TOTAL', '':35, '| ', totalSkor:6:1, ' |');
    writeln('-------------------------------------------------------');

//Hitung IP = total skor / total SKS. Dicek dulu totalSKS > 0 supaya tidak terjadi pembagian dengan nol 
    if totalSKS > 0 then
    ip := totalSkor / totalSKS
    else
    ip := 0;

//Cetak jumlah SKS dan IP 
    writeln('Jumlah SKS : ', totalSKS);
    writeln('IP         : ', ip:0:2);
    writeln;
end;

begin
    clrscr;   

    writeln('=== INPUT HASIL STUDI MAHASISWA ===');

    repeat    //Ulangi sampai jumlah mahasiswa valid (1 sampai MAX_MHS)
        write('Jumlah mahasiswa : ');
        readln(jmlMhs);
    until (jmlMhs >= 1) and (jmlMhs <= MAX_MHS);

//Perulangan luar: input data tiap mahasiswa 
    for i := 1 to jmlMhs do
    begin
        writeln;
        writeln('--- Mahasiswa ke-', i, ' ---');
        write('Nama                    : ');
        readln(mhs[i].nama);
        write('NIM                     : ');
        readln(mhs[i].nim);

    repeat  //Ulangi sampai jumlah mata kuliah valid (1 sampai MAX_MK) 
        write('Jumlah mata kuliah       : ');
        readln(mhs[i].jml);
    until (mhs[i].jml >= 1) and (mhs[i].jml <= MAX_MK);

    //Perulangan dalam: input tiap mata kuliah milik mahasiswa ke-i 
    for j := 1 to mhs[i].jml do
    begin
        writeln('  Mata kuliah ke-', j);
        write('    Nama mata kuliah    : ');
        readln(mhs[i].mk[j].nama);

    //SKS harus lebih dari 0 
        repeat
            write('    Jumlah SKS          : ');
            readln(mhs[i].mk[j].sks);
        until mhs[i].mk[j].sks > 0;

    //Ulangi sampai nilai huruf yang dimasukkan valid 
        repeat
            write('    Nilai (A/B+/B/C+/C/D/E): ');
            readln(nilaiInput);
            nilaiInput := KeHurufBesar(nilaiInput);   //samakan jadi huruf besar 
        until Bobot(nilaiInput) >= 0;

        mhs[i].mk[j].nilai := nilaiInput;

    //Skor = SKS x bobot nilai 
      mhs[i].mk[j].skor := mhs[i].mk[j].sks * Bobot(nilaiInput);
    end;
end;

//Tiap mahasiswa: bersihkan layar, tampilkan datanya, lalu tunggu user menekan sembarang tombol sebelum lanjut ke berikutnya 
    for i := 1 to jmlMhs do
    begin
    clrscr; 
    writeln('=== HASIL STUDI MAHASISWA ', i, ' dari ', jmlMhs, ' ===');
    writeln;
    Tampil(mhs[i]);

    //Pesan tunggu hanya muncul kalau masih ada data berikutnya 
    if i < jmlMhs then
    begin
        writeln('Tekan sembarang tombol untuk melihat data selanjutnya..');
        readkey;   //program berhenti di sini sampai ada tombol ditekan 
    end;
end;

    writeln('Semua data sudah selesai ditampilkan.');
    writeln('Tekan sembarang tombol untuk keluar..');
    readkey;
end.