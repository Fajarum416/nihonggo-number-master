# Tahap 1: Builder
# Menggunakan Node.js untuk membangun aset statis (CSS)
FROM node:18-alpine AS builder

# Menetapkan direktori kerja di dalam container
WORKDIR /app

# Menyalin file package.json dan package-lock.json
COPY package.json package-lock.json* ./

# Menginstal dependensi proyek
RUN npm install

# Menyalin file sumber
COPY src ./src
COPY tailwind.config.js ./

# Menjalankan perintah build untuk menghasilkan output.css
RUN npm run build

# Tahap 2: Final Image
# Menggunakan Nginx untuk menyajikan file statis
FROM nginx:alpine

# Menyalin hasil build dari 'builder' stage ke direktori web server Nginx
COPY --from=builder /app/dist/ /usr/share/nginx/html

# Memberi tahu Docker bahwa container ini akan berjalan di port 80
EXPOSE 80

# Perintah default untuk menjalankan Nginx saat container dimulai
CMD ["nginx", "-g", "daemon off;"]

