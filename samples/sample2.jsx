const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});
const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});
export default function RootLayout() {
  return (
    <html lang="en" test='arst'> 
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased`}
      >
        <someTextWithEntityRefs>&amp; &#x00B7;</someTextWithEntityRefs>
        <div className="w-1/5 mx-auto my-0" > {children} </div>
      </body>
    </html>
  );
}

const Foo = () => {
    return <div>Hello World!</div>;
};
