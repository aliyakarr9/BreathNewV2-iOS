# BreathNew: Ürün Kararları

Bu belge, BreathNew'de alınan kararları ve her birinin bedelini kaydeder.

Her karar üç parçadan oluşur: ne seçildi, neden seçildi, karşılığında neden vazgeçildi.

İlgili belgeler: [PRD](PRD.md) · [Yol haritası](YOL-HARITASI.md)

---

## 1. Veri yalnızca cihazda

**Karar:** Hesap yok, sunucu yok, uygulamada ağ kodu yok. Kullanıcının girdiği her şey cihazdaki uygulama ayarlarında saklanır.

**Neden:** Sigara içmek ve bırakmak sağlıkla ilgili kişisel bir bilgi. Kullanıcının bunu bir şirkete emanet etmesini istemek, ilk açılışta gereksiz bir engel.

**Bedeli:** Uygulama silinirse veri geri gelmez. Cihazlar arasında eşitleme yok. Kullanım verisi toplanamadığı için ürünün işe yarayıp yaramadığı ancak kullanıcı testiyle anlaşılabilir.

## 2. Tasarruf, her dönem kendi fiyatıyla hesaplanır

**Karar:** Fiyat tek bir sayı değil, tarihli kayıtlardan oluşan bir geçmiş. Tasarruf hesaplanırken geçmiş dönemlere bölünür, her dönem o sırada geçerli olan fiyatla toplanır.

**Neden:** Zam geldiğinde yeni fiyatı bütün geçmişe uygulamak tasarrufu bir anda şişirir. Eski fiyatta kalmak ise gerçeğin altında gösterir. İkisi de kullanıcının sayıya güvenini bozar.

**Bedeli:** Ayarlar ekranı karmaşıklaştı: fiyat geçmişi listesi, ekleme ve düzenleme penceresi, silme kuralları. Tek bir fiyat alanı çok daha basit olurdu.

## 3. Zam kaydında gün esas alınır

**Karar:** Fiyat değişikliği günün başından itibaren geçerli sayılır. Aynı güne ikinci kez girilen fiyat yeni kayıt açmaz, o günü günceller. İleri tarihli kayıt girilebilir ve günü gelene kadar hesaba katılmaz.

**Neden:** Kullanıcı zammı çoğu zaman haberden öğrenir ve geçerlilik tarihini bilir, saatini bilmez. Aynı güne iki kayıt neredeyse her zaman bir düzeltmedir.

**Bedeli:** Gün içinde iki kez fiyat değişmesi kaydedilemez. Gerçekte karşılaşılması pek olası değil.

## 4. Sağlık metinleri üç kurumun yayınlarına dayanır

**Karar:** Sağlık çizelgesindeki 13 aşama Dünya Sağlık Örgütü, CDC ve NHS'in yayımladığı bilgilerden alınır. Kaynak bağlantıları uygulamanın içinde durur.

**Neden:** Sağlık hakkında bir şey söyleyen uygulamanın, bunu kimin söylediğini de göstermesi gerekir.

**Bedeli:** Çizelge yalnızca bu kaynakların söylediği kadarını söyleyebilir. Daha çarpıcı ama kaynağı zayıf cümleler dışarıda kalır. Kaynak sayfaları değişirse metinlerin elle güncellenmesi gerekir.

## 5. İyileşme halkası bir tahmindir ve başta hızlı dolar

**Karar:** Özet ekranındaki halka, sigarasız ilk yıldaki ilerlemeyi gösterir. Doğrusal değil: ilk haftada yaklaşık %25'e, ilk ayda yaklaşık %42'ye, üçüncü ayda yaklaşık %61'e ulaşır.

**Neden:** En zor günler ilk günler. Doğrusal bir halka birinci haftanın sonunda %2 gösterirdi, bu da kullanıcıya hiçbir şey kazanmadığını söylemek olurdu.

**Bedeli:** Eğrinin klinik bir dayanağı yok. Uygulama bunun bir ölçüm olmadığını yazıyor, ama uyarı ayrı bir ekranda. Kullanıcının halkayı akciğer sağlığı sanma riski sürüyor.

## 6. Sıfırlama sayacı baştan başlatır

**Karar:** "Sigara İçtim" seçildiğinde bırakma tarihi o an olur. Güncel fiyat korunur, fiyat geçmişi ve kazanımlar sıfırlanır. Onay penceresi çıkar.

**Neden:** Sayacın dürüst kalması gerekir. Sigara içilmiş bir günü sigarasız saymak, bütün sayıları anlamsız kılar.

**Bedeli:** Önceki denemenin kaydı kalmaz. Kullanıcı en kırılgan anında bütün kazanımlarını kaybetmiş görünür. Yol haritasındaki en önemli adaylardan biri bu.

## 7. Bildirimler isteğe bağlı ve yalnızca kazanımlarda gelir

**Karar:** Bildirim izni ilk açılışta istenmez, kullanıcı ayarlardan açar. Açıldığında yalnızca sağlık aşamalarında ve rozetlerde bildirim gelir. Aynı ana denk gelenler tek bildirimde birleşir. Günlük hatırlatma yoktur.

**Neden:** Her bildirim sigarayı hatırlatır. Kutlanacak bir şey olduğunda gelmesi, her gün gelmesinden daha az rahatsız eder.

**Bedeli:** Aşamalar zamanla seyrekleşir. Üçüncü aydan sonra bildirimler aylarca gelmez, kullanıcının uygulamaya dönmesi için bir sebep kalmaz.

## 8. Sade ve klinik bir arayüz

**Karar:** Arayüz sistem renklerini ve standart bileşenleri kullanır. Oyunlaştırma rozetlerle sınırlıdır.

**Neden:** Hedeflenen his: sade, anlaşılır, klinik ve umut veren. Konu sağlık olduğunda renkli ve oyunsu bir arayüz ciddiyeti azaltır.

**Bedeli:** Uygulama daha az eğlenceli. Seri sayacı, günlük görev gibi alışkanlık kurduran araçlar yok.

## 9. Dil uygulamanın içinden seçilir

**Karar:** Türkçe ve İngilizce arasında geçiş ayarlar ekranından yapılır, sistem dilinden bağımsızdır.

**Neden:** Telefonunu İngilizce kullanan biri bu uygulamayı Türkçe okumak isteyebilir. Sağlıkla ilgili metinler ana dilde daha rahat okunur.

**Bedeli:** Dil değişince bildirimlerin yeniden kurulması gibi ek işler doğuyor. Sistem ayarını izlemek daha az kod olurdu.

## 10. Sigara başına süre kullanıcıdan alınır

**Karar:** "Kazanılan Ömür" değeri, kurulumda girilen sigara başına dakikayla hesaplanır. Varsayılan 11 dakika, 1 ile 60 arasında değiştirilebilir.

**Neden:** Sabit bir sayı yerine kullanıcının kendi değerini girebilmesi.

**Bedeli:** Kurulumda bir alan daha. Asıl sorun ise şu: varsayılan değerin kaynağı uygulamada gösterilmiyor ve alanın adı ile sonucun adı aynı şeyi anlatmıyor. 4. kararla çelişen bir nokta, yol haritasında.
