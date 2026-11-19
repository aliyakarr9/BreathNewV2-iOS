# BreathNew: Ürün Gereksinimleri

| | |
|---|---|
| Sürüm | 1.0 |
| Son güncelleme | 19 Kasım 2026 |
| Sahibi | Ali Yakar |
| İlgili belgeler | [Kararlar](KARARLAR.md) · [Yol haritası](YOL-HARITASI.md) |

## Problem

Sigarayı bırakan biri için ilk günlerde kazanılan şey görünmezdir. Kayıp ise çok somuttur: canı sigara ister. Bırakmanın karşılığını görebilmek, devam etmek için bir sebep verir.

BreathNew bu karşılığı üç sayıya çevirir: sigarasız geçen süre, cepte kalan para ve vücutta olan değişim.

Bu sayıların işe yaraması için kullanıcının onlara güvenmesi gerekir. Güveni bozan iki şey var:

- **Yanlış tasarruf.** Sigara fiyatı yıl içinde değişir. Tek bir fiyatla hesap yapan bir uygulama, zam geldiğinde ya eski fiyatta kalıp gerçeğin altında gösterir ya da yeni fiyatı geçmişe de uygulayıp abartır.
- **Kaynağı belirsiz sağlık bilgisi.** "Akciğerlerin şu kadar iyileşti" gibi bir cümlenin nereden geldiği belli değilse kullanıcı ya inanmaz ya da yanlış bir şeye inanır.

## Kimin için

**Asıl kullanıcı:** Sigarayı yeni bırakmış ya da bırakma tarihini belirlemiş bir yetişkin. Bırakma kararını kendisi vermiş, bir programa ya da kliniğe bağlı değil.

Varsayılan para birimi Türk lirası ve zam takibi ürünün temel özelliklerinden biri. Ürün öncelikle sigara fiyatının sık değiştiği bir ülkedeki kullanıcı düşünülerek kuruldu.

Bu tanım henüz kullanıcı görüşmesiyle doğrulanmadı.

**Kimin için değil:** Sigarayı azaltarak bırakmak isteyenler. Uygulama tek bir bırakma anı üzerine kurulu.

## Temel akış

1. İlk açılışta beş bilgi girilir: bırakma tarihi ve saati, günde içilen sigara, paketteki sigara sayısı, paket fiyatı, sigara başına süre.
2. Özet ekranı açılır: sayaç, iyileşme halkası, tasarruf, içilmeyen sigara sayısı.
3. Kullanıcı sağlık çizelgesine ve rozetlere bakar, isterse bildirimleri açar.
4. Zam geldiğinde ayarlardan yeni fiyatı ve geçerlilik tarihini ekler.
5. Sigara içerse "Sigara İçtim" ile sayacı sıfırlar ve yeniden başlar.

## 1.0'da olanlar

| Gereksinim | Ayrıntı |
|---|---|
| Sigarasız süre | Saniye saniye sayar. Dolmamış birimler (yıl, ay, gün) gizlenir. |
| İyileşme halkası | Sigarasız ilk yıldaki ilerlemeyi gösteren bir tahmin. Altındaki mesaj 12 döneme göre değişir. |
| Tasarruf | Fiyat geçmişindeki her dönem kendi fiyatıyla hesaplanır. |
| Zam takibi | Geçerlilik tarihiyle yeni fiyat. İleri tarihli kayıt girilebilir. Aynı güne ikinci kayıt o günü günceller. |
| Sağlık çizelgesi | 20 dakikadan 15 yıla 13 aşama. Kaynak bağlantıları uygulamanın içinde. |
| Rozetler | 1 saatten 15 yıla 13 rozet. |
| Bildirimler | İsteğe bağlı. Her sağlık aşamasında ve her rozette bir bildirim. |
| Dil ve para birimi | Türkçe ve İngilizce, uygulama içinden. TL, dolar, euro, sterlin. |
| Yeniden başlama | "Sigara İçtim" bırakma tarihini o ana çeker, güncel fiyat korunur. |
| Uyarı metni | Uygulamanın tıbbi cihaz olmadığı ve halkanın bir ölçüm olmadığı uygulama içinde yazar. |
| Gizlilik | Ağ kodu yok. Veri yalnızca cihazda. |
| Erişilebilirlik | Açık ve koyu tema, VoiceOver, "Hareketi Azalt" desteği. |

## 1.0'da olmayanlar

| Konu | Neden yok |
|---|---|
| Tıbbi tavsiye, ilaç ya da nikotin bandı takibi | Uygulama bir takip aracı. Tedavi önermek başka bir sorumluluk düzeyi ister. |
| Azaltarak bırakma | Bütün hesaplar tek bir bırakma tarihine dayanıyor. |
| Hesap, eşitleme, yedekleme | Veri cihazdan çıkmıyor. Bedeli [Kararlar](KARARLAR.md) belgesinde. |
| Topluluk, arkadaş ekleme, paylaşım | Hesap ve sunucu gerektirir. |
| Sigara isteği geldiği an için bir araç | 1.0 kapsamına alınmadı. Yol haritasında aday. |
| Ana ekran araç takımı (widget) | 1.0 kapsamına alınmadı. Yol haritasında aday. |
| Geçmiş denemelerin kaydı | Sıfırlama önceki denemeyi siler. Yol haritasında aday. |
| iPad ve iOS 26 öncesi | Aşağıda risk olarak yazılı. |

## Başarı ölçütleri

Uygulama veri toplamıyor, bu yüzden kullanım uygulamanın içinden ölçülemez. Ayrıca asıl sonuç, yani kullanıcının sigarasız kalması, tek başına bu uygulamaya bağlanamaz. Ölçütler bu yüzden uygulamanın kendi işini ne kadar iyi yaptığına bakıyor.

| Ölçüt | Hedef | Şu anki değer |
|---|---|---|
| İlk açılıştan özet ekranına kadar geçen süre | 60 saniyenin altı | Ölçülmedi |
| Kullanıcının yardım almadan bir zam kaydı ekleyebilmesi | 5 kişiden en az 4'ü | Ölçülmedi |
| Kullanıcının tasarruf sayısının nasıl hesaplandığını kendi cümleleriyle anlatabilmesi | 5 kişiden en az 4'ü | Ölçülmedi |
| Kullanıcının iyileşme halkasını tıbbi bir ölçüm sanmaması | 5 kişiden 5'i | Ölçülmedi |
| İki hafta sonunda uygulamayı hâlâ haftada en az bir kez açan kullanıcı | 5 kişiden en az 3'ü | Ölçülmedi |

Hedefler başlangıç tahmini. İlk kullanıcı testinden sonra güncellenecek.

## Riskler ve açık sorular

**Sıfırlama her şeyi siler.** "Sigara İçtim" seçildiğinde sayaç, tasarruf, rozetler ve fiyat geçmişi baştan başlar. Önceki denemenin hiçbir izi kalmaz. Bırakma sürecinde yeniden başlamak sık yaşanan bir şey. Kullanıcının en kırılgan olduğu anda ekranda yalnızca sıfır görmesi, uygulamayı bırakmasına yol açabilir.

**"Kazanılan Ömür" sayısının kaynağı yok.** Özet ekranındaki bu değer, kurulumda girilen "sigara başına süre" ile hesaplanıyor. Varsayılan 11 dakika. Sağlık çizelgesindeki metinlerin kaynağı uygulamada gösteriliyor, bu sayının kaynağı gösterilmiyor. README aynı değere "geri kazanılan süre" diyor, uygulama "Kazanılan Ömür". İki ad aynı şeyi anlatmıyor.

**İyileşme halkası yanlış anlaşılabilir.** Halka ilk haftada yaklaşık %25'e, ilk ayda yaklaşık %42'ye ulaşıyor. Bu eğri klinik bir veriye dayanmıyor. Uyarı metni bunu söylüyor, ama metin ayrı bir ekranda.

**Veri tek bir yerde duruyor.** Rozetler 15 yıla kadar uzanıyor. Veri ise yalnızca cihazdaki uygulama ayarlarında. Uygulama silinirse geri gelmez. Dışa aktarma yok.

**Tasarruf bir varsayıma dayanıyor.** Hesap, kullanıcının bırakmasaydı her gün aynı sayıda sigara içeceğini kabul ediyor.

**Yalnızca iOS 26 ve iPhone.** Eski sürümdeki telefonlar uygulamayı kuramıyor. Bunun bilinçli bir karar olup olmadığı açık.

**Ürün henüz gerçek kullanıcıya ulaşmıyor.** Tek kurulum yolu kaynak kodu Xcode ile derlemek.

**Güncel uygulamanın testi yok.** Depodaki testler eski Swift Package kopyasına ait. Tasarruf hesabı ürünün en kritik sözü ve şu an otomatik olarak doğrulanmıyor.
