# BreathNew: Yol Haritası

Son güncelleme: 19 Kasım 2026

Sıralama tarihe göre değil önceliğe göre. Dayandığı riskler [PRD](PRD.md) belgesinde, ilgili kararlar [Kararlar](KARARLAR.md) belgesinde.

## Şimdi

İlk iki iş ürünün verdiği sözle ilgili: sayılar doğru ve kaynağı belli olmalı. Üçüncüsü, bunu gerçek kullanıcıyla sınamanın ön koşulu.

| İş | Neden şimdi | Bittiğini nasıl anlarız |
|---|---|---|
| Tasarruf hesabının testlerini güncel projeye taşımak | Depodaki testler eski kopyaya ait. Ürünün en önemli sözü otomatik olarak doğrulanmıyor. | Testler Xcode projesinde çalışıyor. Eski `Sources/` ve `Tests/` klasörleri kaldırılmış. |
| "Kazanılan Ömür" değerini netleştirmek | Kaynağı gösterilmeyen tek sağlık sayısı bu. Adı da girilen alanla uyuşmuyor. | Ya kaynağı uygulamada gösteriliyor ya da değer "sigaraya harcanmayan süre" olarak yeniden adlandırılıyor. |
| TestFlight ile dağıtım | Tek kurulum yolu Xcode ile derlemek. | Bağlantıya dokunan biri uygulamayı kurabiliyor. |

## Sırada

| İş | Neden |
|---|---|
| Sigarayı yeni bırakmış beş kişiyle iki haftalık kullanıcı testi | Hedef kullanıcı ve başarı ölçütleri hâlâ varsayım. |
| Geçmiş denemelerin kaydı | Sıfırlama bütün kazanımları siliyor. Kullanıcı "toplamda 43 gün sigarasız kaldım" diyebilmeli. |
| En düşük iOS sürümünü indirmek | Uygulama yalnızca iOS 26'da çalışıyor. Pandu'da aynı kısıt iOS 17'ye indirildi. |
| Verinin dışa aktarılması ve geri yüklenmesi | Rozetler 15 yıla uzanıyor, veri tek bir cihazda. |

## Sonra

Bu maddeler kullanıcı testinin sonucuna göre öne çekilebilir ya da listeden çıkabilir.

| İş | Hangi soruya bağlı |
|---|---|
| Sigara isteği geldiği an için bir araç (kısa nefes egzersizi gibi) | Kullanıcılar uygulamayı canları sigara istediğinde mi açıyor, yoksa kazanımı görmek için mi? |
| Ana ekran araç takımı (widget) | Kullanıcılar sayacı görmek için uygulamayı açmak zorunda kalmaktan şikâyet ediyor mu? |
| Aşamalar arasındaki boşlukta geri dönme sebebi | Üçüncü aydan sonra kullanıcılar uygulamayı açmayı bırakıyor mu? |
| İyileşme halkasının yanında kısa bir açıklama | Kullanıcılar halkayı tıbbi bir ölçüm sanıyor mu? |
| App Store yayını | TestFlight'ta ürün yeterince olgunlaştı mı? Sağlık içeriği inceleme kurallarına uyuyor mu? |
| Yeni diller | Türkçe ve İngilizce dışında talep var mı? |

## Yapılmayacaklar

Bilerek dışarıda bırakıldı. Gerekçeleri [Kararlar](KARARLAR.md) belgesinde.

- Hesap ve sunucu
- Tıbbi tavsiye, ilaç ya da doz önerisi
- Reklam
