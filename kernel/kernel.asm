
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	91013103          	ld	sp,-1776(sp) # 80008910 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0bd050ef          	jal	ra,800058d2 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	25e080e7          	jalr	606(ra) # 800062b8 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2fe080e7          	jalr	766(ra) # 8000636c <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	cf6080e7          	jalr	-778(ra) # 80005d80 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	132080e7          	jalr	306(ra) # 80006228 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00026517          	auipc	a0,0x26
    80000106:	13e50513          	addi	a0,a0,318 # 80026240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	addi	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	18a080e7          	jalr	394(ra) # 800062b8 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	addi	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	226080e7          	jalr	550(ra) # 8000636c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	1fc080e7          	jalr	508(ra) # 8000636c <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	bd8080e7          	jalr	-1064(ra) # 80000f00 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00009717          	auipc	a4,0x9
    80000334:	cd070713          	addi	a4,a4,-816 # 80009000 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	bbc080e7          	jalr	-1092(ra) # 80000f00 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	a74080e7          	jalr	-1420(ra) # 80005dca <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	8ec080e7          	jalr	-1812(ra) # 80001c52 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	f42080e7          	jalr	-190(ra) # 800052b0 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	198080e7          	jalr	408(ra) # 8000150e <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	912080e7          	jalr	-1774(ra) # 80005c90 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	c24080e7          	jalr	-988(ra) # 80005faa <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	a34080e7          	jalr	-1484(ra) # 80005dca <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	a24080e7          	jalr	-1500(ra) # 80005dca <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	a14080e7          	jalr	-1516(ra) # 80005dca <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	322080e7          	jalr	802(ra) # 800006e8 <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	a7c080e7          	jalr	-1412(ra) # 80000e52 <procinit>
    trapinit();      // trap vectors
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	84c080e7          	jalr	-1972(ra) # 80001c2a <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00002097          	auipc	ra,0x2
    800003ea:	86c080e7          	jalr	-1940(ra) # 80001c52 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	eac080e7          	jalr	-340(ra) # 8000529a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	eba080e7          	jalr	-326(ra) # 800052b0 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	06a080e7          	jalr	106(ra) # 80002468 <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	6f8080e7          	jalr	1784(ra) # 80002afe <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	6aa080e7          	jalr	1706(ra) # 80003ab8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	fba080e7          	jalr	-70(ra) # 800053d0 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	eb6080e7          	jalr	-330(ra) # 800012d4 <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00009717          	auipc	a4,0x9
    80000430:	bcf72a23          	sw	a5,-1068(a4) # 80009000 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043c:	00009797          	auipc	a5,0x9
    80000440:	bcc7b783          	ld	a5,-1076(a5) # 80009008 <kernel_pagetable>
    80000444:	83b1                	srli	a5,a5,0xc
    80000446:	577d                	li	a4,-1
    80000448:	177e                	slli	a4,a4,0x3f
    8000044a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000450:	12000073          	sfence.vma
  sfence_vma();
}
    80000454:	6422                	ld	s0,8(sp)
    80000456:	0141                	addi	sp,sp,16
    80000458:	8082                	ret

000000008000045a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045a:	7139                	addi	sp,sp,-64
    8000045c:	fc06                	sd	ra,56(sp)
    8000045e:	f822                	sd	s0,48(sp)
    80000460:	f426                	sd	s1,40(sp)
    80000462:	f04a                	sd	s2,32(sp)
    80000464:	ec4e                	sd	s3,24(sp)
    80000466:	e852                	sd	s4,16(sp)
    80000468:	e456                	sd	s5,8(sp)
    8000046a:	e05a                	sd	s6,0(sp)
    8000046c:	0080                	addi	s0,sp,64
    8000046e:	84aa                	mv	s1,a0
    80000470:	89ae                	mv	s3,a1
    80000472:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000474:	57fd                	li	a5,-1
    80000476:	83e9                	srli	a5,a5,0x1a
    80000478:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047c:	04b7f263          	bgeu	a5,a1,800004c0 <walk+0x66>
    panic("walk");
    80000480:	00008517          	auipc	a0,0x8
    80000484:	bd050513          	addi	a0,a0,-1072 # 80008050 <etext+0x50>
    80000488:	00006097          	auipc	ra,0x6
    8000048c:	8f8080e7          	jalr	-1800(ra) # 80005d80 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000490:	060a8663          	beqz	s5,800004fc <walk+0xa2>
    80000494:	00000097          	auipc	ra,0x0
    80000498:	c86080e7          	jalr	-890(ra) # 8000011a <kalloc>
    8000049c:	84aa                	mv	s1,a0
    8000049e:	c529                	beqz	a0,800004e8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a0:	6605                	lui	a2,0x1
    800004a2:	4581                	li	a1,0
    800004a4:	00000097          	auipc	ra,0x0
    800004a8:	cd6080e7          	jalr	-810(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ac:	00c4d793          	srli	a5,s1,0xc
    800004b0:	07aa                	slli	a5,a5,0xa
    800004b2:	0017e793          	ori	a5,a5,1
    800004b6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004ba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    800004bc:	036a0063          	beq	s4,s6,800004dc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c0:	0149d933          	srl	s2,s3,s4
    800004c4:	1ff97913          	andi	s2,s2,511
    800004c8:	090e                	slli	s2,s2,0x3
    800004ca:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004cc:	00093483          	ld	s1,0(s2)
    800004d0:	0014f793          	andi	a5,s1,1
    800004d4:	dfd5                	beqz	a5,80000490 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d6:	80a9                	srli	s1,s1,0xa
    800004d8:	04b2                	slli	s1,s1,0xc
    800004da:	b7c5                	j	800004ba <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004dc:	00c9d513          	srli	a0,s3,0xc
    800004e0:	1ff57513          	andi	a0,a0,511
    800004e4:	050e                	slli	a0,a0,0x3
    800004e6:	9526                	add	a0,a0,s1
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	74a2                	ld	s1,40(sp)
    800004ee:	7902                	ld	s2,32(sp)
    800004f0:	69e2                	ld	s3,24(sp)
    800004f2:	6a42                	ld	s4,16(sp)
    800004f4:	6aa2                	ld	s5,8(sp)
    800004f6:	6b02                	ld	s6,0(sp)
    800004f8:	6121                	addi	sp,sp,64
    800004fa:	8082                	ret
        return 0;
    800004fc:	4501                	li	a0,0
    800004fe:	b7ed                	j	800004e8 <walk+0x8e>

0000000080000500 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000500:	57fd                	li	a5,-1
    80000502:	83e9                	srli	a5,a5,0x1a
    80000504:	00b7f463          	bgeu	a5,a1,8000050c <walkaddr+0xc>
    return 0;
    80000508:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050a:	8082                	ret
{
    8000050c:	1141                	addi	sp,sp,-16
    8000050e:	e406                	sd	ra,8(sp)
    80000510:	e022                	sd	s0,0(sp)
    80000512:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000514:	4601                	li	a2,0
    80000516:	00000097          	auipc	ra,0x0
    8000051a:	f44080e7          	jalr	-188(ra) # 8000045a <walk>
  if(pte == 0)
    8000051e:	c105                	beqz	a0,8000053e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000520:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000522:	0117f693          	andi	a3,a5,17
    80000526:	4745                	li	a4,17
    return 0;
    80000528:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052a:	00e68663          	beq	a3,a4,80000536 <walkaddr+0x36>
}
    8000052e:	60a2                	ld	ra,8(sp)
    80000530:	6402                	ld	s0,0(sp)
    80000532:	0141                	addi	sp,sp,16
    80000534:	8082                	ret
  pa = PTE2PA(*pte);
    80000536:	83a9                	srli	a5,a5,0xa
    80000538:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053c:	bfcd                	j	8000052e <walkaddr+0x2e>
    return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7fd                	j	8000052e <walkaddr+0x2e>

0000000080000542 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000542:	715d                	addi	sp,sp,-80
    80000544:	e486                	sd	ra,72(sp)
    80000546:	e0a2                	sd	s0,64(sp)
    80000548:	fc26                	sd	s1,56(sp)
    8000054a:	f84a                	sd	s2,48(sp)
    8000054c:	f44e                	sd	s3,40(sp)
    8000054e:	f052                	sd	s4,32(sp)
    80000550:	ec56                	sd	s5,24(sp)
    80000552:	e85a                	sd	s6,16(sp)
    80000554:	e45e                	sd	s7,8(sp)
    80000556:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000558:	c639                	beqz	a2,800005a6 <mappages+0x64>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055e:	777d                	lui	a4,0xfffff
    80000560:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000564:	fff58993          	addi	s3,a1,-1
    80000568:	99b2                	add	s3,s3,a2
    8000056a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000056e:	893e                	mv	s2,a5
    80000570:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	eda080e7          	jalr	-294(ra) # 8000045a <walk>
    80000588:	cd1d                	beqz	a0,800005c6 <mappages+0x84>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e785                	bnez	a5,800005b6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	05390063          	beq	s2,s3,800005de <mappages+0x9c>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x34>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00005097          	auipc	ra,0x5
    800005b2:	7d2080e7          	jalr	2002(ra) # 80005d80 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	7c2080e7          	jalr	1986(ra) # 80005d80 <panic>
      return -1;
    800005c6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c8:	60a6                	ld	ra,72(sp)
    800005ca:	6406                	ld	s0,64(sp)
    800005cc:	74e2                	ld	s1,56(sp)
    800005ce:	7942                	ld	s2,48(sp)
    800005d0:	79a2                	ld	s3,40(sp)
    800005d2:	7a02                	ld	s4,32(sp)
    800005d4:	6ae2                	ld	s5,24(sp)
    800005d6:	6b42                	ld	s6,16(sp)
    800005d8:	6ba2                	ld	s7,8(sp)
    800005da:	6161                	addi	sp,sp,80
    800005dc:	8082                	ret
  return 0;
    800005de:	4501                	li	a0,0
    800005e0:	b7e5                	j	800005c8 <mappages+0x86>

00000000800005e2 <kvmmap>:
{
    800005e2:	1141                	addi	sp,sp,-16
    800005e4:	e406                	sd	ra,8(sp)
    800005e6:	e022                	sd	s0,0(sp)
    800005e8:	0800                	addi	s0,sp,16
    800005ea:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ec:	86b2                	mv	a3,a2
    800005ee:	863e                	mv	a2,a5
    800005f0:	00000097          	auipc	ra,0x0
    800005f4:	f52080e7          	jalr	-174(ra) # 80000542 <mappages>
    800005f8:	e509                	bnez	a0,80000602 <kvmmap+0x20>
}
    800005fa:	60a2                	ld	ra,8(sp)
    800005fc:	6402                	ld	s0,0(sp)
    800005fe:	0141                	addi	sp,sp,16
    80000600:	8082                	ret
    panic("kvmmap");
    80000602:	00008517          	auipc	a0,0x8
    80000606:	a7650513          	addi	a0,a0,-1418 # 80008078 <etext+0x78>
    8000060a:	00005097          	auipc	ra,0x5
    8000060e:	776080e7          	jalr	1910(ra) # 80005d80 <panic>

0000000080000612 <kvmmake>:
{
    80000612:	1101                	addi	sp,sp,-32
    80000614:	ec06                	sd	ra,24(sp)
    80000616:	e822                	sd	s0,16(sp)
    80000618:	e426                	sd	s1,8(sp)
    8000061a:	e04a                	sd	s2,0(sp)
    8000061c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	afc080e7          	jalr	-1284(ra) # 8000011a <kalloc>
    80000626:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000628:	6605                	lui	a2,0x1
    8000062a:	4581                	li	a1,0
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	b4e080e7          	jalr	-1202(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000634:	4719                	li	a4,6
    80000636:	6685                	lui	a3,0x1
    80000638:	10000637          	lui	a2,0x10000
    8000063c:	100005b7          	lui	a1,0x10000
    80000640:	8526                	mv	a0,s1
    80000642:	00000097          	auipc	ra,0x0
    80000646:	fa0080e7          	jalr	-96(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064a:	4719                	li	a4,6
    8000064c:	6685                	lui	a3,0x1
    8000064e:	10001637          	lui	a2,0x10001
    80000652:	100015b7          	lui	a1,0x10001
    80000656:	8526                	mv	a0,s1
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	f8a080e7          	jalr	-118(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000660:	4719                	li	a4,6
    80000662:	004006b7          	lui	a3,0x400
    80000666:	0c000637          	lui	a2,0xc000
    8000066a:	0c0005b7          	lui	a1,0xc000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	f72080e7          	jalr	-142(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000678:	00008917          	auipc	s2,0x8
    8000067c:	98890913          	addi	s2,s2,-1656 # 80008000 <etext>
    80000680:	4729                	li	a4,10
    80000682:	80008697          	auipc	a3,0x80008
    80000686:	97e68693          	addi	a3,a3,-1666 # 8000 <_entry-0x7fff8000>
    8000068a:	4605                	li	a2,1
    8000068c:	067e                	slli	a2,a2,0x1f
    8000068e:	85b2                	mv	a1,a2
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	f50080e7          	jalr	-176(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	46c5                	li	a3,17
    8000069e:	06ee                	slli	a3,a3,0x1b
    800006a0:	412686b3          	sub	a3,a3,s2
    800006a4:	864a                	mv	a2,s2
    800006a6:	85ca                	mv	a1,s2
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f38080e7          	jalr	-200(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b2:	4729                	li	a4,10
    800006b4:	6685                	lui	a3,0x1
    800006b6:	00007617          	auipc	a2,0x7
    800006ba:	94a60613          	addi	a2,a2,-1718 # 80007000 <_trampoline>
    800006be:	040005b7          	lui	a1,0x4000
    800006c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c4:	05b2                	slli	a1,a1,0xc
    800006c6:	8526                	mv	a0,s1
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	f1a080e7          	jalr	-230(ra) # 800005e2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	6ec080e7          	jalr	1772(ra) # 80000dbe <proc_mapstacks>
}
    800006da:	8526                	mv	a0,s1
    800006dc:	60e2                	ld	ra,24(sp)
    800006de:	6442                	ld	s0,16(sp)
    800006e0:	64a2                	ld	s1,8(sp)
    800006e2:	6902                	ld	s2,0(sp)
    800006e4:	6105                	addi	sp,sp,32
    800006e6:	8082                	ret

00000000800006e8 <kvminit>:
{
    800006e8:	1141                	addi	sp,sp,-16
    800006ea:	e406                	sd	ra,8(sp)
    800006ec:	e022                	sd	s0,0(sp)
    800006ee:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	f22080e7          	jalr	-222(ra) # 80000612 <kvmmake>
    800006f8:	00009797          	auipc	a5,0x9
    800006fc:	90a7b823          	sd	a0,-1776(a5) # 80009008 <kernel_pagetable>
}
    80000700:	60a2                	ld	ra,8(sp)
    80000702:	6402                	ld	s0,0(sp)
    80000704:	0141                	addi	sp,sp,16
    80000706:	8082                	ret

0000000080000708 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000708:	715d                	addi	sp,sp,-80
    8000070a:	e486                	sd	ra,72(sp)
    8000070c:	e0a2                	sd	s0,64(sp)
    8000070e:	fc26                	sd	s1,56(sp)
    80000710:	f84a                	sd	s2,48(sp)
    80000712:	f44e                	sd	s3,40(sp)
    80000714:	f052                	sd	s4,32(sp)
    80000716:	ec56                	sd	s5,24(sp)
    80000718:	e85a                	sd	s6,16(sp)
    8000071a:	e45e                	sd	s7,8(sp)
    8000071c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000071e:	03459793          	slli	a5,a1,0x34
    80000722:	e795                	bnez	a5,8000074e <uvmunmap+0x46>
    80000724:	8a2a                	mv	s4,a0
    80000726:	892e                	mv	s2,a1
    80000728:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072a:	0632                	slli	a2,a2,0xc
    8000072c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000730:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000732:	6b05                	lui	s6,0x1
    80000734:	0735e263          	bltu	a1,s3,80000798 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000738:	60a6                	ld	ra,72(sp)
    8000073a:	6406                	ld	s0,64(sp)
    8000073c:	74e2                	ld	s1,56(sp)
    8000073e:	7942                	ld	s2,48(sp)
    80000740:	79a2                	ld	s3,40(sp)
    80000742:	7a02                	ld	s4,32(sp)
    80000744:	6ae2                	ld	s5,24(sp)
    80000746:	6b42                	ld	s6,16(sp)
    80000748:	6ba2                	ld	s7,8(sp)
    8000074a:	6161                	addi	sp,sp,80
    8000074c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000074e:	00008517          	auipc	a0,0x8
    80000752:	93250513          	addi	a0,a0,-1742 # 80008080 <etext+0x80>
    80000756:	00005097          	auipc	ra,0x5
    8000075a:	62a080e7          	jalr	1578(ra) # 80005d80 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	61a080e7          	jalr	1562(ra) # 80005d80 <panic>
      panic("uvmunmap: not mapped");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00005097          	auipc	ra,0x5
    8000077a:	60a080e7          	jalr	1546(ra) # 80005d80 <panic>
      panic("uvmunmap: not a leaf");
    8000077e:	00008517          	auipc	a0,0x8
    80000782:	94250513          	addi	a0,a0,-1726 # 800080c0 <etext+0xc0>
    80000786:	00005097          	auipc	ra,0x5
    8000078a:	5fa080e7          	jalr	1530(ra) # 80005d80 <panic>
    *pte = 0;
    8000078e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000792:	995a                	add	s2,s2,s6
    80000794:	fb3972e3          	bgeu	s2,s3,80000738 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000798:	4601                	li	a2,0
    8000079a:	85ca                	mv	a1,s2
    8000079c:	8552                	mv	a0,s4
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	cbc080e7          	jalr	-836(ra) # 8000045a <walk>
    800007a6:	84aa                	mv	s1,a0
    800007a8:	d95d                	beqz	a0,8000075e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007aa:	6108                	ld	a0,0(a0)
    800007ac:	00157793          	andi	a5,a0,1
    800007b0:	dfdd                	beqz	a5,8000076e <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b2:	3ff57793          	andi	a5,a0,1023
    800007b6:	fd7784e3          	beq	a5,s7,8000077e <uvmunmap+0x76>
    if(do_free){
    800007ba:	fc0a8ae3          	beqz	s5,8000078e <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007be:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c0:	0532                	slli	a0,a0,0xc
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	85a080e7          	jalr	-1958(ra) # 8000001c <kfree>
    800007ca:	b7d1                	j	8000078e <uvmunmap+0x86>

00000000800007cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007cc:	1101                	addi	sp,sp,-32
    800007ce:	ec06                	sd	ra,24(sp)
    800007d0:	e822                	sd	s0,16(sp)
    800007d2:	e426                	sd	s1,8(sp)
    800007d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	944080e7          	jalr	-1724(ra) # 8000011a <kalloc>
    800007de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e0:	c519                	beqz	a0,800007ee <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e2:	6605                	lui	a2,0x1
    800007e4:	4581                	li	a1,0
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	994080e7          	jalr	-1644(ra) # 8000017a <memset>
  return pagetable;
}
    800007ee:	8526                	mv	a0,s1
    800007f0:	60e2                	ld	ra,24(sp)
    800007f2:	6442                	ld	s0,16(sp)
    800007f4:	64a2                	ld	s1,8(sp)
    800007f6:	6105                	addi	sp,sp,32
    800007f8:	8082                	ret

00000000800007fa <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fa:	7179                	addi	sp,sp,-48
    800007fc:	f406                	sd	ra,40(sp)
    800007fe:	f022                	sd	s0,32(sp)
    80000800:	ec26                	sd	s1,24(sp)
    80000802:	e84a                	sd	s2,16(sp)
    80000804:	e44e                	sd	s3,8(sp)
    80000806:	e052                	sd	s4,0(sp)
    80000808:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080a:	6785                	lui	a5,0x1
    8000080c:	04f67863          	bgeu	a2,a5,8000085c <uvminit+0x62>
    80000810:	8a2a                	mv	s4,a0
    80000812:	89ae                	mv	s3,a1
    80000814:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	904080e7          	jalr	-1788(ra) # 8000011a <kalloc>
    8000081e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000820:	6605                	lui	a2,0x1
    80000822:	4581                	li	a1,0
    80000824:	00000097          	auipc	ra,0x0
    80000828:	956080e7          	jalr	-1706(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082c:	4779                	li	a4,30
    8000082e:	86ca                	mv	a3,s2
    80000830:	6605                	lui	a2,0x1
    80000832:	4581                	li	a1,0
    80000834:	8552                	mv	a0,s4
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	d0c080e7          	jalr	-756(ra) # 80000542 <mappages>
  memmove(mem, src, sz);
    8000083e:	8626                	mv	a2,s1
    80000840:	85ce                	mv	a1,s3
    80000842:	854a                	mv	a0,s2
    80000844:	00000097          	auipc	ra,0x0
    80000848:	992080e7          	jalr	-1646(ra) # 800001d6 <memmove>
}
    8000084c:	70a2                	ld	ra,40(sp)
    8000084e:	7402                	ld	s0,32(sp)
    80000850:	64e2                	ld	s1,24(sp)
    80000852:	6942                	ld	s2,16(sp)
    80000854:	69a2                	ld	s3,8(sp)
    80000856:	6a02                	ld	s4,0(sp)
    80000858:	6145                	addi	sp,sp,48
    8000085a:	8082                	ret
    panic("inituvm: more than a page");
    8000085c:	00008517          	auipc	a0,0x8
    80000860:	87c50513          	addi	a0,a0,-1924 # 800080d8 <etext+0xd8>
    80000864:	00005097          	auipc	ra,0x5
    80000868:	51c080e7          	jalr	1308(ra) # 80005d80 <panic>

000000008000086c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086c:	1101                	addi	sp,sp,-32
    8000086e:	ec06                	sd	ra,24(sp)
    80000870:	e822                	sd	s0,16(sp)
    80000872:	e426                	sd	s1,8(sp)
    80000874:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000876:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000878:	00b67d63          	bgeu	a2,a1,80000892 <uvmdealloc+0x26>
    8000087c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087e:	6785                	lui	a5,0x1
    80000880:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000882:	00f60733          	add	a4,a2,a5
    80000886:	76fd                	lui	a3,0xfffff
    80000888:	8f75                	and	a4,a4,a3
    8000088a:	97ae                	add	a5,a5,a1
    8000088c:	8ff5                	and	a5,a5,a3
    8000088e:	00f76863          	bltu	a4,a5,8000089e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000892:	8526                	mv	a0,s1
    80000894:	60e2                	ld	ra,24(sp)
    80000896:	6442                	ld	s0,16(sp)
    80000898:	64a2                	ld	s1,8(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089e:	8f99                	sub	a5,a5,a4
    800008a0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a2:	4685                	li	a3,1
    800008a4:	0007861b          	sext.w	a2,a5
    800008a8:	85ba                	mv	a1,a4
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	e5e080e7          	jalr	-418(ra) # 80000708 <uvmunmap>
    800008b2:	b7c5                	j	80000892 <uvmdealloc+0x26>

00000000800008b4 <uvmalloc>:
  if(newsz < oldsz)
    800008b4:	0ab66163          	bltu	a2,a1,80000956 <uvmalloc+0xa2>
{
    800008b8:	7139                	addi	sp,sp,-64
    800008ba:	fc06                	sd	ra,56(sp)
    800008bc:	f822                	sd	s0,48(sp)
    800008be:	f426                	sd	s1,40(sp)
    800008c0:	f04a                	sd	s2,32(sp)
    800008c2:	ec4e                	sd	s3,24(sp)
    800008c4:	e852                	sd	s4,16(sp)
    800008c6:	e456                	sd	s5,8(sp)
    800008c8:	0080                	addi	s0,sp,64
    800008ca:	8aaa                	mv	s5,a0
    800008cc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d2:	95be                	add	a1,a1,a5
    800008d4:	77fd                	lui	a5,0xfffff
    800008d6:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008da:	08c9f063          	bgeu	s3,a2,8000095a <uvmalloc+0xa6>
    800008de:	894e                	mv	s2,s3
    mem = kalloc();
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	83a080e7          	jalr	-1990(ra) # 8000011a <kalloc>
    800008e8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008ea:	c51d                	beqz	a0,80000918 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ec:	6605                	lui	a2,0x1
    800008ee:	4581                	li	a1,0
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	88a080e7          	jalr	-1910(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f8:	4779                	li	a4,30
    800008fa:	86a6                	mv	a3,s1
    800008fc:	6605                	lui	a2,0x1
    800008fe:	85ca                	mv	a1,s2
    80000900:	8556                	mv	a0,s5
    80000902:	00000097          	auipc	ra,0x0
    80000906:	c40080e7          	jalr	-960(ra) # 80000542 <mappages>
    8000090a:	e905                	bnez	a0,8000093a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090c:	6785                	lui	a5,0x1
    8000090e:	993e                	add	s2,s2,a5
    80000910:	fd4968e3          	bltu	s2,s4,800008e0 <uvmalloc+0x2c>
  return newsz;
    80000914:	8552                	mv	a0,s4
    80000916:	a809                	j	80000928 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000918:	864e                	mv	a2,s3
    8000091a:	85ca                	mv	a1,s2
    8000091c:	8556                	mv	a0,s5
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	f4e080e7          	jalr	-178(ra) # 8000086c <uvmdealloc>
      return 0;
    80000926:	4501                	li	a0,0
}
    80000928:	70e2                	ld	ra,56(sp)
    8000092a:	7442                	ld	s0,48(sp)
    8000092c:	74a2                	ld	s1,40(sp)
    8000092e:	7902                	ld	s2,32(sp)
    80000930:	69e2                	ld	s3,24(sp)
    80000932:	6a42                	ld	s4,16(sp)
    80000934:	6aa2                	ld	s5,8(sp)
    80000936:	6121                	addi	sp,sp,64
    80000938:	8082                	ret
      kfree(mem);
    8000093a:	8526                	mv	a0,s1
    8000093c:	fffff097          	auipc	ra,0xfffff
    80000940:	6e0080e7          	jalr	1760(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f22080e7          	jalr	-222(ra) # 8000086c <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
    80000954:	bfd1                	j	80000928 <uvmalloc+0x74>
    return oldsz;
    80000956:	852e                	mv	a0,a1
}
    80000958:	8082                	ret
  return newsz;
    8000095a:	8532                	mv	a0,a2
    8000095c:	b7f1                	j	80000928 <uvmalloc+0x74>

000000008000095e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095e:	7179                	addi	sp,sp,-48
    80000960:	f406                	sd	ra,40(sp)
    80000962:	f022                	sd	s0,32(sp)
    80000964:	ec26                	sd	s1,24(sp)
    80000966:	e84a                	sd	s2,16(sp)
    80000968:	e44e                	sd	s3,8(sp)
    8000096a:	e052                	sd	s4,0(sp)
    8000096c:	1800                	addi	s0,sp,48
    8000096e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000970:	84aa                	mv	s1,a0
    80000972:	6905                	lui	s2,0x1
    80000974:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000976:	4985                	li	s3,1
    80000978:	a829                	j	80000992 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000097a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000097c:	00c79513          	slli	a0,a5,0xc
    80000980:	00000097          	auipc	ra,0x0
    80000984:	fde080e7          	jalr	-34(ra) # 8000095e <freewalk>
      pagetable[i] = 0;
    80000988:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000098c:	04a1                	addi	s1,s1,8
    8000098e:	03248163          	beq	s1,s2,800009b0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000992:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000994:	00f7f713          	andi	a4,a5,15
    80000998:	ff3701e3          	beq	a4,s3,8000097a <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000099c:	8b85                	andi	a5,a5,1
    8000099e:	d7fd                	beqz	a5,8000098c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009a0:	00007517          	auipc	a0,0x7
    800009a4:	75850513          	addi	a0,a0,1880 # 800080f8 <etext+0xf8>
    800009a8:	00005097          	auipc	ra,0x5
    800009ac:	3d8080e7          	jalr	984(ra) # 80005d80 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b0:	8552                	mv	a0,s4
    800009b2:	fffff097          	auipc	ra,0xfffff
    800009b6:	66a080e7          	jalr	1642(ra) # 8000001c <kfree>
}
    800009ba:	70a2                	ld	ra,40(sp)
    800009bc:	7402                	ld	s0,32(sp)
    800009be:	64e2                	ld	s1,24(sp)
    800009c0:	6942                	ld	s2,16(sp)
    800009c2:	69a2                	ld	s3,8(sp)
    800009c4:	6a02                	ld	s4,0(sp)
    800009c6:	6145                	addi	sp,sp,48
    800009c8:	8082                	ret

00000000800009ca <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ca:	1101                	addi	sp,sp,-32
    800009cc:	ec06                	sd	ra,24(sp)
    800009ce:	e822                	sd	s0,16(sp)
    800009d0:	e426                	sd	s1,8(sp)
    800009d2:	1000                	addi	s0,sp,32
    800009d4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d6:	e999                	bnez	a1,800009ec <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d8:	8526                	mv	a0,s1
    800009da:	00000097          	auipc	ra,0x0
    800009de:	f84080e7          	jalr	-124(ra) # 8000095e <freewalk>
}
    800009e2:	60e2                	ld	ra,24(sp)
    800009e4:	6442                	ld	s0,16(sp)
    800009e6:	64a2                	ld	s1,8(sp)
    800009e8:	6105                	addi	sp,sp,32
    800009ea:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009ec:	6785                	lui	a5,0x1
    800009ee:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f0:	95be                	add	a1,a1,a5
    800009f2:	4685                	li	a3,1
    800009f4:	00c5d613          	srli	a2,a1,0xc
    800009f8:	4581                	li	a1,0
    800009fa:	00000097          	auipc	ra,0x0
    800009fe:	d0e080e7          	jalr	-754(ra) # 80000708 <uvmunmap>
    80000a02:	bfd9                	j	800009d8 <uvmfree+0xe>

0000000080000a04 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a04:	c679                	beqz	a2,80000ad2 <uvmcopy+0xce>
{
    80000a06:	715d                	addi	sp,sp,-80
    80000a08:	e486                	sd	ra,72(sp)
    80000a0a:	e0a2                	sd	s0,64(sp)
    80000a0c:	fc26                	sd	s1,56(sp)
    80000a0e:	f84a                	sd	s2,48(sp)
    80000a10:	f44e                	sd	s3,40(sp)
    80000a12:	f052                	sd	s4,32(sp)
    80000a14:	ec56                	sd	s5,24(sp)
    80000a16:	e85a                	sd	s6,16(sp)
    80000a18:	e45e                	sd	s7,8(sp)
    80000a1a:	0880                	addi	s0,sp,80
    80000a1c:	8b2a                	mv	s6,a0
    80000a1e:	8aae                	mv	s5,a1
    80000a20:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a22:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a24:	4601                	li	a2,0
    80000a26:	85ce                	mv	a1,s3
    80000a28:	855a                	mv	a0,s6
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	a30080e7          	jalr	-1488(ra) # 8000045a <walk>
    80000a32:	c531                	beqz	a0,80000a7e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a34:	6118                	ld	a4,0(a0)
    80000a36:	00177793          	andi	a5,a4,1
    80000a3a:	cbb1                	beqz	a5,80000a8e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3c:	00a75593          	srli	a1,a4,0xa
    80000a40:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a44:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a48:	fffff097          	auipc	ra,0xfffff
    80000a4c:	6d2080e7          	jalr	1746(ra) # 8000011a <kalloc>
    80000a50:	892a                	mv	s2,a0
    80000a52:	c939                	beqz	a0,80000aa8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a54:	6605                	lui	a2,0x1
    80000a56:	85de                	mv	a1,s7
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	77e080e7          	jalr	1918(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a60:	8726                	mv	a4,s1
    80000a62:	86ca                	mv	a3,s2
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85ce                	mv	a1,s3
    80000a68:	8556                	mv	a0,s5
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	ad8080e7          	jalr	-1320(ra) # 80000542 <mappages>
    80000a72:	e515                	bnez	a0,80000a9e <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a74:	6785                	lui	a5,0x1
    80000a76:	99be                	add	s3,s3,a5
    80000a78:	fb49e6e3          	bltu	s3,s4,80000a24 <uvmcopy+0x20>
    80000a7c:	a081                	j	80000abc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a7e:	00007517          	auipc	a0,0x7
    80000a82:	68a50513          	addi	a0,a0,1674 # 80008108 <etext+0x108>
    80000a86:	00005097          	auipc	ra,0x5
    80000a8a:	2fa080e7          	jalr	762(ra) # 80005d80 <panic>
      panic("uvmcopy: page not present");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	69a50513          	addi	a0,a0,1690 # 80008128 <etext+0x128>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	2ea080e7          	jalr	746(ra) # 80005d80 <panic>
      kfree(mem);
    80000a9e:	854a                	mv	a0,s2
    80000aa0:	fffff097          	auipc	ra,0xfffff
    80000aa4:	57c080e7          	jalr	1404(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa8:	4685                	li	a3,1
    80000aaa:	00c9d613          	srli	a2,s3,0xc
    80000aae:	4581                	li	a1,0
    80000ab0:	8556                	mv	a0,s5
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	c56080e7          	jalr	-938(ra) # 80000708 <uvmunmap>
  return -1;
    80000aba:	557d                	li	a0,-1
}
    80000abc:	60a6                	ld	ra,72(sp)
    80000abe:	6406                	ld	s0,64(sp)
    80000ac0:	74e2                	ld	s1,56(sp)
    80000ac2:	7942                	ld	s2,48(sp)
    80000ac4:	79a2                	ld	s3,40(sp)
    80000ac6:	7a02                	ld	s4,32(sp)
    80000ac8:	6ae2                	ld	s5,24(sp)
    80000aca:	6b42                	ld	s6,16(sp)
    80000acc:	6ba2                	ld	s7,8(sp)
    80000ace:	6161                	addi	sp,sp,80
    80000ad0:	8082                	ret
  return 0;
    80000ad2:	4501                	li	a0,0
}
    80000ad4:	8082                	ret

0000000080000ad6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad6:	1141                	addi	sp,sp,-16
    80000ad8:	e406                	sd	ra,8(sp)
    80000ada:	e022                	sd	s0,0(sp)
    80000adc:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ade:	4601                	li	a2,0
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	97a080e7          	jalr	-1670(ra) # 8000045a <walk>
  if(pte == 0)
    80000ae8:	c901                	beqz	a0,80000af8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aea:	611c                	ld	a5,0(a0)
    80000aec:	9bbd                	andi	a5,a5,-17
    80000aee:	e11c                	sd	a5,0(a0)
}
    80000af0:	60a2                	ld	ra,8(sp)
    80000af2:	6402                	ld	s0,0(sp)
    80000af4:	0141                	addi	sp,sp,16
    80000af6:	8082                	ret
    panic("uvmclear");
    80000af8:	00007517          	auipc	a0,0x7
    80000afc:	65050513          	addi	a0,a0,1616 # 80008148 <etext+0x148>
    80000b00:	00005097          	auipc	ra,0x5
    80000b04:	280080e7          	jalr	640(ra) # 80005d80 <panic>

0000000080000b08 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b08:	c6bd                	beqz	a3,80000b76 <copyout+0x6e>
{
    80000b0a:	715d                	addi	sp,sp,-80
    80000b0c:	e486                	sd	ra,72(sp)
    80000b0e:	e0a2                	sd	s0,64(sp)
    80000b10:	fc26                	sd	s1,56(sp)
    80000b12:	f84a                	sd	s2,48(sp)
    80000b14:	f44e                	sd	s3,40(sp)
    80000b16:	f052                	sd	s4,32(sp)
    80000b18:	ec56                	sd	s5,24(sp)
    80000b1a:	e85a                	sd	s6,16(sp)
    80000b1c:	e45e                	sd	s7,8(sp)
    80000b1e:	e062                	sd	s8,0(sp)
    80000b20:	0880                	addi	s0,sp,80
    80000b22:	8b2a                	mv	s6,a0
    80000b24:	8c2e                	mv	s8,a1
    80000b26:	8a32                	mv	s4,a2
    80000b28:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2c:	6a85                	lui	s5,0x1
    80000b2e:	a015                	j	80000b52 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b30:	9562                	add	a0,a0,s8
    80000b32:	0004861b          	sext.w	a2,s1
    80000b36:	85d2                	mv	a1,s4
    80000b38:	41250533          	sub	a0,a0,s2
    80000b3c:	fffff097          	auipc	ra,0xfffff
    80000b40:	69a080e7          	jalr	1690(ra) # 800001d6 <memmove>

    len -= n;
    80000b44:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b48:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b4e:	02098263          	beqz	s3,80000b72 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b52:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b56:	85ca                	mv	a1,s2
    80000b58:	855a                	mv	a0,s6
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	9a6080e7          	jalr	-1626(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000b62:	cd01                	beqz	a0,80000b7a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b64:	418904b3          	sub	s1,s2,s8
    80000b68:	94d6                	add	s1,s1,s5
    80000b6a:	fc99f3e3          	bgeu	s3,s1,80000b30 <copyout+0x28>
    80000b6e:	84ce                	mv	s1,s3
    80000b70:	b7c1                	j	80000b30 <copyout+0x28>
  }
  return 0;
    80000b72:	4501                	li	a0,0
    80000b74:	a021                	j	80000b7c <copyout+0x74>
    80000b76:	4501                	li	a0,0
}
    80000b78:	8082                	ret
      return -1;
    80000b7a:	557d                	li	a0,-1
}
    80000b7c:	60a6                	ld	ra,72(sp)
    80000b7e:	6406                	ld	s0,64(sp)
    80000b80:	74e2                	ld	s1,56(sp)
    80000b82:	7942                	ld	s2,48(sp)
    80000b84:	79a2                	ld	s3,40(sp)
    80000b86:	7a02                	ld	s4,32(sp)
    80000b88:	6ae2                	ld	s5,24(sp)
    80000b8a:	6b42                	ld	s6,16(sp)
    80000b8c:	6ba2                	ld	s7,8(sp)
    80000b8e:	6c02                	ld	s8,0(sp)
    80000b90:	6161                	addi	sp,sp,80
    80000b92:	8082                	ret

0000000080000b94 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b94:	caa5                	beqz	a3,80000c04 <copyin+0x70>
{
    80000b96:	715d                	addi	sp,sp,-80
    80000b98:	e486                	sd	ra,72(sp)
    80000b9a:	e0a2                	sd	s0,64(sp)
    80000b9c:	fc26                	sd	s1,56(sp)
    80000b9e:	f84a                	sd	s2,48(sp)
    80000ba0:	f44e                	sd	s3,40(sp)
    80000ba2:	f052                	sd	s4,32(sp)
    80000ba4:	ec56                	sd	s5,24(sp)
    80000ba6:	e85a                	sd	s6,16(sp)
    80000ba8:	e45e                	sd	s7,8(sp)
    80000baa:	e062                	sd	s8,0(sp)
    80000bac:	0880                	addi	s0,sp,80
    80000bae:	8b2a                	mv	s6,a0
    80000bb0:	8a2e                	mv	s4,a1
    80000bb2:	8c32                	mv	s8,a2
    80000bb4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb8:	6a85                	lui	s5,0x1
    80000bba:	a01d                	j	80000be0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbc:	018505b3          	add	a1,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412585b3          	sub	a1,a1,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60c080e7          	jalr	1548(ra) # 800001d6 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	918080e7          	jalr	-1768(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    80000bf8:	fc99f2e3          	bgeu	s3,s1,80000bbc <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	bf7d                	j	80000bbc <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x76>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c2dd                	beqz	a3,80000cc8 <copyinstr+0xa6>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a02d                	j	80000c70 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	37fd                	addiw	a5,a5,-1
    80000c50:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6161                	addi	sp,sp,80
    80000c68:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c6e:	c8a9                	beqz	s1,80000cc0 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c70:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c74:	85ca                	mv	a1,s2
    80000c76:	8552                	mv	a0,s4
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	888080e7          	jalr	-1912(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000c80:	c131                	beqz	a0,80000cc4 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c82:	417906b3          	sub	a3,s2,s7
    80000c86:	96ce                	add	a3,a3,s3
    80000c88:	00d4f363          	bgeu	s1,a3,80000c8e <copyinstr+0x6c>
    80000c8c:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c8e:	955e                	add	a0,a0,s7
    80000c90:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c94:	daf9                	beqz	a3,80000c6a <copyinstr+0x48>
    80000c96:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c98:	41650633          	sub	a2,a0,s6
    80000c9c:	fff48593          	addi	a1,s1,-1
    80000ca0:	95da                	add	a1,a1,s6
    while(n > 0){
    80000ca2:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000ca4:	00f60733          	add	a4,a2,a5
    80000ca8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cac:	df51                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cae:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb2:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cb6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb8:	fed796e3          	bne	a5,a3,80000ca4 <copyinstr+0x82>
      dst++;
    80000cbc:	8b3e                	mv	s6,a5
    80000cbe:	b775                	j	80000c6a <copyinstr+0x48>
    80000cc0:	4781                	li	a5,0
    80000cc2:	b771                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc4:	557d                	li	a0,-1
    80000cc6:	b779                	j	80000c54 <copyinstr+0x32>
  int got_null = 0;
    80000cc8:	4781                	li	a5,0
  if(got_null){
    80000cca:	37fd                	addiw	a5,a5,-1
    80000ccc:	0007851b          	sext.w	a0,a5
}
    80000cd0:	8082                	ret

0000000080000cd2 <vmprint>:

void vmprint(pagetable_t pgtbl){
    80000cd2:	7159                	addi	sp,sp,-112
    80000cd4:	f486                	sd	ra,104(sp)
    80000cd6:	f0a2                	sd	s0,96(sp)
    80000cd8:	eca6                	sd	s1,88(sp)
    80000cda:	e8ca                	sd	s2,80(sp)
    80000cdc:	e4ce                	sd	s3,72(sp)
    80000cde:	e0d2                	sd	s4,64(sp)
    80000ce0:	fc56                	sd	s5,56(sp)
    80000ce2:	f85a                	sd	s6,48(sp)
    80000ce4:	f45e                	sd	s7,40(sp)
    80000ce6:	f062                	sd	s8,32(sp)
    80000ce8:	ec66                	sd	s9,24(sp)
    80000cea:	e86a                	sd	s10,16(sp)
    80000cec:	e46e                	sd	s11,8(sp)
    80000cee:	1880                	addi	s0,sp,112
    80000cf0:	8baa                	mv	s7,a0
  printf("page table %p\n", pgtbl);
    80000cf2:	85aa                	mv	a1,a0
    80000cf4:	00007517          	auipc	a0,0x7
    80000cf8:	46450513          	addi	a0,a0,1124 # 80008158 <etext+0x158>
    80000cfc:	00005097          	auipc	ra,0x5
    80000d00:	0ce080e7          	jalr	206(ra) # 80005dca <printf>
  for(int l1idx = 0; l1idx < 512; l1idx++){
    80000d04:	4c01                	li	s8,0
    pte_t l1PTE = pgtbl[l1idx];
    if(l1PTE & PTE_V){
      printf(" ..%d: pte %p pa %p\n", l1idx, (void*)l1PTE, PTE2PA(l1PTE));
    80000d06:	00007d97          	auipc	s11,0x7
    80000d0a:	462d8d93          	addi	s11,s11,1122 # 80008168 <etext+0x168>
      for(int l2idx = 0; l2idx < 512; l2idx++){
    80000d0e:	4c81                	li	s9,0
        pte_t l2PTE = ((uint64*)PTE2PA(l1PTE))[l2idx];
        if(l2PTE & PTE_V){
          printf(" .. ..%d: pte %p pa %p\n", l2idx, (void*)l2PTE, PTE2PA(l2PTE));
    80000d10:	00007d17          	auipc	s10,0x7
    80000d14:	470d0d13          	addi	s10,s10,1136 # 80008180 <etext+0x180>
          for(int l3idx=0; l3idx < 512; l3idx++){
            pte_t l3PTE = ((uint64*)PTE2PA(l2PTE))[l3idx];
            if(l3PTE & PTE_V)
              printf(" .. .. ..%d: pte %p pa %p\n", l3idx, (void*)l3PTE, PTE2PA(l3PTE));
    80000d18:	00007a17          	auipc	s4,0x7
    80000d1c:	480a0a13          	addi	s4,s4,1152 # 80008198 <etext+0x198>
          for(int l3idx=0; l3idx < 512; l3idx++){
    80000d20:	20000993          	li	s3,512
    80000d24:	a8a9                	j	80000d7e <vmprint+0xac>
    80000d26:	2485                	addiw	s1,s1,1
    80000d28:	0921                	addi	s2,s2,8 # 1008 <_entry-0x7fffeff8>
    80000d2a:	03348163          	beq	s1,s3,80000d4c <vmprint+0x7a>
            pte_t l3PTE = ((uint64*)PTE2PA(l2PTE))[l3idx];
    80000d2e:	00093603          	ld	a2,0(s2)
            if(l3PTE & PTE_V)
    80000d32:	00167793          	andi	a5,a2,1
    80000d36:	dbe5                	beqz	a5,80000d26 <vmprint+0x54>
              printf(" .. .. ..%d: pte %p pa %p\n", l3idx, (void*)l3PTE, PTE2PA(l3PTE));
    80000d38:	00a65693          	srli	a3,a2,0xa
    80000d3c:	06b2                	slli	a3,a3,0xc
    80000d3e:	85a6                	mv	a1,s1
    80000d40:	8552                	mv	a0,s4
    80000d42:	00005097          	auipc	ra,0x5
    80000d46:	088080e7          	jalr	136(ra) # 80005dca <printf>
    80000d4a:	bff1                	j	80000d26 <vmprint+0x54>
      for(int l2idx = 0; l2idx < 512; l2idx++){
    80000d4c:	2a85                	addiw	s5,s5,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    80000d4e:	0b21                	addi	s6,s6,8 # 1008 <_entry-0x7fffeff8>
    80000d50:	033a8363          	beq	s5,s3,80000d76 <vmprint+0xa4>
        pte_t l2PTE = ((uint64*)PTE2PA(l1PTE))[l2idx];
    80000d54:	000b3603          	ld	a2,0(s6)
        if(l2PTE & PTE_V){
    80000d58:	00167793          	andi	a5,a2,1
    80000d5c:	dbe5                	beqz	a5,80000d4c <vmprint+0x7a>
          printf(" .. ..%d: pte %p pa %p\n", l2idx, (void*)l2PTE, PTE2PA(l2PTE));
    80000d5e:	00a65913          	srli	s2,a2,0xa
    80000d62:	0932                	slli	s2,s2,0xc
    80000d64:	86ca                	mv	a3,s2
    80000d66:	85d6                	mv	a1,s5
    80000d68:	856a                	mv	a0,s10
    80000d6a:	00005097          	auipc	ra,0x5
    80000d6e:	060080e7          	jalr	96(ra) # 80005dca <printf>
          for(int l3idx=0; l3idx < 512; l3idx++){
    80000d72:	84e6                	mv	s1,s9
    80000d74:	bf6d                	j	80000d2e <vmprint+0x5c>
  for(int l1idx = 0; l1idx < 512; l1idx++){
    80000d76:	2c05                	addiw	s8,s8,1
    80000d78:	0ba1                	addi	s7,s7,8 # fffffffffffff008 <end+0xffffffff7ffd8dc8>
    80000d7a:	033c0363          	beq	s8,s3,80000da0 <vmprint+0xce>
    pte_t l1PTE = pgtbl[l1idx];
    80000d7e:	000bb603          	ld	a2,0(s7)
    if(l1PTE & PTE_V){
    80000d82:	00167793          	andi	a5,a2,1
    80000d86:	dbe5                	beqz	a5,80000d76 <vmprint+0xa4>
      printf(" ..%d: pte %p pa %p\n", l1idx, (void*)l1PTE, PTE2PA(l1PTE));
    80000d88:	00a65b13          	srli	s6,a2,0xa
    80000d8c:	0b32                	slli	s6,s6,0xc
    80000d8e:	86da                	mv	a3,s6
    80000d90:	85e2                	mv	a1,s8
    80000d92:	856e                	mv	a0,s11
    80000d94:	00005097          	auipc	ra,0x5
    80000d98:	036080e7          	jalr	54(ra) # 80005dca <printf>
      for(int l2idx = 0; l2idx < 512; l2idx++){
    80000d9c:	8ae6                	mv	s5,s9
    80000d9e:	bf5d                	j	80000d54 <vmprint+0x82>
          }
        }
      }
    }
  }
}
    80000da0:	70a6                	ld	ra,104(sp)
    80000da2:	7406                	ld	s0,96(sp)
    80000da4:	64e6                	ld	s1,88(sp)
    80000da6:	6946                	ld	s2,80(sp)
    80000da8:	69a6                	ld	s3,72(sp)
    80000daa:	6a06                	ld	s4,64(sp)
    80000dac:	7ae2                	ld	s5,56(sp)
    80000dae:	7b42                	ld	s6,48(sp)
    80000db0:	7ba2                	ld	s7,40(sp)
    80000db2:	7c02                	ld	s8,32(sp)
    80000db4:	6ce2                	ld	s9,24(sp)
    80000db6:	6d42                	ld	s10,16(sp)
    80000db8:	6da2                	ld	s11,8(sp)
    80000dba:	6165                	addi	sp,sp,112
    80000dbc:	8082                	ret

0000000080000dbe <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000dbe:	7139                	addi	sp,sp,-64
    80000dc0:	fc06                	sd	ra,56(sp)
    80000dc2:	f822                	sd	s0,48(sp)
    80000dc4:	f426                	sd	s1,40(sp)
    80000dc6:	f04a                	sd	s2,32(sp)
    80000dc8:	ec4e                	sd	s3,24(sp)
    80000dca:	e852                	sd	s4,16(sp)
    80000dcc:	e456                	sd	s5,8(sp)
    80000dce:	e05a                	sd	s6,0(sp)
    80000dd0:	0080                	addi	s0,sp,64
    80000dd2:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd4:	00008497          	auipc	s1,0x8
    80000dd8:	6ac48493          	addi	s1,s1,1708 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ddc:	8b26                	mv	s6,s1
    80000dde:	00007a97          	auipc	s5,0x7
    80000de2:	222a8a93          	addi	s5,s5,546 # 80008000 <etext>
    80000de6:	01000937          	lui	s2,0x1000
    80000dea:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000dec:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dee:	0000ea17          	auipc	s4,0xe
    80000df2:	092a0a13          	addi	s4,s4,146 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000df6:	fffff097          	auipc	ra,0xfffff
    80000dfa:	324080e7          	jalr	804(ra) # 8000011a <kalloc>
    80000dfe:	862a                	mv	a2,a0
    if(pa == 0)
    80000e00:	c129                	beqz	a0,80000e42 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e02:	416485b3          	sub	a1,s1,s6
    80000e06:	858d                	srai	a1,a1,0x3
    80000e08:	000ab783          	ld	a5,0(s5)
    80000e0c:	02f585b3          	mul	a1,a1,a5
    80000e10:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e14:	4719                	li	a4,6
    80000e16:	6685                	lui	a3,0x1
    80000e18:	40b905b3          	sub	a1,s2,a1
    80000e1c:	854e                	mv	a0,s3
    80000e1e:	fffff097          	auipc	ra,0xfffff
    80000e22:	7c4080e7          	jalr	1988(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e26:	16848493          	addi	s1,s1,360
    80000e2a:	fd4496e3          	bne	s1,s4,80000df6 <proc_mapstacks+0x38>
  }
}
    80000e2e:	70e2                	ld	ra,56(sp)
    80000e30:	7442                	ld	s0,48(sp)
    80000e32:	74a2                	ld	s1,40(sp)
    80000e34:	7902                	ld	s2,32(sp)
    80000e36:	69e2                	ld	s3,24(sp)
    80000e38:	6a42                	ld	s4,16(sp)
    80000e3a:	6aa2                	ld	s5,8(sp)
    80000e3c:	6b02                	ld	s6,0(sp)
    80000e3e:	6121                	addi	sp,sp,64
    80000e40:	8082                	ret
      panic("kalloc");
    80000e42:	00007517          	auipc	a0,0x7
    80000e46:	37650513          	addi	a0,a0,886 # 800081b8 <etext+0x1b8>
    80000e4a:	00005097          	auipc	ra,0x5
    80000e4e:	f36080e7          	jalr	-202(ra) # 80005d80 <panic>

0000000080000e52 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e52:	7139                	addi	sp,sp,-64
    80000e54:	fc06                	sd	ra,56(sp)
    80000e56:	f822                	sd	s0,48(sp)
    80000e58:	f426                	sd	s1,40(sp)
    80000e5a:	f04a                	sd	s2,32(sp)
    80000e5c:	ec4e                	sd	s3,24(sp)
    80000e5e:	e852                	sd	s4,16(sp)
    80000e60:	e456                	sd	s5,8(sp)
    80000e62:	e05a                	sd	s6,0(sp)
    80000e64:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e66:	00007597          	auipc	a1,0x7
    80000e6a:	35a58593          	addi	a1,a1,858 # 800081c0 <etext+0x1c0>
    80000e6e:	00008517          	auipc	a0,0x8
    80000e72:	1e250513          	addi	a0,a0,482 # 80009050 <pid_lock>
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	3b2080e7          	jalr	946(ra) # 80006228 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e7e:	00007597          	auipc	a1,0x7
    80000e82:	34a58593          	addi	a1,a1,842 # 800081c8 <etext+0x1c8>
    80000e86:	00008517          	auipc	a0,0x8
    80000e8a:	1e250513          	addi	a0,a0,482 # 80009068 <wait_lock>
    80000e8e:	00005097          	auipc	ra,0x5
    80000e92:	39a080e7          	jalr	922(ra) # 80006228 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e96:	00008497          	auipc	s1,0x8
    80000e9a:	5ea48493          	addi	s1,s1,1514 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e9e:	00007b17          	auipc	s6,0x7
    80000ea2:	33ab0b13          	addi	s6,s6,826 # 800081d8 <etext+0x1d8>
      p->kstack = KSTACK((int) (p - proc));
    80000ea6:	8aa6                	mv	s5,s1
    80000ea8:	00007a17          	auipc	s4,0x7
    80000eac:	158a0a13          	addi	s4,s4,344 # 80008000 <etext>
    80000eb0:	01000937          	lui	s2,0x1000
    80000eb4:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000eb6:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eb8:	0000e997          	auipc	s3,0xe
    80000ebc:	fc898993          	addi	s3,s3,-56 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000ec0:	85da                	mv	a1,s6
    80000ec2:	8526                	mv	a0,s1
    80000ec4:	00005097          	auipc	ra,0x5
    80000ec8:	364080e7          	jalr	868(ra) # 80006228 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000ecc:	415487b3          	sub	a5,s1,s5
    80000ed0:	878d                	srai	a5,a5,0x3
    80000ed2:	000a3703          	ld	a4,0(s4)
    80000ed6:	02e787b3          	mul	a5,a5,a4
    80000eda:	00d7979b          	slliw	a5,a5,0xd
    80000ede:	40f907b3          	sub	a5,s2,a5
    80000ee2:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee4:	16848493          	addi	s1,s1,360
    80000ee8:	fd349ce3          	bne	s1,s3,80000ec0 <procinit+0x6e>
  }
}
    80000eec:	70e2                	ld	ra,56(sp)
    80000eee:	7442                	ld	s0,48(sp)
    80000ef0:	74a2                	ld	s1,40(sp)
    80000ef2:	7902                	ld	s2,32(sp)
    80000ef4:	69e2                	ld	s3,24(sp)
    80000ef6:	6a42                	ld	s4,16(sp)
    80000ef8:	6aa2                	ld	s5,8(sp)
    80000efa:	6b02                	ld	s6,0(sp)
    80000efc:	6121                	addi	sp,sp,64
    80000efe:	8082                	ret

0000000080000f00 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f00:	1141                	addi	sp,sp,-16
    80000f02:	e422                	sd	s0,8(sp)
    80000f04:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f06:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f08:	2501                	sext.w	a0,a0
    80000f0a:	6422                	ld	s0,8(sp)
    80000f0c:	0141                	addi	sp,sp,16
    80000f0e:	8082                	ret

0000000080000f10 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f10:	1141                	addi	sp,sp,-16
    80000f12:	e422                	sd	s0,8(sp)
    80000f14:	0800                	addi	s0,sp,16
    80000f16:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f18:	2781                	sext.w	a5,a5
    80000f1a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f1c:	00008517          	auipc	a0,0x8
    80000f20:	16450513          	addi	a0,a0,356 # 80009080 <cpus>
    80000f24:	953e                	add	a0,a0,a5
    80000f26:	6422                	ld	s0,8(sp)
    80000f28:	0141                	addi	sp,sp,16
    80000f2a:	8082                	ret

0000000080000f2c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f2c:	1101                	addi	sp,sp,-32
    80000f2e:	ec06                	sd	ra,24(sp)
    80000f30:	e822                	sd	s0,16(sp)
    80000f32:	e426                	sd	s1,8(sp)
    80000f34:	1000                	addi	s0,sp,32
  push_off();
    80000f36:	00005097          	auipc	ra,0x5
    80000f3a:	336080e7          	jalr	822(ra) # 8000626c <push_off>
    80000f3e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f40:	2781                	sext.w	a5,a5
    80000f42:	079e                	slli	a5,a5,0x7
    80000f44:	00008717          	auipc	a4,0x8
    80000f48:	10c70713          	addi	a4,a4,268 # 80009050 <pid_lock>
    80000f4c:	97ba                	add	a5,a5,a4
    80000f4e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f50:	00005097          	auipc	ra,0x5
    80000f54:	3bc080e7          	jalr	956(ra) # 8000630c <pop_off>
  return p;
}
    80000f58:	8526                	mv	a0,s1
    80000f5a:	60e2                	ld	ra,24(sp)
    80000f5c:	6442                	ld	s0,16(sp)
    80000f5e:	64a2                	ld	s1,8(sp)
    80000f60:	6105                	addi	sp,sp,32
    80000f62:	8082                	ret

0000000080000f64 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f64:	1141                	addi	sp,sp,-16
    80000f66:	e406                	sd	ra,8(sp)
    80000f68:	e022                	sd	s0,0(sp)
    80000f6a:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f6c:	00000097          	auipc	ra,0x0
    80000f70:	fc0080e7          	jalr	-64(ra) # 80000f2c <myproc>
    80000f74:	00005097          	auipc	ra,0x5
    80000f78:	3f8080e7          	jalr	1016(ra) # 8000636c <release>

  if (first) {
    80000f7c:	00008797          	auipc	a5,0x8
    80000f80:	9447a783          	lw	a5,-1724(a5) # 800088c0 <first.1>
    80000f84:	eb89                	bnez	a5,80000f96 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f86:	00001097          	auipc	ra,0x1
    80000f8a:	ce4080e7          	jalr	-796(ra) # 80001c6a <usertrapret>
}
    80000f8e:	60a2                	ld	ra,8(sp)
    80000f90:	6402                	ld	s0,0(sp)
    80000f92:	0141                	addi	sp,sp,16
    80000f94:	8082                	ret
    first = 0;
    80000f96:	00008797          	auipc	a5,0x8
    80000f9a:	9207a523          	sw	zero,-1750(a5) # 800088c0 <first.1>
    fsinit(ROOTDEV);
    80000f9e:	4505                	li	a0,1
    80000fa0:	00002097          	auipc	ra,0x2
    80000fa4:	ade080e7          	jalr	-1314(ra) # 80002a7e <fsinit>
    80000fa8:	bff9                	j	80000f86 <forkret+0x22>

0000000080000faa <allocpid>:
allocpid() {
    80000faa:	1101                	addi	sp,sp,-32
    80000fac:	ec06                	sd	ra,24(sp)
    80000fae:	e822                	sd	s0,16(sp)
    80000fb0:	e426                	sd	s1,8(sp)
    80000fb2:	e04a                	sd	s2,0(sp)
    80000fb4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fb6:	00008917          	auipc	s2,0x8
    80000fba:	09a90913          	addi	s2,s2,154 # 80009050 <pid_lock>
    80000fbe:	854a                	mv	a0,s2
    80000fc0:	00005097          	auipc	ra,0x5
    80000fc4:	2f8080e7          	jalr	760(ra) # 800062b8 <acquire>
  pid = nextpid;
    80000fc8:	00008797          	auipc	a5,0x8
    80000fcc:	8fc78793          	addi	a5,a5,-1796 # 800088c4 <nextpid>
    80000fd0:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fd2:	0014871b          	addiw	a4,s1,1
    80000fd6:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fd8:	854a                	mv	a0,s2
    80000fda:	00005097          	auipc	ra,0x5
    80000fde:	392080e7          	jalr	914(ra) # 8000636c <release>
}
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	60e2                	ld	ra,24(sp)
    80000fe6:	6442                	ld	s0,16(sp)
    80000fe8:	64a2                	ld	s1,8(sp)
    80000fea:	6902                	ld	s2,0(sp)
    80000fec:	6105                	addi	sp,sp,32
    80000fee:	8082                	ret

0000000080000ff0 <proc_pagetable>:
{
    80000ff0:	7179                	addi	sp,sp,-48
    80000ff2:	f406                	sd	ra,40(sp)
    80000ff4:	f022                	sd	s0,32(sp)
    80000ff6:	ec26                	sd	s1,24(sp)
    80000ff8:	e84a                	sd	s2,16(sp)
    80000ffa:	e44e                	sd	s3,8(sp)
    80000ffc:	1800                	addi	s0,sp,48
    80000ffe:	89aa                	mv	s3,a0
  pagetable = uvmcreate();
    80001000:	fffff097          	auipc	ra,0xfffff
    80001004:	7cc080e7          	jalr	1996(ra) # 800007cc <uvmcreate>
    80001008:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000100a:	c925                	beqz	a0,8000107a <proc_pagetable+0x8a>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000100c:	4729                	li	a4,10
    8000100e:	00006697          	auipc	a3,0x6
    80001012:	ff268693          	addi	a3,a3,-14 # 80007000 <_trampoline>
    80001016:	6605                	lui	a2,0x1
    80001018:	040005b7          	lui	a1,0x4000
    8000101c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000101e:	05b2                	slli	a1,a1,0xc
    80001020:	fffff097          	auipc	ra,0xfffff
    80001024:	522080e7          	jalr	1314(ra) # 80000542 <mappages>
    80001028:	06054163          	bltz	a0,8000108a <proc_pagetable+0x9a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000102c:	4719                	li	a4,6
    8000102e:	0589b683          	ld	a3,88(s3)
    80001032:	6605                	lui	a2,0x1
    80001034:	020005b7          	lui	a1,0x2000
    80001038:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000103a:	05b6                	slli	a1,a1,0xd
    8000103c:	8526                	mv	a0,s1
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	504080e7          	jalr	1284(ra) # 80000542 <mappages>
    80001046:	04054a63          	bltz	a0,8000109a <proc_pagetable+0xaa>
  void* physical_page = kalloc();
    8000104a:	fffff097          	auipc	ra,0xfffff
    8000104e:	0d0080e7          	jalr	208(ra) # 8000011a <kalloc>
    80001052:	892a                	mv	s2,a0
  if(physical_page==0){
    80001054:	c535                	beqz	a0,800010c0 <proc_pagetable+0xd0>
  if(mappages(pagetable, USYSCALL, PGSIZE, (uint64)physical_page, PTE_R|PTE_U) < 0){
    80001056:	4749                	li	a4,18
    80001058:	86aa                	mv	a3,a0
    8000105a:	6605                	lui	a2,0x1
    8000105c:	040005b7          	lui	a1,0x4000
    80001060:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001062:	05b2                	slli	a1,a1,0xc
    80001064:	8526                	mv	a0,s1
    80001066:	fffff097          	auipc	ra,0xfffff
    8000106a:	4dc080e7          	jalr	1244(ra) # 80000542 <mappages>
    8000106e:	08054763          	bltz	a0,800010fc <proc_pagetable+0x10c>
  ((struct usyscall*)physical_page)-> pid = p->pid;
    80001072:	0309a783          	lw	a5,48(s3)
    80001076:	00f92023          	sw	a5,0(s2)
}
    8000107a:	8526                	mv	a0,s1
    8000107c:	70a2                	ld	ra,40(sp)
    8000107e:	7402                	ld	s0,32(sp)
    80001080:	64e2                	ld	s1,24(sp)
    80001082:	6942                	ld	s2,16(sp)
    80001084:	69a2                	ld	s3,8(sp)
    80001086:	6145                	addi	sp,sp,48
    80001088:	8082                	ret
    uvmfree(pagetable, 0);
    8000108a:	4581                	li	a1,0
    8000108c:	8526                	mv	a0,s1
    8000108e:	00000097          	auipc	ra,0x0
    80001092:	93c080e7          	jalr	-1732(ra) # 800009ca <uvmfree>
    return 0;
    80001096:	4481                	li	s1,0
    80001098:	b7cd                	j	8000107a <proc_pagetable+0x8a>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000109a:	4681                	li	a3,0
    8000109c:	4605                	li	a2,1
    8000109e:	040005b7          	lui	a1,0x4000
    800010a2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010a4:	05b2                	slli	a1,a1,0xc
    800010a6:	8526                	mv	a0,s1
    800010a8:	fffff097          	auipc	ra,0xfffff
    800010ac:	660080e7          	jalr	1632(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    800010b0:	4581                	li	a1,0
    800010b2:	8526                	mv	a0,s1
    800010b4:	00000097          	auipc	ra,0x0
    800010b8:	916080e7          	jalr	-1770(ra) # 800009ca <uvmfree>
    return 0;
    800010bc:	4481                	li	s1,0
    800010be:	bf75                	j	8000107a <proc_pagetable+0x8a>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010c0:	4681                	li	a3,0
    800010c2:	4605                	li	a2,1
    800010c4:	040005b7          	lui	a1,0x4000
    800010c8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010ca:	05b2                	slli	a1,a1,0xc
    800010cc:	8526                	mv	a0,s1
    800010ce:	fffff097          	auipc	ra,0xfffff
    800010d2:	63a080e7          	jalr	1594(ra) # 80000708 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010d6:	4681                	li	a3,0
    800010d8:	4605                	li	a2,1
    800010da:	020005b7          	lui	a1,0x2000
    800010de:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010e0:	05b6                	slli	a1,a1,0xd
    800010e2:	8526                	mv	a0,s1
    800010e4:	fffff097          	auipc	ra,0xfffff
    800010e8:	624080e7          	jalr	1572(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    800010ec:	4581                	li	a1,0
    800010ee:	8526                	mv	a0,s1
    800010f0:	00000097          	auipc	ra,0x0
    800010f4:	8da080e7          	jalr	-1830(ra) # 800009ca <uvmfree>
    return 0;
    800010f8:	84ca                	mv	s1,s2
    800010fa:	b741                	j	8000107a <proc_pagetable+0x8a>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010fc:	4681                	li	a3,0
    800010fe:	4605                	li	a2,1
    80001100:	040005b7          	lui	a1,0x4000
    80001104:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001106:	05b2                	slli	a1,a1,0xc
    80001108:	8526                	mv	a0,s1
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	5fe080e7          	jalr	1534(ra) # 80000708 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001112:	4681                	li	a3,0
    80001114:	4605                	li	a2,1
    80001116:	020005b7          	lui	a1,0x2000
    8000111a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000111c:	05b6                	slli	a1,a1,0xd
    8000111e:	8526                	mv	a0,s1
    80001120:	fffff097          	auipc	ra,0xfffff
    80001124:	5e8080e7          	jalr	1512(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    80001128:	4581                	li	a1,0
    8000112a:	8526                	mv	a0,s1
    8000112c:	00000097          	auipc	ra,0x0
    80001130:	89e080e7          	jalr	-1890(ra) # 800009ca <uvmfree>
    kfree(physical_page);
    80001134:	854a                	mv	a0,s2
    80001136:	fffff097          	auipc	ra,0xfffff
    8000113a:	ee6080e7          	jalr	-282(ra) # 8000001c <kfree>
    return 0;
    8000113e:	4481                	li	s1,0
    80001140:	bf2d                	j	8000107a <proc_pagetable+0x8a>

0000000080001142 <proc_freepagetable>:
{
    80001142:	7179                	addi	sp,sp,-48
    80001144:	f406                	sd	ra,40(sp)
    80001146:	f022                	sd	s0,32(sp)
    80001148:	ec26                	sd	s1,24(sp)
    8000114a:	e84a                	sd	s2,16(sp)
    8000114c:	e44e                	sd	s3,8(sp)
    8000114e:	1800                	addi	s0,sp,48
    80001150:	84aa                	mv	s1,a0
    80001152:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001154:	4681                	li	a3,0
    80001156:	4605                	li	a2,1
    80001158:	04000937          	lui	s2,0x4000
    8000115c:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001160:	05b2                	slli	a1,a1,0xc
    80001162:	fffff097          	auipc	ra,0xfffff
    80001166:	5a6080e7          	jalr	1446(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000116a:	4681                	li	a3,0
    8000116c:	4605                	li	a2,1
    8000116e:	020005b7          	lui	a1,0x2000
    80001172:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001174:	05b6                	slli	a1,a1,0xd
    80001176:	8526                	mv	a0,s1
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	590080e7          	jalr	1424(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 1);
    80001180:	4685                	li	a3,1
    80001182:	4605                	li	a2,1
    80001184:	1975                	addi	s2,s2,-3
    80001186:	00c91593          	slli	a1,s2,0xc
    8000118a:	8526                	mv	a0,s1
    8000118c:	fffff097          	auipc	ra,0xfffff
    80001190:	57c080e7          	jalr	1404(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80001194:	85ce                	mv	a1,s3
    80001196:	8526                	mv	a0,s1
    80001198:	00000097          	auipc	ra,0x0
    8000119c:	832080e7          	jalr	-1998(ra) # 800009ca <uvmfree>
}
    800011a0:	70a2                	ld	ra,40(sp)
    800011a2:	7402                	ld	s0,32(sp)
    800011a4:	64e2                	ld	s1,24(sp)
    800011a6:	6942                	ld	s2,16(sp)
    800011a8:	69a2                	ld	s3,8(sp)
    800011aa:	6145                	addi	sp,sp,48
    800011ac:	8082                	ret

00000000800011ae <freeproc>:
{
    800011ae:	1101                	addi	sp,sp,-32
    800011b0:	ec06                	sd	ra,24(sp)
    800011b2:	e822                	sd	s0,16(sp)
    800011b4:	e426                	sd	s1,8(sp)
    800011b6:	1000                	addi	s0,sp,32
    800011b8:	84aa                	mv	s1,a0
  if(p->trapframe)
    800011ba:	6d28                	ld	a0,88(a0)
    800011bc:	c509                	beqz	a0,800011c6 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011be:	fffff097          	auipc	ra,0xfffff
    800011c2:	e5e080e7          	jalr	-418(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011c6:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800011ca:	68a8                	ld	a0,80(s1)
    800011cc:	c511                	beqz	a0,800011d8 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800011ce:	64ac                	ld	a1,72(s1)
    800011d0:	00000097          	auipc	ra,0x0
    800011d4:	f72080e7          	jalr	-142(ra) # 80001142 <proc_freepagetable>
  p->pagetable = 0;
    800011d8:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011dc:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011e0:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011e4:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011e8:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800011ec:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011f0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011f4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011f8:	0004ac23          	sw	zero,24(s1)
}
    800011fc:	60e2                	ld	ra,24(sp)
    800011fe:	6442                	ld	s0,16(sp)
    80001200:	64a2                	ld	s1,8(sp)
    80001202:	6105                	addi	sp,sp,32
    80001204:	8082                	ret

0000000080001206 <allocproc>:
{
    80001206:	1101                	addi	sp,sp,-32
    80001208:	ec06                	sd	ra,24(sp)
    8000120a:	e822                	sd	s0,16(sp)
    8000120c:	e426                	sd	s1,8(sp)
    8000120e:	e04a                	sd	s2,0(sp)
    80001210:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001212:	00008497          	auipc	s1,0x8
    80001216:	26e48493          	addi	s1,s1,622 # 80009480 <proc>
    8000121a:	0000e917          	auipc	s2,0xe
    8000121e:	c6690913          	addi	s2,s2,-922 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001222:	8526                	mv	a0,s1
    80001224:	00005097          	auipc	ra,0x5
    80001228:	094080e7          	jalr	148(ra) # 800062b8 <acquire>
    if(p->state == UNUSED) {
    8000122c:	4c9c                	lw	a5,24(s1)
    8000122e:	cf81                	beqz	a5,80001246 <allocproc+0x40>
      release(&p->lock);
    80001230:	8526                	mv	a0,s1
    80001232:	00005097          	auipc	ra,0x5
    80001236:	13a080e7          	jalr	314(ra) # 8000636c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000123a:	16848493          	addi	s1,s1,360
    8000123e:	ff2492e3          	bne	s1,s2,80001222 <allocproc+0x1c>
  return 0;
    80001242:	4481                	li	s1,0
    80001244:	a889                	j	80001296 <allocproc+0x90>
  p->pid = allocpid();
    80001246:	00000097          	auipc	ra,0x0
    8000124a:	d64080e7          	jalr	-668(ra) # 80000faa <allocpid>
    8000124e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001250:	4785                	li	a5,1
    80001252:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001254:	fffff097          	auipc	ra,0xfffff
    80001258:	ec6080e7          	jalr	-314(ra) # 8000011a <kalloc>
    8000125c:	892a                	mv	s2,a0
    8000125e:	eca8                	sd	a0,88(s1)
    80001260:	c131                	beqz	a0,800012a4 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001262:	8526                	mv	a0,s1
    80001264:	00000097          	auipc	ra,0x0
    80001268:	d8c080e7          	jalr	-628(ra) # 80000ff0 <proc_pagetable>
    8000126c:	892a                	mv	s2,a0
    8000126e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001270:	c531                	beqz	a0,800012bc <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001272:	07000613          	li	a2,112
    80001276:	4581                	li	a1,0
    80001278:	06048513          	addi	a0,s1,96
    8000127c:	fffff097          	auipc	ra,0xfffff
    80001280:	efe080e7          	jalr	-258(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001284:	00000797          	auipc	a5,0x0
    80001288:	ce078793          	addi	a5,a5,-800 # 80000f64 <forkret>
    8000128c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000128e:	60bc                	ld	a5,64(s1)
    80001290:	6705                	lui	a4,0x1
    80001292:	97ba                	add	a5,a5,a4
    80001294:	f4bc                	sd	a5,104(s1)
}
    80001296:	8526                	mv	a0,s1
    80001298:	60e2                	ld	ra,24(sp)
    8000129a:	6442                	ld	s0,16(sp)
    8000129c:	64a2                	ld	s1,8(sp)
    8000129e:	6902                	ld	s2,0(sp)
    800012a0:	6105                	addi	sp,sp,32
    800012a2:	8082                	ret
    freeproc(p);
    800012a4:	8526                	mv	a0,s1
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	f08080e7          	jalr	-248(ra) # 800011ae <freeproc>
    release(&p->lock);
    800012ae:	8526                	mv	a0,s1
    800012b0:	00005097          	auipc	ra,0x5
    800012b4:	0bc080e7          	jalr	188(ra) # 8000636c <release>
    return 0;
    800012b8:	84ca                	mv	s1,s2
    800012ba:	bff1                	j	80001296 <allocproc+0x90>
    freeproc(p);
    800012bc:	8526                	mv	a0,s1
    800012be:	00000097          	auipc	ra,0x0
    800012c2:	ef0080e7          	jalr	-272(ra) # 800011ae <freeproc>
    release(&p->lock);
    800012c6:	8526                	mv	a0,s1
    800012c8:	00005097          	auipc	ra,0x5
    800012cc:	0a4080e7          	jalr	164(ra) # 8000636c <release>
    return 0;
    800012d0:	84ca                	mv	s1,s2
    800012d2:	b7d1                	j	80001296 <allocproc+0x90>

00000000800012d4 <userinit>:
{
    800012d4:	1101                	addi	sp,sp,-32
    800012d6:	ec06                	sd	ra,24(sp)
    800012d8:	e822                	sd	s0,16(sp)
    800012da:	e426                	sd	s1,8(sp)
    800012dc:	1000                	addi	s0,sp,32
  p = allocproc();
    800012de:	00000097          	auipc	ra,0x0
    800012e2:	f28080e7          	jalr	-216(ra) # 80001206 <allocproc>
    800012e6:	84aa                	mv	s1,a0
  initproc = p;
    800012e8:	00008797          	auipc	a5,0x8
    800012ec:	d2a7b423          	sd	a0,-728(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012f0:	03400613          	li	a2,52
    800012f4:	00007597          	auipc	a1,0x7
    800012f8:	5dc58593          	addi	a1,a1,1500 # 800088d0 <initcode>
    800012fc:	6928                	ld	a0,80(a0)
    800012fe:	fffff097          	auipc	ra,0xfffff
    80001302:	4fc080e7          	jalr	1276(ra) # 800007fa <uvminit>
  p->sz = PGSIZE;
    80001306:	6785                	lui	a5,0x1
    80001308:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000130a:	6cb8                	ld	a4,88(s1)
    8000130c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001310:	6cb8                	ld	a4,88(s1)
    80001312:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001314:	4641                	li	a2,16
    80001316:	00007597          	auipc	a1,0x7
    8000131a:	eca58593          	addi	a1,a1,-310 # 800081e0 <etext+0x1e0>
    8000131e:	15848513          	addi	a0,s1,344
    80001322:	fffff097          	auipc	ra,0xfffff
    80001326:	fa2080e7          	jalr	-94(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    8000132a:	00007517          	auipc	a0,0x7
    8000132e:	ec650513          	addi	a0,a0,-314 # 800081f0 <etext+0x1f0>
    80001332:	00002097          	auipc	ra,0x2
    80001336:	182080e7          	jalr	386(ra) # 800034b4 <namei>
    8000133a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000133e:	478d                	li	a5,3
    80001340:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001342:	8526                	mv	a0,s1
    80001344:	00005097          	auipc	ra,0x5
    80001348:	028080e7          	jalr	40(ra) # 8000636c <release>
}
    8000134c:	60e2                	ld	ra,24(sp)
    8000134e:	6442                	ld	s0,16(sp)
    80001350:	64a2                	ld	s1,8(sp)
    80001352:	6105                	addi	sp,sp,32
    80001354:	8082                	ret

0000000080001356 <growproc>:
{
    80001356:	1101                	addi	sp,sp,-32
    80001358:	ec06                	sd	ra,24(sp)
    8000135a:	e822                	sd	s0,16(sp)
    8000135c:	e426                	sd	s1,8(sp)
    8000135e:	e04a                	sd	s2,0(sp)
    80001360:	1000                	addi	s0,sp,32
    80001362:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001364:	00000097          	auipc	ra,0x0
    80001368:	bc8080e7          	jalr	-1080(ra) # 80000f2c <myproc>
    8000136c:	892a                	mv	s2,a0
  sz = p->sz;
    8000136e:	652c                	ld	a1,72(a0)
    80001370:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001374:	00904f63          	bgtz	s1,80001392 <growproc+0x3c>
  } else if(n < 0){
    80001378:	0204cd63          	bltz	s1,800013b2 <growproc+0x5c>
  p->sz = sz;
    8000137c:	1782                	slli	a5,a5,0x20
    8000137e:	9381                	srli	a5,a5,0x20
    80001380:	04f93423          	sd	a5,72(s2)
  return 0;
    80001384:	4501                	li	a0,0
}
    80001386:	60e2                	ld	ra,24(sp)
    80001388:	6442                	ld	s0,16(sp)
    8000138a:	64a2                	ld	s1,8(sp)
    8000138c:	6902                	ld	s2,0(sp)
    8000138e:	6105                	addi	sp,sp,32
    80001390:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001392:	00f4863b          	addw	a2,s1,a5
    80001396:	1602                	slli	a2,a2,0x20
    80001398:	9201                	srli	a2,a2,0x20
    8000139a:	1582                	slli	a1,a1,0x20
    8000139c:	9181                	srli	a1,a1,0x20
    8000139e:	6928                	ld	a0,80(a0)
    800013a0:	fffff097          	auipc	ra,0xfffff
    800013a4:	514080e7          	jalr	1300(ra) # 800008b4 <uvmalloc>
    800013a8:	0005079b          	sext.w	a5,a0
    800013ac:	fbe1                	bnez	a5,8000137c <growproc+0x26>
      return -1;
    800013ae:	557d                	li	a0,-1
    800013b0:	bfd9                	j	80001386 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013b2:	00f4863b          	addw	a2,s1,a5
    800013b6:	1602                	slli	a2,a2,0x20
    800013b8:	9201                	srli	a2,a2,0x20
    800013ba:	1582                	slli	a1,a1,0x20
    800013bc:	9181                	srli	a1,a1,0x20
    800013be:	6928                	ld	a0,80(a0)
    800013c0:	fffff097          	auipc	ra,0xfffff
    800013c4:	4ac080e7          	jalr	1196(ra) # 8000086c <uvmdealloc>
    800013c8:	0005079b          	sext.w	a5,a0
    800013cc:	bf45                	j	8000137c <growproc+0x26>

00000000800013ce <fork>:
{
    800013ce:	7139                	addi	sp,sp,-64
    800013d0:	fc06                	sd	ra,56(sp)
    800013d2:	f822                	sd	s0,48(sp)
    800013d4:	f426                	sd	s1,40(sp)
    800013d6:	f04a                	sd	s2,32(sp)
    800013d8:	ec4e                	sd	s3,24(sp)
    800013da:	e852                	sd	s4,16(sp)
    800013dc:	e456                	sd	s5,8(sp)
    800013de:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013e0:	00000097          	auipc	ra,0x0
    800013e4:	b4c080e7          	jalr	-1204(ra) # 80000f2c <myproc>
    800013e8:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	e1c080e7          	jalr	-484(ra) # 80001206 <allocproc>
    800013f2:	10050c63          	beqz	a0,8000150a <fork+0x13c>
    800013f6:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013f8:	048ab603          	ld	a2,72(s5)
    800013fc:	692c                	ld	a1,80(a0)
    800013fe:	050ab503          	ld	a0,80(s5)
    80001402:	fffff097          	auipc	ra,0xfffff
    80001406:	602080e7          	jalr	1538(ra) # 80000a04 <uvmcopy>
    8000140a:	04054863          	bltz	a0,8000145a <fork+0x8c>
  np->sz = p->sz;
    8000140e:	048ab783          	ld	a5,72(s5)
    80001412:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001416:	058ab683          	ld	a3,88(s5)
    8000141a:	87b6                	mv	a5,a3
    8000141c:	058a3703          	ld	a4,88(s4)
    80001420:	12068693          	addi	a3,a3,288
    80001424:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001428:	6788                	ld	a0,8(a5)
    8000142a:	6b8c                	ld	a1,16(a5)
    8000142c:	6f90                	ld	a2,24(a5)
    8000142e:	01073023          	sd	a6,0(a4)
    80001432:	e708                	sd	a0,8(a4)
    80001434:	eb0c                	sd	a1,16(a4)
    80001436:	ef10                	sd	a2,24(a4)
    80001438:	02078793          	addi	a5,a5,32
    8000143c:	02070713          	addi	a4,a4,32
    80001440:	fed792e3          	bne	a5,a3,80001424 <fork+0x56>
  np->trapframe->a0 = 0;
    80001444:	058a3783          	ld	a5,88(s4)
    80001448:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000144c:	0d0a8493          	addi	s1,s5,208
    80001450:	0d0a0913          	addi	s2,s4,208
    80001454:	150a8993          	addi	s3,s5,336
    80001458:	a00d                	j	8000147a <fork+0xac>
    freeproc(np);
    8000145a:	8552                	mv	a0,s4
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	d52080e7          	jalr	-686(ra) # 800011ae <freeproc>
    release(&np->lock);
    80001464:	8552                	mv	a0,s4
    80001466:	00005097          	auipc	ra,0x5
    8000146a:	f06080e7          	jalr	-250(ra) # 8000636c <release>
    return -1;
    8000146e:	597d                	li	s2,-1
    80001470:	a059                	j	800014f6 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001472:	04a1                	addi	s1,s1,8
    80001474:	0921                	addi	s2,s2,8
    80001476:	01348b63          	beq	s1,s3,8000148c <fork+0xbe>
    if(p->ofile[i])
    8000147a:	6088                	ld	a0,0(s1)
    8000147c:	d97d                	beqz	a0,80001472 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    8000147e:	00002097          	auipc	ra,0x2
    80001482:	6cc080e7          	jalr	1740(ra) # 80003b4a <filedup>
    80001486:	00a93023          	sd	a0,0(s2)
    8000148a:	b7e5                	j	80001472 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000148c:	150ab503          	ld	a0,336(s5)
    80001490:	00002097          	auipc	ra,0x2
    80001494:	82a080e7          	jalr	-2006(ra) # 80002cba <idup>
    80001498:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000149c:	4641                	li	a2,16
    8000149e:	158a8593          	addi	a1,s5,344
    800014a2:	158a0513          	addi	a0,s4,344
    800014a6:	fffff097          	auipc	ra,0xfffff
    800014aa:	e1e080e7          	jalr	-482(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800014ae:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800014b2:	8552                	mv	a0,s4
    800014b4:	00005097          	auipc	ra,0x5
    800014b8:	eb8080e7          	jalr	-328(ra) # 8000636c <release>
  acquire(&wait_lock);
    800014bc:	00008497          	auipc	s1,0x8
    800014c0:	bac48493          	addi	s1,s1,-1108 # 80009068 <wait_lock>
    800014c4:	8526                	mv	a0,s1
    800014c6:	00005097          	auipc	ra,0x5
    800014ca:	df2080e7          	jalr	-526(ra) # 800062b8 <acquire>
  np->parent = p;
    800014ce:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800014d2:	8526                	mv	a0,s1
    800014d4:	00005097          	auipc	ra,0x5
    800014d8:	e98080e7          	jalr	-360(ra) # 8000636c <release>
  acquire(&np->lock);
    800014dc:	8552                	mv	a0,s4
    800014de:	00005097          	auipc	ra,0x5
    800014e2:	dda080e7          	jalr	-550(ra) # 800062b8 <acquire>
  np->state = RUNNABLE;
    800014e6:	478d                	li	a5,3
    800014e8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800014ec:	8552                	mv	a0,s4
    800014ee:	00005097          	auipc	ra,0x5
    800014f2:	e7e080e7          	jalr	-386(ra) # 8000636c <release>
}
    800014f6:	854a                	mv	a0,s2
    800014f8:	70e2                	ld	ra,56(sp)
    800014fa:	7442                	ld	s0,48(sp)
    800014fc:	74a2                	ld	s1,40(sp)
    800014fe:	7902                	ld	s2,32(sp)
    80001500:	69e2                	ld	s3,24(sp)
    80001502:	6a42                	ld	s4,16(sp)
    80001504:	6aa2                	ld	s5,8(sp)
    80001506:	6121                	addi	sp,sp,64
    80001508:	8082                	ret
    return -1;
    8000150a:	597d                	li	s2,-1
    8000150c:	b7ed                	j	800014f6 <fork+0x128>

000000008000150e <scheduler>:
{
    8000150e:	7139                	addi	sp,sp,-64
    80001510:	fc06                	sd	ra,56(sp)
    80001512:	f822                	sd	s0,48(sp)
    80001514:	f426                	sd	s1,40(sp)
    80001516:	f04a                	sd	s2,32(sp)
    80001518:	ec4e                	sd	s3,24(sp)
    8000151a:	e852                	sd	s4,16(sp)
    8000151c:	e456                	sd	s5,8(sp)
    8000151e:	e05a                	sd	s6,0(sp)
    80001520:	0080                	addi	s0,sp,64
    80001522:	8792                	mv	a5,tp
  int id = r_tp();
    80001524:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001526:	00779a93          	slli	s5,a5,0x7
    8000152a:	00008717          	auipc	a4,0x8
    8000152e:	b2670713          	addi	a4,a4,-1242 # 80009050 <pid_lock>
    80001532:	9756                	add	a4,a4,s5
    80001534:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001538:	00008717          	auipc	a4,0x8
    8000153c:	b5070713          	addi	a4,a4,-1200 # 80009088 <cpus+0x8>
    80001540:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001542:	498d                	li	s3,3
        p->state = RUNNING;
    80001544:	4b11                	li	s6,4
        c->proc = p;
    80001546:	079e                	slli	a5,a5,0x7
    80001548:	00008a17          	auipc	s4,0x8
    8000154c:	b08a0a13          	addi	s4,s4,-1272 # 80009050 <pid_lock>
    80001550:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001552:	0000e917          	auipc	s2,0xe
    80001556:	92e90913          	addi	s2,s2,-1746 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000155a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000155e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001562:	10079073          	csrw	sstatus,a5
    80001566:	00008497          	auipc	s1,0x8
    8000156a:	f1a48493          	addi	s1,s1,-230 # 80009480 <proc>
    8000156e:	a811                	j	80001582 <scheduler+0x74>
      release(&p->lock);
    80001570:	8526                	mv	a0,s1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	dfa080e7          	jalr	-518(ra) # 8000636c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000157a:	16848493          	addi	s1,s1,360
    8000157e:	fd248ee3          	beq	s1,s2,8000155a <scheduler+0x4c>
      acquire(&p->lock);
    80001582:	8526                	mv	a0,s1
    80001584:	00005097          	auipc	ra,0x5
    80001588:	d34080e7          	jalr	-716(ra) # 800062b8 <acquire>
      if(p->state == RUNNABLE) {
    8000158c:	4c9c                	lw	a5,24(s1)
    8000158e:	ff3791e3          	bne	a5,s3,80001570 <scheduler+0x62>
        p->state = RUNNING;
    80001592:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001596:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000159a:	06048593          	addi	a1,s1,96
    8000159e:	8556                	mv	a0,s5
    800015a0:	00000097          	auipc	ra,0x0
    800015a4:	620080e7          	jalr	1568(ra) # 80001bc0 <swtch>
        c->proc = 0;
    800015a8:	020a3823          	sd	zero,48(s4)
    800015ac:	b7d1                	j	80001570 <scheduler+0x62>

00000000800015ae <sched>:
{
    800015ae:	7179                	addi	sp,sp,-48
    800015b0:	f406                	sd	ra,40(sp)
    800015b2:	f022                	sd	s0,32(sp)
    800015b4:	ec26                	sd	s1,24(sp)
    800015b6:	e84a                	sd	s2,16(sp)
    800015b8:	e44e                	sd	s3,8(sp)
    800015ba:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015bc:	00000097          	auipc	ra,0x0
    800015c0:	970080e7          	jalr	-1680(ra) # 80000f2c <myproc>
    800015c4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015c6:	00005097          	auipc	ra,0x5
    800015ca:	c78080e7          	jalr	-904(ra) # 8000623e <holding>
    800015ce:	c93d                	beqz	a0,80001644 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015d0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015d2:	2781                	sext.w	a5,a5
    800015d4:	079e                	slli	a5,a5,0x7
    800015d6:	00008717          	auipc	a4,0x8
    800015da:	a7a70713          	addi	a4,a4,-1414 # 80009050 <pid_lock>
    800015de:	97ba                	add	a5,a5,a4
    800015e0:	0a87a703          	lw	a4,168(a5)
    800015e4:	4785                	li	a5,1
    800015e6:	06f71763          	bne	a4,a5,80001654 <sched+0xa6>
  if(p->state == RUNNING)
    800015ea:	4c98                	lw	a4,24(s1)
    800015ec:	4791                	li	a5,4
    800015ee:	06f70b63          	beq	a4,a5,80001664 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015f2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015f6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015f8:	efb5                	bnez	a5,80001674 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015fa:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015fc:	00008917          	auipc	s2,0x8
    80001600:	a5490913          	addi	s2,s2,-1452 # 80009050 <pid_lock>
    80001604:	2781                	sext.w	a5,a5
    80001606:	079e                	slli	a5,a5,0x7
    80001608:	97ca                	add	a5,a5,s2
    8000160a:	0ac7a983          	lw	s3,172(a5)
    8000160e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001610:	2781                	sext.w	a5,a5
    80001612:	079e                	slli	a5,a5,0x7
    80001614:	00008597          	auipc	a1,0x8
    80001618:	a7458593          	addi	a1,a1,-1420 # 80009088 <cpus+0x8>
    8000161c:	95be                	add	a1,a1,a5
    8000161e:	06048513          	addi	a0,s1,96
    80001622:	00000097          	auipc	ra,0x0
    80001626:	59e080e7          	jalr	1438(ra) # 80001bc0 <swtch>
    8000162a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000162c:	2781                	sext.w	a5,a5
    8000162e:	079e                	slli	a5,a5,0x7
    80001630:	993e                	add	s2,s2,a5
    80001632:	0b392623          	sw	s3,172(s2)
}
    80001636:	70a2                	ld	ra,40(sp)
    80001638:	7402                	ld	s0,32(sp)
    8000163a:	64e2                	ld	s1,24(sp)
    8000163c:	6942                	ld	s2,16(sp)
    8000163e:	69a2                	ld	s3,8(sp)
    80001640:	6145                	addi	sp,sp,48
    80001642:	8082                	ret
    panic("sched p->lock");
    80001644:	00007517          	auipc	a0,0x7
    80001648:	bb450513          	addi	a0,a0,-1100 # 800081f8 <etext+0x1f8>
    8000164c:	00004097          	auipc	ra,0x4
    80001650:	734080e7          	jalr	1844(ra) # 80005d80 <panic>
    panic("sched locks");
    80001654:	00007517          	auipc	a0,0x7
    80001658:	bb450513          	addi	a0,a0,-1100 # 80008208 <etext+0x208>
    8000165c:	00004097          	auipc	ra,0x4
    80001660:	724080e7          	jalr	1828(ra) # 80005d80 <panic>
    panic("sched running");
    80001664:	00007517          	auipc	a0,0x7
    80001668:	bb450513          	addi	a0,a0,-1100 # 80008218 <etext+0x218>
    8000166c:	00004097          	auipc	ra,0x4
    80001670:	714080e7          	jalr	1812(ra) # 80005d80 <panic>
    panic("sched interruptible");
    80001674:	00007517          	auipc	a0,0x7
    80001678:	bb450513          	addi	a0,a0,-1100 # 80008228 <etext+0x228>
    8000167c:	00004097          	auipc	ra,0x4
    80001680:	704080e7          	jalr	1796(ra) # 80005d80 <panic>

0000000080001684 <yield>:
{
    80001684:	1101                	addi	sp,sp,-32
    80001686:	ec06                	sd	ra,24(sp)
    80001688:	e822                	sd	s0,16(sp)
    8000168a:	e426                	sd	s1,8(sp)
    8000168c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000168e:	00000097          	auipc	ra,0x0
    80001692:	89e080e7          	jalr	-1890(ra) # 80000f2c <myproc>
    80001696:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001698:	00005097          	auipc	ra,0x5
    8000169c:	c20080e7          	jalr	-992(ra) # 800062b8 <acquire>
  p->state = RUNNABLE;
    800016a0:	478d                	li	a5,3
    800016a2:	cc9c                	sw	a5,24(s1)
  sched();
    800016a4:	00000097          	auipc	ra,0x0
    800016a8:	f0a080e7          	jalr	-246(ra) # 800015ae <sched>
  release(&p->lock);
    800016ac:	8526                	mv	a0,s1
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	cbe080e7          	jalr	-834(ra) # 8000636c <release>
}
    800016b6:	60e2                	ld	ra,24(sp)
    800016b8:	6442                	ld	s0,16(sp)
    800016ba:	64a2                	ld	s1,8(sp)
    800016bc:	6105                	addi	sp,sp,32
    800016be:	8082                	ret

00000000800016c0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016c0:	7179                	addi	sp,sp,-48
    800016c2:	f406                	sd	ra,40(sp)
    800016c4:	f022                	sd	s0,32(sp)
    800016c6:	ec26                	sd	s1,24(sp)
    800016c8:	e84a                	sd	s2,16(sp)
    800016ca:	e44e                	sd	s3,8(sp)
    800016cc:	1800                	addi	s0,sp,48
    800016ce:	89aa                	mv	s3,a0
    800016d0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	85a080e7          	jalr	-1958(ra) # 80000f2c <myproc>
    800016da:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016dc:	00005097          	auipc	ra,0x5
    800016e0:	bdc080e7          	jalr	-1060(ra) # 800062b8 <acquire>
  release(lk);
    800016e4:	854a                	mv	a0,s2
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	c86080e7          	jalr	-890(ra) # 8000636c <release>

  // Go to sleep.
  p->chan = chan;
    800016ee:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016f2:	4789                	li	a5,2
    800016f4:	cc9c                	sw	a5,24(s1)

  sched();
    800016f6:	00000097          	auipc	ra,0x0
    800016fa:	eb8080e7          	jalr	-328(ra) # 800015ae <sched>

  // Tidy up.
  p->chan = 0;
    800016fe:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001702:	8526                	mv	a0,s1
    80001704:	00005097          	auipc	ra,0x5
    80001708:	c68080e7          	jalr	-920(ra) # 8000636c <release>
  acquire(lk);
    8000170c:	854a                	mv	a0,s2
    8000170e:	00005097          	auipc	ra,0x5
    80001712:	baa080e7          	jalr	-1110(ra) # 800062b8 <acquire>
}
    80001716:	70a2                	ld	ra,40(sp)
    80001718:	7402                	ld	s0,32(sp)
    8000171a:	64e2                	ld	s1,24(sp)
    8000171c:	6942                	ld	s2,16(sp)
    8000171e:	69a2                	ld	s3,8(sp)
    80001720:	6145                	addi	sp,sp,48
    80001722:	8082                	ret

0000000080001724 <wait>:
{
    80001724:	715d                	addi	sp,sp,-80
    80001726:	e486                	sd	ra,72(sp)
    80001728:	e0a2                	sd	s0,64(sp)
    8000172a:	fc26                	sd	s1,56(sp)
    8000172c:	f84a                	sd	s2,48(sp)
    8000172e:	f44e                	sd	s3,40(sp)
    80001730:	f052                	sd	s4,32(sp)
    80001732:	ec56                	sd	s5,24(sp)
    80001734:	e85a                	sd	s6,16(sp)
    80001736:	e45e                	sd	s7,8(sp)
    80001738:	e062                	sd	s8,0(sp)
    8000173a:	0880                	addi	s0,sp,80
    8000173c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000173e:	fffff097          	auipc	ra,0xfffff
    80001742:	7ee080e7          	jalr	2030(ra) # 80000f2c <myproc>
    80001746:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001748:	00008517          	auipc	a0,0x8
    8000174c:	92050513          	addi	a0,a0,-1760 # 80009068 <wait_lock>
    80001750:	00005097          	auipc	ra,0x5
    80001754:	b68080e7          	jalr	-1176(ra) # 800062b8 <acquire>
    havekids = 0;
    80001758:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000175a:	4a15                	li	s4,5
        havekids = 1;
    8000175c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000175e:	0000d997          	auipc	s3,0xd
    80001762:	72298993          	addi	s3,s3,1826 # 8000ee80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001766:	00008c17          	auipc	s8,0x8
    8000176a:	902c0c13          	addi	s8,s8,-1790 # 80009068 <wait_lock>
    havekids = 0;
    8000176e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001770:	00008497          	auipc	s1,0x8
    80001774:	d1048493          	addi	s1,s1,-752 # 80009480 <proc>
    80001778:	a0bd                	j	800017e6 <wait+0xc2>
          pid = np->pid;
    8000177a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000177e:	000b0e63          	beqz	s6,8000179a <wait+0x76>
    80001782:	4691                	li	a3,4
    80001784:	02c48613          	addi	a2,s1,44
    80001788:	85da                	mv	a1,s6
    8000178a:	05093503          	ld	a0,80(s2)
    8000178e:	fffff097          	auipc	ra,0xfffff
    80001792:	37a080e7          	jalr	890(ra) # 80000b08 <copyout>
    80001796:	02054563          	bltz	a0,800017c0 <wait+0x9c>
          freeproc(np);
    8000179a:	8526                	mv	a0,s1
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	a12080e7          	jalr	-1518(ra) # 800011ae <freeproc>
          release(&np->lock);
    800017a4:	8526                	mv	a0,s1
    800017a6:	00005097          	auipc	ra,0x5
    800017aa:	bc6080e7          	jalr	-1082(ra) # 8000636c <release>
          release(&wait_lock);
    800017ae:	00008517          	auipc	a0,0x8
    800017b2:	8ba50513          	addi	a0,a0,-1862 # 80009068 <wait_lock>
    800017b6:	00005097          	auipc	ra,0x5
    800017ba:	bb6080e7          	jalr	-1098(ra) # 8000636c <release>
          return pid;
    800017be:	a09d                	j	80001824 <wait+0x100>
            release(&np->lock);
    800017c0:	8526                	mv	a0,s1
    800017c2:	00005097          	auipc	ra,0x5
    800017c6:	baa080e7          	jalr	-1110(ra) # 8000636c <release>
            release(&wait_lock);
    800017ca:	00008517          	auipc	a0,0x8
    800017ce:	89e50513          	addi	a0,a0,-1890 # 80009068 <wait_lock>
    800017d2:	00005097          	auipc	ra,0x5
    800017d6:	b9a080e7          	jalr	-1126(ra) # 8000636c <release>
            return -1;
    800017da:	59fd                	li	s3,-1
    800017dc:	a0a1                	j	80001824 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017de:	16848493          	addi	s1,s1,360
    800017e2:	03348463          	beq	s1,s3,8000180a <wait+0xe6>
      if(np->parent == p){
    800017e6:	7c9c                	ld	a5,56(s1)
    800017e8:	ff279be3          	bne	a5,s2,800017de <wait+0xba>
        acquire(&np->lock);
    800017ec:	8526                	mv	a0,s1
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	aca080e7          	jalr	-1334(ra) # 800062b8 <acquire>
        if(np->state == ZOMBIE){
    800017f6:	4c9c                	lw	a5,24(s1)
    800017f8:	f94781e3          	beq	a5,s4,8000177a <wait+0x56>
        release(&np->lock);
    800017fc:	8526                	mv	a0,s1
    800017fe:	00005097          	auipc	ra,0x5
    80001802:	b6e080e7          	jalr	-1170(ra) # 8000636c <release>
        havekids = 1;
    80001806:	8756                	mv	a4,s5
    80001808:	bfd9                	j	800017de <wait+0xba>
    if(!havekids || p->killed){
    8000180a:	c701                	beqz	a4,80001812 <wait+0xee>
    8000180c:	02892783          	lw	a5,40(s2)
    80001810:	c79d                	beqz	a5,8000183e <wait+0x11a>
      release(&wait_lock);
    80001812:	00008517          	auipc	a0,0x8
    80001816:	85650513          	addi	a0,a0,-1962 # 80009068 <wait_lock>
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	b52080e7          	jalr	-1198(ra) # 8000636c <release>
      return -1;
    80001822:	59fd                	li	s3,-1
}
    80001824:	854e                	mv	a0,s3
    80001826:	60a6                	ld	ra,72(sp)
    80001828:	6406                	ld	s0,64(sp)
    8000182a:	74e2                	ld	s1,56(sp)
    8000182c:	7942                	ld	s2,48(sp)
    8000182e:	79a2                	ld	s3,40(sp)
    80001830:	7a02                	ld	s4,32(sp)
    80001832:	6ae2                	ld	s5,24(sp)
    80001834:	6b42                	ld	s6,16(sp)
    80001836:	6ba2                	ld	s7,8(sp)
    80001838:	6c02                	ld	s8,0(sp)
    8000183a:	6161                	addi	sp,sp,80
    8000183c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000183e:	85e2                	mv	a1,s8
    80001840:	854a                	mv	a0,s2
    80001842:	00000097          	auipc	ra,0x0
    80001846:	e7e080e7          	jalr	-386(ra) # 800016c0 <sleep>
    havekids = 0;
    8000184a:	b715                	j	8000176e <wait+0x4a>

000000008000184c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000184c:	7139                	addi	sp,sp,-64
    8000184e:	fc06                	sd	ra,56(sp)
    80001850:	f822                	sd	s0,48(sp)
    80001852:	f426                	sd	s1,40(sp)
    80001854:	f04a                	sd	s2,32(sp)
    80001856:	ec4e                	sd	s3,24(sp)
    80001858:	e852                	sd	s4,16(sp)
    8000185a:	e456                	sd	s5,8(sp)
    8000185c:	0080                	addi	s0,sp,64
    8000185e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001860:	00008497          	auipc	s1,0x8
    80001864:	c2048493          	addi	s1,s1,-992 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001868:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000186a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186c:	0000d917          	auipc	s2,0xd
    80001870:	61490913          	addi	s2,s2,1556 # 8000ee80 <tickslock>
    80001874:	a811                	j	80001888 <wakeup+0x3c>
      }
      release(&p->lock);
    80001876:	8526                	mv	a0,s1
    80001878:	00005097          	auipc	ra,0x5
    8000187c:	af4080e7          	jalr	-1292(ra) # 8000636c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001880:	16848493          	addi	s1,s1,360
    80001884:	03248663          	beq	s1,s2,800018b0 <wakeup+0x64>
    if(p != myproc()){
    80001888:	fffff097          	auipc	ra,0xfffff
    8000188c:	6a4080e7          	jalr	1700(ra) # 80000f2c <myproc>
    80001890:	fea488e3          	beq	s1,a0,80001880 <wakeup+0x34>
      acquire(&p->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	a22080e7          	jalr	-1502(ra) # 800062b8 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000189e:	4c9c                	lw	a5,24(s1)
    800018a0:	fd379be3          	bne	a5,s3,80001876 <wakeup+0x2a>
    800018a4:	709c                	ld	a5,32(s1)
    800018a6:	fd4798e3          	bne	a5,s4,80001876 <wakeup+0x2a>
        p->state = RUNNABLE;
    800018aa:	0154ac23          	sw	s5,24(s1)
    800018ae:	b7e1                	j	80001876 <wakeup+0x2a>
    }
  }
}
    800018b0:	70e2                	ld	ra,56(sp)
    800018b2:	7442                	ld	s0,48(sp)
    800018b4:	74a2                	ld	s1,40(sp)
    800018b6:	7902                	ld	s2,32(sp)
    800018b8:	69e2                	ld	s3,24(sp)
    800018ba:	6a42                	ld	s4,16(sp)
    800018bc:	6aa2                	ld	s5,8(sp)
    800018be:	6121                	addi	sp,sp,64
    800018c0:	8082                	ret

00000000800018c2 <reparent>:
{
    800018c2:	7179                	addi	sp,sp,-48
    800018c4:	f406                	sd	ra,40(sp)
    800018c6:	f022                	sd	s0,32(sp)
    800018c8:	ec26                	sd	s1,24(sp)
    800018ca:	e84a                	sd	s2,16(sp)
    800018cc:	e44e                	sd	s3,8(sp)
    800018ce:	e052                	sd	s4,0(sp)
    800018d0:	1800                	addi	s0,sp,48
    800018d2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018d4:	00008497          	auipc	s1,0x8
    800018d8:	bac48493          	addi	s1,s1,-1108 # 80009480 <proc>
      pp->parent = initproc;
    800018dc:	00007a17          	auipc	s4,0x7
    800018e0:	734a0a13          	addi	s4,s4,1844 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018e4:	0000d997          	auipc	s3,0xd
    800018e8:	59c98993          	addi	s3,s3,1436 # 8000ee80 <tickslock>
    800018ec:	a029                	j	800018f6 <reparent+0x34>
    800018ee:	16848493          	addi	s1,s1,360
    800018f2:	01348d63          	beq	s1,s3,8000190c <reparent+0x4a>
    if(pp->parent == p){
    800018f6:	7c9c                	ld	a5,56(s1)
    800018f8:	ff279be3          	bne	a5,s2,800018ee <reparent+0x2c>
      pp->parent = initproc;
    800018fc:	000a3503          	ld	a0,0(s4)
    80001900:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001902:	00000097          	auipc	ra,0x0
    80001906:	f4a080e7          	jalr	-182(ra) # 8000184c <wakeup>
    8000190a:	b7d5                	j	800018ee <reparent+0x2c>
}
    8000190c:	70a2                	ld	ra,40(sp)
    8000190e:	7402                	ld	s0,32(sp)
    80001910:	64e2                	ld	s1,24(sp)
    80001912:	6942                	ld	s2,16(sp)
    80001914:	69a2                	ld	s3,8(sp)
    80001916:	6a02                	ld	s4,0(sp)
    80001918:	6145                	addi	sp,sp,48
    8000191a:	8082                	ret

000000008000191c <exit>:
{
    8000191c:	7179                	addi	sp,sp,-48
    8000191e:	f406                	sd	ra,40(sp)
    80001920:	f022                	sd	s0,32(sp)
    80001922:	ec26                	sd	s1,24(sp)
    80001924:	e84a                	sd	s2,16(sp)
    80001926:	e44e                	sd	s3,8(sp)
    80001928:	e052                	sd	s4,0(sp)
    8000192a:	1800                	addi	s0,sp,48
    8000192c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000192e:	fffff097          	auipc	ra,0xfffff
    80001932:	5fe080e7          	jalr	1534(ra) # 80000f2c <myproc>
    80001936:	89aa                	mv	s3,a0
  if(p == initproc)
    80001938:	00007797          	auipc	a5,0x7
    8000193c:	6d87b783          	ld	a5,1752(a5) # 80009010 <initproc>
    80001940:	0d050493          	addi	s1,a0,208
    80001944:	15050913          	addi	s2,a0,336
    80001948:	02a79363          	bne	a5,a0,8000196e <exit+0x52>
    panic("init exiting");
    8000194c:	00007517          	auipc	a0,0x7
    80001950:	8f450513          	addi	a0,a0,-1804 # 80008240 <etext+0x240>
    80001954:	00004097          	auipc	ra,0x4
    80001958:	42c080e7          	jalr	1068(ra) # 80005d80 <panic>
      fileclose(f);
    8000195c:	00002097          	auipc	ra,0x2
    80001960:	240080e7          	jalr	576(ra) # 80003b9c <fileclose>
      p->ofile[fd] = 0;
    80001964:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001968:	04a1                	addi	s1,s1,8
    8000196a:	01248563          	beq	s1,s2,80001974 <exit+0x58>
    if(p->ofile[fd]){
    8000196e:	6088                	ld	a0,0(s1)
    80001970:	f575                	bnez	a0,8000195c <exit+0x40>
    80001972:	bfdd                	j	80001968 <exit+0x4c>
  begin_op();
    80001974:	00002097          	auipc	ra,0x2
    80001978:	d60080e7          	jalr	-672(ra) # 800036d4 <begin_op>
  iput(p->cwd);
    8000197c:	1509b503          	ld	a0,336(s3)
    80001980:	00001097          	auipc	ra,0x1
    80001984:	532080e7          	jalr	1330(ra) # 80002eb2 <iput>
  end_op();
    80001988:	00002097          	auipc	ra,0x2
    8000198c:	dca080e7          	jalr	-566(ra) # 80003752 <end_op>
  p->cwd = 0;
    80001990:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001994:	00007497          	auipc	s1,0x7
    80001998:	6d448493          	addi	s1,s1,1748 # 80009068 <wait_lock>
    8000199c:	8526                	mv	a0,s1
    8000199e:	00005097          	auipc	ra,0x5
    800019a2:	91a080e7          	jalr	-1766(ra) # 800062b8 <acquire>
  reparent(p);
    800019a6:	854e                	mv	a0,s3
    800019a8:	00000097          	auipc	ra,0x0
    800019ac:	f1a080e7          	jalr	-230(ra) # 800018c2 <reparent>
  wakeup(p->parent);
    800019b0:	0389b503          	ld	a0,56(s3)
    800019b4:	00000097          	auipc	ra,0x0
    800019b8:	e98080e7          	jalr	-360(ra) # 8000184c <wakeup>
  acquire(&p->lock);
    800019bc:	854e                	mv	a0,s3
    800019be:	00005097          	auipc	ra,0x5
    800019c2:	8fa080e7          	jalr	-1798(ra) # 800062b8 <acquire>
  p->xstate = status;
    800019c6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019ca:	4795                	li	a5,5
    800019cc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019d0:	8526                	mv	a0,s1
    800019d2:	00005097          	auipc	ra,0x5
    800019d6:	99a080e7          	jalr	-1638(ra) # 8000636c <release>
  sched();
    800019da:	00000097          	auipc	ra,0x0
    800019de:	bd4080e7          	jalr	-1068(ra) # 800015ae <sched>
  panic("zombie exit");
    800019e2:	00007517          	auipc	a0,0x7
    800019e6:	86e50513          	addi	a0,a0,-1938 # 80008250 <etext+0x250>
    800019ea:	00004097          	auipc	ra,0x4
    800019ee:	396080e7          	jalr	918(ra) # 80005d80 <panic>

00000000800019f2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019f2:	7179                	addi	sp,sp,-48
    800019f4:	f406                	sd	ra,40(sp)
    800019f6:	f022                	sd	s0,32(sp)
    800019f8:	ec26                	sd	s1,24(sp)
    800019fa:	e84a                	sd	s2,16(sp)
    800019fc:	e44e                	sd	s3,8(sp)
    800019fe:	1800                	addi	s0,sp,48
    80001a00:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a02:	00008497          	auipc	s1,0x8
    80001a06:	a7e48493          	addi	s1,s1,-1410 # 80009480 <proc>
    80001a0a:	0000d997          	auipc	s3,0xd
    80001a0e:	47698993          	addi	s3,s3,1142 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001a12:	8526                	mv	a0,s1
    80001a14:	00005097          	auipc	ra,0x5
    80001a18:	8a4080e7          	jalr	-1884(ra) # 800062b8 <acquire>
    if(p->pid == pid){
    80001a1c:	589c                	lw	a5,48(s1)
    80001a1e:	01278d63          	beq	a5,s2,80001a38 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a22:	8526                	mv	a0,s1
    80001a24:	00005097          	auipc	ra,0x5
    80001a28:	948080e7          	jalr	-1720(ra) # 8000636c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a2c:	16848493          	addi	s1,s1,360
    80001a30:	ff3491e3          	bne	s1,s3,80001a12 <kill+0x20>
  }
  return -1;
    80001a34:	557d                	li	a0,-1
    80001a36:	a829                	j	80001a50 <kill+0x5e>
      p->killed = 1;
    80001a38:	4785                	li	a5,1
    80001a3a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a3c:	4c98                	lw	a4,24(s1)
    80001a3e:	4789                	li	a5,2
    80001a40:	00f70f63          	beq	a4,a5,80001a5e <kill+0x6c>
      release(&p->lock);
    80001a44:	8526                	mv	a0,s1
    80001a46:	00005097          	auipc	ra,0x5
    80001a4a:	926080e7          	jalr	-1754(ra) # 8000636c <release>
      return 0;
    80001a4e:	4501                	li	a0,0
}
    80001a50:	70a2                	ld	ra,40(sp)
    80001a52:	7402                	ld	s0,32(sp)
    80001a54:	64e2                	ld	s1,24(sp)
    80001a56:	6942                	ld	s2,16(sp)
    80001a58:	69a2                	ld	s3,8(sp)
    80001a5a:	6145                	addi	sp,sp,48
    80001a5c:	8082                	ret
        p->state = RUNNABLE;
    80001a5e:	478d                	li	a5,3
    80001a60:	cc9c                	sw	a5,24(s1)
    80001a62:	b7cd                	j	80001a44 <kill+0x52>

0000000080001a64 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a64:	7179                	addi	sp,sp,-48
    80001a66:	f406                	sd	ra,40(sp)
    80001a68:	f022                	sd	s0,32(sp)
    80001a6a:	ec26                	sd	s1,24(sp)
    80001a6c:	e84a                	sd	s2,16(sp)
    80001a6e:	e44e                	sd	s3,8(sp)
    80001a70:	e052                	sd	s4,0(sp)
    80001a72:	1800                	addi	s0,sp,48
    80001a74:	84aa                	mv	s1,a0
    80001a76:	892e                	mv	s2,a1
    80001a78:	89b2                	mv	s3,a2
    80001a7a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a7c:	fffff097          	auipc	ra,0xfffff
    80001a80:	4b0080e7          	jalr	1200(ra) # 80000f2c <myproc>
  if(user_dst){
    80001a84:	c08d                	beqz	s1,80001aa6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a86:	86d2                	mv	a3,s4
    80001a88:	864e                	mv	a2,s3
    80001a8a:	85ca                	mv	a1,s2
    80001a8c:	6928                	ld	a0,80(a0)
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	07a080e7          	jalr	122(ra) # 80000b08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a96:	70a2                	ld	ra,40(sp)
    80001a98:	7402                	ld	s0,32(sp)
    80001a9a:	64e2                	ld	s1,24(sp)
    80001a9c:	6942                	ld	s2,16(sp)
    80001a9e:	69a2                	ld	s3,8(sp)
    80001aa0:	6a02                	ld	s4,0(sp)
    80001aa2:	6145                	addi	sp,sp,48
    80001aa4:	8082                	ret
    memmove((char *)dst, src, len);
    80001aa6:	000a061b          	sext.w	a2,s4
    80001aaa:	85ce                	mv	a1,s3
    80001aac:	854a                	mv	a0,s2
    80001aae:	ffffe097          	auipc	ra,0xffffe
    80001ab2:	728080e7          	jalr	1832(ra) # 800001d6 <memmove>
    return 0;
    80001ab6:	8526                	mv	a0,s1
    80001ab8:	bff9                	j	80001a96 <either_copyout+0x32>

0000000080001aba <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001aba:	7179                	addi	sp,sp,-48
    80001abc:	f406                	sd	ra,40(sp)
    80001abe:	f022                	sd	s0,32(sp)
    80001ac0:	ec26                	sd	s1,24(sp)
    80001ac2:	e84a                	sd	s2,16(sp)
    80001ac4:	e44e                	sd	s3,8(sp)
    80001ac6:	e052                	sd	s4,0(sp)
    80001ac8:	1800                	addi	s0,sp,48
    80001aca:	892a                	mv	s2,a0
    80001acc:	84ae                	mv	s1,a1
    80001ace:	89b2                	mv	s3,a2
    80001ad0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ad2:	fffff097          	auipc	ra,0xfffff
    80001ad6:	45a080e7          	jalr	1114(ra) # 80000f2c <myproc>
  if(user_src){
    80001ada:	c08d                	beqz	s1,80001afc <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001adc:	86d2                	mv	a3,s4
    80001ade:	864e                	mv	a2,s3
    80001ae0:	85ca                	mv	a1,s2
    80001ae2:	6928                	ld	a0,80(a0)
    80001ae4:	fffff097          	auipc	ra,0xfffff
    80001ae8:	0b0080e7          	jalr	176(ra) # 80000b94 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001aec:	70a2                	ld	ra,40(sp)
    80001aee:	7402                	ld	s0,32(sp)
    80001af0:	64e2                	ld	s1,24(sp)
    80001af2:	6942                	ld	s2,16(sp)
    80001af4:	69a2                	ld	s3,8(sp)
    80001af6:	6a02                	ld	s4,0(sp)
    80001af8:	6145                	addi	sp,sp,48
    80001afa:	8082                	ret
    memmove(dst, (char*)src, len);
    80001afc:	000a061b          	sext.w	a2,s4
    80001b00:	85ce                	mv	a1,s3
    80001b02:	854a                	mv	a0,s2
    80001b04:	ffffe097          	auipc	ra,0xffffe
    80001b08:	6d2080e7          	jalr	1746(ra) # 800001d6 <memmove>
    return 0;
    80001b0c:	8526                	mv	a0,s1
    80001b0e:	bff9                	j	80001aec <either_copyin+0x32>

0000000080001b10 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b10:	715d                	addi	sp,sp,-80
    80001b12:	e486                	sd	ra,72(sp)
    80001b14:	e0a2                	sd	s0,64(sp)
    80001b16:	fc26                	sd	s1,56(sp)
    80001b18:	f84a                	sd	s2,48(sp)
    80001b1a:	f44e                	sd	s3,40(sp)
    80001b1c:	f052                	sd	s4,32(sp)
    80001b1e:	ec56                	sd	s5,24(sp)
    80001b20:	e85a                	sd	s6,16(sp)
    80001b22:	e45e                	sd	s7,8(sp)
    80001b24:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b26:	00006517          	auipc	a0,0x6
    80001b2a:	52250513          	addi	a0,a0,1314 # 80008048 <etext+0x48>
    80001b2e:	00004097          	auipc	ra,0x4
    80001b32:	29c080e7          	jalr	668(ra) # 80005dca <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b36:	00008497          	auipc	s1,0x8
    80001b3a:	aa248493          	addi	s1,s1,-1374 # 800095d8 <proc+0x158>
    80001b3e:	0000d917          	auipc	s2,0xd
    80001b42:	49a90913          	addi	s2,s2,1178 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b46:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b48:	00006997          	auipc	s3,0x6
    80001b4c:	71898993          	addi	s3,s3,1816 # 80008260 <etext+0x260>
    printf("%d %s %s", p->pid, state, p->name);
    80001b50:	00006a97          	auipc	s5,0x6
    80001b54:	718a8a93          	addi	s5,s5,1816 # 80008268 <etext+0x268>
    printf("\n");
    80001b58:	00006a17          	auipc	s4,0x6
    80001b5c:	4f0a0a13          	addi	s4,s4,1264 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b60:	00006b97          	auipc	s7,0x6
    80001b64:	740b8b93          	addi	s7,s7,1856 # 800082a0 <states.0>
    80001b68:	a00d                	j	80001b8a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b6a:	ed86a583          	lw	a1,-296(a3)
    80001b6e:	8556                	mv	a0,s5
    80001b70:	00004097          	auipc	ra,0x4
    80001b74:	25a080e7          	jalr	602(ra) # 80005dca <printf>
    printf("\n");
    80001b78:	8552                	mv	a0,s4
    80001b7a:	00004097          	auipc	ra,0x4
    80001b7e:	250080e7          	jalr	592(ra) # 80005dca <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b82:	16848493          	addi	s1,s1,360
    80001b86:	03248263          	beq	s1,s2,80001baa <procdump+0x9a>
    if(p->state == UNUSED)
    80001b8a:	86a6                	mv	a3,s1
    80001b8c:	ec04a783          	lw	a5,-320(s1)
    80001b90:	dbed                	beqz	a5,80001b82 <procdump+0x72>
      state = "???";
    80001b92:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b94:	fcfb6be3          	bltu	s6,a5,80001b6a <procdump+0x5a>
    80001b98:	02079713          	slli	a4,a5,0x20
    80001b9c:	01d75793          	srli	a5,a4,0x1d
    80001ba0:	97de                	add	a5,a5,s7
    80001ba2:	6390                	ld	a2,0(a5)
    80001ba4:	f279                	bnez	a2,80001b6a <procdump+0x5a>
      state = "???";
    80001ba6:	864e                	mv	a2,s3
    80001ba8:	b7c9                	j	80001b6a <procdump+0x5a>
  }
}
    80001baa:	60a6                	ld	ra,72(sp)
    80001bac:	6406                	ld	s0,64(sp)
    80001bae:	74e2                	ld	s1,56(sp)
    80001bb0:	7942                	ld	s2,48(sp)
    80001bb2:	79a2                	ld	s3,40(sp)
    80001bb4:	7a02                	ld	s4,32(sp)
    80001bb6:	6ae2                	ld	s5,24(sp)
    80001bb8:	6b42                	ld	s6,16(sp)
    80001bba:	6ba2                	ld	s7,8(sp)
    80001bbc:	6161                	addi	sp,sp,80
    80001bbe:	8082                	ret

0000000080001bc0 <swtch>:
    80001bc0:	00153023          	sd	ra,0(a0)
    80001bc4:	00253423          	sd	sp,8(a0)
    80001bc8:	e900                	sd	s0,16(a0)
    80001bca:	ed04                	sd	s1,24(a0)
    80001bcc:	03253023          	sd	s2,32(a0)
    80001bd0:	03353423          	sd	s3,40(a0)
    80001bd4:	03453823          	sd	s4,48(a0)
    80001bd8:	03553c23          	sd	s5,56(a0)
    80001bdc:	05653023          	sd	s6,64(a0)
    80001be0:	05753423          	sd	s7,72(a0)
    80001be4:	05853823          	sd	s8,80(a0)
    80001be8:	05953c23          	sd	s9,88(a0)
    80001bec:	07a53023          	sd	s10,96(a0)
    80001bf0:	07b53423          	sd	s11,104(a0)
    80001bf4:	0005b083          	ld	ra,0(a1)
    80001bf8:	0085b103          	ld	sp,8(a1)
    80001bfc:	6980                	ld	s0,16(a1)
    80001bfe:	6d84                	ld	s1,24(a1)
    80001c00:	0205b903          	ld	s2,32(a1)
    80001c04:	0285b983          	ld	s3,40(a1)
    80001c08:	0305ba03          	ld	s4,48(a1)
    80001c0c:	0385ba83          	ld	s5,56(a1)
    80001c10:	0405bb03          	ld	s6,64(a1)
    80001c14:	0485bb83          	ld	s7,72(a1)
    80001c18:	0505bc03          	ld	s8,80(a1)
    80001c1c:	0585bc83          	ld	s9,88(a1)
    80001c20:	0605bd03          	ld	s10,96(a1)
    80001c24:	0685bd83          	ld	s11,104(a1)
    80001c28:	8082                	ret

0000000080001c2a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c2a:	1141                	addi	sp,sp,-16
    80001c2c:	e406                	sd	ra,8(sp)
    80001c2e:	e022                	sd	s0,0(sp)
    80001c30:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c32:	00006597          	auipc	a1,0x6
    80001c36:	69e58593          	addi	a1,a1,1694 # 800082d0 <states.0+0x30>
    80001c3a:	0000d517          	auipc	a0,0xd
    80001c3e:	24650513          	addi	a0,a0,582 # 8000ee80 <tickslock>
    80001c42:	00004097          	auipc	ra,0x4
    80001c46:	5e6080e7          	jalr	1510(ra) # 80006228 <initlock>
}
    80001c4a:	60a2                	ld	ra,8(sp)
    80001c4c:	6402                	ld	s0,0(sp)
    80001c4e:	0141                	addi	sp,sp,16
    80001c50:	8082                	ret

0000000080001c52 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c52:	1141                	addi	sp,sp,-16
    80001c54:	e422                	sd	s0,8(sp)
    80001c56:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c58:	00003797          	auipc	a5,0x3
    80001c5c:	58878793          	addi	a5,a5,1416 # 800051e0 <kernelvec>
    80001c60:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c64:	6422                	ld	s0,8(sp)
    80001c66:	0141                	addi	sp,sp,16
    80001c68:	8082                	ret

0000000080001c6a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c6a:	1141                	addi	sp,sp,-16
    80001c6c:	e406                	sd	ra,8(sp)
    80001c6e:	e022                	sd	s0,0(sp)
    80001c70:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	2ba080e7          	jalr	698(ra) # 80000f2c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c7e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c80:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c84:	00005697          	auipc	a3,0x5
    80001c88:	37c68693          	addi	a3,a3,892 # 80007000 <_trampoline>
    80001c8c:	00005717          	auipc	a4,0x5
    80001c90:	37470713          	addi	a4,a4,884 # 80007000 <_trampoline>
    80001c94:	8f15                	sub	a4,a4,a3
    80001c96:	040007b7          	lui	a5,0x4000
    80001c9a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c9c:	07b2                	slli	a5,a5,0xc
    80001c9e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca0:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ca4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ca6:	18002673          	csrr	a2,satp
    80001caa:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cac:	6d30                	ld	a2,88(a0)
    80001cae:	6138                	ld	a4,64(a0)
    80001cb0:	6585                	lui	a1,0x1
    80001cb2:	972e                	add	a4,a4,a1
    80001cb4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cb6:	6d38                	ld	a4,88(a0)
    80001cb8:	00000617          	auipc	a2,0x0
    80001cbc:	13860613          	addi	a2,a2,312 # 80001df0 <usertrap>
    80001cc0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cc2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cc4:	8612                	mv	a2,tp
    80001cc6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cc8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001ccc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cd0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cd4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cd8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cda:	6f18                	ld	a4,24(a4)
    80001cdc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ce0:	692c                	ld	a1,80(a0)
    80001ce2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001ce4:	00005717          	auipc	a4,0x5
    80001ce8:	3ac70713          	addi	a4,a4,940 # 80007090 <userret>
    80001cec:	8f15                	sub	a4,a4,a3
    80001cee:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cf0:	577d                	li	a4,-1
    80001cf2:	177e                	slli	a4,a4,0x3f
    80001cf4:	8dd9                	or	a1,a1,a4
    80001cf6:	02000537          	lui	a0,0x2000
    80001cfa:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001cfc:	0536                	slli	a0,a0,0xd
    80001cfe:	9782                	jalr	a5
}
    80001d00:	60a2                	ld	ra,8(sp)
    80001d02:	6402                	ld	s0,0(sp)
    80001d04:	0141                	addi	sp,sp,16
    80001d06:	8082                	ret

0000000080001d08 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d08:	1101                	addi	sp,sp,-32
    80001d0a:	ec06                	sd	ra,24(sp)
    80001d0c:	e822                	sd	s0,16(sp)
    80001d0e:	e426                	sd	s1,8(sp)
    80001d10:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d12:	0000d497          	auipc	s1,0xd
    80001d16:	16e48493          	addi	s1,s1,366 # 8000ee80 <tickslock>
    80001d1a:	8526                	mv	a0,s1
    80001d1c:	00004097          	auipc	ra,0x4
    80001d20:	59c080e7          	jalr	1436(ra) # 800062b8 <acquire>
  ticks++;
    80001d24:	00007517          	auipc	a0,0x7
    80001d28:	2f450513          	addi	a0,a0,756 # 80009018 <ticks>
    80001d2c:	411c                	lw	a5,0(a0)
    80001d2e:	2785                	addiw	a5,a5,1
    80001d30:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d32:	00000097          	auipc	ra,0x0
    80001d36:	b1a080e7          	jalr	-1254(ra) # 8000184c <wakeup>
  release(&tickslock);
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	00004097          	auipc	ra,0x4
    80001d40:	630080e7          	jalr	1584(ra) # 8000636c <release>
}
    80001d44:	60e2                	ld	ra,24(sp)
    80001d46:	6442                	ld	s0,16(sp)
    80001d48:	64a2                	ld	s1,8(sp)
    80001d4a:	6105                	addi	sp,sp,32
    80001d4c:	8082                	ret

0000000080001d4e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d4e:	1101                	addi	sp,sp,-32
    80001d50:	ec06                	sd	ra,24(sp)
    80001d52:	e822                	sd	s0,16(sp)
    80001d54:	e426                	sd	s1,8(sp)
    80001d56:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d58:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d5c:	00074d63          	bltz	a4,80001d76 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d60:	57fd                	li	a5,-1
    80001d62:	17fe                	slli	a5,a5,0x3f
    80001d64:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d66:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d68:	06f70363          	beq	a4,a5,80001dce <devintr+0x80>
  }
}
    80001d6c:	60e2                	ld	ra,24(sp)
    80001d6e:	6442                	ld	s0,16(sp)
    80001d70:	64a2                	ld	s1,8(sp)
    80001d72:	6105                	addi	sp,sp,32
    80001d74:	8082                	ret
     (scause & 0xff) == 9){
    80001d76:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001d7a:	46a5                	li	a3,9
    80001d7c:	fed792e3          	bne	a5,a3,80001d60 <devintr+0x12>
    int irq = plic_claim();
    80001d80:	00003097          	auipc	ra,0x3
    80001d84:	568080e7          	jalr	1384(ra) # 800052e8 <plic_claim>
    80001d88:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d8a:	47a9                	li	a5,10
    80001d8c:	02f50763          	beq	a0,a5,80001dba <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d90:	4785                	li	a5,1
    80001d92:	02f50963          	beq	a0,a5,80001dc4 <devintr+0x76>
    return 1;
    80001d96:	4505                	li	a0,1
    } else if(irq){
    80001d98:	d8f1                	beqz	s1,80001d6c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d9a:	85a6                	mv	a1,s1
    80001d9c:	00006517          	auipc	a0,0x6
    80001da0:	53c50513          	addi	a0,a0,1340 # 800082d8 <states.0+0x38>
    80001da4:	00004097          	auipc	ra,0x4
    80001da8:	026080e7          	jalr	38(ra) # 80005dca <printf>
      plic_complete(irq);
    80001dac:	8526                	mv	a0,s1
    80001dae:	00003097          	auipc	ra,0x3
    80001db2:	55e080e7          	jalr	1374(ra) # 8000530c <plic_complete>
    return 1;
    80001db6:	4505                	li	a0,1
    80001db8:	bf55                	j	80001d6c <devintr+0x1e>
      uartintr();
    80001dba:	00004097          	auipc	ra,0x4
    80001dbe:	41e080e7          	jalr	1054(ra) # 800061d8 <uartintr>
    80001dc2:	b7ed                	j	80001dac <devintr+0x5e>
      virtio_disk_intr();
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	9d4080e7          	jalr	-1580(ra) # 80005798 <virtio_disk_intr>
    80001dcc:	b7c5                	j	80001dac <devintr+0x5e>
    if(cpuid() == 0){
    80001dce:	fffff097          	auipc	ra,0xfffff
    80001dd2:	132080e7          	jalr	306(ra) # 80000f00 <cpuid>
    80001dd6:	c901                	beqz	a0,80001de6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dd8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ddc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001dde:	14479073          	csrw	sip,a5
    return 2;
    80001de2:	4509                	li	a0,2
    80001de4:	b761                	j	80001d6c <devintr+0x1e>
      clockintr();
    80001de6:	00000097          	auipc	ra,0x0
    80001dea:	f22080e7          	jalr	-222(ra) # 80001d08 <clockintr>
    80001dee:	b7ed                	j	80001dd8 <devintr+0x8a>

0000000080001df0 <usertrap>:
{
    80001df0:	1101                	addi	sp,sp,-32
    80001df2:	ec06                	sd	ra,24(sp)
    80001df4:	e822                	sd	s0,16(sp)
    80001df6:	e426                	sd	s1,8(sp)
    80001df8:	e04a                	sd	s2,0(sp)
    80001dfa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dfc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e00:	1007f793          	andi	a5,a5,256
    80001e04:	e3ad                	bnez	a5,80001e66 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e06:	00003797          	auipc	a5,0x3
    80001e0a:	3da78793          	addi	a5,a5,986 # 800051e0 <kernelvec>
    80001e0e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e12:	fffff097          	auipc	ra,0xfffff
    80001e16:	11a080e7          	jalr	282(ra) # 80000f2c <myproc>
    80001e1a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e1c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e1e:	14102773          	csrr	a4,sepc
    80001e22:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e24:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e28:	47a1                	li	a5,8
    80001e2a:	04f71c63          	bne	a4,a5,80001e82 <usertrap+0x92>
    if(p->killed)
    80001e2e:	551c                	lw	a5,40(a0)
    80001e30:	e3b9                	bnez	a5,80001e76 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e32:	6cb8                	ld	a4,88(s1)
    80001e34:	6f1c                	ld	a5,24(a4)
    80001e36:	0791                	addi	a5,a5,4
    80001e38:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e3a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e3e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e42:	10079073          	csrw	sstatus,a5
    syscall();
    80001e46:	00000097          	auipc	ra,0x0
    80001e4a:	2e0080e7          	jalr	736(ra) # 80002126 <syscall>
  if(p->killed)
    80001e4e:	549c                	lw	a5,40(s1)
    80001e50:	ebc1                	bnez	a5,80001ee0 <usertrap+0xf0>
  usertrapret();
    80001e52:	00000097          	auipc	ra,0x0
    80001e56:	e18080e7          	jalr	-488(ra) # 80001c6a <usertrapret>
}
    80001e5a:	60e2                	ld	ra,24(sp)
    80001e5c:	6442                	ld	s0,16(sp)
    80001e5e:	64a2                	ld	s1,8(sp)
    80001e60:	6902                	ld	s2,0(sp)
    80001e62:	6105                	addi	sp,sp,32
    80001e64:	8082                	ret
    panic("usertrap: not from user mode");
    80001e66:	00006517          	auipc	a0,0x6
    80001e6a:	49250513          	addi	a0,a0,1170 # 800082f8 <states.0+0x58>
    80001e6e:	00004097          	auipc	ra,0x4
    80001e72:	f12080e7          	jalr	-238(ra) # 80005d80 <panic>
      exit(-1);
    80001e76:	557d                	li	a0,-1
    80001e78:	00000097          	auipc	ra,0x0
    80001e7c:	aa4080e7          	jalr	-1372(ra) # 8000191c <exit>
    80001e80:	bf4d                	j	80001e32 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e82:	00000097          	auipc	ra,0x0
    80001e86:	ecc080e7          	jalr	-308(ra) # 80001d4e <devintr>
    80001e8a:	892a                	mv	s2,a0
    80001e8c:	c501                	beqz	a0,80001e94 <usertrap+0xa4>
  if(p->killed)
    80001e8e:	549c                	lw	a5,40(s1)
    80001e90:	c3a1                	beqz	a5,80001ed0 <usertrap+0xe0>
    80001e92:	a815                	j	80001ec6 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e94:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e98:	5890                	lw	a2,48(s1)
    80001e9a:	00006517          	auipc	a0,0x6
    80001e9e:	47e50513          	addi	a0,a0,1150 # 80008318 <states.0+0x78>
    80001ea2:	00004097          	auipc	ra,0x4
    80001ea6:	f28080e7          	jalr	-216(ra) # 80005dca <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eaa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eae:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eb2:	00006517          	auipc	a0,0x6
    80001eb6:	49650513          	addi	a0,a0,1174 # 80008348 <states.0+0xa8>
    80001eba:	00004097          	auipc	ra,0x4
    80001ebe:	f10080e7          	jalr	-240(ra) # 80005dca <printf>
    p->killed = 1;
    80001ec2:	4785                	li	a5,1
    80001ec4:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001ec6:	557d                	li	a0,-1
    80001ec8:	00000097          	auipc	ra,0x0
    80001ecc:	a54080e7          	jalr	-1452(ra) # 8000191c <exit>
  if(which_dev == 2)
    80001ed0:	4789                	li	a5,2
    80001ed2:	f8f910e3          	bne	s2,a5,80001e52 <usertrap+0x62>
    yield();
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	7ae080e7          	jalr	1966(ra) # 80001684 <yield>
    80001ede:	bf95                	j	80001e52 <usertrap+0x62>
  int which_dev = 0;
    80001ee0:	4901                	li	s2,0
    80001ee2:	b7d5                	j	80001ec6 <usertrap+0xd6>

0000000080001ee4 <kerneltrap>:
{
    80001ee4:	7179                	addi	sp,sp,-48
    80001ee6:	f406                	sd	ra,40(sp)
    80001ee8:	f022                	sd	s0,32(sp)
    80001eea:	ec26                	sd	s1,24(sp)
    80001eec:	e84a                	sd	s2,16(sp)
    80001eee:	e44e                	sd	s3,8(sp)
    80001ef0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ef6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001efa:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001efe:	1004f793          	andi	a5,s1,256
    80001f02:	cb85                	beqz	a5,80001f32 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f04:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f08:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f0a:	ef85                	bnez	a5,80001f42 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f0c:	00000097          	auipc	ra,0x0
    80001f10:	e42080e7          	jalr	-446(ra) # 80001d4e <devintr>
    80001f14:	cd1d                	beqz	a0,80001f52 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f16:	4789                	li	a5,2
    80001f18:	06f50a63          	beq	a0,a5,80001f8c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f1c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f20:	10049073          	csrw	sstatus,s1
}
    80001f24:	70a2                	ld	ra,40(sp)
    80001f26:	7402                	ld	s0,32(sp)
    80001f28:	64e2                	ld	s1,24(sp)
    80001f2a:	6942                	ld	s2,16(sp)
    80001f2c:	69a2                	ld	s3,8(sp)
    80001f2e:	6145                	addi	sp,sp,48
    80001f30:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f32:	00006517          	auipc	a0,0x6
    80001f36:	43650513          	addi	a0,a0,1078 # 80008368 <states.0+0xc8>
    80001f3a:	00004097          	auipc	ra,0x4
    80001f3e:	e46080e7          	jalr	-442(ra) # 80005d80 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f42:	00006517          	auipc	a0,0x6
    80001f46:	44e50513          	addi	a0,a0,1102 # 80008390 <states.0+0xf0>
    80001f4a:	00004097          	auipc	ra,0x4
    80001f4e:	e36080e7          	jalr	-458(ra) # 80005d80 <panic>
    printf("scause %p\n", scause);
    80001f52:	85ce                	mv	a1,s3
    80001f54:	00006517          	auipc	a0,0x6
    80001f58:	45c50513          	addi	a0,a0,1116 # 800083b0 <states.0+0x110>
    80001f5c:	00004097          	auipc	ra,0x4
    80001f60:	e6e080e7          	jalr	-402(ra) # 80005dca <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f64:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f68:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f6c:	00006517          	auipc	a0,0x6
    80001f70:	45450513          	addi	a0,a0,1108 # 800083c0 <states.0+0x120>
    80001f74:	00004097          	auipc	ra,0x4
    80001f78:	e56080e7          	jalr	-426(ra) # 80005dca <printf>
    panic("kerneltrap");
    80001f7c:	00006517          	auipc	a0,0x6
    80001f80:	45c50513          	addi	a0,a0,1116 # 800083d8 <states.0+0x138>
    80001f84:	00004097          	auipc	ra,0x4
    80001f88:	dfc080e7          	jalr	-516(ra) # 80005d80 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	fa0080e7          	jalr	-96(ra) # 80000f2c <myproc>
    80001f94:	d541                	beqz	a0,80001f1c <kerneltrap+0x38>
    80001f96:	fffff097          	auipc	ra,0xfffff
    80001f9a:	f96080e7          	jalr	-106(ra) # 80000f2c <myproc>
    80001f9e:	4d18                	lw	a4,24(a0)
    80001fa0:	4791                	li	a5,4
    80001fa2:	f6f71de3          	bne	a4,a5,80001f1c <kerneltrap+0x38>
    yield();
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	6de080e7          	jalr	1758(ra) # 80001684 <yield>
    80001fae:	b7bd                	j	80001f1c <kerneltrap+0x38>

0000000080001fb0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fb0:	1101                	addi	sp,sp,-32
    80001fb2:	ec06                	sd	ra,24(sp)
    80001fb4:	e822                	sd	s0,16(sp)
    80001fb6:	e426                	sd	s1,8(sp)
    80001fb8:	1000                	addi	s0,sp,32
    80001fba:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	f70080e7          	jalr	-144(ra) # 80000f2c <myproc>
  switch (n) {
    80001fc4:	4795                	li	a5,5
    80001fc6:	0497e163          	bltu	a5,s1,80002008 <argraw+0x58>
    80001fca:	048a                	slli	s1,s1,0x2
    80001fcc:	00006717          	auipc	a4,0x6
    80001fd0:	44470713          	addi	a4,a4,1092 # 80008410 <states.0+0x170>
    80001fd4:	94ba                	add	s1,s1,a4
    80001fd6:	409c                	lw	a5,0(s1)
    80001fd8:	97ba                	add	a5,a5,a4
    80001fda:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fdc:	6d3c                	ld	a5,88(a0)
    80001fde:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fe0:	60e2                	ld	ra,24(sp)
    80001fe2:	6442                	ld	s0,16(sp)
    80001fe4:	64a2                	ld	s1,8(sp)
    80001fe6:	6105                	addi	sp,sp,32
    80001fe8:	8082                	ret
    return p->trapframe->a1;
    80001fea:	6d3c                	ld	a5,88(a0)
    80001fec:	7fa8                	ld	a0,120(a5)
    80001fee:	bfcd                	j	80001fe0 <argraw+0x30>
    return p->trapframe->a2;
    80001ff0:	6d3c                	ld	a5,88(a0)
    80001ff2:	63c8                	ld	a0,128(a5)
    80001ff4:	b7f5                	j	80001fe0 <argraw+0x30>
    return p->trapframe->a3;
    80001ff6:	6d3c                	ld	a5,88(a0)
    80001ff8:	67c8                	ld	a0,136(a5)
    80001ffa:	b7dd                	j	80001fe0 <argraw+0x30>
    return p->trapframe->a4;
    80001ffc:	6d3c                	ld	a5,88(a0)
    80001ffe:	6bc8                	ld	a0,144(a5)
    80002000:	b7c5                	j	80001fe0 <argraw+0x30>
    return p->trapframe->a5;
    80002002:	6d3c                	ld	a5,88(a0)
    80002004:	6fc8                	ld	a0,152(a5)
    80002006:	bfe9                	j	80001fe0 <argraw+0x30>
  panic("argraw");
    80002008:	00006517          	auipc	a0,0x6
    8000200c:	3e050513          	addi	a0,a0,992 # 800083e8 <states.0+0x148>
    80002010:	00004097          	auipc	ra,0x4
    80002014:	d70080e7          	jalr	-656(ra) # 80005d80 <panic>

0000000080002018 <fetchaddr>:
{
    80002018:	1101                	addi	sp,sp,-32
    8000201a:	ec06                	sd	ra,24(sp)
    8000201c:	e822                	sd	s0,16(sp)
    8000201e:	e426                	sd	s1,8(sp)
    80002020:	e04a                	sd	s2,0(sp)
    80002022:	1000                	addi	s0,sp,32
    80002024:	84aa                	mv	s1,a0
    80002026:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	f04080e7          	jalr	-252(ra) # 80000f2c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002030:	653c                	ld	a5,72(a0)
    80002032:	02f4f863          	bgeu	s1,a5,80002062 <fetchaddr+0x4a>
    80002036:	00848713          	addi	a4,s1,8
    8000203a:	02e7e663          	bltu	a5,a4,80002066 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000203e:	46a1                	li	a3,8
    80002040:	8626                	mv	a2,s1
    80002042:	85ca                	mv	a1,s2
    80002044:	6928                	ld	a0,80(a0)
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	b4e080e7          	jalr	-1202(ra) # 80000b94 <copyin>
    8000204e:	00a03533          	snez	a0,a0
    80002052:	40a00533          	neg	a0,a0
}
    80002056:	60e2                	ld	ra,24(sp)
    80002058:	6442                	ld	s0,16(sp)
    8000205a:	64a2                	ld	s1,8(sp)
    8000205c:	6902                	ld	s2,0(sp)
    8000205e:	6105                	addi	sp,sp,32
    80002060:	8082                	ret
    return -1;
    80002062:	557d                	li	a0,-1
    80002064:	bfcd                	j	80002056 <fetchaddr+0x3e>
    80002066:	557d                	li	a0,-1
    80002068:	b7fd                	j	80002056 <fetchaddr+0x3e>

000000008000206a <fetchstr>:
{
    8000206a:	7179                	addi	sp,sp,-48
    8000206c:	f406                	sd	ra,40(sp)
    8000206e:	f022                	sd	s0,32(sp)
    80002070:	ec26                	sd	s1,24(sp)
    80002072:	e84a                	sd	s2,16(sp)
    80002074:	e44e                	sd	s3,8(sp)
    80002076:	1800                	addi	s0,sp,48
    80002078:	892a                	mv	s2,a0
    8000207a:	84ae                	mv	s1,a1
    8000207c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	eae080e7          	jalr	-338(ra) # 80000f2c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002086:	86ce                	mv	a3,s3
    80002088:	864a                	mv	a2,s2
    8000208a:	85a6                	mv	a1,s1
    8000208c:	6928                	ld	a0,80(a0)
    8000208e:	fffff097          	auipc	ra,0xfffff
    80002092:	b94080e7          	jalr	-1132(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80002096:	00054763          	bltz	a0,800020a4 <fetchstr+0x3a>
  return strlen(buf);
    8000209a:	8526                	mv	a0,s1
    8000209c:	ffffe097          	auipc	ra,0xffffe
    800020a0:	25a080e7          	jalr	602(ra) # 800002f6 <strlen>
}
    800020a4:	70a2                	ld	ra,40(sp)
    800020a6:	7402                	ld	s0,32(sp)
    800020a8:	64e2                	ld	s1,24(sp)
    800020aa:	6942                	ld	s2,16(sp)
    800020ac:	69a2                	ld	s3,8(sp)
    800020ae:	6145                	addi	sp,sp,48
    800020b0:	8082                	ret

00000000800020b2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020b2:	1101                	addi	sp,sp,-32
    800020b4:	ec06                	sd	ra,24(sp)
    800020b6:	e822                	sd	s0,16(sp)
    800020b8:	e426                	sd	s1,8(sp)
    800020ba:	1000                	addi	s0,sp,32
    800020bc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020be:	00000097          	auipc	ra,0x0
    800020c2:	ef2080e7          	jalr	-270(ra) # 80001fb0 <argraw>
    800020c6:	c088                	sw	a0,0(s1)
  return 0;
}
    800020c8:	4501                	li	a0,0
    800020ca:	60e2                	ld	ra,24(sp)
    800020cc:	6442                	ld	s0,16(sp)
    800020ce:	64a2                	ld	s1,8(sp)
    800020d0:	6105                	addi	sp,sp,32
    800020d2:	8082                	ret

00000000800020d4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020d4:	1101                	addi	sp,sp,-32
    800020d6:	ec06                	sd	ra,24(sp)
    800020d8:	e822                	sd	s0,16(sp)
    800020da:	e426                	sd	s1,8(sp)
    800020dc:	1000                	addi	s0,sp,32
    800020de:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020e0:	00000097          	auipc	ra,0x0
    800020e4:	ed0080e7          	jalr	-304(ra) # 80001fb0 <argraw>
    800020e8:	e088                	sd	a0,0(s1)
  return 0;
}
    800020ea:	4501                	li	a0,0
    800020ec:	60e2                	ld	ra,24(sp)
    800020ee:	6442                	ld	s0,16(sp)
    800020f0:	64a2                	ld	s1,8(sp)
    800020f2:	6105                	addi	sp,sp,32
    800020f4:	8082                	ret

00000000800020f6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020f6:	1101                	addi	sp,sp,-32
    800020f8:	ec06                	sd	ra,24(sp)
    800020fa:	e822                	sd	s0,16(sp)
    800020fc:	e426                	sd	s1,8(sp)
    800020fe:	e04a                	sd	s2,0(sp)
    80002100:	1000                	addi	s0,sp,32
    80002102:	84ae                	mv	s1,a1
    80002104:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002106:	00000097          	auipc	ra,0x0
    8000210a:	eaa080e7          	jalr	-342(ra) # 80001fb0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000210e:	864a                	mv	a2,s2
    80002110:	85a6                	mv	a1,s1
    80002112:	00000097          	auipc	ra,0x0
    80002116:	f58080e7          	jalr	-168(ra) # 8000206a <fetchstr>
}
    8000211a:	60e2                	ld	ra,24(sp)
    8000211c:	6442                	ld	s0,16(sp)
    8000211e:	64a2                	ld	s1,8(sp)
    80002120:	6902                	ld	s2,0(sp)
    80002122:	6105                	addi	sp,sp,32
    80002124:	8082                	ret

0000000080002126 <syscall>:



void
syscall(void)
{
    80002126:	1101                	addi	sp,sp,-32
    80002128:	ec06                	sd	ra,24(sp)
    8000212a:	e822                	sd	s0,16(sp)
    8000212c:	e426                	sd	s1,8(sp)
    8000212e:	e04a                	sd	s2,0(sp)
    80002130:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002132:	fffff097          	auipc	ra,0xfffff
    80002136:	dfa080e7          	jalr	-518(ra) # 80000f2c <myproc>
    8000213a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000213c:	05853903          	ld	s2,88(a0)
    80002140:	0a893783          	ld	a5,168(s2)
    80002144:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002148:	37fd                	addiw	a5,a5,-1
    8000214a:	4775                	li	a4,29
    8000214c:	00f76f63          	bltu	a4,a5,8000216a <syscall+0x44>
    80002150:	00369713          	slli	a4,a3,0x3
    80002154:	00006797          	auipc	a5,0x6
    80002158:	2d478793          	addi	a5,a5,724 # 80008428 <syscalls>
    8000215c:	97ba                	add	a5,a5,a4
    8000215e:	639c                	ld	a5,0(a5)
    80002160:	c789                	beqz	a5,8000216a <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002162:	9782                	jalr	a5
    80002164:	06a93823          	sd	a0,112(s2)
    80002168:	a839                	j	80002186 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000216a:	15848613          	addi	a2,s1,344
    8000216e:	588c                	lw	a1,48(s1)
    80002170:	00006517          	auipc	a0,0x6
    80002174:	28050513          	addi	a0,a0,640 # 800083f0 <states.0+0x150>
    80002178:	00004097          	auipc	ra,0x4
    8000217c:	c52080e7          	jalr	-942(ra) # 80005dca <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002180:	6cbc                	ld	a5,88(s1)
    80002182:	577d                	li	a4,-1
    80002184:	fbb8                	sd	a4,112(a5)
  }
}
    80002186:	60e2                	ld	ra,24(sp)
    80002188:	6442                	ld	s0,16(sp)
    8000218a:	64a2                	ld	s1,8(sp)
    8000218c:	6902                	ld	s2,0(sp)
    8000218e:	6105                	addi	sp,sp,32
    80002190:	8082                	ret

0000000080002192 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002192:	1101                	addi	sp,sp,-32
    80002194:	ec06                	sd	ra,24(sp)
    80002196:	e822                	sd	s0,16(sp)
    80002198:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000219a:	fec40593          	addi	a1,s0,-20
    8000219e:	4501                	li	a0,0
    800021a0:	00000097          	auipc	ra,0x0
    800021a4:	f12080e7          	jalr	-238(ra) # 800020b2 <argint>
    return -1;
    800021a8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021aa:	00054963          	bltz	a0,800021bc <sys_exit+0x2a>
  exit(n);
    800021ae:	fec42503          	lw	a0,-20(s0)
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	76a080e7          	jalr	1898(ra) # 8000191c <exit>
  return 0;  // not reached
    800021ba:	4781                	li	a5,0
}
    800021bc:	853e                	mv	a0,a5
    800021be:	60e2                	ld	ra,24(sp)
    800021c0:	6442                	ld	s0,16(sp)
    800021c2:	6105                	addi	sp,sp,32
    800021c4:	8082                	ret

00000000800021c6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021c6:	1141                	addi	sp,sp,-16
    800021c8:	e406                	sd	ra,8(sp)
    800021ca:	e022                	sd	s0,0(sp)
    800021cc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	d5e080e7          	jalr	-674(ra) # 80000f2c <myproc>
}
    800021d6:	5908                	lw	a0,48(a0)
    800021d8:	60a2                	ld	ra,8(sp)
    800021da:	6402                	ld	s0,0(sp)
    800021dc:	0141                	addi	sp,sp,16
    800021de:	8082                	ret

00000000800021e0 <sys_fork>:

uint64
sys_fork(void)
{
    800021e0:	1141                	addi	sp,sp,-16
    800021e2:	e406                	sd	ra,8(sp)
    800021e4:	e022                	sd	s0,0(sp)
    800021e6:	0800                	addi	s0,sp,16
  return fork();
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	1e6080e7          	jalr	486(ra) # 800013ce <fork>
}
    800021f0:	60a2                	ld	ra,8(sp)
    800021f2:	6402                	ld	s0,0(sp)
    800021f4:	0141                	addi	sp,sp,16
    800021f6:	8082                	ret

00000000800021f8 <sys_wait>:

uint64
sys_wait(void)
{
    800021f8:	1101                	addi	sp,sp,-32
    800021fa:	ec06                	sd	ra,24(sp)
    800021fc:	e822                	sd	s0,16(sp)
    800021fe:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002200:	fe840593          	addi	a1,s0,-24
    80002204:	4501                	li	a0,0
    80002206:	00000097          	auipc	ra,0x0
    8000220a:	ece080e7          	jalr	-306(ra) # 800020d4 <argaddr>
    8000220e:	87aa                	mv	a5,a0
    return -1;
    80002210:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002212:	0007c863          	bltz	a5,80002222 <sys_wait+0x2a>
  return wait(p);
    80002216:	fe843503          	ld	a0,-24(s0)
    8000221a:	fffff097          	auipc	ra,0xfffff
    8000221e:	50a080e7          	jalr	1290(ra) # 80001724 <wait>
}
    80002222:	60e2                	ld	ra,24(sp)
    80002224:	6442                	ld	s0,16(sp)
    80002226:	6105                	addi	sp,sp,32
    80002228:	8082                	ret

000000008000222a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000222a:	7179                	addi	sp,sp,-48
    8000222c:	f406                	sd	ra,40(sp)
    8000222e:	f022                	sd	s0,32(sp)
    80002230:	ec26                	sd	s1,24(sp)
    80002232:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002234:	fdc40593          	addi	a1,s0,-36
    80002238:	4501                	li	a0,0
    8000223a:	00000097          	auipc	ra,0x0
    8000223e:	e78080e7          	jalr	-392(ra) # 800020b2 <argint>
    80002242:	87aa                	mv	a5,a0
    return -1;
    80002244:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002246:	0207c063          	bltz	a5,80002266 <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	ce2080e7          	jalr	-798(ra) # 80000f2c <myproc>
    80002252:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002254:	fdc42503          	lw	a0,-36(s0)
    80002258:	fffff097          	auipc	ra,0xfffff
    8000225c:	0fe080e7          	jalr	254(ra) # 80001356 <growproc>
    80002260:	00054863          	bltz	a0,80002270 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002264:	8526                	mv	a0,s1
}
    80002266:	70a2                	ld	ra,40(sp)
    80002268:	7402                	ld	s0,32(sp)
    8000226a:	64e2                	ld	s1,24(sp)
    8000226c:	6145                	addi	sp,sp,48
    8000226e:	8082                	ret
    return -1;
    80002270:	557d                	li	a0,-1
    80002272:	bfd5                	j	80002266 <sys_sbrk+0x3c>

0000000080002274 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002274:	7139                	addi	sp,sp,-64
    80002276:	fc06                	sd	ra,56(sp)
    80002278:	f822                	sd	s0,48(sp)
    8000227a:	f426                	sd	s1,40(sp)
    8000227c:	f04a                	sd	s2,32(sp)
    8000227e:	ec4e                	sd	s3,24(sp)
    80002280:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    80002282:	fcc40593          	addi	a1,s0,-52
    80002286:	4501                	li	a0,0
    80002288:	00000097          	auipc	ra,0x0
    8000228c:	e2a080e7          	jalr	-470(ra) # 800020b2 <argint>
    return -1;
    80002290:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002292:	06054563          	bltz	a0,800022fc <sys_sleep+0x88>
  acquire(&tickslock);
    80002296:	0000d517          	auipc	a0,0xd
    8000229a:	bea50513          	addi	a0,a0,-1046 # 8000ee80 <tickslock>
    8000229e:	00004097          	auipc	ra,0x4
    800022a2:	01a080e7          	jalr	26(ra) # 800062b8 <acquire>
  ticks0 = ticks;
    800022a6:	00007917          	auipc	s2,0x7
    800022aa:	d7292903          	lw	s2,-654(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800022ae:	fcc42783          	lw	a5,-52(s0)
    800022b2:	cf85                	beqz	a5,800022ea <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022b4:	0000d997          	auipc	s3,0xd
    800022b8:	bcc98993          	addi	s3,s3,-1076 # 8000ee80 <tickslock>
    800022bc:	00007497          	auipc	s1,0x7
    800022c0:	d5c48493          	addi	s1,s1,-676 # 80009018 <ticks>
    if(myproc()->killed){
    800022c4:	fffff097          	auipc	ra,0xfffff
    800022c8:	c68080e7          	jalr	-920(ra) # 80000f2c <myproc>
    800022cc:	551c                	lw	a5,40(a0)
    800022ce:	ef9d                	bnez	a5,8000230c <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022d0:	85ce                	mv	a1,s3
    800022d2:	8526                	mv	a0,s1
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	3ec080e7          	jalr	1004(ra) # 800016c0 <sleep>
  while(ticks - ticks0 < n){
    800022dc:	409c                	lw	a5,0(s1)
    800022de:	412787bb          	subw	a5,a5,s2
    800022e2:	fcc42703          	lw	a4,-52(s0)
    800022e6:	fce7efe3          	bltu	a5,a4,800022c4 <sys_sleep+0x50>
  }
  release(&tickslock);
    800022ea:	0000d517          	auipc	a0,0xd
    800022ee:	b9650513          	addi	a0,a0,-1130 # 8000ee80 <tickslock>
    800022f2:	00004097          	auipc	ra,0x4
    800022f6:	07a080e7          	jalr	122(ra) # 8000636c <release>
  return 0;
    800022fa:	4781                	li	a5,0
}
    800022fc:	853e                	mv	a0,a5
    800022fe:	70e2                	ld	ra,56(sp)
    80002300:	7442                	ld	s0,48(sp)
    80002302:	74a2                	ld	s1,40(sp)
    80002304:	7902                	ld	s2,32(sp)
    80002306:	69e2                	ld	s3,24(sp)
    80002308:	6121                	addi	sp,sp,64
    8000230a:	8082                	ret
      release(&tickslock);
    8000230c:	0000d517          	auipc	a0,0xd
    80002310:	b7450513          	addi	a0,a0,-1164 # 8000ee80 <tickslock>
    80002314:	00004097          	auipc	ra,0x4
    80002318:	058080e7          	jalr	88(ra) # 8000636c <release>
      return -1;
    8000231c:	57fd                	li	a5,-1
    8000231e:	bff9                	j	800022fc <sys_sleep+0x88>

0000000080002320 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002320:	715d                	addi	sp,sp,-80
    80002322:	e486                	sd	ra,72(sp)
    80002324:	e0a2                	sd	s0,64(sp)
    80002326:	fc26                	sd	s1,56(sp)
    80002328:	f84a                	sd	s2,48(sp)
    8000232a:	f44e                	sd	s3,40(sp)
    8000232c:	f052                	sd	s4,32(sp)
    8000232e:	0880                	addi	s0,sp,80
  // lab pgtbl: your code here.
  uint64 start_va, buffer_va;
  int npages;
  int bits = 0;
    80002330:	fa042c23          	sw	zero,-72(s0)
  
  argaddr(0, &start_va);
    80002334:	fc840593          	addi	a1,s0,-56
    80002338:	4501                	li	a0,0
    8000233a:	00000097          	auipc	ra,0x0
    8000233e:	d9a080e7          	jalr	-614(ra) # 800020d4 <argaddr>
  argint(1, &npages);
    80002342:	fbc40593          	addi	a1,s0,-68
    80002346:	4505                	li	a0,1
    80002348:	00000097          	auipc	ra,0x0
    8000234c:	d6a080e7          	jalr	-662(ra) # 800020b2 <argint>
  argaddr(2, &buffer_va);
    80002350:	fc040593          	addi	a1,s0,-64
    80002354:	4509                	li	a0,2
    80002356:	00000097          	auipc	ra,0x0
    8000235a:	d7e080e7          	jalr	-642(ra) # 800020d4 <argaddr>

  if(npages>32)
    8000235e:	fbc42703          	lw	a4,-68(s0)
    80002362:	02000793          	li	a5,32
    80002366:	00e7d463          	bge	a5,a4,8000236e <sys_pgaccess+0x4e>
  npages = 32;
    8000236a:	faf42e23          	sw	a5,-68(s0)

  struct proc* p = myproc();
    8000236e:	fffff097          	auipc	ra,0xfffff
    80002372:	bbe080e7          	jalr	-1090(ra) # 80000f2c <myproc>
  pagetable_t pgtbl = p->pagetable;
    80002376:	05053903          	ld	s2,80(a0)
  for(int i=0; i < npages; i++){
    8000237a:	fbc42783          	lw	a5,-68(s0)
    8000237e:	04f05863          	blez	a5,800023ce <sys_pgaccess+0xae>
    80002382:	4481                	li	s1,0
    extern pte_t *walk(pagetable_t pagetable, uint64 va, int alloc);
    pte_t* PTE = walk(pgtbl, start_va, 0);
    if(*PTE & PTE_A)
    {
      bits |= 1L << i;
    80002384:	4a05                	li	s4,1
    }
    *PTE &= ~PTE_A;
    start_va += PGSIZE;
    80002386:	6985                	lui	s3,0x1
    80002388:	a839                	j	800023a6 <sys_pgaccess+0x86>
    *PTE &= ~PTE_A;
    8000238a:	611c                	ld	a5,0(a0)
    8000238c:	fbf7f793          	andi	a5,a5,-65
    80002390:	e11c                	sd	a5,0(a0)
    start_va += PGSIZE;
    80002392:	fc843783          	ld	a5,-56(s0)
    80002396:	97ce                	add	a5,a5,s3
    80002398:	fcf43423          	sd	a5,-56(s0)
  for(int i=0; i < npages; i++){
    8000239c:	2485                	addiw	s1,s1,1
    8000239e:	fbc42783          	lw	a5,-68(s0)
    800023a2:	02f4d663          	bge	s1,a5,800023ce <sys_pgaccess+0xae>
    pte_t* PTE = walk(pgtbl, start_va, 0);
    800023a6:	4601                	li	a2,0
    800023a8:	fc843583          	ld	a1,-56(s0)
    800023ac:	854a                	mv	a0,s2
    800023ae:	ffffe097          	auipc	ra,0xffffe
    800023b2:	0ac080e7          	jalr	172(ra) # 8000045a <walk>
    if(*PTE & PTE_A)
    800023b6:	611c                	ld	a5,0(a0)
    800023b8:	0407f793          	andi	a5,a5,64
    800023bc:	d7f9                	beqz	a5,8000238a <sys_pgaccess+0x6a>
      bits |= 1L << i;
    800023be:	009a17b3          	sll	a5,s4,s1
    800023c2:	fb842703          	lw	a4,-72(s0)
    800023c6:	8fd9                	or	a5,a5,a4
    800023c8:	faf42c23          	sw	a5,-72(s0)
    800023cc:	bf7d                	j	8000238a <sys_pgaccess+0x6a>
  }
  copyout(pgtbl, buffer_va, (char*)&bits, 4);
    800023ce:	4691                	li	a3,4
    800023d0:	fb840613          	addi	a2,s0,-72
    800023d4:	fc043583          	ld	a1,-64(s0)
    800023d8:	854a                	mv	a0,s2
    800023da:	ffffe097          	auipc	ra,0xffffe
    800023de:	72e080e7          	jalr	1838(ra) # 80000b08 <copyout>
  return 0;
}
    800023e2:	4501                	li	a0,0
    800023e4:	60a6                	ld	ra,72(sp)
    800023e6:	6406                	ld	s0,64(sp)
    800023e8:	74e2                	ld	s1,56(sp)
    800023ea:	7942                	ld	s2,48(sp)
    800023ec:	79a2                	ld	s3,40(sp)
    800023ee:	7a02                	ld	s4,32(sp)
    800023f0:	6161                	addi	sp,sp,80
    800023f2:	8082                	ret

00000000800023f4 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    800023f4:	1101                	addi	sp,sp,-32
    800023f6:	ec06                	sd	ra,24(sp)
    800023f8:	e822                	sd	s0,16(sp)
    800023fa:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800023fc:	fec40593          	addi	a1,s0,-20
    80002400:	4501                	li	a0,0
    80002402:	00000097          	auipc	ra,0x0
    80002406:	cb0080e7          	jalr	-848(ra) # 800020b2 <argint>
    8000240a:	87aa                	mv	a5,a0
    return -1;
    8000240c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000240e:	0007c863          	bltz	a5,8000241e <sys_kill+0x2a>
  return kill(pid);
    80002412:	fec42503          	lw	a0,-20(s0)
    80002416:	fffff097          	auipc	ra,0xfffff
    8000241a:	5dc080e7          	jalr	1500(ra) # 800019f2 <kill>
}
    8000241e:	60e2                	ld	ra,24(sp)
    80002420:	6442                	ld	s0,16(sp)
    80002422:	6105                	addi	sp,sp,32
    80002424:	8082                	ret

0000000080002426 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002426:	1101                	addi	sp,sp,-32
    80002428:	ec06                	sd	ra,24(sp)
    8000242a:	e822                	sd	s0,16(sp)
    8000242c:	e426                	sd	s1,8(sp)
    8000242e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002430:	0000d517          	auipc	a0,0xd
    80002434:	a5050513          	addi	a0,a0,-1456 # 8000ee80 <tickslock>
    80002438:	00004097          	auipc	ra,0x4
    8000243c:	e80080e7          	jalr	-384(ra) # 800062b8 <acquire>
  xticks = ticks;
    80002440:	00007497          	auipc	s1,0x7
    80002444:	bd84a483          	lw	s1,-1064(s1) # 80009018 <ticks>
  release(&tickslock);
    80002448:	0000d517          	auipc	a0,0xd
    8000244c:	a3850513          	addi	a0,a0,-1480 # 8000ee80 <tickslock>
    80002450:	00004097          	auipc	ra,0x4
    80002454:	f1c080e7          	jalr	-228(ra) # 8000636c <release>
  return xticks;
}
    80002458:	02049513          	slli	a0,s1,0x20
    8000245c:	9101                	srli	a0,a0,0x20
    8000245e:	60e2                	ld	ra,24(sp)
    80002460:	6442                	ld	s0,16(sp)
    80002462:	64a2                	ld	s1,8(sp)
    80002464:	6105                	addi	sp,sp,32
    80002466:	8082                	ret

0000000080002468 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002468:	7179                	addi	sp,sp,-48
    8000246a:	f406                	sd	ra,40(sp)
    8000246c:	f022                	sd	s0,32(sp)
    8000246e:	ec26                	sd	s1,24(sp)
    80002470:	e84a                	sd	s2,16(sp)
    80002472:	e44e                	sd	s3,8(sp)
    80002474:	e052                	sd	s4,0(sp)
    80002476:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002478:	00006597          	auipc	a1,0x6
    8000247c:	0a858593          	addi	a1,a1,168 # 80008520 <syscalls+0xf8>
    80002480:	0000d517          	auipc	a0,0xd
    80002484:	a1850513          	addi	a0,a0,-1512 # 8000ee98 <bcache>
    80002488:	00004097          	auipc	ra,0x4
    8000248c:	da0080e7          	jalr	-608(ra) # 80006228 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002490:	00015797          	auipc	a5,0x15
    80002494:	a0878793          	addi	a5,a5,-1528 # 80016e98 <bcache+0x8000>
    80002498:	00015717          	auipc	a4,0x15
    8000249c:	c6870713          	addi	a4,a4,-920 # 80017100 <bcache+0x8268>
    800024a0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024a4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024a8:	0000d497          	auipc	s1,0xd
    800024ac:	a0848493          	addi	s1,s1,-1528 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    800024b0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024b2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024b4:	00006a17          	auipc	s4,0x6
    800024b8:	074a0a13          	addi	s4,s4,116 # 80008528 <syscalls+0x100>
    b->next = bcache.head.next;
    800024bc:	2b893783          	ld	a5,696(s2)
    800024c0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024c2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024c6:	85d2                	mv	a1,s4
    800024c8:	01048513          	addi	a0,s1,16
    800024cc:	00001097          	auipc	ra,0x1
    800024d0:	4c2080e7          	jalr	1218(ra) # 8000398e <initsleeplock>
    bcache.head.next->prev = b;
    800024d4:	2b893783          	ld	a5,696(s2)
    800024d8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024da:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024de:	45848493          	addi	s1,s1,1112
    800024e2:	fd349de3          	bne	s1,s3,800024bc <binit+0x54>
  }
}
    800024e6:	70a2                	ld	ra,40(sp)
    800024e8:	7402                	ld	s0,32(sp)
    800024ea:	64e2                	ld	s1,24(sp)
    800024ec:	6942                	ld	s2,16(sp)
    800024ee:	69a2                	ld	s3,8(sp)
    800024f0:	6a02                	ld	s4,0(sp)
    800024f2:	6145                	addi	sp,sp,48
    800024f4:	8082                	ret

00000000800024f6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024f6:	7179                	addi	sp,sp,-48
    800024f8:	f406                	sd	ra,40(sp)
    800024fa:	f022                	sd	s0,32(sp)
    800024fc:	ec26                	sd	s1,24(sp)
    800024fe:	e84a                	sd	s2,16(sp)
    80002500:	e44e                	sd	s3,8(sp)
    80002502:	1800                	addi	s0,sp,48
    80002504:	892a                	mv	s2,a0
    80002506:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002508:	0000d517          	auipc	a0,0xd
    8000250c:	99050513          	addi	a0,a0,-1648 # 8000ee98 <bcache>
    80002510:	00004097          	auipc	ra,0x4
    80002514:	da8080e7          	jalr	-600(ra) # 800062b8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002518:	00015497          	auipc	s1,0x15
    8000251c:	c384b483          	ld	s1,-968(s1) # 80017150 <bcache+0x82b8>
    80002520:	00015797          	auipc	a5,0x15
    80002524:	be078793          	addi	a5,a5,-1056 # 80017100 <bcache+0x8268>
    80002528:	02f48f63          	beq	s1,a5,80002566 <bread+0x70>
    8000252c:	873e                	mv	a4,a5
    8000252e:	a021                	j	80002536 <bread+0x40>
    80002530:	68a4                	ld	s1,80(s1)
    80002532:	02e48a63          	beq	s1,a4,80002566 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002536:	449c                	lw	a5,8(s1)
    80002538:	ff279ce3          	bne	a5,s2,80002530 <bread+0x3a>
    8000253c:	44dc                	lw	a5,12(s1)
    8000253e:	ff3799e3          	bne	a5,s3,80002530 <bread+0x3a>
      b->refcnt++;
    80002542:	40bc                	lw	a5,64(s1)
    80002544:	2785                	addiw	a5,a5,1
    80002546:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002548:	0000d517          	auipc	a0,0xd
    8000254c:	95050513          	addi	a0,a0,-1712 # 8000ee98 <bcache>
    80002550:	00004097          	auipc	ra,0x4
    80002554:	e1c080e7          	jalr	-484(ra) # 8000636c <release>
      acquiresleep(&b->lock);
    80002558:	01048513          	addi	a0,s1,16
    8000255c:	00001097          	auipc	ra,0x1
    80002560:	46c080e7          	jalr	1132(ra) # 800039c8 <acquiresleep>
      return b;
    80002564:	a8b9                	j	800025c2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002566:	00015497          	auipc	s1,0x15
    8000256a:	be24b483          	ld	s1,-1054(s1) # 80017148 <bcache+0x82b0>
    8000256e:	00015797          	auipc	a5,0x15
    80002572:	b9278793          	addi	a5,a5,-1134 # 80017100 <bcache+0x8268>
    80002576:	00f48863          	beq	s1,a5,80002586 <bread+0x90>
    8000257a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000257c:	40bc                	lw	a5,64(s1)
    8000257e:	cf81                	beqz	a5,80002596 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002580:	64a4                	ld	s1,72(s1)
    80002582:	fee49de3          	bne	s1,a4,8000257c <bread+0x86>
  panic("bget: no buffers");
    80002586:	00006517          	auipc	a0,0x6
    8000258a:	faa50513          	addi	a0,a0,-86 # 80008530 <syscalls+0x108>
    8000258e:	00003097          	auipc	ra,0x3
    80002592:	7f2080e7          	jalr	2034(ra) # 80005d80 <panic>
      b->dev = dev;
    80002596:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000259a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000259e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025a2:	4785                	li	a5,1
    800025a4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025a6:	0000d517          	auipc	a0,0xd
    800025aa:	8f250513          	addi	a0,a0,-1806 # 8000ee98 <bcache>
    800025ae:	00004097          	auipc	ra,0x4
    800025b2:	dbe080e7          	jalr	-578(ra) # 8000636c <release>
      acquiresleep(&b->lock);
    800025b6:	01048513          	addi	a0,s1,16
    800025ba:	00001097          	auipc	ra,0x1
    800025be:	40e080e7          	jalr	1038(ra) # 800039c8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025c2:	409c                	lw	a5,0(s1)
    800025c4:	cb89                	beqz	a5,800025d6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025c6:	8526                	mv	a0,s1
    800025c8:	70a2                	ld	ra,40(sp)
    800025ca:	7402                	ld	s0,32(sp)
    800025cc:	64e2                	ld	s1,24(sp)
    800025ce:	6942                	ld	s2,16(sp)
    800025d0:	69a2                	ld	s3,8(sp)
    800025d2:	6145                	addi	sp,sp,48
    800025d4:	8082                	ret
    virtio_disk_rw(b, 0);
    800025d6:	4581                	li	a1,0
    800025d8:	8526                	mv	a0,s1
    800025da:	00003097          	auipc	ra,0x3
    800025de:	f38080e7          	jalr	-200(ra) # 80005512 <virtio_disk_rw>
    b->valid = 1;
    800025e2:	4785                	li	a5,1
    800025e4:	c09c                	sw	a5,0(s1)
  return b;
    800025e6:	b7c5                	j	800025c6 <bread+0xd0>

00000000800025e8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025e8:	1101                	addi	sp,sp,-32
    800025ea:	ec06                	sd	ra,24(sp)
    800025ec:	e822                	sd	s0,16(sp)
    800025ee:	e426                	sd	s1,8(sp)
    800025f0:	1000                	addi	s0,sp,32
    800025f2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025f4:	0541                	addi	a0,a0,16
    800025f6:	00001097          	auipc	ra,0x1
    800025fa:	46c080e7          	jalr	1132(ra) # 80003a62 <holdingsleep>
    800025fe:	cd01                	beqz	a0,80002616 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002600:	4585                	li	a1,1
    80002602:	8526                	mv	a0,s1
    80002604:	00003097          	auipc	ra,0x3
    80002608:	f0e080e7          	jalr	-242(ra) # 80005512 <virtio_disk_rw>
}
    8000260c:	60e2                	ld	ra,24(sp)
    8000260e:	6442                	ld	s0,16(sp)
    80002610:	64a2                	ld	s1,8(sp)
    80002612:	6105                	addi	sp,sp,32
    80002614:	8082                	ret
    panic("bwrite");
    80002616:	00006517          	auipc	a0,0x6
    8000261a:	f3250513          	addi	a0,a0,-206 # 80008548 <syscalls+0x120>
    8000261e:	00003097          	auipc	ra,0x3
    80002622:	762080e7          	jalr	1890(ra) # 80005d80 <panic>

0000000080002626 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002626:	1101                	addi	sp,sp,-32
    80002628:	ec06                	sd	ra,24(sp)
    8000262a:	e822                	sd	s0,16(sp)
    8000262c:	e426                	sd	s1,8(sp)
    8000262e:	e04a                	sd	s2,0(sp)
    80002630:	1000                	addi	s0,sp,32
    80002632:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002634:	01050913          	addi	s2,a0,16
    80002638:	854a                	mv	a0,s2
    8000263a:	00001097          	auipc	ra,0x1
    8000263e:	428080e7          	jalr	1064(ra) # 80003a62 <holdingsleep>
    80002642:	c92d                	beqz	a0,800026b4 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002644:	854a                	mv	a0,s2
    80002646:	00001097          	auipc	ra,0x1
    8000264a:	3d8080e7          	jalr	984(ra) # 80003a1e <releasesleep>

  acquire(&bcache.lock);
    8000264e:	0000d517          	auipc	a0,0xd
    80002652:	84a50513          	addi	a0,a0,-1974 # 8000ee98 <bcache>
    80002656:	00004097          	auipc	ra,0x4
    8000265a:	c62080e7          	jalr	-926(ra) # 800062b8 <acquire>
  b->refcnt--;
    8000265e:	40bc                	lw	a5,64(s1)
    80002660:	37fd                	addiw	a5,a5,-1
    80002662:	0007871b          	sext.w	a4,a5
    80002666:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002668:	eb05                	bnez	a4,80002698 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000266a:	68bc                	ld	a5,80(s1)
    8000266c:	64b8                	ld	a4,72(s1)
    8000266e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002670:	64bc                	ld	a5,72(s1)
    80002672:	68b8                	ld	a4,80(s1)
    80002674:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002676:	00015797          	auipc	a5,0x15
    8000267a:	82278793          	addi	a5,a5,-2014 # 80016e98 <bcache+0x8000>
    8000267e:	2b87b703          	ld	a4,696(a5)
    80002682:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002684:	00015717          	auipc	a4,0x15
    80002688:	a7c70713          	addi	a4,a4,-1412 # 80017100 <bcache+0x8268>
    8000268c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000268e:	2b87b703          	ld	a4,696(a5)
    80002692:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002694:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002698:	0000d517          	auipc	a0,0xd
    8000269c:	80050513          	addi	a0,a0,-2048 # 8000ee98 <bcache>
    800026a0:	00004097          	auipc	ra,0x4
    800026a4:	ccc080e7          	jalr	-820(ra) # 8000636c <release>
}
    800026a8:	60e2                	ld	ra,24(sp)
    800026aa:	6442                	ld	s0,16(sp)
    800026ac:	64a2                	ld	s1,8(sp)
    800026ae:	6902                	ld	s2,0(sp)
    800026b0:	6105                	addi	sp,sp,32
    800026b2:	8082                	ret
    panic("brelse");
    800026b4:	00006517          	auipc	a0,0x6
    800026b8:	e9c50513          	addi	a0,a0,-356 # 80008550 <syscalls+0x128>
    800026bc:	00003097          	auipc	ra,0x3
    800026c0:	6c4080e7          	jalr	1732(ra) # 80005d80 <panic>

00000000800026c4 <bpin>:

void
bpin(struct buf *b) {
    800026c4:	1101                	addi	sp,sp,-32
    800026c6:	ec06                	sd	ra,24(sp)
    800026c8:	e822                	sd	s0,16(sp)
    800026ca:	e426                	sd	s1,8(sp)
    800026cc:	1000                	addi	s0,sp,32
    800026ce:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026d0:	0000c517          	auipc	a0,0xc
    800026d4:	7c850513          	addi	a0,a0,1992 # 8000ee98 <bcache>
    800026d8:	00004097          	auipc	ra,0x4
    800026dc:	be0080e7          	jalr	-1056(ra) # 800062b8 <acquire>
  b->refcnt++;
    800026e0:	40bc                	lw	a5,64(s1)
    800026e2:	2785                	addiw	a5,a5,1
    800026e4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026e6:	0000c517          	auipc	a0,0xc
    800026ea:	7b250513          	addi	a0,a0,1970 # 8000ee98 <bcache>
    800026ee:	00004097          	auipc	ra,0x4
    800026f2:	c7e080e7          	jalr	-898(ra) # 8000636c <release>
}
    800026f6:	60e2                	ld	ra,24(sp)
    800026f8:	6442                	ld	s0,16(sp)
    800026fa:	64a2                	ld	s1,8(sp)
    800026fc:	6105                	addi	sp,sp,32
    800026fe:	8082                	ret

0000000080002700 <bunpin>:

void
bunpin(struct buf *b) {
    80002700:	1101                	addi	sp,sp,-32
    80002702:	ec06                	sd	ra,24(sp)
    80002704:	e822                	sd	s0,16(sp)
    80002706:	e426                	sd	s1,8(sp)
    80002708:	1000                	addi	s0,sp,32
    8000270a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000270c:	0000c517          	auipc	a0,0xc
    80002710:	78c50513          	addi	a0,a0,1932 # 8000ee98 <bcache>
    80002714:	00004097          	auipc	ra,0x4
    80002718:	ba4080e7          	jalr	-1116(ra) # 800062b8 <acquire>
  b->refcnt--;
    8000271c:	40bc                	lw	a5,64(s1)
    8000271e:	37fd                	addiw	a5,a5,-1
    80002720:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002722:	0000c517          	auipc	a0,0xc
    80002726:	77650513          	addi	a0,a0,1910 # 8000ee98 <bcache>
    8000272a:	00004097          	auipc	ra,0x4
    8000272e:	c42080e7          	jalr	-958(ra) # 8000636c <release>
}
    80002732:	60e2                	ld	ra,24(sp)
    80002734:	6442                	ld	s0,16(sp)
    80002736:	64a2                	ld	s1,8(sp)
    80002738:	6105                	addi	sp,sp,32
    8000273a:	8082                	ret

000000008000273c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000273c:	1101                	addi	sp,sp,-32
    8000273e:	ec06                	sd	ra,24(sp)
    80002740:	e822                	sd	s0,16(sp)
    80002742:	e426                	sd	s1,8(sp)
    80002744:	e04a                	sd	s2,0(sp)
    80002746:	1000                	addi	s0,sp,32
    80002748:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000274a:	00d5d59b          	srliw	a1,a1,0xd
    8000274e:	00015797          	auipc	a5,0x15
    80002752:	e267a783          	lw	a5,-474(a5) # 80017574 <sb+0x1c>
    80002756:	9dbd                	addw	a1,a1,a5
    80002758:	00000097          	auipc	ra,0x0
    8000275c:	d9e080e7          	jalr	-610(ra) # 800024f6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002760:	0074f713          	andi	a4,s1,7
    80002764:	4785                	li	a5,1
    80002766:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000276a:	14ce                	slli	s1,s1,0x33
    8000276c:	90d9                	srli	s1,s1,0x36
    8000276e:	00950733          	add	a4,a0,s1
    80002772:	05874703          	lbu	a4,88(a4)
    80002776:	00e7f6b3          	and	a3,a5,a4
    8000277a:	c69d                	beqz	a3,800027a8 <bfree+0x6c>
    8000277c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000277e:	94aa                	add	s1,s1,a0
    80002780:	fff7c793          	not	a5,a5
    80002784:	8f7d                	and	a4,a4,a5
    80002786:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000278a:	00001097          	auipc	ra,0x1
    8000278e:	120080e7          	jalr	288(ra) # 800038aa <log_write>
  brelse(bp);
    80002792:	854a                	mv	a0,s2
    80002794:	00000097          	auipc	ra,0x0
    80002798:	e92080e7          	jalr	-366(ra) # 80002626 <brelse>
}
    8000279c:	60e2                	ld	ra,24(sp)
    8000279e:	6442                	ld	s0,16(sp)
    800027a0:	64a2                	ld	s1,8(sp)
    800027a2:	6902                	ld	s2,0(sp)
    800027a4:	6105                	addi	sp,sp,32
    800027a6:	8082                	ret
    panic("freeing free block");
    800027a8:	00006517          	auipc	a0,0x6
    800027ac:	db050513          	addi	a0,a0,-592 # 80008558 <syscalls+0x130>
    800027b0:	00003097          	auipc	ra,0x3
    800027b4:	5d0080e7          	jalr	1488(ra) # 80005d80 <panic>

00000000800027b8 <balloc>:
{
    800027b8:	711d                	addi	sp,sp,-96
    800027ba:	ec86                	sd	ra,88(sp)
    800027bc:	e8a2                	sd	s0,80(sp)
    800027be:	e4a6                	sd	s1,72(sp)
    800027c0:	e0ca                	sd	s2,64(sp)
    800027c2:	fc4e                	sd	s3,56(sp)
    800027c4:	f852                	sd	s4,48(sp)
    800027c6:	f456                	sd	s5,40(sp)
    800027c8:	f05a                	sd	s6,32(sp)
    800027ca:	ec5e                	sd	s7,24(sp)
    800027cc:	e862                	sd	s8,16(sp)
    800027ce:	e466                	sd	s9,8(sp)
    800027d0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027d2:	00015797          	auipc	a5,0x15
    800027d6:	d8a7a783          	lw	a5,-630(a5) # 8001755c <sb+0x4>
    800027da:	cbc1                	beqz	a5,8000286a <balloc+0xb2>
    800027dc:	8baa                	mv	s7,a0
    800027de:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027e0:	00015b17          	auipc	s6,0x15
    800027e4:	d78b0b13          	addi	s6,s6,-648 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027e8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027ea:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027ec:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027ee:	6c89                	lui	s9,0x2
    800027f0:	a831                	j	8000280c <balloc+0x54>
    brelse(bp);
    800027f2:	854a                	mv	a0,s2
    800027f4:	00000097          	auipc	ra,0x0
    800027f8:	e32080e7          	jalr	-462(ra) # 80002626 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027fc:	015c87bb          	addw	a5,s9,s5
    80002800:	00078a9b          	sext.w	s5,a5
    80002804:	004b2703          	lw	a4,4(s6)
    80002808:	06eaf163          	bgeu	s5,a4,8000286a <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000280c:	41fad79b          	sraiw	a5,s5,0x1f
    80002810:	0137d79b          	srliw	a5,a5,0x13
    80002814:	015787bb          	addw	a5,a5,s5
    80002818:	40d7d79b          	sraiw	a5,a5,0xd
    8000281c:	01cb2583          	lw	a1,28(s6)
    80002820:	9dbd                	addw	a1,a1,a5
    80002822:	855e                	mv	a0,s7
    80002824:	00000097          	auipc	ra,0x0
    80002828:	cd2080e7          	jalr	-814(ra) # 800024f6 <bread>
    8000282c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000282e:	004b2503          	lw	a0,4(s6)
    80002832:	000a849b          	sext.w	s1,s5
    80002836:	8762                	mv	a4,s8
    80002838:	faa4fde3          	bgeu	s1,a0,800027f2 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000283c:	00777693          	andi	a3,a4,7
    80002840:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002844:	41f7579b          	sraiw	a5,a4,0x1f
    80002848:	01d7d79b          	srliw	a5,a5,0x1d
    8000284c:	9fb9                	addw	a5,a5,a4
    8000284e:	4037d79b          	sraiw	a5,a5,0x3
    80002852:	00f90633          	add	a2,s2,a5
    80002856:	05864603          	lbu	a2,88(a2)
    8000285a:	00c6f5b3          	and	a1,a3,a2
    8000285e:	cd91                	beqz	a1,8000287a <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002860:	2705                	addiw	a4,a4,1
    80002862:	2485                	addiw	s1,s1,1
    80002864:	fd471ae3          	bne	a4,s4,80002838 <balloc+0x80>
    80002868:	b769                	j	800027f2 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000286a:	00006517          	auipc	a0,0x6
    8000286e:	d0650513          	addi	a0,a0,-762 # 80008570 <syscalls+0x148>
    80002872:	00003097          	auipc	ra,0x3
    80002876:	50e080e7          	jalr	1294(ra) # 80005d80 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000287a:	97ca                	add	a5,a5,s2
    8000287c:	8e55                	or	a2,a2,a3
    8000287e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002882:	854a                	mv	a0,s2
    80002884:	00001097          	auipc	ra,0x1
    80002888:	026080e7          	jalr	38(ra) # 800038aa <log_write>
        brelse(bp);
    8000288c:	854a                	mv	a0,s2
    8000288e:	00000097          	auipc	ra,0x0
    80002892:	d98080e7          	jalr	-616(ra) # 80002626 <brelse>
  bp = bread(dev, bno);
    80002896:	85a6                	mv	a1,s1
    80002898:	855e                	mv	a0,s7
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	c5c080e7          	jalr	-932(ra) # 800024f6 <bread>
    800028a2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028a4:	40000613          	li	a2,1024
    800028a8:	4581                	li	a1,0
    800028aa:	05850513          	addi	a0,a0,88
    800028ae:	ffffe097          	auipc	ra,0xffffe
    800028b2:	8cc080e7          	jalr	-1844(ra) # 8000017a <memset>
  log_write(bp);
    800028b6:	854a                	mv	a0,s2
    800028b8:	00001097          	auipc	ra,0x1
    800028bc:	ff2080e7          	jalr	-14(ra) # 800038aa <log_write>
  brelse(bp);
    800028c0:	854a                	mv	a0,s2
    800028c2:	00000097          	auipc	ra,0x0
    800028c6:	d64080e7          	jalr	-668(ra) # 80002626 <brelse>
}
    800028ca:	8526                	mv	a0,s1
    800028cc:	60e6                	ld	ra,88(sp)
    800028ce:	6446                	ld	s0,80(sp)
    800028d0:	64a6                	ld	s1,72(sp)
    800028d2:	6906                	ld	s2,64(sp)
    800028d4:	79e2                	ld	s3,56(sp)
    800028d6:	7a42                	ld	s4,48(sp)
    800028d8:	7aa2                	ld	s5,40(sp)
    800028da:	7b02                	ld	s6,32(sp)
    800028dc:	6be2                	ld	s7,24(sp)
    800028de:	6c42                	ld	s8,16(sp)
    800028e0:	6ca2                	ld	s9,8(sp)
    800028e2:	6125                	addi	sp,sp,96
    800028e4:	8082                	ret

00000000800028e6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028e6:	7179                	addi	sp,sp,-48
    800028e8:	f406                	sd	ra,40(sp)
    800028ea:	f022                	sd	s0,32(sp)
    800028ec:	ec26                	sd	s1,24(sp)
    800028ee:	e84a                	sd	s2,16(sp)
    800028f0:	e44e                	sd	s3,8(sp)
    800028f2:	e052                	sd	s4,0(sp)
    800028f4:	1800                	addi	s0,sp,48
    800028f6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028f8:	47ad                	li	a5,11
    800028fa:	04b7fe63          	bgeu	a5,a1,80002956 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028fe:	ff45849b          	addiw	s1,a1,-12
    80002902:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002906:	0ff00793          	li	a5,255
    8000290a:	0ae7e463          	bltu	a5,a4,800029b2 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000290e:	08052583          	lw	a1,128(a0)
    80002912:	c5b5                	beqz	a1,8000297e <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002914:	00092503          	lw	a0,0(s2)
    80002918:	00000097          	auipc	ra,0x0
    8000291c:	bde080e7          	jalr	-1058(ra) # 800024f6 <bread>
    80002920:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002922:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002926:	02049713          	slli	a4,s1,0x20
    8000292a:	01e75593          	srli	a1,a4,0x1e
    8000292e:	00b784b3          	add	s1,a5,a1
    80002932:	0004a983          	lw	s3,0(s1)
    80002936:	04098e63          	beqz	s3,80002992 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000293a:	8552                	mv	a0,s4
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	cea080e7          	jalr	-790(ra) # 80002626 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002944:	854e                	mv	a0,s3
    80002946:	70a2                	ld	ra,40(sp)
    80002948:	7402                	ld	s0,32(sp)
    8000294a:	64e2                	ld	s1,24(sp)
    8000294c:	6942                	ld	s2,16(sp)
    8000294e:	69a2                	ld	s3,8(sp)
    80002950:	6a02                	ld	s4,0(sp)
    80002952:	6145                	addi	sp,sp,48
    80002954:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002956:	02059793          	slli	a5,a1,0x20
    8000295a:	01e7d593          	srli	a1,a5,0x1e
    8000295e:	00b504b3          	add	s1,a0,a1
    80002962:	0504a983          	lw	s3,80(s1)
    80002966:	fc099fe3          	bnez	s3,80002944 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000296a:	4108                	lw	a0,0(a0)
    8000296c:	00000097          	auipc	ra,0x0
    80002970:	e4c080e7          	jalr	-436(ra) # 800027b8 <balloc>
    80002974:	0005099b          	sext.w	s3,a0
    80002978:	0534a823          	sw	s3,80(s1)
    8000297c:	b7e1                	j	80002944 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000297e:	4108                	lw	a0,0(a0)
    80002980:	00000097          	auipc	ra,0x0
    80002984:	e38080e7          	jalr	-456(ra) # 800027b8 <balloc>
    80002988:	0005059b          	sext.w	a1,a0
    8000298c:	08b92023          	sw	a1,128(s2)
    80002990:	b751                	j	80002914 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002992:	00092503          	lw	a0,0(s2)
    80002996:	00000097          	auipc	ra,0x0
    8000299a:	e22080e7          	jalr	-478(ra) # 800027b8 <balloc>
    8000299e:	0005099b          	sext.w	s3,a0
    800029a2:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029a6:	8552                	mv	a0,s4
    800029a8:	00001097          	auipc	ra,0x1
    800029ac:	f02080e7          	jalr	-254(ra) # 800038aa <log_write>
    800029b0:	b769                	j	8000293a <bmap+0x54>
  panic("bmap: out of range");
    800029b2:	00006517          	auipc	a0,0x6
    800029b6:	bd650513          	addi	a0,a0,-1066 # 80008588 <syscalls+0x160>
    800029ba:	00003097          	auipc	ra,0x3
    800029be:	3c6080e7          	jalr	966(ra) # 80005d80 <panic>

00000000800029c2 <iget>:
{
    800029c2:	7179                	addi	sp,sp,-48
    800029c4:	f406                	sd	ra,40(sp)
    800029c6:	f022                	sd	s0,32(sp)
    800029c8:	ec26                	sd	s1,24(sp)
    800029ca:	e84a                	sd	s2,16(sp)
    800029cc:	e44e                	sd	s3,8(sp)
    800029ce:	e052                	sd	s4,0(sp)
    800029d0:	1800                	addi	s0,sp,48
    800029d2:	89aa                	mv	s3,a0
    800029d4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029d6:	00015517          	auipc	a0,0x15
    800029da:	ba250513          	addi	a0,a0,-1118 # 80017578 <itable>
    800029de:	00004097          	auipc	ra,0x4
    800029e2:	8da080e7          	jalr	-1830(ra) # 800062b8 <acquire>
  empty = 0;
    800029e6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029e8:	00015497          	auipc	s1,0x15
    800029ec:	ba848493          	addi	s1,s1,-1112 # 80017590 <itable+0x18>
    800029f0:	00016697          	auipc	a3,0x16
    800029f4:	63068693          	addi	a3,a3,1584 # 80019020 <log>
    800029f8:	a039                	j	80002a06 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029fa:	02090b63          	beqz	s2,80002a30 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029fe:	08848493          	addi	s1,s1,136
    80002a02:	02d48a63          	beq	s1,a3,80002a36 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a06:	449c                	lw	a5,8(s1)
    80002a08:	fef059e3          	blez	a5,800029fa <iget+0x38>
    80002a0c:	4098                	lw	a4,0(s1)
    80002a0e:	ff3716e3          	bne	a4,s3,800029fa <iget+0x38>
    80002a12:	40d8                	lw	a4,4(s1)
    80002a14:	ff4713e3          	bne	a4,s4,800029fa <iget+0x38>
      ip->ref++;
    80002a18:	2785                	addiw	a5,a5,1
    80002a1a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a1c:	00015517          	auipc	a0,0x15
    80002a20:	b5c50513          	addi	a0,a0,-1188 # 80017578 <itable>
    80002a24:	00004097          	auipc	ra,0x4
    80002a28:	948080e7          	jalr	-1720(ra) # 8000636c <release>
      return ip;
    80002a2c:	8926                	mv	s2,s1
    80002a2e:	a03d                	j	80002a5c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a30:	f7f9                	bnez	a5,800029fe <iget+0x3c>
    80002a32:	8926                	mv	s2,s1
    80002a34:	b7e9                	j	800029fe <iget+0x3c>
  if(empty == 0)
    80002a36:	02090c63          	beqz	s2,80002a6e <iget+0xac>
  ip->dev = dev;
    80002a3a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a3e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a42:	4785                	li	a5,1
    80002a44:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a48:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a4c:	00015517          	auipc	a0,0x15
    80002a50:	b2c50513          	addi	a0,a0,-1236 # 80017578 <itable>
    80002a54:	00004097          	auipc	ra,0x4
    80002a58:	918080e7          	jalr	-1768(ra) # 8000636c <release>
}
    80002a5c:	854a                	mv	a0,s2
    80002a5e:	70a2                	ld	ra,40(sp)
    80002a60:	7402                	ld	s0,32(sp)
    80002a62:	64e2                	ld	s1,24(sp)
    80002a64:	6942                	ld	s2,16(sp)
    80002a66:	69a2                	ld	s3,8(sp)
    80002a68:	6a02                	ld	s4,0(sp)
    80002a6a:	6145                	addi	sp,sp,48
    80002a6c:	8082                	ret
    panic("iget: no inodes");
    80002a6e:	00006517          	auipc	a0,0x6
    80002a72:	b3250513          	addi	a0,a0,-1230 # 800085a0 <syscalls+0x178>
    80002a76:	00003097          	auipc	ra,0x3
    80002a7a:	30a080e7          	jalr	778(ra) # 80005d80 <panic>

0000000080002a7e <fsinit>:
fsinit(int dev) {
    80002a7e:	7179                	addi	sp,sp,-48
    80002a80:	f406                	sd	ra,40(sp)
    80002a82:	f022                	sd	s0,32(sp)
    80002a84:	ec26                	sd	s1,24(sp)
    80002a86:	e84a                	sd	s2,16(sp)
    80002a88:	e44e                	sd	s3,8(sp)
    80002a8a:	1800                	addi	s0,sp,48
    80002a8c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a8e:	4585                	li	a1,1
    80002a90:	00000097          	auipc	ra,0x0
    80002a94:	a66080e7          	jalr	-1434(ra) # 800024f6 <bread>
    80002a98:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a9a:	00015997          	auipc	s3,0x15
    80002a9e:	abe98993          	addi	s3,s3,-1346 # 80017558 <sb>
    80002aa2:	02000613          	li	a2,32
    80002aa6:	05850593          	addi	a1,a0,88
    80002aaa:	854e                	mv	a0,s3
    80002aac:	ffffd097          	auipc	ra,0xffffd
    80002ab0:	72a080e7          	jalr	1834(ra) # 800001d6 <memmove>
  brelse(bp);
    80002ab4:	8526                	mv	a0,s1
    80002ab6:	00000097          	auipc	ra,0x0
    80002aba:	b70080e7          	jalr	-1168(ra) # 80002626 <brelse>
  if(sb.magic != FSMAGIC)
    80002abe:	0009a703          	lw	a4,0(s3)
    80002ac2:	102037b7          	lui	a5,0x10203
    80002ac6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002aca:	02f71263          	bne	a4,a5,80002aee <fsinit+0x70>
  initlog(dev, &sb);
    80002ace:	00015597          	auipc	a1,0x15
    80002ad2:	a8a58593          	addi	a1,a1,-1398 # 80017558 <sb>
    80002ad6:	854a                	mv	a0,s2
    80002ad8:	00001097          	auipc	ra,0x1
    80002adc:	b56080e7          	jalr	-1194(ra) # 8000362e <initlog>
}
    80002ae0:	70a2                	ld	ra,40(sp)
    80002ae2:	7402                	ld	s0,32(sp)
    80002ae4:	64e2                	ld	s1,24(sp)
    80002ae6:	6942                	ld	s2,16(sp)
    80002ae8:	69a2                	ld	s3,8(sp)
    80002aea:	6145                	addi	sp,sp,48
    80002aec:	8082                	ret
    panic("invalid file system");
    80002aee:	00006517          	auipc	a0,0x6
    80002af2:	ac250513          	addi	a0,a0,-1342 # 800085b0 <syscalls+0x188>
    80002af6:	00003097          	auipc	ra,0x3
    80002afa:	28a080e7          	jalr	650(ra) # 80005d80 <panic>

0000000080002afe <iinit>:
{
    80002afe:	7179                	addi	sp,sp,-48
    80002b00:	f406                	sd	ra,40(sp)
    80002b02:	f022                	sd	s0,32(sp)
    80002b04:	ec26                	sd	s1,24(sp)
    80002b06:	e84a                	sd	s2,16(sp)
    80002b08:	e44e                	sd	s3,8(sp)
    80002b0a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b0c:	00006597          	auipc	a1,0x6
    80002b10:	abc58593          	addi	a1,a1,-1348 # 800085c8 <syscalls+0x1a0>
    80002b14:	00015517          	auipc	a0,0x15
    80002b18:	a6450513          	addi	a0,a0,-1436 # 80017578 <itable>
    80002b1c:	00003097          	auipc	ra,0x3
    80002b20:	70c080e7          	jalr	1804(ra) # 80006228 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b24:	00015497          	auipc	s1,0x15
    80002b28:	a7c48493          	addi	s1,s1,-1412 # 800175a0 <itable+0x28>
    80002b2c:	00016997          	auipc	s3,0x16
    80002b30:	50498993          	addi	s3,s3,1284 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b34:	00006917          	auipc	s2,0x6
    80002b38:	a9c90913          	addi	s2,s2,-1380 # 800085d0 <syscalls+0x1a8>
    80002b3c:	85ca                	mv	a1,s2
    80002b3e:	8526                	mv	a0,s1
    80002b40:	00001097          	auipc	ra,0x1
    80002b44:	e4e080e7          	jalr	-434(ra) # 8000398e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b48:	08848493          	addi	s1,s1,136
    80002b4c:	ff3498e3          	bne	s1,s3,80002b3c <iinit+0x3e>
}
    80002b50:	70a2                	ld	ra,40(sp)
    80002b52:	7402                	ld	s0,32(sp)
    80002b54:	64e2                	ld	s1,24(sp)
    80002b56:	6942                	ld	s2,16(sp)
    80002b58:	69a2                	ld	s3,8(sp)
    80002b5a:	6145                	addi	sp,sp,48
    80002b5c:	8082                	ret

0000000080002b5e <ialloc>:
{
    80002b5e:	715d                	addi	sp,sp,-80
    80002b60:	e486                	sd	ra,72(sp)
    80002b62:	e0a2                	sd	s0,64(sp)
    80002b64:	fc26                	sd	s1,56(sp)
    80002b66:	f84a                	sd	s2,48(sp)
    80002b68:	f44e                	sd	s3,40(sp)
    80002b6a:	f052                	sd	s4,32(sp)
    80002b6c:	ec56                	sd	s5,24(sp)
    80002b6e:	e85a                	sd	s6,16(sp)
    80002b70:	e45e                	sd	s7,8(sp)
    80002b72:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b74:	00015717          	auipc	a4,0x15
    80002b78:	9f072703          	lw	a4,-1552(a4) # 80017564 <sb+0xc>
    80002b7c:	4785                	li	a5,1
    80002b7e:	04e7fa63          	bgeu	a5,a4,80002bd2 <ialloc+0x74>
    80002b82:	8aaa                	mv	s5,a0
    80002b84:	8bae                	mv	s7,a1
    80002b86:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b88:	00015a17          	auipc	s4,0x15
    80002b8c:	9d0a0a13          	addi	s4,s4,-1584 # 80017558 <sb>
    80002b90:	00048b1b          	sext.w	s6,s1
    80002b94:	0044d593          	srli	a1,s1,0x4
    80002b98:	018a2783          	lw	a5,24(s4)
    80002b9c:	9dbd                	addw	a1,a1,a5
    80002b9e:	8556                	mv	a0,s5
    80002ba0:	00000097          	auipc	ra,0x0
    80002ba4:	956080e7          	jalr	-1706(ra) # 800024f6 <bread>
    80002ba8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002baa:	05850993          	addi	s3,a0,88
    80002bae:	00f4f793          	andi	a5,s1,15
    80002bb2:	079a                	slli	a5,a5,0x6
    80002bb4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bb6:	00099783          	lh	a5,0(s3)
    80002bba:	c785                	beqz	a5,80002be2 <ialloc+0x84>
    brelse(bp);
    80002bbc:	00000097          	auipc	ra,0x0
    80002bc0:	a6a080e7          	jalr	-1430(ra) # 80002626 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bc4:	0485                	addi	s1,s1,1
    80002bc6:	00ca2703          	lw	a4,12(s4)
    80002bca:	0004879b          	sext.w	a5,s1
    80002bce:	fce7e1e3          	bltu	a5,a4,80002b90 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002bd2:	00006517          	auipc	a0,0x6
    80002bd6:	a0650513          	addi	a0,a0,-1530 # 800085d8 <syscalls+0x1b0>
    80002bda:	00003097          	auipc	ra,0x3
    80002bde:	1a6080e7          	jalr	422(ra) # 80005d80 <panic>
      memset(dip, 0, sizeof(*dip));
    80002be2:	04000613          	li	a2,64
    80002be6:	4581                	li	a1,0
    80002be8:	854e                	mv	a0,s3
    80002bea:	ffffd097          	auipc	ra,0xffffd
    80002bee:	590080e7          	jalr	1424(ra) # 8000017a <memset>
      dip->type = type;
    80002bf2:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bf6:	854a                	mv	a0,s2
    80002bf8:	00001097          	auipc	ra,0x1
    80002bfc:	cb2080e7          	jalr	-846(ra) # 800038aa <log_write>
      brelse(bp);
    80002c00:	854a                	mv	a0,s2
    80002c02:	00000097          	auipc	ra,0x0
    80002c06:	a24080e7          	jalr	-1500(ra) # 80002626 <brelse>
      return iget(dev, inum);
    80002c0a:	85da                	mv	a1,s6
    80002c0c:	8556                	mv	a0,s5
    80002c0e:	00000097          	auipc	ra,0x0
    80002c12:	db4080e7          	jalr	-588(ra) # 800029c2 <iget>
}
    80002c16:	60a6                	ld	ra,72(sp)
    80002c18:	6406                	ld	s0,64(sp)
    80002c1a:	74e2                	ld	s1,56(sp)
    80002c1c:	7942                	ld	s2,48(sp)
    80002c1e:	79a2                	ld	s3,40(sp)
    80002c20:	7a02                	ld	s4,32(sp)
    80002c22:	6ae2                	ld	s5,24(sp)
    80002c24:	6b42                	ld	s6,16(sp)
    80002c26:	6ba2                	ld	s7,8(sp)
    80002c28:	6161                	addi	sp,sp,80
    80002c2a:	8082                	ret

0000000080002c2c <iupdate>:
{
    80002c2c:	1101                	addi	sp,sp,-32
    80002c2e:	ec06                	sd	ra,24(sp)
    80002c30:	e822                	sd	s0,16(sp)
    80002c32:	e426                	sd	s1,8(sp)
    80002c34:	e04a                	sd	s2,0(sp)
    80002c36:	1000                	addi	s0,sp,32
    80002c38:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c3a:	415c                	lw	a5,4(a0)
    80002c3c:	0047d79b          	srliw	a5,a5,0x4
    80002c40:	00015597          	auipc	a1,0x15
    80002c44:	9305a583          	lw	a1,-1744(a1) # 80017570 <sb+0x18>
    80002c48:	9dbd                	addw	a1,a1,a5
    80002c4a:	4108                	lw	a0,0(a0)
    80002c4c:	00000097          	auipc	ra,0x0
    80002c50:	8aa080e7          	jalr	-1878(ra) # 800024f6 <bread>
    80002c54:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c56:	05850793          	addi	a5,a0,88
    80002c5a:	40d8                	lw	a4,4(s1)
    80002c5c:	8b3d                	andi	a4,a4,15
    80002c5e:	071a                	slli	a4,a4,0x6
    80002c60:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c62:	04449703          	lh	a4,68(s1)
    80002c66:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c6a:	04649703          	lh	a4,70(s1)
    80002c6e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c72:	04849703          	lh	a4,72(s1)
    80002c76:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c7a:	04a49703          	lh	a4,74(s1)
    80002c7e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c82:	44f8                	lw	a4,76(s1)
    80002c84:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c86:	03400613          	li	a2,52
    80002c8a:	05048593          	addi	a1,s1,80
    80002c8e:	00c78513          	addi	a0,a5,12
    80002c92:	ffffd097          	auipc	ra,0xffffd
    80002c96:	544080e7          	jalr	1348(ra) # 800001d6 <memmove>
  log_write(bp);
    80002c9a:	854a                	mv	a0,s2
    80002c9c:	00001097          	auipc	ra,0x1
    80002ca0:	c0e080e7          	jalr	-1010(ra) # 800038aa <log_write>
  brelse(bp);
    80002ca4:	854a                	mv	a0,s2
    80002ca6:	00000097          	auipc	ra,0x0
    80002caa:	980080e7          	jalr	-1664(ra) # 80002626 <brelse>
}
    80002cae:	60e2                	ld	ra,24(sp)
    80002cb0:	6442                	ld	s0,16(sp)
    80002cb2:	64a2                	ld	s1,8(sp)
    80002cb4:	6902                	ld	s2,0(sp)
    80002cb6:	6105                	addi	sp,sp,32
    80002cb8:	8082                	ret

0000000080002cba <idup>:
{
    80002cba:	1101                	addi	sp,sp,-32
    80002cbc:	ec06                	sd	ra,24(sp)
    80002cbe:	e822                	sd	s0,16(sp)
    80002cc0:	e426                	sd	s1,8(sp)
    80002cc2:	1000                	addi	s0,sp,32
    80002cc4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cc6:	00015517          	auipc	a0,0x15
    80002cca:	8b250513          	addi	a0,a0,-1870 # 80017578 <itable>
    80002cce:	00003097          	auipc	ra,0x3
    80002cd2:	5ea080e7          	jalr	1514(ra) # 800062b8 <acquire>
  ip->ref++;
    80002cd6:	449c                	lw	a5,8(s1)
    80002cd8:	2785                	addiw	a5,a5,1
    80002cda:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cdc:	00015517          	auipc	a0,0x15
    80002ce0:	89c50513          	addi	a0,a0,-1892 # 80017578 <itable>
    80002ce4:	00003097          	auipc	ra,0x3
    80002ce8:	688080e7          	jalr	1672(ra) # 8000636c <release>
}
    80002cec:	8526                	mv	a0,s1
    80002cee:	60e2                	ld	ra,24(sp)
    80002cf0:	6442                	ld	s0,16(sp)
    80002cf2:	64a2                	ld	s1,8(sp)
    80002cf4:	6105                	addi	sp,sp,32
    80002cf6:	8082                	ret

0000000080002cf8 <ilock>:
{
    80002cf8:	1101                	addi	sp,sp,-32
    80002cfa:	ec06                	sd	ra,24(sp)
    80002cfc:	e822                	sd	s0,16(sp)
    80002cfe:	e426                	sd	s1,8(sp)
    80002d00:	e04a                	sd	s2,0(sp)
    80002d02:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d04:	c115                	beqz	a0,80002d28 <ilock+0x30>
    80002d06:	84aa                	mv	s1,a0
    80002d08:	451c                	lw	a5,8(a0)
    80002d0a:	00f05f63          	blez	a5,80002d28 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d0e:	0541                	addi	a0,a0,16
    80002d10:	00001097          	auipc	ra,0x1
    80002d14:	cb8080e7          	jalr	-840(ra) # 800039c8 <acquiresleep>
  if(ip->valid == 0){
    80002d18:	40bc                	lw	a5,64(s1)
    80002d1a:	cf99                	beqz	a5,80002d38 <ilock+0x40>
}
    80002d1c:	60e2                	ld	ra,24(sp)
    80002d1e:	6442                	ld	s0,16(sp)
    80002d20:	64a2                	ld	s1,8(sp)
    80002d22:	6902                	ld	s2,0(sp)
    80002d24:	6105                	addi	sp,sp,32
    80002d26:	8082                	ret
    panic("ilock");
    80002d28:	00006517          	auipc	a0,0x6
    80002d2c:	8c850513          	addi	a0,a0,-1848 # 800085f0 <syscalls+0x1c8>
    80002d30:	00003097          	auipc	ra,0x3
    80002d34:	050080e7          	jalr	80(ra) # 80005d80 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d38:	40dc                	lw	a5,4(s1)
    80002d3a:	0047d79b          	srliw	a5,a5,0x4
    80002d3e:	00015597          	auipc	a1,0x15
    80002d42:	8325a583          	lw	a1,-1998(a1) # 80017570 <sb+0x18>
    80002d46:	9dbd                	addw	a1,a1,a5
    80002d48:	4088                	lw	a0,0(s1)
    80002d4a:	fffff097          	auipc	ra,0xfffff
    80002d4e:	7ac080e7          	jalr	1964(ra) # 800024f6 <bread>
    80002d52:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d54:	05850593          	addi	a1,a0,88
    80002d58:	40dc                	lw	a5,4(s1)
    80002d5a:	8bbd                	andi	a5,a5,15
    80002d5c:	079a                	slli	a5,a5,0x6
    80002d5e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d60:	00059783          	lh	a5,0(a1)
    80002d64:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d68:	00259783          	lh	a5,2(a1)
    80002d6c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d70:	00459783          	lh	a5,4(a1)
    80002d74:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d78:	00659783          	lh	a5,6(a1)
    80002d7c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d80:	459c                	lw	a5,8(a1)
    80002d82:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d84:	03400613          	li	a2,52
    80002d88:	05b1                	addi	a1,a1,12
    80002d8a:	05048513          	addi	a0,s1,80
    80002d8e:	ffffd097          	auipc	ra,0xffffd
    80002d92:	448080e7          	jalr	1096(ra) # 800001d6 <memmove>
    brelse(bp);
    80002d96:	854a                	mv	a0,s2
    80002d98:	00000097          	auipc	ra,0x0
    80002d9c:	88e080e7          	jalr	-1906(ra) # 80002626 <brelse>
    ip->valid = 1;
    80002da0:	4785                	li	a5,1
    80002da2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002da4:	04449783          	lh	a5,68(s1)
    80002da8:	fbb5                	bnez	a5,80002d1c <ilock+0x24>
      panic("ilock: no type");
    80002daa:	00006517          	auipc	a0,0x6
    80002dae:	84e50513          	addi	a0,a0,-1970 # 800085f8 <syscalls+0x1d0>
    80002db2:	00003097          	auipc	ra,0x3
    80002db6:	fce080e7          	jalr	-50(ra) # 80005d80 <panic>

0000000080002dba <iunlock>:
{
    80002dba:	1101                	addi	sp,sp,-32
    80002dbc:	ec06                	sd	ra,24(sp)
    80002dbe:	e822                	sd	s0,16(sp)
    80002dc0:	e426                	sd	s1,8(sp)
    80002dc2:	e04a                	sd	s2,0(sp)
    80002dc4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dc6:	c905                	beqz	a0,80002df6 <iunlock+0x3c>
    80002dc8:	84aa                	mv	s1,a0
    80002dca:	01050913          	addi	s2,a0,16
    80002dce:	854a                	mv	a0,s2
    80002dd0:	00001097          	auipc	ra,0x1
    80002dd4:	c92080e7          	jalr	-878(ra) # 80003a62 <holdingsleep>
    80002dd8:	cd19                	beqz	a0,80002df6 <iunlock+0x3c>
    80002dda:	449c                	lw	a5,8(s1)
    80002ddc:	00f05d63          	blez	a5,80002df6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002de0:	854a                	mv	a0,s2
    80002de2:	00001097          	auipc	ra,0x1
    80002de6:	c3c080e7          	jalr	-964(ra) # 80003a1e <releasesleep>
}
    80002dea:	60e2                	ld	ra,24(sp)
    80002dec:	6442                	ld	s0,16(sp)
    80002dee:	64a2                	ld	s1,8(sp)
    80002df0:	6902                	ld	s2,0(sp)
    80002df2:	6105                	addi	sp,sp,32
    80002df4:	8082                	ret
    panic("iunlock");
    80002df6:	00006517          	auipc	a0,0x6
    80002dfa:	81250513          	addi	a0,a0,-2030 # 80008608 <syscalls+0x1e0>
    80002dfe:	00003097          	auipc	ra,0x3
    80002e02:	f82080e7          	jalr	-126(ra) # 80005d80 <panic>

0000000080002e06 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e06:	7179                	addi	sp,sp,-48
    80002e08:	f406                	sd	ra,40(sp)
    80002e0a:	f022                	sd	s0,32(sp)
    80002e0c:	ec26                	sd	s1,24(sp)
    80002e0e:	e84a                	sd	s2,16(sp)
    80002e10:	e44e                	sd	s3,8(sp)
    80002e12:	e052                	sd	s4,0(sp)
    80002e14:	1800                	addi	s0,sp,48
    80002e16:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e18:	05050493          	addi	s1,a0,80
    80002e1c:	08050913          	addi	s2,a0,128
    80002e20:	a021                	j	80002e28 <itrunc+0x22>
    80002e22:	0491                	addi	s1,s1,4
    80002e24:	01248d63          	beq	s1,s2,80002e3e <itrunc+0x38>
    if(ip->addrs[i]){
    80002e28:	408c                	lw	a1,0(s1)
    80002e2a:	dde5                	beqz	a1,80002e22 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e2c:	0009a503          	lw	a0,0(s3)
    80002e30:	00000097          	auipc	ra,0x0
    80002e34:	90c080e7          	jalr	-1780(ra) # 8000273c <bfree>
      ip->addrs[i] = 0;
    80002e38:	0004a023          	sw	zero,0(s1)
    80002e3c:	b7dd                	j	80002e22 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e3e:	0809a583          	lw	a1,128(s3)
    80002e42:	e185                	bnez	a1,80002e62 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e44:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e48:	854e                	mv	a0,s3
    80002e4a:	00000097          	auipc	ra,0x0
    80002e4e:	de2080e7          	jalr	-542(ra) # 80002c2c <iupdate>
}
    80002e52:	70a2                	ld	ra,40(sp)
    80002e54:	7402                	ld	s0,32(sp)
    80002e56:	64e2                	ld	s1,24(sp)
    80002e58:	6942                	ld	s2,16(sp)
    80002e5a:	69a2                	ld	s3,8(sp)
    80002e5c:	6a02                	ld	s4,0(sp)
    80002e5e:	6145                	addi	sp,sp,48
    80002e60:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e62:	0009a503          	lw	a0,0(s3)
    80002e66:	fffff097          	auipc	ra,0xfffff
    80002e6a:	690080e7          	jalr	1680(ra) # 800024f6 <bread>
    80002e6e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e70:	05850493          	addi	s1,a0,88
    80002e74:	45850913          	addi	s2,a0,1112
    80002e78:	a021                	j	80002e80 <itrunc+0x7a>
    80002e7a:	0491                	addi	s1,s1,4
    80002e7c:	01248b63          	beq	s1,s2,80002e92 <itrunc+0x8c>
      if(a[j])
    80002e80:	408c                	lw	a1,0(s1)
    80002e82:	dde5                	beqz	a1,80002e7a <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e84:	0009a503          	lw	a0,0(s3)
    80002e88:	00000097          	auipc	ra,0x0
    80002e8c:	8b4080e7          	jalr	-1868(ra) # 8000273c <bfree>
    80002e90:	b7ed                	j	80002e7a <itrunc+0x74>
    brelse(bp);
    80002e92:	8552                	mv	a0,s4
    80002e94:	fffff097          	auipc	ra,0xfffff
    80002e98:	792080e7          	jalr	1938(ra) # 80002626 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e9c:	0809a583          	lw	a1,128(s3)
    80002ea0:	0009a503          	lw	a0,0(s3)
    80002ea4:	00000097          	auipc	ra,0x0
    80002ea8:	898080e7          	jalr	-1896(ra) # 8000273c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002eac:	0809a023          	sw	zero,128(s3)
    80002eb0:	bf51                	j	80002e44 <itrunc+0x3e>

0000000080002eb2 <iput>:
{
    80002eb2:	1101                	addi	sp,sp,-32
    80002eb4:	ec06                	sd	ra,24(sp)
    80002eb6:	e822                	sd	s0,16(sp)
    80002eb8:	e426                	sd	s1,8(sp)
    80002eba:	e04a                	sd	s2,0(sp)
    80002ebc:	1000                	addi	s0,sp,32
    80002ebe:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ec0:	00014517          	auipc	a0,0x14
    80002ec4:	6b850513          	addi	a0,a0,1720 # 80017578 <itable>
    80002ec8:	00003097          	auipc	ra,0x3
    80002ecc:	3f0080e7          	jalr	1008(ra) # 800062b8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ed0:	4498                	lw	a4,8(s1)
    80002ed2:	4785                	li	a5,1
    80002ed4:	02f70363          	beq	a4,a5,80002efa <iput+0x48>
  ip->ref--;
    80002ed8:	449c                	lw	a5,8(s1)
    80002eda:	37fd                	addiw	a5,a5,-1
    80002edc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ede:	00014517          	auipc	a0,0x14
    80002ee2:	69a50513          	addi	a0,a0,1690 # 80017578 <itable>
    80002ee6:	00003097          	auipc	ra,0x3
    80002eea:	486080e7          	jalr	1158(ra) # 8000636c <release>
}
    80002eee:	60e2                	ld	ra,24(sp)
    80002ef0:	6442                	ld	s0,16(sp)
    80002ef2:	64a2                	ld	s1,8(sp)
    80002ef4:	6902                	ld	s2,0(sp)
    80002ef6:	6105                	addi	sp,sp,32
    80002ef8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002efa:	40bc                	lw	a5,64(s1)
    80002efc:	dff1                	beqz	a5,80002ed8 <iput+0x26>
    80002efe:	04a49783          	lh	a5,74(s1)
    80002f02:	fbf9                	bnez	a5,80002ed8 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f04:	01048913          	addi	s2,s1,16
    80002f08:	854a                	mv	a0,s2
    80002f0a:	00001097          	auipc	ra,0x1
    80002f0e:	abe080e7          	jalr	-1346(ra) # 800039c8 <acquiresleep>
    release(&itable.lock);
    80002f12:	00014517          	auipc	a0,0x14
    80002f16:	66650513          	addi	a0,a0,1638 # 80017578 <itable>
    80002f1a:	00003097          	auipc	ra,0x3
    80002f1e:	452080e7          	jalr	1106(ra) # 8000636c <release>
    itrunc(ip);
    80002f22:	8526                	mv	a0,s1
    80002f24:	00000097          	auipc	ra,0x0
    80002f28:	ee2080e7          	jalr	-286(ra) # 80002e06 <itrunc>
    ip->type = 0;
    80002f2c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f30:	8526                	mv	a0,s1
    80002f32:	00000097          	auipc	ra,0x0
    80002f36:	cfa080e7          	jalr	-774(ra) # 80002c2c <iupdate>
    ip->valid = 0;
    80002f3a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f3e:	854a                	mv	a0,s2
    80002f40:	00001097          	auipc	ra,0x1
    80002f44:	ade080e7          	jalr	-1314(ra) # 80003a1e <releasesleep>
    acquire(&itable.lock);
    80002f48:	00014517          	auipc	a0,0x14
    80002f4c:	63050513          	addi	a0,a0,1584 # 80017578 <itable>
    80002f50:	00003097          	auipc	ra,0x3
    80002f54:	368080e7          	jalr	872(ra) # 800062b8 <acquire>
    80002f58:	b741                	j	80002ed8 <iput+0x26>

0000000080002f5a <iunlockput>:
{
    80002f5a:	1101                	addi	sp,sp,-32
    80002f5c:	ec06                	sd	ra,24(sp)
    80002f5e:	e822                	sd	s0,16(sp)
    80002f60:	e426                	sd	s1,8(sp)
    80002f62:	1000                	addi	s0,sp,32
    80002f64:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	e54080e7          	jalr	-428(ra) # 80002dba <iunlock>
  iput(ip);
    80002f6e:	8526                	mv	a0,s1
    80002f70:	00000097          	auipc	ra,0x0
    80002f74:	f42080e7          	jalr	-190(ra) # 80002eb2 <iput>
}
    80002f78:	60e2                	ld	ra,24(sp)
    80002f7a:	6442                	ld	s0,16(sp)
    80002f7c:	64a2                	ld	s1,8(sp)
    80002f7e:	6105                	addi	sp,sp,32
    80002f80:	8082                	ret

0000000080002f82 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f82:	1141                	addi	sp,sp,-16
    80002f84:	e422                	sd	s0,8(sp)
    80002f86:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f88:	411c                	lw	a5,0(a0)
    80002f8a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f8c:	415c                	lw	a5,4(a0)
    80002f8e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f90:	04451783          	lh	a5,68(a0)
    80002f94:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f98:	04a51783          	lh	a5,74(a0)
    80002f9c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fa0:	04c56783          	lwu	a5,76(a0)
    80002fa4:	e99c                	sd	a5,16(a1)
}
    80002fa6:	6422                	ld	s0,8(sp)
    80002fa8:	0141                	addi	sp,sp,16
    80002faa:	8082                	ret

0000000080002fac <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fac:	457c                	lw	a5,76(a0)
    80002fae:	0ed7e963          	bltu	a5,a3,800030a0 <readi+0xf4>
{
    80002fb2:	7159                	addi	sp,sp,-112
    80002fb4:	f486                	sd	ra,104(sp)
    80002fb6:	f0a2                	sd	s0,96(sp)
    80002fb8:	eca6                	sd	s1,88(sp)
    80002fba:	e8ca                	sd	s2,80(sp)
    80002fbc:	e4ce                	sd	s3,72(sp)
    80002fbe:	e0d2                	sd	s4,64(sp)
    80002fc0:	fc56                	sd	s5,56(sp)
    80002fc2:	f85a                	sd	s6,48(sp)
    80002fc4:	f45e                	sd	s7,40(sp)
    80002fc6:	f062                	sd	s8,32(sp)
    80002fc8:	ec66                	sd	s9,24(sp)
    80002fca:	e86a                	sd	s10,16(sp)
    80002fcc:	e46e                	sd	s11,8(sp)
    80002fce:	1880                	addi	s0,sp,112
    80002fd0:	8baa                	mv	s7,a0
    80002fd2:	8c2e                	mv	s8,a1
    80002fd4:	8ab2                	mv	s5,a2
    80002fd6:	84b6                	mv	s1,a3
    80002fd8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fda:	9f35                	addw	a4,a4,a3
    return 0;
    80002fdc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fde:	0ad76063          	bltu	a4,a3,8000307e <readi+0xd2>
  if(off + n > ip->size)
    80002fe2:	00e7f463          	bgeu	a5,a4,80002fea <readi+0x3e>
    n = ip->size - off;
    80002fe6:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fea:	0a0b0963          	beqz	s6,8000309c <readi+0xf0>
    80002fee:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ff0:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ff4:	5cfd                	li	s9,-1
    80002ff6:	a82d                	j	80003030 <readi+0x84>
    80002ff8:	020a1d93          	slli	s11,s4,0x20
    80002ffc:	020ddd93          	srli	s11,s11,0x20
    80003000:	05890613          	addi	a2,s2,88
    80003004:	86ee                	mv	a3,s11
    80003006:	963a                	add	a2,a2,a4
    80003008:	85d6                	mv	a1,s5
    8000300a:	8562                	mv	a0,s8
    8000300c:	fffff097          	auipc	ra,0xfffff
    80003010:	a58080e7          	jalr	-1448(ra) # 80001a64 <either_copyout>
    80003014:	05950d63          	beq	a0,s9,8000306e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003018:	854a                	mv	a0,s2
    8000301a:	fffff097          	auipc	ra,0xfffff
    8000301e:	60c080e7          	jalr	1548(ra) # 80002626 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003022:	013a09bb          	addw	s3,s4,s3
    80003026:	009a04bb          	addw	s1,s4,s1
    8000302a:	9aee                	add	s5,s5,s11
    8000302c:	0569f763          	bgeu	s3,s6,8000307a <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003030:	000ba903          	lw	s2,0(s7)
    80003034:	00a4d59b          	srliw	a1,s1,0xa
    80003038:	855e                	mv	a0,s7
    8000303a:	00000097          	auipc	ra,0x0
    8000303e:	8ac080e7          	jalr	-1876(ra) # 800028e6 <bmap>
    80003042:	0005059b          	sext.w	a1,a0
    80003046:	854a                	mv	a0,s2
    80003048:	fffff097          	auipc	ra,0xfffff
    8000304c:	4ae080e7          	jalr	1198(ra) # 800024f6 <bread>
    80003050:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003052:	3ff4f713          	andi	a4,s1,1023
    80003056:	40ed07bb          	subw	a5,s10,a4
    8000305a:	413b06bb          	subw	a3,s6,s3
    8000305e:	8a3e                	mv	s4,a5
    80003060:	2781                	sext.w	a5,a5
    80003062:	0006861b          	sext.w	a2,a3
    80003066:	f8f679e3          	bgeu	a2,a5,80002ff8 <readi+0x4c>
    8000306a:	8a36                	mv	s4,a3
    8000306c:	b771                	j	80002ff8 <readi+0x4c>
      brelse(bp);
    8000306e:	854a                	mv	a0,s2
    80003070:	fffff097          	auipc	ra,0xfffff
    80003074:	5b6080e7          	jalr	1462(ra) # 80002626 <brelse>
      tot = -1;
    80003078:	59fd                	li	s3,-1
  }
  return tot;
    8000307a:	0009851b          	sext.w	a0,s3
}
    8000307e:	70a6                	ld	ra,104(sp)
    80003080:	7406                	ld	s0,96(sp)
    80003082:	64e6                	ld	s1,88(sp)
    80003084:	6946                	ld	s2,80(sp)
    80003086:	69a6                	ld	s3,72(sp)
    80003088:	6a06                	ld	s4,64(sp)
    8000308a:	7ae2                	ld	s5,56(sp)
    8000308c:	7b42                	ld	s6,48(sp)
    8000308e:	7ba2                	ld	s7,40(sp)
    80003090:	7c02                	ld	s8,32(sp)
    80003092:	6ce2                	ld	s9,24(sp)
    80003094:	6d42                	ld	s10,16(sp)
    80003096:	6da2                	ld	s11,8(sp)
    80003098:	6165                	addi	sp,sp,112
    8000309a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000309c:	89da                	mv	s3,s6
    8000309e:	bff1                	j	8000307a <readi+0xce>
    return 0;
    800030a0:	4501                	li	a0,0
}
    800030a2:	8082                	ret

00000000800030a4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030a4:	457c                	lw	a5,76(a0)
    800030a6:	10d7e863          	bltu	a5,a3,800031b6 <writei+0x112>
{
    800030aa:	7159                	addi	sp,sp,-112
    800030ac:	f486                	sd	ra,104(sp)
    800030ae:	f0a2                	sd	s0,96(sp)
    800030b0:	eca6                	sd	s1,88(sp)
    800030b2:	e8ca                	sd	s2,80(sp)
    800030b4:	e4ce                	sd	s3,72(sp)
    800030b6:	e0d2                	sd	s4,64(sp)
    800030b8:	fc56                	sd	s5,56(sp)
    800030ba:	f85a                	sd	s6,48(sp)
    800030bc:	f45e                	sd	s7,40(sp)
    800030be:	f062                	sd	s8,32(sp)
    800030c0:	ec66                	sd	s9,24(sp)
    800030c2:	e86a                	sd	s10,16(sp)
    800030c4:	e46e                	sd	s11,8(sp)
    800030c6:	1880                	addi	s0,sp,112
    800030c8:	8b2a                	mv	s6,a0
    800030ca:	8c2e                	mv	s8,a1
    800030cc:	8ab2                	mv	s5,a2
    800030ce:	8936                	mv	s2,a3
    800030d0:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030d2:	00e687bb          	addw	a5,a3,a4
    800030d6:	0ed7e263          	bltu	a5,a3,800031ba <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030da:	00043737          	lui	a4,0x43
    800030de:	0ef76063          	bltu	a4,a5,800031be <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030e2:	0c0b8863          	beqz	s7,800031b2 <writei+0x10e>
    800030e6:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030e8:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030ec:	5cfd                	li	s9,-1
    800030ee:	a091                	j	80003132 <writei+0x8e>
    800030f0:	02099d93          	slli	s11,s3,0x20
    800030f4:	020ddd93          	srli	s11,s11,0x20
    800030f8:	05848513          	addi	a0,s1,88
    800030fc:	86ee                	mv	a3,s11
    800030fe:	8656                	mv	a2,s5
    80003100:	85e2                	mv	a1,s8
    80003102:	953a                	add	a0,a0,a4
    80003104:	fffff097          	auipc	ra,0xfffff
    80003108:	9b6080e7          	jalr	-1610(ra) # 80001aba <either_copyin>
    8000310c:	07950263          	beq	a0,s9,80003170 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003110:	8526                	mv	a0,s1
    80003112:	00000097          	auipc	ra,0x0
    80003116:	798080e7          	jalr	1944(ra) # 800038aa <log_write>
    brelse(bp);
    8000311a:	8526                	mv	a0,s1
    8000311c:	fffff097          	auipc	ra,0xfffff
    80003120:	50a080e7          	jalr	1290(ra) # 80002626 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003124:	01498a3b          	addw	s4,s3,s4
    80003128:	0129893b          	addw	s2,s3,s2
    8000312c:	9aee                	add	s5,s5,s11
    8000312e:	057a7663          	bgeu	s4,s7,8000317a <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003132:	000b2483          	lw	s1,0(s6)
    80003136:	00a9559b          	srliw	a1,s2,0xa
    8000313a:	855a                	mv	a0,s6
    8000313c:	fffff097          	auipc	ra,0xfffff
    80003140:	7aa080e7          	jalr	1962(ra) # 800028e6 <bmap>
    80003144:	0005059b          	sext.w	a1,a0
    80003148:	8526                	mv	a0,s1
    8000314a:	fffff097          	auipc	ra,0xfffff
    8000314e:	3ac080e7          	jalr	940(ra) # 800024f6 <bread>
    80003152:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003154:	3ff97713          	andi	a4,s2,1023
    80003158:	40ed07bb          	subw	a5,s10,a4
    8000315c:	414b86bb          	subw	a3,s7,s4
    80003160:	89be                	mv	s3,a5
    80003162:	2781                	sext.w	a5,a5
    80003164:	0006861b          	sext.w	a2,a3
    80003168:	f8f674e3          	bgeu	a2,a5,800030f0 <writei+0x4c>
    8000316c:	89b6                	mv	s3,a3
    8000316e:	b749                	j	800030f0 <writei+0x4c>
      brelse(bp);
    80003170:	8526                	mv	a0,s1
    80003172:	fffff097          	auipc	ra,0xfffff
    80003176:	4b4080e7          	jalr	1204(ra) # 80002626 <brelse>
  }

  if(off > ip->size)
    8000317a:	04cb2783          	lw	a5,76(s6)
    8000317e:	0127f463          	bgeu	a5,s2,80003186 <writei+0xe2>
    ip->size = off;
    80003182:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003186:	855a                	mv	a0,s6
    80003188:	00000097          	auipc	ra,0x0
    8000318c:	aa4080e7          	jalr	-1372(ra) # 80002c2c <iupdate>

  return tot;
    80003190:	000a051b          	sext.w	a0,s4
}
    80003194:	70a6                	ld	ra,104(sp)
    80003196:	7406                	ld	s0,96(sp)
    80003198:	64e6                	ld	s1,88(sp)
    8000319a:	6946                	ld	s2,80(sp)
    8000319c:	69a6                	ld	s3,72(sp)
    8000319e:	6a06                	ld	s4,64(sp)
    800031a0:	7ae2                	ld	s5,56(sp)
    800031a2:	7b42                	ld	s6,48(sp)
    800031a4:	7ba2                	ld	s7,40(sp)
    800031a6:	7c02                	ld	s8,32(sp)
    800031a8:	6ce2                	ld	s9,24(sp)
    800031aa:	6d42                	ld	s10,16(sp)
    800031ac:	6da2                	ld	s11,8(sp)
    800031ae:	6165                	addi	sp,sp,112
    800031b0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031b2:	8a5e                	mv	s4,s7
    800031b4:	bfc9                	j	80003186 <writei+0xe2>
    return -1;
    800031b6:	557d                	li	a0,-1
}
    800031b8:	8082                	ret
    return -1;
    800031ba:	557d                	li	a0,-1
    800031bc:	bfe1                	j	80003194 <writei+0xf0>
    return -1;
    800031be:	557d                	li	a0,-1
    800031c0:	bfd1                	j	80003194 <writei+0xf0>

00000000800031c2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031c2:	1141                	addi	sp,sp,-16
    800031c4:	e406                	sd	ra,8(sp)
    800031c6:	e022                	sd	s0,0(sp)
    800031c8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031ca:	4639                	li	a2,14
    800031cc:	ffffd097          	auipc	ra,0xffffd
    800031d0:	07e080e7          	jalr	126(ra) # 8000024a <strncmp>
}
    800031d4:	60a2                	ld	ra,8(sp)
    800031d6:	6402                	ld	s0,0(sp)
    800031d8:	0141                	addi	sp,sp,16
    800031da:	8082                	ret

00000000800031dc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031dc:	7139                	addi	sp,sp,-64
    800031de:	fc06                	sd	ra,56(sp)
    800031e0:	f822                	sd	s0,48(sp)
    800031e2:	f426                	sd	s1,40(sp)
    800031e4:	f04a                	sd	s2,32(sp)
    800031e6:	ec4e                	sd	s3,24(sp)
    800031e8:	e852                	sd	s4,16(sp)
    800031ea:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031ec:	04451703          	lh	a4,68(a0)
    800031f0:	4785                	li	a5,1
    800031f2:	00f71a63          	bne	a4,a5,80003206 <dirlookup+0x2a>
    800031f6:	892a                	mv	s2,a0
    800031f8:	89ae                	mv	s3,a1
    800031fa:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031fc:	457c                	lw	a5,76(a0)
    800031fe:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003200:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003202:	e79d                	bnez	a5,80003230 <dirlookup+0x54>
    80003204:	a8a5                	j	8000327c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003206:	00005517          	auipc	a0,0x5
    8000320a:	40a50513          	addi	a0,a0,1034 # 80008610 <syscalls+0x1e8>
    8000320e:	00003097          	auipc	ra,0x3
    80003212:	b72080e7          	jalr	-1166(ra) # 80005d80 <panic>
      panic("dirlookup read");
    80003216:	00005517          	auipc	a0,0x5
    8000321a:	41250513          	addi	a0,a0,1042 # 80008628 <syscalls+0x200>
    8000321e:	00003097          	auipc	ra,0x3
    80003222:	b62080e7          	jalr	-1182(ra) # 80005d80 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003226:	24c1                	addiw	s1,s1,16
    80003228:	04c92783          	lw	a5,76(s2)
    8000322c:	04f4f763          	bgeu	s1,a5,8000327a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003230:	4741                	li	a4,16
    80003232:	86a6                	mv	a3,s1
    80003234:	fc040613          	addi	a2,s0,-64
    80003238:	4581                	li	a1,0
    8000323a:	854a                	mv	a0,s2
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	d70080e7          	jalr	-656(ra) # 80002fac <readi>
    80003244:	47c1                	li	a5,16
    80003246:	fcf518e3          	bne	a0,a5,80003216 <dirlookup+0x3a>
    if(de.inum == 0)
    8000324a:	fc045783          	lhu	a5,-64(s0)
    8000324e:	dfe1                	beqz	a5,80003226 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003250:	fc240593          	addi	a1,s0,-62
    80003254:	854e                	mv	a0,s3
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	f6c080e7          	jalr	-148(ra) # 800031c2 <namecmp>
    8000325e:	f561                	bnez	a0,80003226 <dirlookup+0x4a>
      if(poff)
    80003260:	000a0463          	beqz	s4,80003268 <dirlookup+0x8c>
        *poff = off;
    80003264:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003268:	fc045583          	lhu	a1,-64(s0)
    8000326c:	00092503          	lw	a0,0(s2)
    80003270:	fffff097          	auipc	ra,0xfffff
    80003274:	752080e7          	jalr	1874(ra) # 800029c2 <iget>
    80003278:	a011                	j	8000327c <dirlookup+0xa0>
  return 0;
    8000327a:	4501                	li	a0,0
}
    8000327c:	70e2                	ld	ra,56(sp)
    8000327e:	7442                	ld	s0,48(sp)
    80003280:	74a2                	ld	s1,40(sp)
    80003282:	7902                	ld	s2,32(sp)
    80003284:	69e2                	ld	s3,24(sp)
    80003286:	6a42                	ld	s4,16(sp)
    80003288:	6121                	addi	sp,sp,64
    8000328a:	8082                	ret

000000008000328c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000328c:	711d                	addi	sp,sp,-96
    8000328e:	ec86                	sd	ra,88(sp)
    80003290:	e8a2                	sd	s0,80(sp)
    80003292:	e4a6                	sd	s1,72(sp)
    80003294:	e0ca                	sd	s2,64(sp)
    80003296:	fc4e                	sd	s3,56(sp)
    80003298:	f852                	sd	s4,48(sp)
    8000329a:	f456                	sd	s5,40(sp)
    8000329c:	f05a                	sd	s6,32(sp)
    8000329e:	ec5e                	sd	s7,24(sp)
    800032a0:	e862                	sd	s8,16(sp)
    800032a2:	e466                	sd	s9,8(sp)
    800032a4:	e06a                	sd	s10,0(sp)
    800032a6:	1080                	addi	s0,sp,96
    800032a8:	84aa                	mv	s1,a0
    800032aa:	8b2e                	mv	s6,a1
    800032ac:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032ae:	00054703          	lbu	a4,0(a0)
    800032b2:	02f00793          	li	a5,47
    800032b6:	02f70363          	beq	a4,a5,800032dc <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032ba:	ffffe097          	auipc	ra,0xffffe
    800032be:	c72080e7          	jalr	-910(ra) # 80000f2c <myproc>
    800032c2:	15053503          	ld	a0,336(a0)
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	9f4080e7          	jalr	-1548(ra) # 80002cba <idup>
    800032ce:	8a2a                	mv	s4,a0
  while(*path == '/')
    800032d0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800032d4:	4cb5                	li	s9,13
  len = path - s;
    800032d6:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032d8:	4c05                	li	s8,1
    800032da:	a87d                	j	80003398 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800032dc:	4585                	li	a1,1
    800032de:	4505                	li	a0,1
    800032e0:	fffff097          	auipc	ra,0xfffff
    800032e4:	6e2080e7          	jalr	1762(ra) # 800029c2 <iget>
    800032e8:	8a2a                	mv	s4,a0
    800032ea:	b7dd                	j	800032d0 <namex+0x44>
      iunlockput(ip);
    800032ec:	8552                	mv	a0,s4
    800032ee:	00000097          	auipc	ra,0x0
    800032f2:	c6c080e7          	jalr	-916(ra) # 80002f5a <iunlockput>
      return 0;
    800032f6:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032f8:	8552                	mv	a0,s4
    800032fa:	60e6                	ld	ra,88(sp)
    800032fc:	6446                	ld	s0,80(sp)
    800032fe:	64a6                	ld	s1,72(sp)
    80003300:	6906                	ld	s2,64(sp)
    80003302:	79e2                	ld	s3,56(sp)
    80003304:	7a42                	ld	s4,48(sp)
    80003306:	7aa2                	ld	s5,40(sp)
    80003308:	7b02                	ld	s6,32(sp)
    8000330a:	6be2                	ld	s7,24(sp)
    8000330c:	6c42                	ld	s8,16(sp)
    8000330e:	6ca2                	ld	s9,8(sp)
    80003310:	6d02                	ld	s10,0(sp)
    80003312:	6125                	addi	sp,sp,96
    80003314:	8082                	ret
      iunlock(ip);
    80003316:	8552                	mv	a0,s4
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	aa2080e7          	jalr	-1374(ra) # 80002dba <iunlock>
      return ip;
    80003320:	bfe1                	j	800032f8 <namex+0x6c>
      iunlockput(ip);
    80003322:	8552                	mv	a0,s4
    80003324:	00000097          	auipc	ra,0x0
    80003328:	c36080e7          	jalr	-970(ra) # 80002f5a <iunlockput>
      return 0;
    8000332c:	8a4e                	mv	s4,s3
    8000332e:	b7e9                	j	800032f8 <namex+0x6c>
  len = path - s;
    80003330:	40998633          	sub	a2,s3,s1
    80003334:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003338:	09acd863          	bge	s9,s10,800033c8 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000333c:	4639                	li	a2,14
    8000333e:	85a6                	mv	a1,s1
    80003340:	8556                	mv	a0,s5
    80003342:	ffffd097          	auipc	ra,0xffffd
    80003346:	e94080e7          	jalr	-364(ra) # 800001d6 <memmove>
    8000334a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000334c:	0004c783          	lbu	a5,0(s1)
    80003350:	01279763          	bne	a5,s2,8000335e <namex+0xd2>
    path++;
    80003354:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003356:	0004c783          	lbu	a5,0(s1)
    8000335a:	ff278de3          	beq	a5,s2,80003354 <namex+0xc8>
    ilock(ip);
    8000335e:	8552                	mv	a0,s4
    80003360:	00000097          	auipc	ra,0x0
    80003364:	998080e7          	jalr	-1640(ra) # 80002cf8 <ilock>
    if(ip->type != T_DIR){
    80003368:	044a1783          	lh	a5,68(s4)
    8000336c:	f98790e3          	bne	a5,s8,800032ec <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003370:	000b0563          	beqz	s6,8000337a <namex+0xee>
    80003374:	0004c783          	lbu	a5,0(s1)
    80003378:	dfd9                	beqz	a5,80003316 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000337a:	865e                	mv	a2,s7
    8000337c:	85d6                	mv	a1,s5
    8000337e:	8552                	mv	a0,s4
    80003380:	00000097          	auipc	ra,0x0
    80003384:	e5c080e7          	jalr	-420(ra) # 800031dc <dirlookup>
    80003388:	89aa                	mv	s3,a0
    8000338a:	dd41                	beqz	a0,80003322 <namex+0x96>
    iunlockput(ip);
    8000338c:	8552                	mv	a0,s4
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	bcc080e7          	jalr	-1076(ra) # 80002f5a <iunlockput>
    ip = next;
    80003396:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003398:	0004c783          	lbu	a5,0(s1)
    8000339c:	01279763          	bne	a5,s2,800033aa <namex+0x11e>
    path++;
    800033a0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033a2:	0004c783          	lbu	a5,0(s1)
    800033a6:	ff278de3          	beq	a5,s2,800033a0 <namex+0x114>
  if(*path == 0)
    800033aa:	cb9d                	beqz	a5,800033e0 <namex+0x154>
  while(*path != '/' && *path != 0)
    800033ac:	0004c783          	lbu	a5,0(s1)
    800033b0:	89a6                	mv	s3,s1
  len = path - s;
    800033b2:	8d5e                	mv	s10,s7
    800033b4:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033b6:	01278963          	beq	a5,s2,800033c8 <namex+0x13c>
    800033ba:	dbbd                	beqz	a5,80003330 <namex+0xa4>
    path++;
    800033bc:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033be:	0009c783          	lbu	a5,0(s3)
    800033c2:	ff279ce3          	bne	a5,s2,800033ba <namex+0x12e>
    800033c6:	b7ad                	j	80003330 <namex+0xa4>
    memmove(name, s, len);
    800033c8:	2601                	sext.w	a2,a2
    800033ca:	85a6                	mv	a1,s1
    800033cc:	8556                	mv	a0,s5
    800033ce:	ffffd097          	auipc	ra,0xffffd
    800033d2:	e08080e7          	jalr	-504(ra) # 800001d6 <memmove>
    name[len] = 0;
    800033d6:	9d56                	add	s10,s10,s5
    800033d8:	000d0023          	sb	zero,0(s10)
    800033dc:	84ce                	mv	s1,s3
    800033de:	b7bd                	j	8000334c <namex+0xc0>
  if(nameiparent){
    800033e0:	f00b0ce3          	beqz	s6,800032f8 <namex+0x6c>
    iput(ip);
    800033e4:	8552                	mv	a0,s4
    800033e6:	00000097          	auipc	ra,0x0
    800033ea:	acc080e7          	jalr	-1332(ra) # 80002eb2 <iput>
    return 0;
    800033ee:	4a01                	li	s4,0
    800033f0:	b721                	j	800032f8 <namex+0x6c>

00000000800033f2 <dirlink>:
{
    800033f2:	7139                	addi	sp,sp,-64
    800033f4:	fc06                	sd	ra,56(sp)
    800033f6:	f822                	sd	s0,48(sp)
    800033f8:	f426                	sd	s1,40(sp)
    800033fa:	f04a                	sd	s2,32(sp)
    800033fc:	ec4e                	sd	s3,24(sp)
    800033fe:	e852                	sd	s4,16(sp)
    80003400:	0080                	addi	s0,sp,64
    80003402:	892a                	mv	s2,a0
    80003404:	8a2e                	mv	s4,a1
    80003406:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003408:	4601                	li	a2,0
    8000340a:	00000097          	auipc	ra,0x0
    8000340e:	dd2080e7          	jalr	-558(ra) # 800031dc <dirlookup>
    80003412:	e93d                	bnez	a0,80003488 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003414:	04c92483          	lw	s1,76(s2)
    80003418:	c49d                	beqz	s1,80003446 <dirlink+0x54>
    8000341a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000341c:	4741                	li	a4,16
    8000341e:	86a6                	mv	a3,s1
    80003420:	fc040613          	addi	a2,s0,-64
    80003424:	4581                	li	a1,0
    80003426:	854a                	mv	a0,s2
    80003428:	00000097          	auipc	ra,0x0
    8000342c:	b84080e7          	jalr	-1148(ra) # 80002fac <readi>
    80003430:	47c1                	li	a5,16
    80003432:	06f51163          	bne	a0,a5,80003494 <dirlink+0xa2>
    if(de.inum == 0)
    80003436:	fc045783          	lhu	a5,-64(s0)
    8000343a:	c791                	beqz	a5,80003446 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000343c:	24c1                	addiw	s1,s1,16
    8000343e:	04c92783          	lw	a5,76(s2)
    80003442:	fcf4ede3          	bltu	s1,a5,8000341c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003446:	4639                	li	a2,14
    80003448:	85d2                	mv	a1,s4
    8000344a:	fc240513          	addi	a0,s0,-62
    8000344e:	ffffd097          	auipc	ra,0xffffd
    80003452:	e38080e7          	jalr	-456(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003456:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000345a:	4741                	li	a4,16
    8000345c:	86a6                	mv	a3,s1
    8000345e:	fc040613          	addi	a2,s0,-64
    80003462:	4581                	li	a1,0
    80003464:	854a                	mv	a0,s2
    80003466:	00000097          	auipc	ra,0x0
    8000346a:	c3e080e7          	jalr	-962(ra) # 800030a4 <writei>
    8000346e:	872a                	mv	a4,a0
    80003470:	47c1                	li	a5,16
  return 0;
    80003472:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003474:	02f71863          	bne	a4,a5,800034a4 <dirlink+0xb2>
}
    80003478:	70e2                	ld	ra,56(sp)
    8000347a:	7442                	ld	s0,48(sp)
    8000347c:	74a2                	ld	s1,40(sp)
    8000347e:	7902                	ld	s2,32(sp)
    80003480:	69e2                	ld	s3,24(sp)
    80003482:	6a42                	ld	s4,16(sp)
    80003484:	6121                	addi	sp,sp,64
    80003486:	8082                	ret
    iput(ip);
    80003488:	00000097          	auipc	ra,0x0
    8000348c:	a2a080e7          	jalr	-1494(ra) # 80002eb2 <iput>
    return -1;
    80003490:	557d                	li	a0,-1
    80003492:	b7dd                	j	80003478 <dirlink+0x86>
      panic("dirlink read");
    80003494:	00005517          	auipc	a0,0x5
    80003498:	1a450513          	addi	a0,a0,420 # 80008638 <syscalls+0x210>
    8000349c:	00003097          	auipc	ra,0x3
    800034a0:	8e4080e7          	jalr	-1820(ra) # 80005d80 <panic>
    panic("dirlink");
    800034a4:	00005517          	auipc	a0,0x5
    800034a8:	2a450513          	addi	a0,a0,676 # 80008748 <syscalls+0x320>
    800034ac:	00003097          	auipc	ra,0x3
    800034b0:	8d4080e7          	jalr	-1836(ra) # 80005d80 <panic>

00000000800034b4 <namei>:

struct inode*
namei(char *path)
{
    800034b4:	1101                	addi	sp,sp,-32
    800034b6:	ec06                	sd	ra,24(sp)
    800034b8:	e822                	sd	s0,16(sp)
    800034ba:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034bc:	fe040613          	addi	a2,s0,-32
    800034c0:	4581                	li	a1,0
    800034c2:	00000097          	auipc	ra,0x0
    800034c6:	dca080e7          	jalr	-566(ra) # 8000328c <namex>
}
    800034ca:	60e2                	ld	ra,24(sp)
    800034cc:	6442                	ld	s0,16(sp)
    800034ce:	6105                	addi	sp,sp,32
    800034d0:	8082                	ret

00000000800034d2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034d2:	1141                	addi	sp,sp,-16
    800034d4:	e406                	sd	ra,8(sp)
    800034d6:	e022                	sd	s0,0(sp)
    800034d8:	0800                	addi	s0,sp,16
    800034da:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034dc:	4585                	li	a1,1
    800034de:	00000097          	auipc	ra,0x0
    800034e2:	dae080e7          	jalr	-594(ra) # 8000328c <namex>
}
    800034e6:	60a2                	ld	ra,8(sp)
    800034e8:	6402                	ld	s0,0(sp)
    800034ea:	0141                	addi	sp,sp,16
    800034ec:	8082                	ret

00000000800034ee <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034ee:	1101                	addi	sp,sp,-32
    800034f0:	ec06                	sd	ra,24(sp)
    800034f2:	e822                	sd	s0,16(sp)
    800034f4:	e426                	sd	s1,8(sp)
    800034f6:	e04a                	sd	s2,0(sp)
    800034f8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034fa:	00016917          	auipc	s2,0x16
    800034fe:	b2690913          	addi	s2,s2,-1242 # 80019020 <log>
    80003502:	01892583          	lw	a1,24(s2)
    80003506:	02892503          	lw	a0,40(s2)
    8000350a:	fffff097          	auipc	ra,0xfffff
    8000350e:	fec080e7          	jalr	-20(ra) # 800024f6 <bread>
    80003512:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003514:	02c92683          	lw	a3,44(s2)
    80003518:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000351a:	02d05863          	blez	a3,8000354a <write_head+0x5c>
    8000351e:	00016797          	auipc	a5,0x16
    80003522:	b3278793          	addi	a5,a5,-1230 # 80019050 <log+0x30>
    80003526:	05c50713          	addi	a4,a0,92
    8000352a:	36fd                	addiw	a3,a3,-1
    8000352c:	02069613          	slli	a2,a3,0x20
    80003530:	01e65693          	srli	a3,a2,0x1e
    80003534:	00016617          	auipc	a2,0x16
    80003538:	b2060613          	addi	a2,a2,-1248 # 80019054 <log+0x34>
    8000353c:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000353e:	4390                	lw	a2,0(a5)
    80003540:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003542:	0791                	addi	a5,a5,4
    80003544:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003546:	fed79ce3          	bne	a5,a3,8000353e <write_head+0x50>
  }
  bwrite(buf);
    8000354a:	8526                	mv	a0,s1
    8000354c:	fffff097          	auipc	ra,0xfffff
    80003550:	09c080e7          	jalr	156(ra) # 800025e8 <bwrite>
  brelse(buf);
    80003554:	8526                	mv	a0,s1
    80003556:	fffff097          	auipc	ra,0xfffff
    8000355a:	0d0080e7          	jalr	208(ra) # 80002626 <brelse>
}
    8000355e:	60e2                	ld	ra,24(sp)
    80003560:	6442                	ld	s0,16(sp)
    80003562:	64a2                	ld	s1,8(sp)
    80003564:	6902                	ld	s2,0(sp)
    80003566:	6105                	addi	sp,sp,32
    80003568:	8082                	ret

000000008000356a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000356a:	00016797          	auipc	a5,0x16
    8000356e:	ae27a783          	lw	a5,-1310(a5) # 8001904c <log+0x2c>
    80003572:	0af05d63          	blez	a5,8000362c <install_trans+0xc2>
{
    80003576:	7139                	addi	sp,sp,-64
    80003578:	fc06                	sd	ra,56(sp)
    8000357a:	f822                	sd	s0,48(sp)
    8000357c:	f426                	sd	s1,40(sp)
    8000357e:	f04a                	sd	s2,32(sp)
    80003580:	ec4e                	sd	s3,24(sp)
    80003582:	e852                	sd	s4,16(sp)
    80003584:	e456                	sd	s5,8(sp)
    80003586:	e05a                	sd	s6,0(sp)
    80003588:	0080                	addi	s0,sp,64
    8000358a:	8b2a                	mv	s6,a0
    8000358c:	00016a97          	auipc	s5,0x16
    80003590:	ac4a8a93          	addi	s5,s5,-1340 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003594:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003596:	00016997          	auipc	s3,0x16
    8000359a:	a8a98993          	addi	s3,s3,-1398 # 80019020 <log>
    8000359e:	a00d                	j	800035c0 <install_trans+0x56>
    brelse(lbuf);
    800035a0:	854a                	mv	a0,s2
    800035a2:	fffff097          	auipc	ra,0xfffff
    800035a6:	084080e7          	jalr	132(ra) # 80002626 <brelse>
    brelse(dbuf);
    800035aa:	8526                	mv	a0,s1
    800035ac:	fffff097          	auipc	ra,0xfffff
    800035b0:	07a080e7          	jalr	122(ra) # 80002626 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035b4:	2a05                	addiw	s4,s4,1
    800035b6:	0a91                	addi	s5,s5,4
    800035b8:	02c9a783          	lw	a5,44(s3)
    800035bc:	04fa5e63          	bge	s4,a5,80003618 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035c0:	0189a583          	lw	a1,24(s3)
    800035c4:	014585bb          	addw	a1,a1,s4
    800035c8:	2585                	addiw	a1,a1,1
    800035ca:	0289a503          	lw	a0,40(s3)
    800035ce:	fffff097          	auipc	ra,0xfffff
    800035d2:	f28080e7          	jalr	-216(ra) # 800024f6 <bread>
    800035d6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035d8:	000aa583          	lw	a1,0(s5)
    800035dc:	0289a503          	lw	a0,40(s3)
    800035e0:	fffff097          	auipc	ra,0xfffff
    800035e4:	f16080e7          	jalr	-234(ra) # 800024f6 <bread>
    800035e8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035ea:	40000613          	li	a2,1024
    800035ee:	05890593          	addi	a1,s2,88
    800035f2:	05850513          	addi	a0,a0,88
    800035f6:	ffffd097          	auipc	ra,0xffffd
    800035fa:	be0080e7          	jalr	-1056(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035fe:	8526                	mv	a0,s1
    80003600:	fffff097          	auipc	ra,0xfffff
    80003604:	fe8080e7          	jalr	-24(ra) # 800025e8 <bwrite>
    if(recovering == 0)
    80003608:	f80b1ce3          	bnez	s6,800035a0 <install_trans+0x36>
      bunpin(dbuf);
    8000360c:	8526                	mv	a0,s1
    8000360e:	fffff097          	auipc	ra,0xfffff
    80003612:	0f2080e7          	jalr	242(ra) # 80002700 <bunpin>
    80003616:	b769                	j	800035a0 <install_trans+0x36>
}
    80003618:	70e2                	ld	ra,56(sp)
    8000361a:	7442                	ld	s0,48(sp)
    8000361c:	74a2                	ld	s1,40(sp)
    8000361e:	7902                	ld	s2,32(sp)
    80003620:	69e2                	ld	s3,24(sp)
    80003622:	6a42                	ld	s4,16(sp)
    80003624:	6aa2                	ld	s5,8(sp)
    80003626:	6b02                	ld	s6,0(sp)
    80003628:	6121                	addi	sp,sp,64
    8000362a:	8082                	ret
    8000362c:	8082                	ret

000000008000362e <initlog>:
{
    8000362e:	7179                	addi	sp,sp,-48
    80003630:	f406                	sd	ra,40(sp)
    80003632:	f022                	sd	s0,32(sp)
    80003634:	ec26                	sd	s1,24(sp)
    80003636:	e84a                	sd	s2,16(sp)
    80003638:	e44e                	sd	s3,8(sp)
    8000363a:	1800                	addi	s0,sp,48
    8000363c:	892a                	mv	s2,a0
    8000363e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003640:	00016497          	auipc	s1,0x16
    80003644:	9e048493          	addi	s1,s1,-1568 # 80019020 <log>
    80003648:	00005597          	auipc	a1,0x5
    8000364c:	00058593          	mv	a1,a1
    80003650:	8526                	mv	a0,s1
    80003652:	00003097          	auipc	ra,0x3
    80003656:	bd6080e7          	jalr	-1066(ra) # 80006228 <initlock>
  log.start = sb->logstart;
    8000365a:	0149a583          	lw	a1,20(s3)
    8000365e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003660:	0109a783          	lw	a5,16(s3)
    80003664:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003666:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000366a:	854a                	mv	a0,s2
    8000366c:	fffff097          	auipc	ra,0xfffff
    80003670:	e8a080e7          	jalr	-374(ra) # 800024f6 <bread>
  log.lh.n = lh->n;
    80003674:	4d34                	lw	a3,88(a0)
    80003676:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003678:	02d05663          	blez	a3,800036a4 <initlog+0x76>
    8000367c:	05c50793          	addi	a5,a0,92
    80003680:	00016717          	auipc	a4,0x16
    80003684:	9d070713          	addi	a4,a4,-1584 # 80019050 <log+0x30>
    80003688:	36fd                	addiw	a3,a3,-1
    8000368a:	02069613          	slli	a2,a3,0x20
    8000368e:	01e65693          	srli	a3,a2,0x1e
    80003692:	06050613          	addi	a2,a0,96
    80003696:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003698:	4390                	lw	a2,0(a5)
    8000369a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000369c:	0791                	addi	a5,a5,4
    8000369e:	0711                	addi	a4,a4,4
    800036a0:	fed79ce3          	bne	a5,a3,80003698 <initlog+0x6a>
  brelse(buf);
    800036a4:	fffff097          	auipc	ra,0xfffff
    800036a8:	f82080e7          	jalr	-126(ra) # 80002626 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036ac:	4505                	li	a0,1
    800036ae:	00000097          	auipc	ra,0x0
    800036b2:	ebc080e7          	jalr	-324(ra) # 8000356a <install_trans>
  log.lh.n = 0;
    800036b6:	00016797          	auipc	a5,0x16
    800036ba:	9807ab23          	sw	zero,-1642(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    800036be:	00000097          	auipc	ra,0x0
    800036c2:	e30080e7          	jalr	-464(ra) # 800034ee <write_head>
}
    800036c6:	70a2                	ld	ra,40(sp)
    800036c8:	7402                	ld	s0,32(sp)
    800036ca:	64e2                	ld	s1,24(sp)
    800036cc:	6942                	ld	s2,16(sp)
    800036ce:	69a2                	ld	s3,8(sp)
    800036d0:	6145                	addi	sp,sp,48
    800036d2:	8082                	ret

00000000800036d4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036d4:	1101                	addi	sp,sp,-32
    800036d6:	ec06                	sd	ra,24(sp)
    800036d8:	e822                	sd	s0,16(sp)
    800036da:	e426                	sd	s1,8(sp)
    800036dc:	e04a                	sd	s2,0(sp)
    800036de:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036e0:	00016517          	auipc	a0,0x16
    800036e4:	94050513          	addi	a0,a0,-1728 # 80019020 <log>
    800036e8:	00003097          	auipc	ra,0x3
    800036ec:	bd0080e7          	jalr	-1072(ra) # 800062b8 <acquire>
  while(1){
    if(log.committing){
    800036f0:	00016497          	auipc	s1,0x16
    800036f4:	93048493          	addi	s1,s1,-1744 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036f8:	4979                	li	s2,30
    800036fa:	a039                	j	80003708 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036fc:	85a6                	mv	a1,s1
    800036fe:	8526                	mv	a0,s1
    80003700:	ffffe097          	auipc	ra,0xffffe
    80003704:	fc0080e7          	jalr	-64(ra) # 800016c0 <sleep>
    if(log.committing){
    80003708:	50dc                	lw	a5,36(s1)
    8000370a:	fbed                	bnez	a5,800036fc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000370c:	5098                	lw	a4,32(s1)
    8000370e:	2705                	addiw	a4,a4,1
    80003710:	0007069b          	sext.w	a3,a4
    80003714:	0027179b          	slliw	a5,a4,0x2
    80003718:	9fb9                	addw	a5,a5,a4
    8000371a:	0017979b          	slliw	a5,a5,0x1
    8000371e:	54d8                	lw	a4,44(s1)
    80003720:	9fb9                	addw	a5,a5,a4
    80003722:	00f95963          	bge	s2,a5,80003734 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003726:	85a6                	mv	a1,s1
    80003728:	8526                	mv	a0,s1
    8000372a:	ffffe097          	auipc	ra,0xffffe
    8000372e:	f96080e7          	jalr	-106(ra) # 800016c0 <sleep>
    80003732:	bfd9                	j	80003708 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003734:	00016517          	auipc	a0,0x16
    80003738:	8ec50513          	addi	a0,a0,-1812 # 80019020 <log>
    8000373c:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000373e:	00003097          	auipc	ra,0x3
    80003742:	c2e080e7          	jalr	-978(ra) # 8000636c <release>
      break;
    }
  }
}
    80003746:	60e2                	ld	ra,24(sp)
    80003748:	6442                	ld	s0,16(sp)
    8000374a:	64a2                	ld	s1,8(sp)
    8000374c:	6902                	ld	s2,0(sp)
    8000374e:	6105                	addi	sp,sp,32
    80003750:	8082                	ret

0000000080003752 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003752:	7139                	addi	sp,sp,-64
    80003754:	fc06                	sd	ra,56(sp)
    80003756:	f822                	sd	s0,48(sp)
    80003758:	f426                	sd	s1,40(sp)
    8000375a:	f04a                	sd	s2,32(sp)
    8000375c:	ec4e                	sd	s3,24(sp)
    8000375e:	e852                	sd	s4,16(sp)
    80003760:	e456                	sd	s5,8(sp)
    80003762:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003764:	00016497          	auipc	s1,0x16
    80003768:	8bc48493          	addi	s1,s1,-1860 # 80019020 <log>
    8000376c:	8526                	mv	a0,s1
    8000376e:	00003097          	auipc	ra,0x3
    80003772:	b4a080e7          	jalr	-1206(ra) # 800062b8 <acquire>
  log.outstanding -= 1;
    80003776:	509c                	lw	a5,32(s1)
    80003778:	37fd                	addiw	a5,a5,-1
    8000377a:	0007891b          	sext.w	s2,a5
    8000377e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003780:	50dc                	lw	a5,36(s1)
    80003782:	e7b9                	bnez	a5,800037d0 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003784:	04091e63          	bnez	s2,800037e0 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003788:	00016497          	auipc	s1,0x16
    8000378c:	89848493          	addi	s1,s1,-1896 # 80019020 <log>
    80003790:	4785                	li	a5,1
    80003792:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003794:	8526                	mv	a0,s1
    80003796:	00003097          	auipc	ra,0x3
    8000379a:	bd6080e7          	jalr	-1066(ra) # 8000636c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000379e:	54dc                	lw	a5,44(s1)
    800037a0:	06f04763          	bgtz	a5,8000380e <end_op+0xbc>
    acquire(&log.lock);
    800037a4:	00016497          	auipc	s1,0x16
    800037a8:	87c48493          	addi	s1,s1,-1924 # 80019020 <log>
    800037ac:	8526                	mv	a0,s1
    800037ae:	00003097          	auipc	ra,0x3
    800037b2:	b0a080e7          	jalr	-1270(ra) # 800062b8 <acquire>
    log.committing = 0;
    800037b6:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037ba:	8526                	mv	a0,s1
    800037bc:	ffffe097          	auipc	ra,0xffffe
    800037c0:	090080e7          	jalr	144(ra) # 8000184c <wakeup>
    release(&log.lock);
    800037c4:	8526                	mv	a0,s1
    800037c6:	00003097          	auipc	ra,0x3
    800037ca:	ba6080e7          	jalr	-1114(ra) # 8000636c <release>
}
    800037ce:	a03d                	j	800037fc <end_op+0xaa>
    panic("log.committing");
    800037d0:	00005517          	auipc	a0,0x5
    800037d4:	e8050513          	addi	a0,a0,-384 # 80008650 <syscalls+0x228>
    800037d8:	00002097          	auipc	ra,0x2
    800037dc:	5a8080e7          	jalr	1448(ra) # 80005d80 <panic>
    wakeup(&log);
    800037e0:	00016497          	auipc	s1,0x16
    800037e4:	84048493          	addi	s1,s1,-1984 # 80019020 <log>
    800037e8:	8526                	mv	a0,s1
    800037ea:	ffffe097          	auipc	ra,0xffffe
    800037ee:	062080e7          	jalr	98(ra) # 8000184c <wakeup>
  release(&log.lock);
    800037f2:	8526                	mv	a0,s1
    800037f4:	00003097          	auipc	ra,0x3
    800037f8:	b78080e7          	jalr	-1160(ra) # 8000636c <release>
}
    800037fc:	70e2                	ld	ra,56(sp)
    800037fe:	7442                	ld	s0,48(sp)
    80003800:	74a2                	ld	s1,40(sp)
    80003802:	7902                	ld	s2,32(sp)
    80003804:	69e2                	ld	s3,24(sp)
    80003806:	6a42                	ld	s4,16(sp)
    80003808:	6aa2                	ld	s5,8(sp)
    8000380a:	6121                	addi	sp,sp,64
    8000380c:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000380e:	00016a97          	auipc	s5,0x16
    80003812:	842a8a93          	addi	s5,s5,-1982 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003816:	00016a17          	auipc	s4,0x16
    8000381a:	80aa0a13          	addi	s4,s4,-2038 # 80019020 <log>
    8000381e:	018a2583          	lw	a1,24(s4)
    80003822:	012585bb          	addw	a1,a1,s2
    80003826:	2585                	addiw	a1,a1,1 # ffffffff80008649 <end+0xfffffffefffe2409>
    80003828:	028a2503          	lw	a0,40(s4)
    8000382c:	fffff097          	auipc	ra,0xfffff
    80003830:	cca080e7          	jalr	-822(ra) # 800024f6 <bread>
    80003834:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003836:	000aa583          	lw	a1,0(s5)
    8000383a:	028a2503          	lw	a0,40(s4)
    8000383e:	fffff097          	auipc	ra,0xfffff
    80003842:	cb8080e7          	jalr	-840(ra) # 800024f6 <bread>
    80003846:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003848:	40000613          	li	a2,1024
    8000384c:	05850593          	addi	a1,a0,88
    80003850:	05848513          	addi	a0,s1,88
    80003854:	ffffd097          	auipc	ra,0xffffd
    80003858:	982080e7          	jalr	-1662(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000385c:	8526                	mv	a0,s1
    8000385e:	fffff097          	auipc	ra,0xfffff
    80003862:	d8a080e7          	jalr	-630(ra) # 800025e8 <bwrite>
    brelse(from);
    80003866:	854e                	mv	a0,s3
    80003868:	fffff097          	auipc	ra,0xfffff
    8000386c:	dbe080e7          	jalr	-578(ra) # 80002626 <brelse>
    brelse(to);
    80003870:	8526                	mv	a0,s1
    80003872:	fffff097          	auipc	ra,0xfffff
    80003876:	db4080e7          	jalr	-588(ra) # 80002626 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000387a:	2905                	addiw	s2,s2,1
    8000387c:	0a91                	addi	s5,s5,4
    8000387e:	02ca2783          	lw	a5,44(s4)
    80003882:	f8f94ee3          	blt	s2,a5,8000381e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003886:	00000097          	auipc	ra,0x0
    8000388a:	c68080e7          	jalr	-920(ra) # 800034ee <write_head>
    install_trans(0); // Now install writes to home locations
    8000388e:	4501                	li	a0,0
    80003890:	00000097          	auipc	ra,0x0
    80003894:	cda080e7          	jalr	-806(ra) # 8000356a <install_trans>
    log.lh.n = 0;
    80003898:	00015797          	auipc	a5,0x15
    8000389c:	7a07aa23          	sw	zero,1972(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038a0:	00000097          	auipc	ra,0x0
    800038a4:	c4e080e7          	jalr	-946(ra) # 800034ee <write_head>
    800038a8:	bdf5                	j	800037a4 <end_op+0x52>

00000000800038aa <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038aa:	1101                	addi	sp,sp,-32
    800038ac:	ec06                	sd	ra,24(sp)
    800038ae:	e822                	sd	s0,16(sp)
    800038b0:	e426                	sd	s1,8(sp)
    800038b2:	e04a                	sd	s2,0(sp)
    800038b4:	1000                	addi	s0,sp,32
    800038b6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038b8:	00015917          	auipc	s2,0x15
    800038bc:	76890913          	addi	s2,s2,1896 # 80019020 <log>
    800038c0:	854a                	mv	a0,s2
    800038c2:	00003097          	auipc	ra,0x3
    800038c6:	9f6080e7          	jalr	-1546(ra) # 800062b8 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038ca:	02c92603          	lw	a2,44(s2)
    800038ce:	47f5                	li	a5,29
    800038d0:	06c7c563          	blt	a5,a2,8000393a <log_write+0x90>
    800038d4:	00015797          	auipc	a5,0x15
    800038d8:	7687a783          	lw	a5,1896(a5) # 8001903c <log+0x1c>
    800038dc:	37fd                	addiw	a5,a5,-1
    800038de:	04f65e63          	bge	a2,a5,8000393a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038e2:	00015797          	auipc	a5,0x15
    800038e6:	75e7a783          	lw	a5,1886(a5) # 80019040 <log+0x20>
    800038ea:	06f05063          	blez	a5,8000394a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038ee:	4781                	li	a5,0
    800038f0:	06c05563          	blez	a2,8000395a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038f4:	44cc                	lw	a1,12(s1)
    800038f6:	00015717          	auipc	a4,0x15
    800038fa:	75a70713          	addi	a4,a4,1882 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038fe:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003900:	4314                	lw	a3,0(a4)
    80003902:	04b68c63          	beq	a3,a1,8000395a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003906:	2785                	addiw	a5,a5,1
    80003908:	0711                	addi	a4,a4,4
    8000390a:	fef61be3          	bne	a2,a5,80003900 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000390e:	0621                	addi	a2,a2,8
    80003910:	060a                	slli	a2,a2,0x2
    80003912:	00015797          	auipc	a5,0x15
    80003916:	70e78793          	addi	a5,a5,1806 # 80019020 <log>
    8000391a:	97b2                	add	a5,a5,a2
    8000391c:	44d8                	lw	a4,12(s1)
    8000391e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003920:	8526                	mv	a0,s1
    80003922:	fffff097          	auipc	ra,0xfffff
    80003926:	da2080e7          	jalr	-606(ra) # 800026c4 <bpin>
    log.lh.n++;
    8000392a:	00015717          	auipc	a4,0x15
    8000392e:	6f670713          	addi	a4,a4,1782 # 80019020 <log>
    80003932:	575c                	lw	a5,44(a4)
    80003934:	2785                	addiw	a5,a5,1
    80003936:	d75c                	sw	a5,44(a4)
    80003938:	a82d                	j	80003972 <log_write+0xc8>
    panic("too big a transaction");
    8000393a:	00005517          	auipc	a0,0x5
    8000393e:	d2650513          	addi	a0,a0,-730 # 80008660 <syscalls+0x238>
    80003942:	00002097          	auipc	ra,0x2
    80003946:	43e080e7          	jalr	1086(ra) # 80005d80 <panic>
    panic("log_write outside of trans");
    8000394a:	00005517          	auipc	a0,0x5
    8000394e:	d2e50513          	addi	a0,a0,-722 # 80008678 <syscalls+0x250>
    80003952:	00002097          	auipc	ra,0x2
    80003956:	42e080e7          	jalr	1070(ra) # 80005d80 <panic>
  log.lh.block[i] = b->blockno;
    8000395a:	00878693          	addi	a3,a5,8
    8000395e:	068a                	slli	a3,a3,0x2
    80003960:	00015717          	auipc	a4,0x15
    80003964:	6c070713          	addi	a4,a4,1728 # 80019020 <log>
    80003968:	9736                	add	a4,a4,a3
    8000396a:	44d4                	lw	a3,12(s1)
    8000396c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000396e:	faf609e3          	beq	a2,a5,80003920 <log_write+0x76>
  }
  release(&log.lock);
    80003972:	00015517          	auipc	a0,0x15
    80003976:	6ae50513          	addi	a0,a0,1710 # 80019020 <log>
    8000397a:	00003097          	auipc	ra,0x3
    8000397e:	9f2080e7          	jalr	-1550(ra) # 8000636c <release>
}
    80003982:	60e2                	ld	ra,24(sp)
    80003984:	6442                	ld	s0,16(sp)
    80003986:	64a2                	ld	s1,8(sp)
    80003988:	6902                	ld	s2,0(sp)
    8000398a:	6105                	addi	sp,sp,32
    8000398c:	8082                	ret

000000008000398e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000398e:	1101                	addi	sp,sp,-32
    80003990:	ec06                	sd	ra,24(sp)
    80003992:	e822                	sd	s0,16(sp)
    80003994:	e426                	sd	s1,8(sp)
    80003996:	e04a                	sd	s2,0(sp)
    80003998:	1000                	addi	s0,sp,32
    8000399a:	84aa                	mv	s1,a0
    8000399c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000399e:	00005597          	auipc	a1,0x5
    800039a2:	cfa58593          	addi	a1,a1,-774 # 80008698 <syscalls+0x270>
    800039a6:	0521                	addi	a0,a0,8
    800039a8:	00003097          	auipc	ra,0x3
    800039ac:	880080e7          	jalr	-1920(ra) # 80006228 <initlock>
  lk->name = name;
    800039b0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039b4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039b8:	0204a423          	sw	zero,40(s1)
}
    800039bc:	60e2                	ld	ra,24(sp)
    800039be:	6442                	ld	s0,16(sp)
    800039c0:	64a2                	ld	s1,8(sp)
    800039c2:	6902                	ld	s2,0(sp)
    800039c4:	6105                	addi	sp,sp,32
    800039c6:	8082                	ret

00000000800039c8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039c8:	1101                	addi	sp,sp,-32
    800039ca:	ec06                	sd	ra,24(sp)
    800039cc:	e822                	sd	s0,16(sp)
    800039ce:	e426                	sd	s1,8(sp)
    800039d0:	e04a                	sd	s2,0(sp)
    800039d2:	1000                	addi	s0,sp,32
    800039d4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039d6:	00850913          	addi	s2,a0,8
    800039da:	854a                	mv	a0,s2
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	8dc080e7          	jalr	-1828(ra) # 800062b8 <acquire>
  while (lk->locked) {
    800039e4:	409c                	lw	a5,0(s1)
    800039e6:	cb89                	beqz	a5,800039f8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039e8:	85ca                	mv	a1,s2
    800039ea:	8526                	mv	a0,s1
    800039ec:	ffffe097          	auipc	ra,0xffffe
    800039f0:	cd4080e7          	jalr	-812(ra) # 800016c0 <sleep>
  while (lk->locked) {
    800039f4:	409c                	lw	a5,0(s1)
    800039f6:	fbed                	bnez	a5,800039e8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039f8:	4785                	li	a5,1
    800039fa:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039fc:	ffffd097          	auipc	ra,0xffffd
    80003a00:	530080e7          	jalr	1328(ra) # 80000f2c <myproc>
    80003a04:	591c                	lw	a5,48(a0)
    80003a06:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a08:	854a                	mv	a0,s2
    80003a0a:	00003097          	auipc	ra,0x3
    80003a0e:	962080e7          	jalr	-1694(ra) # 8000636c <release>
}
    80003a12:	60e2                	ld	ra,24(sp)
    80003a14:	6442                	ld	s0,16(sp)
    80003a16:	64a2                	ld	s1,8(sp)
    80003a18:	6902                	ld	s2,0(sp)
    80003a1a:	6105                	addi	sp,sp,32
    80003a1c:	8082                	ret

0000000080003a1e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a1e:	1101                	addi	sp,sp,-32
    80003a20:	ec06                	sd	ra,24(sp)
    80003a22:	e822                	sd	s0,16(sp)
    80003a24:	e426                	sd	s1,8(sp)
    80003a26:	e04a                	sd	s2,0(sp)
    80003a28:	1000                	addi	s0,sp,32
    80003a2a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a2c:	00850913          	addi	s2,a0,8
    80003a30:	854a                	mv	a0,s2
    80003a32:	00003097          	auipc	ra,0x3
    80003a36:	886080e7          	jalr	-1914(ra) # 800062b8 <acquire>
  lk->locked = 0;
    80003a3a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a3e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a42:	8526                	mv	a0,s1
    80003a44:	ffffe097          	auipc	ra,0xffffe
    80003a48:	e08080e7          	jalr	-504(ra) # 8000184c <wakeup>
  release(&lk->lk);
    80003a4c:	854a                	mv	a0,s2
    80003a4e:	00003097          	auipc	ra,0x3
    80003a52:	91e080e7          	jalr	-1762(ra) # 8000636c <release>
}
    80003a56:	60e2                	ld	ra,24(sp)
    80003a58:	6442                	ld	s0,16(sp)
    80003a5a:	64a2                	ld	s1,8(sp)
    80003a5c:	6902                	ld	s2,0(sp)
    80003a5e:	6105                	addi	sp,sp,32
    80003a60:	8082                	ret

0000000080003a62 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a62:	7179                	addi	sp,sp,-48
    80003a64:	f406                	sd	ra,40(sp)
    80003a66:	f022                	sd	s0,32(sp)
    80003a68:	ec26                	sd	s1,24(sp)
    80003a6a:	e84a                	sd	s2,16(sp)
    80003a6c:	e44e                	sd	s3,8(sp)
    80003a6e:	1800                	addi	s0,sp,48
    80003a70:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a72:	00850913          	addi	s2,a0,8
    80003a76:	854a                	mv	a0,s2
    80003a78:	00003097          	auipc	ra,0x3
    80003a7c:	840080e7          	jalr	-1984(ra) # 800062b8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a80:	409c                	lw	a5,0(s1)
    80003a82:	ef99                	bnez	a5,80003aa0 <holdingsleep+0x3e>
    80003a84:	4481                	li	s1,0
  release(&lk->lk);
    80003a86:	854a                	mv	a0,s2
    80003a88:	00003097          	auipc	ra,0x3
    80003a8c:	8e4080e7          	jalr	-1820(ra) # 8000636c <release>
  return r;
}
    80003a90:	8526                	mv	a0,s1
    80003a92:	70a2                	ld	ra,40(sp)
    80003a94:	7402                	ld	s0,32(sp)
    80003a96:	64e2                	ld	s1,24(sp)
    80003a98:	6942                	ld	s2,16(sp)
    80003a9a:	69a2                	ld	s3,8(sp)
    80003a9c:	6145                	addi	sp,sp,48
    80003a9e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aa0:	0284a983          	lw	s3,40(s1)
    80003aa4:	ffffd097          	auipc	ra,0xffffd
    80003aa8:	488080e7          	jalr	1160(ra) # 80000f2c <myproc>
    80003aac:	5904                	lw	s1,48(a0)
    80003aae:	413484b3          	sub	s1,s1,s3
    80003ab2:	0014b493          	seqz	s1,s1
    80003ab6:	bfc1                	j	80003a86 <holdingsleep+0x24>

0000000080003ab8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ab8:	1141                	addi	sp,sp,-16
    80003aba:	e406                	sd	ra,8(sp)
    80003abc:	e022                	sd	s0,0(sp)
    80003abe:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ac0:	00005597          	auipc	a1,0x5
    80003ac4:	be858593          	addi	a1,a1,-1048 # 800086a8 <syscalls+0x280>
    80003ac8:	00015517          	auipc	a0,0x15
    80003acc:	6a050513          	addi	a0,a0,1696 # 80019168 <ftable>
    80003ad0:	00002097          	auipc	ra,0x2
    80003ad4:	758080e7          	jalr	1880(ra) # 80006228 <initlock>
}
    80003ad8:	60a2                	ld	ra,8(sp)
    80003ada:	6402                	ld	s0,0(sp)
    80003adc:	0141                	addi	sp,sp,16
    80003ade:	8082                	ret

0000000080003ae0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ae0:	1101                	addi	sp,sp,-32
    80003ae2:	ec06                	sd	ra,24(sp)
    80003ae4:	e822                	sd	s0,16(sp)
    80003ae6:	e426                	sd	s1,8(sp)
    80003ae8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003aea:	00015517          	auipc	a0,0x15
    80003aee:	67e50513          	addi	a0,a0,1662 # 80019168 <ftable>
    80003af2:	00002097          	auipc	ra,0x2
    80003af6:	7c6080e7          	jalr	1990(ra) # 800062b8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003afa:	00015497          	auipc	s1,0x15
    80003afe:	68648493          	addi	s1,s1,1670 # 80019180 <ftable+0x18>
    80003b02:	00016717          	auipc	a4,0x16
    80003b06:	61e70713          	addi	a4,a4,1566 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003b0a:	40dc                	lw	a5,4(s1)
    80003b0c:	cf99                	beqz	a5,80003b2a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b0e:	02848493          	addi	s1,s1,40
    80003b12:	fee49ce3          	bne	s1,a4,80003b0a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b16:	00015517          	auipc	a0,0x15
    80003b1a:	65250513          	addi	a0,a0,1618 # 80019168 <ftable>
    80003b1e:	00003097          	auipc	ra,0x3
    80003b22:	84e080e7          	jalr	-1970(ra) # 8000636c <release>
  return 0;
    80003b26:	4481                	li	s1,0
    80003b28:	a819                	j	80003b3e <filealloc+0x5e>
      f->ref = 1;
    80003b2a:	4785                	li	a5,1
    80003b2c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b2e:	00015517          	auipc	a0,0x15
    80003b32:	63a50513          	addi	a0,a0,1594 # 80019168 <ftable>
    80003b36:	00003097          	auipc	ra,0x3
    80003b3a:	836080e7          	jalr	-1994(ra) # 8000636c <release>
}
    80003b3e:	8526                	mv	a0,s1
    80003b40:	60e2                	ld	ra,24(sp)
    80003b42:	6442                	ld	s0,16(sp)
    80003b44:	64a2                	ld	s1,8(sp)
    80003b46:	6105                	addi	sp,sp,32
    80003b48:	8082                	ret

0000000080003b4a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b4a:	1101                	addi	sp,sp,-32
    80003b4c:	ec06                	sd	ra,24(sp)
    80003b4e:	e822                	sd	s0,16(sp)
    80003b50:	e426                	sd	s1,8(sp)
    80003b52:	1000                	addi	s0,sp,32
    80003b54:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b56:	00015517          	auipc	a0,0x15
    80003b5a:	61250513          	addi	a0,a0,1554 # 80019168 <ftable>
    80003b5e:	00002097          	auipc	ra,0x2
    80003b62:	75a080e7          	jalr	1882(ra) # 800062b8 <acquire>
  if(f->ref < 1)
    80003b66:	40dc                	lw	a5,4(s1)
    80003b68:	02f05263          	blez	a5,80003b8c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b6c:	2785                	addiw	a5,a5,1
    80003b6e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b70:	00015517          	auipc	a0,0x15
    80003b74:	5f850513          	addi	a0,a0,1528 # 80019168 <ftable>
    80003b78:	00002097          	auipc	ra,0x2
    80003b7c:	7f4080e7          	jalr	2036(ra) # 8000636c <release>
  return f;
}
    80003b80:	8526                	mv	a0,s1
    80003b82:	60e2                	ld	ra,24(sp)
    80003b84:	6442                	ld	s0,16(sp)
    80003b86:	64a2                	ld	s1,8(sp)
    80003b88:	6105                	addi	sp,sp,32
    80003b8a:	8082                	ret
    panic("filedup");
    80003b8c:	00005517          	auipc	a0,0x5
    80003b90:	b2450513          	addi	a0,a0,-1244 # 800086b0 <syscalls+0x288>
    80003b94:	00002097          	auipc	ra,0x2
    80003b98:	1ec080e7          	jalr	492(ra) # 80005d80 <panic>

0000000080003b9c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b9c:	7139                	addi	sp,sp,-64
    80003b9e:	fc06                	sd	ra,56(sp)
    80003ba0:	f822                	sd	s0,48(sp)
    80003ba2:	f426                	sd	s1,40(sp)
    80003ba4:	f04a                	sd	s2,32(sp)
    80003ba6:	ec4e                	sd	s3,24(sp)
    80003ba8:	e852                	sd	s4,16(sp)
    80003baa:	e456                	sd	s5,8(sp)
    80003bac:	0080                	addi	s0,sp,64
    80003bae:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bb0:	00015517          	auipc	a0,0x15
    80003bb4:	5b850513          	addi	a0,a0,1464 # 80019168 <ftable>
    80003bb8:	00002097          	auipc	ra,0x2
    80003bbc:	700080e7          	jalr	1792(ra) # 800062b8 <acquire>
  if(f->ref < 1)
    80003bc0:	40dc                	lw	a5,4(s1)
    80003bc2:	06f05163          	blez	a5,80003c24 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bc6:	37fd                	addiw	a5,a5,-1
    80003bc8:	0007871b          	sext.w	a4,a5
    80003bcc:	c0dc                	sw	a5,4(s1)
    80003bce:	06e04363          	bgtz	a4,80003c34 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bd2:	0004a903          	lw	s2,0(s1)
    80003bd6:	0094ca83          	lbu	s5,9(s1)
    80003bda:	0104ba03          	ld	s4,16(s1)
    80003bde:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003be2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003be6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bea:	00015517          	auipc	a0,0x15
    80003bee:	57e50513          	addi	a0,a0,1406 # 80019168 <ftable>
    80003bf2:	00002097          	auipc	ra,0x2
    80003bf6:	77a080e7          	jalr	1914(ra) # 8000636c <release>

  if(ff.type == FD_PIPE){
    80003bfa:	4785                	li	a5,1
    80003bfc:	04f90d63          	beq	s2,a5,80003c56 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c00:	3979                	addiw	s2,s2,-2
    80003c02:	4785                	li	a5,1
    80003c04:	0527e063          	bltu	a5,s2,80003c44 <fileclose+0xa8>
    begin_op();
    80003c08:	00000097          	auipc	ra,0x0
    80003c0c:	acc080e7          	jalr	-1332(ra) # 800036d4 <begin_op>
    iput(ff.ip);
    80003c10:	854e                	mv	a0,s3
    80003c12:	fffff097          	auipc	ra,0xfffff
    80003c16:	2a0080e7          	jalr	672(ra) # 80002eb2 <iput>
    end_op();
    80003c1a:	00000097          	auipc	ra,0x0
    80003c1e:	b38080e7          	jalr	-1224(ra) # 80003752 <end_op>
    80003c22:	a00d                	j	80003c44 <fileclose+0xa8>
    panic("fileclose");
    80003c24:	00005517          	auipc	a0,0x5
    80003c28:	a9450513          	addi	a0,a0,-1388 # 800086b8 <syscalls+0x290>
    80003c2c:	00002097          	auipc	ra,0x2
    80003c30:	154080e7          	jalr	340(ra) # 80005d80 <panic>
    release(&ftable.lock);
    80003c34:	00015517          	auipc	a0,0x15
    80003c38:	53450513          	addi	a0,a0,1332 # 80019168 <ftable>
    80003c3c:	00002097          	auipc	ra,0x2
    80003c40:	730080e7          	jalr	1840(ra) # 8000636c <release>
  }
}
    80003c44:	70e2                	ld	ra,56(sp)
    80003c46:	7442                	ld	s0,48(sp)
    80003c48:	74a2                	ld	s1,40(sp)
    80003c4a:	7902                	ld	s2,32(sp)
    80003c4c:	69e2                	ld	s3,24(sp)
    80003c4e:	6a42                	ld	s4,16(sp)
    80003c50:	6aa2                	ld	s5,8(sp)
    80003c52:	6121                	addi	sp,sp,64
    80003c54:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c56:	85d6                	mv	a1,s5
    80003c58:	8552                	mv	a0,s4
    80003c5a:	00000097          	auipc	ra,0x0
    80003c5e:	34c080e7          	jalr	844(ra) # 80003fa6 <pipeclose>
    80003c62:	b7cd                	j	80003c44 <fileclose+0xa8>

0000000080003c64 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c64:	715d                	addi	sp,sp,-80
    80003c66:	e486                	sd	ra,72(sp)
    80003c68:	e0a2                	sd	s0,64(sp)
    80003c6a:	fc26                	sd	s1,56(sp)
    80003c6c:	f84a                	sd	s2,48(sp)
    80003c6e:	f44e                	sd	s3,40(sp)
    80003c70:	0880                	addi	s0,sp,80
    80003c72:	84aa                	mv	s1,a0
    80003c74:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c76:	ffffd097          	auipc	ra,0xffffd
    80003c7a:	2b6080e7          	jalr	694(ra) # 80000f2c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c7e:	409c                	lw	a5,0(s1)
    80003c80:	37f9                	addiw	a5,a5,-2
    80003c82:	4705                	li	a4,1
    80003c84:	04f76763          	bltu	a4,a5,80003cd2 <filestat+0x6e>
    80003c88:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c8a:	6c88                	ld	a0,24(s1)
    80003c8c:	fffff097          	auipc	ra,0xfffff
    80003c90:	06c080e7          	jalr	108(ra) # 80002cf8 <ilock>
    stati(f->ip, &st);
    80003c94:	fb840593          	addi	a1,s0,-72
    80003c98:	6c88                	ld	a0,24(s1)
    80003c9a:	fffff097          	auipc	ra,0xfffff
    80003c9e:	2e8080e7          	jalr	744(ra) # 80002f82 <stati>
    iunlock(f->ip);
    80003ca2:	6c88                	ld	a0,24(s1)
    80003ca4:	fffff097          	auipc	ra,0xfffff
    80003ca8:	116080e7          	jalr	278(ra) # 80002dba <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cac:	46e1                	li	a3,24
    80003cae:	fb840613          	addi	a2,s0,-72
    80003cb2:	85ce                	mv	a1,s3
    80003cb4:	05093503          	ld	a0,80(s2)
    80003cb8:	ffffd097          	auipc	ra,0xffffd
    80003cbc:	e50080e7          	jalr	-432(ra) # 80000b08 <copyout>
    80003cc0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cc4:	60a6                	ld	ra,72(sp)
    80003cc6:	6406                	ld	s0,64(sp)
    80003cc8:	74e2                	ld	s1,56(sp)
    80003cca:	7942                	ld	s2,48(sp)
    80003ccc:	79a2                	ld	s3,40(sp)
    80003cce:	6161                	addi	sp,sp,80
    80003cd0:	8082                	ret
  return -1;
    80003cd2:	557d                	li	a0,-1
    80003cd4:	bfc5                	j	80003cc4 <filestat+0x60>

0000000080003cd6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cd6:	7179                	addi	sp,sp,-48
    80003cd8:	f406                	sd	ra,40(sp)
    80003cda:	f022                	sd	s0,32(sp)
    80003cdc:	ec26                	sd	s1,24(sp)
    80003cde:	e84a                	sd	s2,16(sp)
    80003ce0:	e44e                	sd	s3,8(sp)
    80003ce2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ce4:	00854783          	lbu	a5,8(a0)
    80003ce8:	c3d5                	beqz	a5,80003d8c <fileread+0xb6>
    80003cea:	84aa                	mv	s1,a0
    80003cec:	89ae                	mv	s3,a1
    80003cee:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cf0:	411c                	lw	a5,0(a0)
    80003cf2:	4705                	li	a4,1
    80003cf4:	04e78963          	beq	a5,a4,80003d46 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cf8:	470d                	li	a4,3
    80003cfa:	04e78d63          	beq	a5,a4,80003d54 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cfe:	4709                	li	a4,2
    80003d00:	06e79e63          	bne	a5,a4,80003d7c <fileread+0xa6>
    ilock(f->ip);
    80003d04:	6d08                	ld	a0,24(a0)
    80003d06:	fffff097          	auipc	ra,0xfffff
    80003d0a:	ff2080e7          	jalr	-14(ra) # 80002cf8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d0e:	874a                	mv	a4,s2
    80003d10:	5094                	lw	a3,32(s1)
    80003d12:	864e                	mv	a2,s3
    80003d14:	4585                	li	a1,1
    80003d16:	6c88                	ld	a0,24(s1)
    80003d18:	fffff097          	auipc	ra,0xfffff
    80003d1c:	294080e7          	jalr	660(ra) # 80002fac <readi>
    80003d20:	892a                	mv	s2,a0
    80003d22:	00a05563          	blez	a0,80003d2c <fileread+0x56>
      f->off += r;
    80003d26:	509c                	lw	a5,32(s1)
    80003d28:	9fa9                	addw	a5,a5,a0
    80003d2a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d2c:	6c88                	ld	a0,24(s1)
    80003d2e:	fffff097          	auipc	ra,0xfffff
    80003d32:	08c080e7          	jalr	140(ra) # 80002dba <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d36:	854a                	mv	a0,s2
    80003d38:	70a2                	ld	ra,40(sp)
    80003d3a:	7402                	ld	s0,32(sp)
    80003d3c:	64e2                	ld	s1,24(sp)
    80003d3e:	6942                	ld	s2,16(sp)
    80003d40:	69a2                	ld	s3,8(sp)
    80003d42:	6145                	addi	sp,sp,48
    80003d44:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d46:	6908                	ld	a0,16(a0)
    80003d48:	00000097          	auipc	ra,0x0
    80003d4c:	3c0080e7          	jalr	960(ra) # 80004108 <piperead>
    80003d50:	892a                	mv	s2,a0
    80003d52:	b7d5                	j	80003d36 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d54:	02451783          	lh	a5,36(a0)
    80003d58:	03079693          	slli	a3,a5,0x30
    80003d5c:	92c1                	srli	a3,a3,0x30
    80003d5e:	4725                	li	a4,9
    80003d60:	02d76863          	bltu	a4,a3,80003d90 <fileread+0xba>
    80003d64:	0792                	slli	a5,a5,0x4
    80003d66:	00015717          	auipc	a4,0x15
    80003d6a:	36270713          	addi	a4,a4,866 # 800190c8 <devsw>
    80003d6e:	97ba                	add	a5,a5,a4
    80003d70:	639c                	ld	a5,0(a5)
    80003d72:	c38d                	beqz	a5,80003d94 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d74:	4505                	li	a0,1
    80003d76:	9782                	jalr	a5
    80003d78:	892a                	mv	s2,a0
    80003d7a:	bf75                	j	80003d36 <fileread+0x60>
    panic("fileread");
    80003d7c:	00005517          	auipc	a0,0x5
    80003d80:	94c50513          	addi	a0,a0,-1716 # 800086c8 <syscalls+0x2a0>
    80003d84:	00002097          	auipc	ra,0x2
    80003d88:	ffc080e7          	jalr	-4(ra) # 80005d80 <panic>
    return -1;
    80003d8c:	597d                	li	s2,-1
    80003d8e:	b765                	j	80003d36 <fileread+0x60>
      return -1;
    80003d90:	597d                	li	s2,-1
    80003d92:	b755                	j	80003d36 <fileread+0x60>
    80003d94:	597d                	li	s2,-1
    80003d96:	b745                	j	80003d36 <fileread+0x60>

0000000080003d98 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d98:	715d                	addi	sp,sp,-80
    80003d9a:	e486                	sd	ra,72(sp)
    80003d9c:	e0a2                	sd	s0,64(sp)
    80003d9e:	fc26                	sd	s1,56(sp)
    80003da0:	f84a                	sd	s2,48(sp)
    80003da2:	f44e                	sd	s3,40(sp)
    80003da4:	f052                	sd	s4,32(sp)
    80003da6:	ec56                	sd	s5,24(sp)
    80003da8:	e85a                	sd	s6,16(sp)
    80003daa:	e45e                	sd	s7,8(sp)
    80003dac:	e062                	sd	s8,0(sp)
    80003dae:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003db0:	00954783          	lbu	a5,9(a0)
    80003db4:	10078663          	beqz	a5,80003ec0 <filewrite+0x128>
    80003db8:	892a                	mv	s2,a0
    80003dba:	8b2e                	mv	s6,a1
    80003dbc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dbe:	411c                	lw	a5,0(a0)
    80003dc0:	4705                	li	a4,1
    80003dc2:	02e78263          	beq	a5,a4,80003de6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dc6:	470d                	li	a4,3
    80003dc8:	02e78663          	beq	a5,a4,80003df4 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dcc:	4709                	li	a4,2
    80003dce:	0ee79163          	bne	a5,a4,80003eb0 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dd2:	0ac05d63          	blez	a2,80003e8c <filewrite+0xf4>
    int i = 0;
    80003dd6:	4981                	li	s3,0
    80003dd8:	6b85                	lui	s7,0x1
    80003dda:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003dde:	6c05                	lui	s8,0x1
    80003de0:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003de4:	a861                	j	80003e7c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003de6:	6908                	ld	a0,16(a0)
    80003de8:	00000097          	auipc	ra,0x0
    80003dec:	22e080e7          	jalr	558(ra) # 80004016 <pipewrite>
    80003df0:	8a2a                	mv	s4,a0
    80003df2:	a045                	j	80003e92 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003df4:	02451783          	lh	a5,36(a0)
    80003df8:	03079693          	slli	a3,a5,0x30
    80003dfc:	92c1                	srli	a3,a3,0x30
    80003dfe:	4725                	li	a4,9
    80003e00:	0cd76263          	bltu	a4,a3,80003ec4 <filewrite+0x12c>
    80003e04:	0792                	slli	a5,a5,0x4
    80003e06:	00015717          	auipc	a4,0x15
    80003e0a:	2c270713          	addi	a4,a4,706 # 800190c8 <devsw>
    80003e0e:	97ba                	add	a5,a5,a4
    80003e10:	679c                	ld	a5,8(a5)
    80003e12:	cbdd                	beqz	a5,80003ec8 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e14:	4505                	li	a0,1
    80003e16:	9782                	jalr	a5
    80003e18:	8a2a                	mv	s4,a0
    80003e1a:	a8a5                	j	80003e92 <filewrite+0xfa>
    80003e1c:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	8b4080e7          	jalr	-1868(ra) # 800036d4 <begin_op>
      ilock(f->ip);
    80003e28:	01893503          	ld	a0,24(s2)
    80003e2c:	fffff097          	auipc	ra,0xfffff
    80003e30:	ecc080e7          	jalr	-308(ra) # 80002cf8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e34:	8756                	mv	a4,s5
    80003e36:	02092683          	lw	a3,32(s2)
    80003e3a:	01698633          	add	a2,s3,s6
    80003e3e:	4585                	li	a1,1
    80003e40:	01893503          	ld	a0,24(s2)
    80003e44:	fffff097          	auipc	ra,0xfffff
    80003e48:	260080e7          	jalr	608(ra) # 800030a4 <writei>
    80003e4c:	84aa                	mv	s1,a0
    80003e4e:	00a05763          	blez	a0,80003e5c <filewrite+0xc4>
        f->off += r;
    80003e52:	02092783          	lw	a5,32(s2)
    80003e56:	9fa9                	addw	a5,a5,a0
    80003e58:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e5c:	01893503          	ld	a0,24(s2)
    80003e60:	fffff097          	auipc	ra,0xfffff
    80003e64:	f5a080e7          	jalr	-166(ra) # 80002dba <iunlock>
      end_op();
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	8ea080e7          	jalr	-1814(ra) # 80003752 <end_op>

      if(r != n1){
    80003e70:	009a9f63          	bne	s5,s1,80003e8e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e74:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e78:	0149db63          	bge	s3,s4,80003e8e <filewrite+0xf6>
      int n1 = n - i;
    80003e7c:	413a04bb          	subw	s1,s4,s3
    80003e80:	0004879b          	sext.w	a5,s1
    80003e84:	f8fbdce3          	bge	s7,a5,80003e1c <filewrite+0x84>
    80003e88:	84e2                	mv	s1,s8
    80003e8a:	bf49                	j	80003e1c <filewrite+0x84>
    int i = 0;
    80003e8c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e8e:	013a1f63          	bne	s4,s3,80003eac <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e92:	8552                	mv	a0,s4
    80003e94:	60a6                	ld	ra,72(sp)
    80003e96:	6406                	ld	s0,64(sp)
    80003e98:	74e2                	ld	s1,56(sp)
    80003e9a:	7942                	ld	s2,48(sp)
    80003e9c:	79a2                	ld	s3,40(sp)
    80003e9e:	7a02                	ld	s4,32(sp)
    80003ea0:	6ae2                	ld	s5,24(sp)
    80003ea2:	6b42                	ld	s6,16(sp)
    80003ea4:	6ba2                	ld	s7,8(sp)
    80003ea6:	6c02                	ld	s8,0(sp)
    80003ea8:	6161                	addi	sp,sp,80
    80003eaa:	8082                	ret
    ret = (i == n ? n : -1);
    80003eac:	5a7d                	li	s4,-1
    80003eae:	b7d5                	j	80003e92 <filewrite+0xfa>
    panic("filewrite");
    80003eb0:	00005517          	auipc	a0,0x5
    80003eb4:	82850513          	addi	a0,a0,-2008 # 800086d8 <syscalls+0x2b0>
    80003eb8:	00002097          	auipc	ra,0x2
    80003ebc:	ec8080e7          	jalr	-312(ra) # 80005d80 <panic>
    return -1;
    80003ec0:	5a7d                	li	s4,-1
    80003ec2:	bfc1                	j	80003e92 <filewrite+0xfa>
      return -1;
    80003ec4:	5a7d                	li	s4,-1
    80003ec6:	b7f1                	j	80003e92 <filewrite+0xfa>
    80003ec8:	5a7d                	li	s4,-1
    80003eca:	b7e1                	j	80003e92 <filewrite+0xfa>

0000000080003ecc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ecc:	7179                	addi	sp,sp,-48
    80003ece:	f406                	sd	ra,40(sp)
    80003ed0:	f022                	sd	s0,32(sp)
    80003ed2:	ec26                	sd	s1,24(sp)
    80003ed4:	e84a                	sd	s2,16(sp)
    80003ed6:	e44e                	sd	s3,8(sp)
    80003ed8:	e052                	sd	s4,0(sp)
    80003eda:	1800                	addi	s0,sp,48
    80003edc:	84aa                	mv	s1,a0
    80003ede:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ee0:	0005b023          	sd	zero,0(a1)
    80003ee4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ee8:	00000097          	auipc	ra,0x0
    80003eec:	bf8080e7          	jalr	-1032(ra) # 80003ae0 <filealloc>
    80003ef0:	e088                	sd	a0,0(s1)
    80003ef2:	c551                	beqz	a0,80003f7e <pipealloc+0xb2>
    80003ef4:	00000097          	auipc	ra,0x0
    80003ef8:	bec080e7          	jalr	-1044(ra) # 80003ae0 <filealloc>
    80003efc:	00aa3023          	sd	a0,0(s4)
    80003f00:	c92d                	beqz	a0,80003f72 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f02:	ffffc097          	auipc	ra,0xffffc
    80003f06:	218080e7          	jalr	536(ra) # 8000011a <kalloc>
    80003f0a:	892a                	mv	s2,a0
    80003f0c:	c125                	beqz	a0,80003f6c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f0e:	4985                	li	s3,1
    80003f10:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f14:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f18:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f1c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f20:	00004597          	auipc	a1,0x4
    80003f24:	7c858593          	addi	a1,a1,1992 # 800086e8 <syscalls+0x2c0>
    80003f28:	00002097          	auipc	ra,0x2
    80003f2c:	300080e7          	jalr	768(ra) # 80006228 <initlock>
  (*f0)->type = FD_PIPE;
    80003f30:	609c                	ld	a5,0(s1)
    80003f32:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f36:	609c                	ld	a5,0(s1)
    80003f38:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f3c:	609c                	ld	a5,0(s1)
    80003f3e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f42:	609c                	ld	a5,0(s1)
    80003f44:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f48:	000a3783          	ld	a5,0(s4)
    80003f4c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f50:	000a3783          	ld	a5,0(s4)
    80003f54:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f58:	000a3783          	ld	a5,0(s4)
    80003f5c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f60:	000a3783          	ld	a5,0(s4)
    80003f64:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f68:	4501                	li	a0,0
    80003f6a:	a025                	j	80003f92 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f6c:	6088                	ld	a0,0(s1)
    80003f6e:	e501                	bnez	a0,80003f76 <pipealloc+0xaa>
    80003f70:	a039                	j	80003f7e <pipealloc+0xb2>
    80003f72:	6088                	ld	a0,0(s1)
    80003f74:	c51d                	beqz	a0,80003fa2 <pipealloc+0xd6>
    fileclose(*f0);
    80003f76:	00000097          	auipc	ra,0x0
    80003f7a:	c26080e7          	jalr	-986(ra) # 80003b9c <fileclose>
  if(*f1)
    80003f7e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f82:	557d                	li	a0,-1
  if(*f1)
    80003f84:	c799                	beqz	a5,80003f92 <pipealloc+0xc6>
    fileclose(*f1);
    80003f86:	853e                	mv	a0,a5
    80003f88:	00000097          	auipc	ra,0x0
    80003f8c:	c14080e7          	jalr	-1004(ra) # 80003b9c <fileclose>
  return -1;
    80003f90:	557d                	li	a0,-1
}
    80003f92:	70a2                	ld	ra,40(sp)
    80003f94:	7402                	ld	s0,32(sp)
    80003f96:	64e2                	ld	s1,24(sp)
    80003f98:	6942                	ld	s2,16(sp)
    80003f9a:	69a2                	ld	s3,8(sp)
    80003f9c:	6a02                	ld	s4,0(sp)
    80003f9e:	6145                	addi	sp,sp,48
    80003fa0:	8082                	ret
  return -1;
    80003fa2:	557d                	li	a0,-1
    80003fa4:	b7fd                	j	80003f92 <pipealloc+0xc6>

0000000080003fa6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fa6:	1101                	addi	sp,sp,-32
    80003fa8:	ec06                	sd	ra,24(sp)
    80003faa:	e822                	sd	s0,16(sp)
    80003fac:	e426                	sd	s1,8(sp)
    80003fae:	e04a                	sd	s2,0(sp)
    80003fb0:	1000                	addi	s0,sp,32
    80003fb2:	84aa                	mv	s1,a0
    80003fb4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fb6:	00002097          	auipc	ra,0x2
    80003fba:	302080e7          	jalr	770(ra) # 800062b8 <acquire>
  if(writable){
    80003fbe:	02090d63          	beqz	s2,80003ff8 <pipeclose+0x52>
    pi->writeopen = 0;
    80003fc2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fc6:	21848513          	addi	a0,s1,536
    80003fca:	ffffe097          	auipc	ra,0xffffe
    80003fce:	882080e7          	jalr	-1918(ra) # 8000184c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fd2:	2204b783          	ld	a5,544(s1)
    80003fd6:	eb95                	bnez	a5,8000400a <pipeclose+0x64>
    release(&pi->lock);
    80003fd8:	8526                	mv	a0,s1
    80003fda:	00002097          	auipc	ra,0x2
    80003fde:	392080e7          	jalr	914(ra) # 8000636c <release>
    kfree((char*)pi);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	ffffc097          	auipc	ra,0xffffc
    80003fe8:	038080e7          	jalr	56(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fec:	60e2                	ld	ra,24(sp)
    80003fee:	6442                	ld	s0,16(sp)
    80003ff0:	64a2                	ld	s1,8(sp)
    80003ff2:	6902                	ld	s2,0(sp)
    80003ff4:	6105                	addi	sp,sp,32
    80003ff6:	8082                	ret
    pi->readopen = 0;
    80003ff8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ffc:	21c48513          	addi	a0,s1,540
    80004000:	ffffe097          	auipc	ra,0xffffe
    80004004:	84c080e7          	jalr	-1972(ra) # 8000184c <wakeup>
    80004008:	b7e9                	j	80003fd2 <pipeclose+0x2c>
    release(&pi->lock);
    8000400a:	8526                	mv	a0,s1
    8000400c:	00002097          	auipc	ra,0x2
    80004010:	360080e7          	jalr	864(ra) # 8000636c <release>
}
    80004014:	bfe1                	j	80003fec <pipeclose+0x46>

0000000080004016 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004016:	711d                	addi	sp,sp,-96
    80004018:	ec86                	sd	ra,88(sp)
    8000401a:	e8a2                	sd	s0,80(sp)
    8000401c:	e4a6                	sd	s1,72(sp)
    8000401e:	e0ca                	sd	s2,64(sp)
    80004020:	fc4e                	sd	s3,56(sp)
    80004022:	f852                	sd	s4,48(sp)
    80004024:	f456                	sd	s5,40(sp)
    80004026:	f05a                	sd	s6,32(sp)
    80004028:	ec5e                	sd	s7,24(sp)
    8000402a:	e862                	sd	s8,16(sp)
    8000402c:	1080                	addi	s0,sp,96
    8000402e:	84aa                	mv	s1,a0
    80004030:	8aae                	mv	s5,a1
    80004032:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004034:	ffffd097          	auipc	ra,0xffffd
    80004038:	ef8080e7          	jalr	-264(ra) # 80000f2c <myproc>
    8000403c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000403e:	8526                	mv	a0,s1
    80004040:	00002097          	auipc	ra,0x2
    80004044:	278080e7          	jalr	632(ra) # 800062b8 <acquire>
  while(i < n){
    80004048:	0b405363          	blez	s4,800040ee <pipewrite+0xd8>
  int i = 0;
    8000404c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000404e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004050:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004054:	21c48b93          	addi	s7,s1,540
    80004058:	a089                	j	8000409a <pipewrite+0x84>
      release(&pi->lock);
    8000405a:	8526                	mv	a0,s1
    8000405c:	00002097          	auipc	ra,0x2
    80004060:	310080e7          	jalr	784(ra) # 8000636c <release>
      return -1;
    80004064:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004066:	854a                	mv	a0,s2
    80004068:	60e6                	ld	ra,88(sp)
    8000406a:	6446                	ld	s0,80(sp)
    8000406c:	64a6                	ld	s1,72(sp)
    8000406e:	6906                	ld	s2,64(sp)
    80004070:	79e2                	ld	s3,56(sp)
    80004072:	7a42                	ld	s4,48(sp)
    80004074:	7aa2                	ld	s5,40(sp)
    80004076:	7b02                	ld	s6,32(sp)
    80004078:	6be2                	ld	s7,24(sp)
    8000407a:	6c42                	ld	s8,16(sp)
    8000407c:	6125                	addi	sp,sp,96
    8000407e:	8082                	ret
      wakeup(&pi->nread);
    80004080:	8562                	mv	a0,s8
    80004082:	ffffd097          	auipc	ra,0xffffd
    80004086:	7ca080e7          	jalr	1994(ra) # 8000184c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000408a:	85a6                	mv	a1,s1
    8000408c:	855e                	mv	a0,s7
    8000408e:	ffffd097          	auipc	ra,0xffffd
    80004092:	632080e7          	jalr	1586(ra) # 800016c0 <sleep>
  while(i < n){
    80004096:	05495d63          	bge	s2,s4,800040f0 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    8000409a:	2204a783          	lw	a5,544(s1)
    8000409e:	dfd5                	beqz	a5,8000405a <pipewrite+0x44>
    800040a0:	0289a783          	lw	a5,40(s3)
    800040a4:	fbdd                	bnez	a5,8000405a <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040a6:	2184a783          	lw	a5,536(s1)
    800040aa:	21c4a703          	lw	a4,540(s1)
    800040ae:	2007879b          	addiw	a5,a5,512
    800040b2:	fcf707e3          	beq	a4,a5,80004080 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040b6:	4685                	li	a3,1
    800040b8:	01590633          	add	a2,s2,s5
    800040bc:	faf40593          	addi	a1,s0,-81
    800040c0:	0509b503          	ld	a0,80(s3)
    800040c4:	ffffd097          	auipc	ra,0xffffd
    800040c8:	ad0080e7          	jalr	-1328(ra) # 80000b94 <copyin>
    800040cc:	03650263          	beq	a0,s6,800040f0 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040d0:	21c4a783          	lw	a5,540(s1)
    800040d4:	0017871b          	addiw	a4,a5,1
    800040d8:	20e4ae23          	sw	a4,540(s1)
    800040dc:	1ff7f793          	andi	a5,a5,511
    800040e0:	97a6                	add	a5,a5,s1
    800040e2:	faf44703          	lbu	a4,-81(s0)
    800040e6:	00e78c23          	sb	a4,24(a5)
      i++;
    800040ea:	2905                	addiw	s2,s2,1
    800040ec:	b76d                	j	80004096 <pipewrite+0x80>
  int i = 0;
    800040ee:	4901                	li	s2,0
  wakeup(&pi->nread);
    800040f0:	21848513          	addi	a0,s1,536
    800040f4:	ffffd097          	auipc	ra,0xffffd
    800040f8:	758080e7          	jalr	1880(ra) # 8000184c <wakeup>
  release(&pi->lock);
    800040fc:	8526                	mv	a0,s1
    800040fe:	00002097          	auipc	ra,0x2
    80004102:	26e080e7          	jalr	622(ra) # 8000636c <release>
  return i;
    80004106:	b785                	j	80004066 <pipewrite+0x50>

0000000080004108 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004108:	715d                	addi	sp,sp,-80
    8000410a:	e486                	sd	ra,72(sp)
    8000410c:	e0a2                	sd	s0,64(sp)
    8000410e:	fc26                	sd	s1,56(sp)
    80004110:	f84a                	sd	s2,48(sp)
    80004112:	f44e                	sd	s3,40(sp)
    80004114:	f052                	sd	s4,32(sp)
    80004116:	ec56                	sd	s5,24(sp)
    80004118:	e85a                	sd	s6,16(sp)
    8000411a:	0880                	addi	s0,sp,80
    8000411c:	84aa                	mv	s1,a0
    8000411e:	892e                	mv	s2,a1
    80004120:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004122:	ffffd097          	auipc	ra,0xffffd
    80004126:	e0a080e7          	jalr	-502(ra) # 80000f2c <myproc>
    8000412a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000412c:	8526                	mv	a0,s1
    8000412e:	00002097          	auipc	ra,0x2
    80004132:	18a080e7          	jalr	394(ra) # 800062b8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004136:	2184a703          	lw	a4,536(s1)
    8000413a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000413e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004142:	02f71463          	bne	a4,a5,8000416a <piperead+0x62>
    80004146:	2244a783          	lw	a5,548(s1)
    8000414a:	c385                	beqz	a5,8000416a <piperead+0x62>
    if(pr->killed){
    8000414c:	028a2783          	lw	a5,40(s4)
    80004150:	ebc9                	bnez	a5,800041e2 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004152:	85a6                	mv	a1,s1
    80004154:	854e                	mv	a0,s3
    80004156:	ffffd097          	auipc	ra,0xffffd
    8000415a:	56a080e7          	jalr	1386(ra) # 800016c0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000415e:	2184a703          	lw	a4,536(s1)
    80004162:	21c4a783          	lw	a5,540(s1)
    80004166:	fef700e3          	beq	a4,a5,80004146 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000416a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000416c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000416e:	05505463          	blez	s5,800041b6 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004172:	2184a783          	lw	a5,536(s1)
    80004176:	21c4a703          	lw	a4,540(s1)
    8000417a:	02f70e63          	beq	a4,a5,800041b6 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000417e:	0017871b          	addiw	a4,a5,1
    80004182:	20e4ac23          	sw	a4,536(s1)
    80004186:	1ff7f793          	andi	a5,a5,511
    8000418a:	97a6                	add	a5,a5,s1
    8000418c:	0187c783          	lbu	a5,24(a5)
    80004190:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004194:	4685                	li	a3,1
    80004196:	fbf40613          	addi	a2,s0,-65
    8000419a:	85ca                	mv	a1,s2
    8000419c:	050a3503          	ld	a0,80(s4)
    800041a0:	ffffd097          	auipc	ra,0xffffd
    800041a4:	968080e7          	jalr	-1688(ra) # 80000b08 <copyout>
    800041a8:	01650763          	beq	a0,s6,800041b6 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041ac:	2985                	addiw	s3,s3,1
    800041ae:	0905                	addi	s2,s2,1
    800041b0:	fd3a91e3          	bne	s5,s3,80004172 <piperead+0x6a>
    800041b4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041b6:	21c48513          	addi	a0,s1,540
    800041ba:	ffffd097          	auipc	ra,0xffffd
    800041be:	692080e7          	jalr	1682(ra) # 8000184c <wakeup>
  release(&pi->lock);
    800041c2:	8526                	mv	a0,s1
    800041c4:	00002097          	auipc	ra,0x2
    800041c8:	1a8080e7          	jalr	424(ra) # 8000636c <release>
  return i;
}
    800041cc:	854e                	mv	a0,s3
    800041ce:	60a6                	ld	ra,72(sp)
    800041d0:	6406                	ld	s0,64(sp)
    800041d2:	74e2                	ld	s1,56(sp)
    800041d4:	7942                	ld	s2,48(sp)
    800041d6:	79a2                	ld	s3,40(sp)
    800041d8:	7a02                	ld	s4,32(sp)
    800041da:	6ae2                	ld	s5,24(sp)
    800041dc:	6b42                	ld	s6,16(sp)
    800041de:	6161                	addi	sp,sp,80
    800041e0:	8082                	ret
      release(&pi->lock);
    800041e2:	8526                	mv	a0,s1
    800041e4:	00002097          	auipc	ra,0x2
    800041e8:	188080e7          	jalr	392(ra) # 8000636c <release>
      return -1;
    800041ec:	59fd                	li	s3,-1
    800041ee:	bff9                	j	800041cc <piperead+0xc4>

00000000800041f0 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041f0:	de010113          	addi	sp,sp,-544
    800041f4:	20113c23          	sd	ra,536(sp)
    800041f8:	20813823          	sd	s0,528(sp)
    800041fc:	20913423          	sd	s1,520(sp)
    80004200:	21213023          	sd	s2,512(sp)
    80004204:	ffce                	sd	s3,504(sp)
    80004206:	fbd2                	sd	s4,496(sp)
    80004208:	f7d6                	sd	s5,488(sp)
    8000420a:	f3da                	sd	s6,480(sp)
    8000420c:	efde                	sd	s7,472(sp)
    8000420e:	ebe2                	sd	s8,464(sp)
    80004210:	e7e6                	sd	s9,456(sp)
    80004212:	e3ea                	sd	s10,448(sp)
    80004214:	ff6e                	sd	s11,440(sp)
    80004216:	1400                	addi	s0,sp,544
    80004218:	892a                	mv	s2,a0
    8000421a:	dea43423          	sd	a0,-536(s0)
    8000421e:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004222:	ffffd097          	auipc	ra,0xffffd
    80004226:	d0a080e7          	jalr	-758(ra) # 80000f2c <myproc>
    8000422a:	84aa                	mv	s1,a0

  begin_op();
    8000422c:	fffff097          	auipc	ra,0xfffff
    80004230:	4a8080e7          	jalr	1192(ra) # 800036d4 <begin_op>

  if((ip = namei(path)) == 0){
    80004234:	854a                	mv	a0,s2
    80004236:	fffff097          	auipc	ra,0xfffff
    8000423a:	27e080e7          	jalr	638(ra) # 800034b4 <namei>
    8000423e:	c93d                	beqz	a0,800042b4 <exec+0xc4>
    80004240:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004242:	fffff097          	auipc	ra,0xfffff
    80004246:	ab6080e7          	jalr	-1354(ra) # 80002cf8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000424a:	04000713          	li	a4,64
    8000424e:	4681                	li	a3,0
    80004250:	e5040613          	addi	a2,s0,-432
    80004254:	4581                	li	a1,0
    80004256:	8556                	mv	a0,s5
    80004258:	fffff097          	auipc	ra,0xfffff
    8000425c:	d54080e7          	jalr	-684(ra) # 80002fac <readi>
    80004260:	04000793          	li	a5,64
    80004264:	00f51a63          	bne	a0,a5,80004278 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004268:	e5042703          	lw	a4,-432(s0)
    8000426c:	464c47b7          	lui	a5,0x464c4
    80004270:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004274:	04f70663          	beq	a4,a5,800042c0 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004278:	8556                	mv	a0,s5
    8000427a:	fffff097          	auipc	ra,0xfffff
    8000427e:	ce0080e7          	jalr	-800(ra) # 80002f5a <iunlockput>
    end_op();
    80004282:	fffff097          	auipc	ra,0xfffff
    80004286:	4d0080e7          	jalr	1232(ra) # 80003752 <end_op>
  }
  return -1;
    8000428a:	557d                	li	a0,-1
}
    8000428c:	21813083          	ld	ra,536(sp)
    80004290:	21013403          	ld	s0,528(sp)
    80004294:	20813483          	ld	s1,520(sp)
    80004298:	20013903          	ld	s2,512(sp)
    8000429c:	79fe                	ld	s3,504(sp)
    8000429e:	7a5e                	ld	s4,496(sp)
    800042a0:	7abe                	ld	s5,488(sp)
    800042a2:	7b1e                	ld	s6,480(sp)
    800042a4:	6bfe                	ld	s7,472(sp)
    800042a6:	6c5e                	ld	s8,464(sp)
    800042a8:	6cbe                	ld	s9,456(sp)
    800042aa:	6d1e                	ld	s10,448(sp)
    800042ac:	7dfa                	ld	s11,440(sp)
    800042ae:	22010113          	addi	sp,sp,544
    800042b2:	8082                	ret
    end_op();
    800042b4:	fffff097          	auipc	ra,0xfffff
    800042b8:	49e080e7          	jalr	1182(ra) # 80003752 <end_op>
    return -1;
    800042bc:	557d                	li	a0,-1
    800042be:	b7f9                	j	8000428c <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800042c0:	8526                	mv	a0,s1
    800042c2:	ffffd097          	auipc	ra,0xffffd
    800042c6:	d2e080e7          	jalr	-722(ra) # 80000ff0 <proc_pagetable>
    800042ca:	8b2a                	mv	s6,a0
    800042cc:	d555                	beqz	a0,80004278 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042ce:	e7042783          	lw	a5,-400(s0)
    800042d2:	e8845703          	lhu	a4,-376(s0)
    800042d6:	c735                	beqz	a4,80004342 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042d8:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042da:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800042de:	6a05                	lui	s4,0x1
    800042e0:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800042e4:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800042e8:	6d85                	lui	s11,0x1
    800042ea:	7d7d                	lui	s10,0xfffff
    800042ec:	a4b9                	j	8000453a <exec+0x34a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042ee:	00004517          	auipc	a0,0x4
    800042f2:	40250513          	addi	a0,a0,1026 # 800086f0 <syscalls+0x2c8>
    800042f6:	00002097          	auipc	ra,0x2
    800042fa:	a8a080e7          	jalr	-1398(ra) # 80005d80 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042fe:	874a                	mv	a4,s2
    80004300:	009c86bb          	addw	a3,s9,s1
    80004304:	4581                	li	a1,0
    80004306:	8556                	mv	a0,s5
    80004308:	fffff097          	auipc	ra,0xfffff
    8000430c:	ca4080e7          	jalr	-860(ra) # 80002fac <readi>
    80004310:	2501                	sext.w	a0,a0
    80004312:	1ca91463          	bne	s2,a0,800044da <exec+0x2ea>
  for(i = 0; i < sz; i += PGSIZE){
    80004316:	009d84bb          	addw	s1,s11,s1
    8000431a:	013d09bb          	addw	s3,s10,s3
    8000431e:	1f74fe63          	bgeu	s1,s7,8000451a <exec+0x32a>
    pa = walkaddr(pagetable, va + i);
    80004322:	02049593          	slli	a1,s1,0x20
    80004326:	9181                	srli	a1,a1,0x20
    80004328:	95e2                	add	a1,a1,s8
    8000432a:	855a                	mv	a0,s6
    8000432c:	ffffc097          	auipc	ra,0xffffc
    80004330:	1d4080e7          	jalr	468(ra) # 80000500 <walkaddr>
    80004334:	862a                	mv	a2,a0
    if(pa == 0)
    80004336:	dd45                	beqz	a0,800042ee <exec+0xfe>
      n = PGSIZE;
    80004338:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000433a:	fd49f2e3          	bgeu	s3,s4,800042fe <exec+0x10e>
      n = sz - i;
    8000433e:	894e                	mv	s2,s3
    80004340:	bf7d                	j	800042fe <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004342:	4481                	li	s1,0
  iunlockput(ip);
    80004344:	8556                	mv	a0,s5
    80004346:	fffff097          	auipc	ra,0xfffff
    8000434a:	c14080e7          	jalr	-1004(ra) # 80002f5a <iunlockput>
  end_op();
    8000434e:	fffff097          	auipc	ra,0xfffff
    80004352:	404080e7          	jalr	1028(ra) # 80003752 <end_op>
  p = myproc();
    80004356:	ffffd097          	auipc	ra,0xffffd
    8000435a:	bd6080e7          	jalr	-1066(ra) # 80000f2c <myproc>
    8000435e:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004360:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004364:	6785                	lui	a5,0x1
    80004366:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004368:	97a6                	add	a5,a5,s1
    8000436a:	777d                	lui	a4,0xfffff
    8000436c:	8ff9                	and	a5,a5,a4
    8000436e:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004372:	6609                	lui	a2,0x2
    80004374:	963e                	add	a2,a2,a5
    80004376:	85be                	mv	a1,a5
    80004378:	855a                	mv	a0,s6
    8000437a:	ffffc097          	auipc	ra,0xffffc
    8000437e:	53a080e7          	jalr	1338(ra) # 800008b4 <uvmalloc>
    80004382:	8c2a                	mv	s8,a0
  ip = 0;
    80004384:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004386:	14050a63          	beqz	a0,800044da <exec+0x2ea>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000438a:	75f9                	lui	a1,0xffffe
    8000438c:	95aa                	add	a1,a1,a0
    8000438e:	855a                	mv	a0,s6
    80004390:	ffffc097          	auipc	ra,0xffffc
    80004394:	746080e7          	jalr	1862(ra) # 80000ad6 <uvmclear>
  stackbase = sp - PGSIZE;
    80004398:	7afd                	lui	s5,0xfffff
    8000439a:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000439c:	df043783          	ld	a5,-528(s0)
    800043a0:	6388                	ld	a0,0(a5)
    800043a2:	c925                	beqz	a0,80004412 <exec+0x222>
    800043a4:	e9040993          	addi	s3,s0,-368
    800043a8:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043ac:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043ae:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043b0:	ffffc097          	auipc	ra,0xffffc
    800043b4:	f46080e7          	jalr	-186(ra) # 800002f6 <strlen>
    800043b8:	0015079b          	addiw	a5,a0,1
    800043bc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043c0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043c4:	13596f63          	bltu	s2,s5,80004502 <exec+0x312>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043c8:	df043d83          	ld	s11,-528(s0)
    800043cc:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800043d0:	8552                	mv	a0,s4
    800043d2:	ffffc097          	auipc	ra,0xffffc
    800043d6:	f24080e7          	jalr	-220(ra) # 800002f6 <strlen>
    800043da:	0015069b          	addiw	a3,a0,1
    800043de:	8652                	mv	a2,s4
    800043e0:	85ca                	mv	a1,s2
    800043e2:	855a                	mv	a0,s6
    800043e4:	ffffc097          	auipc	ra,0xffffc
    800043e8:	724080e7          	jalr	1828(ra) # 80000b08 <copyout>
    800043ec:	10054f63          	bltz	a0,8000450a <exec+0x31a>
    ustack[argc] = sp;
    800043f0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043f4:	0485                	addi	s1,s1,1
    800043f6:	008d8793          	addi	a5,s11,8
    800043fa:	def43823          	sd	a5,-528(s0)
    800043fe:	008db503          	ld	a0,8(s11)
    80004402:	c911                	beqz	a0,80004416 <exec+0x226>
    if(argc >= MAXARG)
    80004404:	09a1                	addi	s3,s3,8
    80004406:	fb3c95e3          	bne	s9,s3,800043b0 <exec+0x1c0>
  sz = sz1;
    8000440a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000440e:	4a81                	li	s5,0
    80004410:	a0e9                	j	800044da <exec+0x2ea>
  sp = sz;
    80004412:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004414:	4481                	li	s1,0
  ustack[argc] = 0;
    80004416:	00349793          	slli	a5,s1,0x3
    8000441a:	f9078793          	addi	a5,a5,-112
    8000441e:	97a2                	add	a5,a5,s0
    80004420:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004424:	00148693          	addi	a3,s1,1
    80004428:	068e                	slli	a3,a3,0x3
    8000442a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000442e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004432:	01597663          	bgeu	s2,s5,8000443e <exec+0x24e>
  sz = sz1;
    80004436:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000443a:	4a81                	li	s5,0
    8000443c:	a879                	j	800044da <exec+0x2ea>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000443e:	e9040613          	addi	a2,s0,-368
    80004442:	85ca                	mv	a1,s2
    80004444:	855a                	mv	a0,s6
    80004446:	ffffc097          	auipc	ra,0xffffc
    8000444a:	6c2080e7          	jalr	1730(ra) # 80000b08 <copyout>
    8000444e:	0c054263          	bltz	a0,80004512 <exec+0x322>
  p->trapframe->a1 = sp;
    80004452:	058bb783          	ld	a5,88(s7)
    80004456:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000445a:	de843783          	ld	a5,-536(s0)
    8000445e:	0007c703          	lbu	a4,0(a5)
    80004462:	cf11                	beqz	a4,8000447e <exec+0x28e>
    80004464:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004466:	02f00693          	li	a3,47
    8000446a:	a039                	j	80004478 <exec+0x288>
      last = s+1;
    8000446c:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004470:	0785                	addi	a5,a5,1
    80004472:	fff7c703          	lbu	a4,-1(a5)
    80004476:	c701                	beqz	a4,8000447e <exec+0x28e>
    if(*s == '/')
    80004478:	fed71ce3          	bne	a4,a3,80004470 <exec+0x280>
    8000447c:	bfc5                	j	8000446c <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000447e:	4641                	li	a2,16
    80004480:	de843583          	ld	a1,-536(s0)
    80004484:	158b8513          	addi	a0,s7,344
    80004488:	ffffc097          	auipc	ra,0xffffc
    8000448c:	e3c080e7          	jalr	-452(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004490:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004494:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004498:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000449c:	058bb783          	ld	a5,88(s7)
    800044a0:	e6843703          	ld	a4,-408(s0)
    800044a4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044a6:	058bb783          	ld	a5,88(s7)
    800044aa:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044ae:	85ea                	mv	a1,s10
    800044b0:	ffffd097          	auipc	ra,0xffffd
    800044b4:	c92080e7          	jalr	-878(ra) # 80001142 <proc_freepagetable>
  if(p->pid==1) vmprint(p->pagetable);
    800044b8:	030ba703          	lw	a4,48(s7)
    800044bc:	4785                	li	a5,1
    800044be:	00f70563          	beq	a4,a5,800044c8 <exec+0x2d8>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044c2:	0004851b          	sext.w	a0,s1
    800044c6:	b3d9                	j	8000428c <exec+0x9c>
  if(p->pid==1) vmprint(p->pagetable);
    800044c8:	050bb503          	ld	a0,80(s7)
    800044cc:	ffffd097          	auipc	ra,0xffffd
    800044d0:	806080e7          	jalr	-2042(ra) # 80000cd2 <vmprint>
    800044d4:	b7fd                	j	800044c2 <exec+0x2d2>
    800044d6:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800044da:	df843583          	ld	a1,-520(s0)
    800044de:	855a                	mv	a0,s6
    800044e0:	ffffd097          	auipc	ra,0xffffd
    800044e4:	c62080e7          	jalr	-926(ra) # 80001142 <proc_freepagetable>
  if(ip){
    800044e8:	d80a98e3          	bnez	s5,80004278 <exec+0x88>
  return -1;
    800044ec:	557d                	li	a0,-1
    800044ee:	bb79                	j	8000428c <exec+0x9c>
    800044f0:	de943c23          	sd	s1,-520(s0)
    800044f4:	b7dd                	j	800044da <exec+0x2ea>
    800044f6:	de943c23          	sd	s1,-520(s0)
    800044fa:	b7c5                	j	800044da <exec+0x2ea>
    800044fc:	de943c23          	sd	s1,-520(s0)
    80004500:	bfe9                	j	800044da <exec+0x2ea>
  sz = sz1;
    80004502:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004506:	4a81                	li	s5,0
    80004508:	bfc9                	j	800044da <exec+0x2ea>
  sz = sz1;
    8000450a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000450e:	4a81                	li	s5,0
    80004510:	b7e9                	j	800044da <exec+0x2ea>
  sz = sz1;
    80004512:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004516:	4a81                	li	s5,0
    80004518:	b7c9                	j	800044da <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000451a:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000451e:	e0843783          	ld	a5,-504(s0)
    80004522:	0017869b          	addiw	a3,a5,1
    80004526:	e0d43423          	sd	a3,-504(s0)
    8000452a:	e0043783          	ld	a5,-512(s0)
    8000452e:	0387879b          	addiw	a5,a5,56
    80004532:	e8845703          	lhu	a4,-376(s0)
    80004536:	e0e6d7e3          	bge	a3,a4,80004344 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000453a:	2781                	sext.w	a5,a5
    8000453c:	e0f43023          	sd	a5,-512(s0)
    80004540:	03800713          	li	a4,56
    80004544:	86be                	mv	a3,a5
    80004546:	e1840613          	addi	a2,s0,-488
    8000454a:	4581                	li	a1,0
    8000454c:	8556                	mv	a0,s5
    8000454e:	fffff097          	auipc	ra,0xfffff
    80004552:	a5e080e7          	jalr	-1442(ra) # 80002fac <readi>
    80004556:	03800793          	li	a5,56
    8000455a:	f6f51ee3          	bne	a0,a5,800044d6 <exec+0x2e6>
    if(ph.type != ELF_PROG_LOAD)
    8000455e:	e1842783          	lw	a5,-488(s0)
    80004562:	4705                	li	a4,1
    80004564:	fae79de3          	bne	a5,a4,8000451e <exec+0x32e>
    if(ph.memsz < ph.filesz)
    80004568:	e4043603          	ld	a2,-448(s0)
    8000456c:	e3843783          	ld	a5,-456(s0)
    80004570:	f8f660e3          	bltu	a2,a5,800044f0 <exec+0x300>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004574:	e2843783          	ld	a5,-472(s0)
    80004578:	963e                	add	a2,a2,a5
    8000457a:	f6f66ee3          	bltu	a2,a5,800044f6 <exec+0x306>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000457e:	85a6                	mv	a1,s1
    80004580:	855a                	mv	a0,s6
    80004582:	ffffc097          	auipc	ra,0xffffc
    80004586:	332080e7          	jalr	818(ra) # 800008b4 <uvmalloc>
    8000458a:	dea43c23          	sd	a0,-520(s0)
    8000458e:	d53d                	beqz	a0,800044fc <exec+0x30c>
    if((ph.vaddr % PGSIZE) != 0)
    80004590:	e2843c03          	ld	s8,-472(s0)
    80004594:	de043783          	ld	a5,-544(s0)
    80004598:	00fc77b3          	and	a5,s8,a5
    8000459c:	ff9d                	bnez	a5,800044da <exec+0x2ea>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000459e:	e2042c83          	lw	s9,-480(s0)
    800045a2:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045a6:	f60b8ae3          	beqz	s7,8000451a <exec+0x32a>
    800045aa:	89de                	mv	s3,s7
    800045ac:	4481                	li	s1,0
    800045ae:	bb95                	j	80004322 <exec+0x132>

00000000800045b0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045b0:	7179                	addi	sp,sp,-48
    800045b2:	f406                	sd	ra,40(sp)
    800045b4:	f022                	sd	s0,32(sp)
    800045b6:	ec26                	sd	s1,24(sp)
    800045b8:	e84a                	sd	s2,16(sp)
    800045ba:	1800                	addi	s0,sp,48
    800045bc:	892e                	mv	s2,a1
    800045be:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045c0:	fdc40593          	addi	a1,s0,-36
    800045c4:	ffffe097          	auipc	ra,0xffffe
    800045c8:	aee080e7          	jalr	-1298(ra) # 800020b2 <argint>
    800045cc:	04054063          	bltz	a0,8000460c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045d0:	fdc42703          	lw	a4,-36(s0)
    800045d4:	47bd                	li	a5,15
    800045d6:	02e7ed63          	bltu	a5,a4,80004610 <argfd+0x60>
    800045da:	ffffd097          	auipc	ra,0xffffd
    800045de:	952080e7          	jalr	-1710(ra) # 80000f2c <myproc>
    800045e2:	fdc42703          	lw	a4,-36(s0)
    800045e6:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    800045ea:	078e                	slli	a5,a5,0x3
    800045ec:	953e                	add	a0,a0,a5
    800045ee:	611c                	ld	a5,0(a0)
    800045f0:	c395                	beqz	a5,80004614 <argfd+0x64>
    return -1;
  if(pfd)
    800045f2:	00090463          	beqz	s2,800045fa <argfd+0x4a>
    *pfd = fd;
    800045f6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045fa:	4501                	li	a0,0
  if(pf)
    800045fc:	c091                	beqz	s1,80004600 <argfd+0x50>
    *pf = f;
    800045fe:	e09c                	sd	a5,0(s1)
}
    80004600:	70a2                	ld	ra,40(sp)
    80004602:	7402                	ld	s0,32(sp)
    80004604:	64e2                	ld	s1,24(sp)
    80004606:	6942                	ld	s2,16(sp)
    80004608:	6145                	addi	sp,sp,48
    8000460a:	8082                	ret
    return -1;
    8000460c:	557d                	li	a0,-1
    8000460e:	bfcd                	j	80004600 <argfd+0x50>
    return -1;
    80004610:	557d                	li	a0,-1
    80004612:	b7fd                	j	80004600 <argfd+0x50>
    80004614:	557d                	li	a0,-1
    80004616:	b7ed                	j	80004600 <argfd+0x50>

0000000080004618 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004618:	1101                	addi	sp,sp,-32
    8000461a:	ec06                	sd	ra,24(sp)
    8000461c:	e822                	sd	s0,16(sp)
    8000461e:	e426                	sd	s1,8(sp)
    80004620:	1000                	addi	s0,sp,32
    80004622:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004624:	ffffd097          	auipc	ra,0xffffd
    80004628:	908080e7          	jalr	-1784(ra) # 80000f2c <myproc>
    8000462c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000462e:	0d050793          	addi	a5,a0,208
    80004632:	4501                	li	a0,0
    80004634:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004636:	6398                	ld	a4,0(a5)
    80004638:	cb19                	beqz	a4,8000464e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000463a:	2505                	addiw	a0,a0,1
    8000463c:	07a1                	addi	a5,a5,8
    8000463e:	fed51ce3          	bne	a0,a3,80004636 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004642:	557d                	li	a0,-1
}
    80004644:	60e2                	ld	ra,24(sp)
    80004646:	6442                	ld	s0,16(sp)
    80004648:	64a2                	ld	s1,8(sp)
    8000464a:	6105                	addi	sp,sp,32
    8000464c:	8082                	ret
      p->ofile[fd] = f;
    8000464e:	01a50793          	addi	a5,a0,26
    80004652:	078e                	slli	a5,a5,0x3
    80004654:	963e                	add	a2,a2,a5
    80004656:	e204                	sd	s1,0(a2)
      return fd;
    80004658:	b7f5                	j	80004644 <fdalloc+0x2c>

000000008000465a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000465a:	715d                	addi	sp,sp,-80
    8000465c:	e486                	sd	ra,72(sp)
    8000465e:	e0a2                	sd	s0,64(sp)
    80004660:	fc26                	sd	s1,56(sp)
    80004662:	f84a                	sd	s2,48(sp)
    80004664:	f44e                	sd	s3,40(sp)
    80004666:	f052                	sd	s4,32(sp)
    80004668:	ec56                	sd	s5,24(sp)
    8000466a:	0880                	addi	s0,sp,80
    8000466c:	89ae                	mv	s3,a1
    8000466e:	8ab2                	mv	s5,a2
    80004670:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004672:	fb040593          	addi	a1,s0,-80
    80004676:	fffff097          	auipc	ra,0xfffff
    8000467a:	e5c080e7          	jalr	-420(ra) # 800034d2 <nameiparent>
    8000467e:	892a                	mv	s2,a0
    80004680:	12050e63          	beqz	a0,800047bc <create+0x162>
    return 0;

  ilock(dp);
    80004684:	ffffe097          	auipc	ra,0xffffe
    80004688:	674080e7          	jalr	1652(ra) # 80002cf8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000468c:	4601                	li	a2,0
    8000468e:	fb040593          	addi	a1,s0,-80
    80004692:	854a                	mv	a0,s2
    80004694:	fffff097          	auipc	ra,0xfffff
    80004698:	b48080e7          	jalr	-1208(ra) # 800031dc <dirlookup>
    8000469c:	84aa                	mv	s1,a0
    8000469e:	c921                	beqz	a0,800046ee <create+0x94>
    iunlockput(dp);
    800046a0:	854a                	mv	a0,s2
    800046a2:	fffff097          	auipc	ra,0xfffff
    800046a6:	8b8080e7          	jalr	-1864(ra) # 80002f5a <iunlockput>
    ilock(ip);
    800046aa:	8526                	mv	a0,s1
    800046ac:	ffffe097          	auipc	ra,0xffffe
    800046b0:	64c080e7          	jalr	1612(ra) # 80002cf8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046b4:	2981                	sext.w	s3,s3
    800046b6:	4789                	li	a5,2
    800046b8:	02f99463          	bne	s3,a5,800046e0 <create+0x86>
    800046bc:	0444d783          	lhu	a5,68(s1)
    800046c0:	37f9                	addiw	a5,a5,-2
    800046c2:	17c2                	slli	a5,a5,0x30
    800046c4:	93c1                	srli	a5,a5,0x30
    800046c6:	4705                	li	a4,1
    800046c8:	00f76c63          	bltu	a4,a5,800046e0 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046cc:	8526                	mv	a0,s1
    800046ce:	60a6                	ld	ra,72(sp)
    800046d0:	6406                	ld	s0,64(sp)
    800046d2:	74e2                	ld	s1,56(sp)
    800046d4:	7942                	ld	s2,48(sp)
    800046d6:	79a2                	ld	s3,40(sp)
    800046d8:	7a02                	ld	s4,32(sp)
    800046da:	6ae2                	ld	s5,24(sp)
    800046dc:	6161                	addi	sp,sp,80
    800046de:	8082                	ret
    iunlockput(ip);
    800046e0:	8526                	mv	a0,s1
    800046e2:	fffff097          	auipc	ra,0xfffff
    800046e6:	878080e7          	jalr	-1928(ra) # 80002f5a <iunlockput>
    return 0;
    800046ea:	4481                	li	s1,0
    800046ec:	b7c5                	j	800046cc <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046ee:	85ce                	mv	a1,s3
    800046f0:	00092503          	lw	a0,0(s2)
    800046f4:	ffffe097          	auipc	ra,0xffffe
    800046f8:	46a080e7          	jalr	1130(ra) # 80002b5e <ialloc>
    800046fc:	84aa                	mv	s1,a0
    800046fe:	c521                	beqz	a0,80004746 <create+0xec>
  ilock(ip);
    80004700:	ffffe097          	auipc	ra,0xffffe
    80004704:	5f8080e7          	jalr	1528(ra) # 80002cf8 <ilock>
  ip->major = major;
    80004708:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000470c:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004710:	4a05                	li	s4,1
    80004712:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80004716:	8526                	mv	a0,s1
    80004718:	ffffe097          	auipc	ra,0xffffe
    8000471c:	514080e7          	jalr	1300(ra) # 80002c2c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004720:	2981                	sext.w	s3,s3
    80004722:	03498a63          	beq	s3,s4,80004756 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004726:	40d0                	lw	a2,4(s1)
    80004728:	fb040593          	addi	a1,s0,-80
    8000472c:	854a                	mv	a0,s2
    8000472e:	fffff097          	auipc	ra,0xfffff
    80004732:	cc4080e7          	jalr	-828(ra) # 800033f2 <dirlink>
    80004736:	06054b63          	bltz	a0,800047ac <create+0x152>
  iunlockput(dp);
    8000473a:	854a                	mv	a0,s2
    8000473c:	fffff097          	auipc	ra,0xfffff
    80004740:	81e080e7          	jalr	-2018(ra) # 80002f5a <iunlockput>
  return ip;
    80004744:	b761                	j	800046cc <create+0x72>
    panic("create: ialloc");
    80004746:	00004517          	auipc	a0,0x4
    8000474a:	fca50513          	addi	a0,a0,-54 # 80008710 <syscalls+0x2e8>
    8000474e:	00001097          	auipc	ra,0x1
    80004752:	632080e7          	jalr	1586(ra) # 80005d80 <panic>
    dp->nlink++;  // for ".."
    80004756:	04a95783          	lhu	a5,74(s2)
    8000475a:	2785                	addiw	a5,a5,1
    8000475c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004760:	854a                	mv	a0,s2
    80004762:	ffffe097          	auipc	ra,0xffffe
    80004766:	4ca080e7          	jalr	1226(ra) # 80002c2c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000476a:	40d0                	lw	a2,4(s1)
    8000476c:	00004597          	auipc	a1,0x4
    80004770:	fb458593          	addi	a1,a1,-76 # 80008720 <syscalls+0x2f8>
    80004774:	8526                	mv	a0,s1
    80004776:	fffff097          	auipc	ra,0xfffff
    8000477a:	c7c080e7          	jalr	-900(ra) # 800033f2 <dirlink>
    8000477e:	00054f63          	bltz	a0,8000479c <create+0x142>
    80004782:	00492603          	lw	a2,4(s2)
    80004786:	00004597          	auipc	a1,0x4
    8000478a:	fa258593          	addi	a1,a1,-94 # 80008728 <syscalls+0x300>
    8000478e:	8526                	mv	a0,s1
    80004790:	fffff097          	auipc	ra,0xfffff
    80004794:	c62080e7          	jalr	-926(ra) # 800033f2 <dirlink>
    80004798:	f80557e3          	bgez	a0,80004726 <create+0xcc>
      panic("create dots");
    8000479c:	00004517          	auipc	a0,0x4
    800047a0:	f9450513          	addi	a0,a0,-108 # 80008730 <syscalls+0x308>
    800047a4:	00001097          	auipc	ra,0x1
    800047a8:	5dc080e7          	jalr	1500(ra) # 80005d80 <panic>
    panic("create: dirlink");
    800047ac:	00004517          	auipc	a0,0x4
    800047b0:	f9450513          	addi	a0,a0,-108 # 80008740 <syscalls+0x318>
    800047b4:	00001097          	auipc	ra,0x1
    800047b8:	5cc080e7          	jalr	1484(ra) # 80005d80 <panic>
    return 0;
    800047bc:	84aa                	mv	s1,a0
    800047be:	b739                	j	800046cc <create+0x72>

00000000800047c0 <sys_dup>:
{
    800047c0:	7179                	addi	sp,sp,-48
    800047c2:	f406                	sd	ra,40(sp)
    800047c4:	f022                	sd	s0,32(sp)
    800047c6:	ec26                	sd	s1,24(sp)
    800047c8:	e84a                	sd	s2,16(sp)
    800047ca:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047cc:	fd840613          	addi	a2,s0,-40
    800047d0:	4581                	li	a1,0
    800047d2:	4501                	li	a0,0
    800047d4:	00000097          	auipc	ra,0x0
    800047d8:	ddc080e7          	jalr	-548(ra) # 800045b0 <argfd>
    return -1;
    800047dc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047de:	02054363          	bltz	a0,80004804 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800047e2:	fd843903          	ld	s2,-40(s0)
    800047e6:	854a                	mv	a0,s2
    800047e8:	00000097          	auipc	ra,0x0
    800047ec:	e30080e7          	jalr	-464(ra) # 80004618 <fdalloc>
    800047f0:	84aa                	mv	s1,a0
    return -1;
    800047f2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047f4:	00054863          	bltz	a0,80004804 <sys_dup+0x44>
  filedup(f);
    800047f8:	854a                	mv	a0,s2
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	350080e7          	jalr	848(ra) # 80003b4a <filedup>
  return fd;
    80004802:	87a6                	mv	a5,s1
}
    80004804:	853e                	mv	a0,a5
    80004806:	70a2                	ld	ra,40(sp)
    80004808:	7402                	ld	s0,32(sp)
    8000480a:	64e2                	ld	s1,24(sp)
    8000480c:	6942                	ld	s2,16(sp)
    8000480e:	6145                	addi	sp,sp,48
    80004810:	8082                	ret

0000000080004812 <sys_read>:
{
    80004812:	7179                	addi	sp,sp,-48
    80004814:	f406                	sd	ra,40(sp)
    80004816:	f022                	sd	s0,32(sp)
    80004818:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000481a:	fe840613          	addi	a2,s0,-24
    8000481e:	4581                	li	a1,0
    80004820:	4501                	li	a0,0
    80004822:	00000097          	auipc	ra,0x0
    80004826:	d8e080e7          	jalr	-626(ra) # 800045b0 <argfd>
    return -1;
    8000482a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000482c:	04054163          	bltz	a0,8000486e <sys_read+0x5c>
    80004830:	fe440593          	addi	a1,s0,-28
    80004834:	4509                	li	a0,2
    80004836:	ffffe097          	auipc	ra,0xffffe
    8000483a:	87c080e7          	jalr	-1924(ra) # 800020b2 <argint>
    return -1;
    8000483e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004840:	02054763          	bltz	a0,8000486e <sys_read+0x5c>
    80004844:	fd840593          	addi	a1,s0,-40
    80004848:	4505                	li	a0,1
    8000484a:	ffffe097          	auipc	ra,0xffffe
    8000484e:	88a080e7          	jalr	-1910(ra) # 800020d4 <argaddr>
    return -1;
    80004852:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004854:	00054d63          	bltz	a0,8000486e <sys_read+0x5c>
  return fileread(f, p, n);
    80004858:	fe442603          	lw	a2,-28(s0)
    8000485c:	fd843583          	ld	a1,-40(s0)
    80004860:	fe843503          	ld	a0,-24(s0)
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	472080e7          	jalr	1138(ra) # 80003cd6 <fileread>
    8000486c:	87aa                	mv	a5,a0
}
    8000486e:	853e                	mv	a0,a5
    80004870:	70a2                	ld	ra,40(sp)
    80004872:	7402                	ld	s0,32(sp)
    80004874:	6145                	addi	sp,sp,48
    80004876:	8082                	ret

0000000080004878 <sys_write>:
{
    80004878:	7179                	addi	sp,sp,-48
    8000487a:	f406                	sd	ra,40(sp)
    8000487c:	f022                	sd	s0,32(sp)
    8000487e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004880:	fe840613          	addi	a2,s0,-24
    80004884:	4581                	li	a1,0
    80004886:	4501                	li	a0,0
    80004888:	00000097          	auipc	ra,0x0
    8000488c:	d28080e7          	jalr	-728(ra) # 800045b0 <argfd>
    return -1;
    80004890:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004892:	04054163          	bltz	a0,800048d4 <sys_write+0x5c>
    80004896:	fe440593          	addi	a1,s0,-28
    8000489a:	4509                	li	a0,2
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	816080e7          	jalr	-2026(ra) # 800020b2 <argint>
    return -1;
    800048a4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a6:	02054763          	bltz	a0,800048d4 <sys_write+0x5c>
    800048aa:	fd840593          	addi	a1,s0,-40
    800048ae:	4505                	li	a0,1
    800048b0:	ffffe097          	auipc	ra,0xffffe
    800048b4:	824080e7          	jalr	-2012(ra) # 800020d4 <argaddr>
    return -1;
    800048b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ba:	00054d63          	bltz	a0,800048d4 <sys_write+0x5c>
  return filewrite(f, p, n);
    800048be:	fe442603          	lw	a2,-28(s0)
    800048c2:	fd843583          	ld	a1,-40(s0)
    800048c6:	fe843503          	ld	a0,-24(s0)
    800048ca:	fffff097          	auipc	ra,0xfffff
    800048ce:	4ce080e7          	jalr	1230(ra) # 80003d98 <filewrite>
    800048d2:	87aa                	mv	a5,a0
}
    800048d4:	853e                	mv	a0,a5
    800048d6:	70a2                	ld	ra,40(sp)
    800048d8:	7402                	ld	s0,32(sp)
    800048da:	6145                	addi	sp,sp,48
    800048dc:	8082                	ret

00000000800048de <sys_close>:
{
    800048de:	1101                	addi	sp,sp,-32
    800048e0:	ec06                	sd	ra,24(sp)
    800048e2:	e822                	sd	s0,16(sp)
    800048e4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048e6:	fe040613          	addi	a2,s0,-32
    800048ea:	fec40593          	addi	a1,s0,-20
    800048ee:	4501                	li	a0,0
    800048f0:	00000097          	auipc	ra,0x0
    800048f4:	cc0080e7          	jalr	-832(ra) # 800045b0 <argfd>
    return -1;
    800048f8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048fa:	02054463          	bltz	a0,80004922 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048fe:	ffffc097          	auipc	ra,0xffffc
    80004902:	62e080e7          	jalr	1582(ra) # 80000f2c <myproc>
    80004906:	fec42783          	lw	a5,-20(s0)
    8000490a:	07e9                	addi	a5,a5,26
    8000490c:	078e                	slli	a5,a5,0x3
    8000490e:	953e                	add	a0,a0,a5
    80004910:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004914:	fe043503          	ld	a0,-32(s0)
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	284080e7          	jalr	644(ra) # 80003b9c <fileclose>
  return 0;
    80004920:	4781                	li	a5,0
}
    80004922:	853e                	mv	a0,a5
    80004924:	60e2                	ld	ra,24(sp)
    80004926:	6442                	ld	s0,16(sp)
    80004928:	6105                	addi	sp,sp,32
    8000492a:	8082                	ret

000000008000492c <sys_fstat>:
{
    8000492c:	1101                	addi	sp,sp,-32
    8000492e:	ec06                	sd	ra,24(sp)
    80004930:	e822                	sd	s0,16(sp)
    80004932:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004934:	fe840613          	addi	a2,s0,-24
    80004938:	4581                	li	a1,0
    8000493a:	4501                	li	a0,0
    8000493c:	00000097          	auipc	ra,0x0
    80004940:	c74080e7          	jalr	-908(ra) # 800045b0 <argfd>
    return -1;
    80004944:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004946:	02054563          	bltz	a0,80004970 <sys_fstat+0x44>
    8000494a:	fe040593          	addi	a1,s0,-32
    8000494e:	4505                	li	a0,1
    80004950:	ffffd097          	auipc	ra,0xffffd
    80004954:	784080e7          	jalr	1924(ra) # 800020d4 <argaddr>
    return -1;
    80004958:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000495a:	00054b63          	bltz	a0,80004970 <sys_fstat+0x44>
  return filestat(f, st);
    8000495e:	fe043583          	ld	a1,-32(s0)
    80004962:	fe843503          	ld	a0,-24(s0)
    80004966:	fffff097          	auipc	ra,0xfffff
    8000496a:	2fe080e7          	jalr	766(ra) # 80003c64 <filestat>
    8000496e:	87aa                	mv	a5,a0
}
    80004970:	853e                	mv	a0,a5
    80004972:	60e2                	ld	ra,24(sp)
    80004974:	6442                	ld	s0,16(sp)
    80004976:	6105                	addi	sp,sp,32
    80004978:	8082                	ret

000000008000497a <sys_link>:
{
    8000497a:	7169                	addi	sp,sp,-304
    8000497c:	f606                	sd	ra,296(sp)
    8000497e:	f222                	sd	s0,288(sp)
    80004980:	ee26                	sd	s1,280(sp)
    80004982:	ea4a                	sd	s2,272(sp)
    80004984:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004986:	08000613          	li	a2,128
    8000498a:	ed040593          	addi	a1,s0,-304
    8000498e:	4501                	li	a0,0
    80004990:	ffffd097          	auipc	ra,0xffffd
    80004994:	766080e7          	jalr	1894(ra) # 800020f6 <argstr>
    return -1;
    80004998:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000499a:	10054e63          	bltz	a0,80004ab6 <sys_link+0x13c>
    8000499e:	08000613          	li	a2,128
    800049a2:	f5040593          	addi	a1,s0,-176
    800049a6:	4505                	li	a0,1
    800049a8:	ffffd097          	auipc	ra,0xffffd
    800049ac:	74e080e7          	jalr	1870(ra) # 800020f6 <argstr>
    return -1;
    800049b0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049b2:	10054263          	bltz	a0,80004ab6 <sys_link+0x13c>
  begin_op();
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	d1e080e7          	jalr	-738(ra) # 800036d4 <begin_op>
  if((ip = namei(old)) == 0){
    800049be:	ed040513          	addi	a0,s0,-304
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	af2080e7          	jalr	-1294(ra) # 800034b4 <namei>
    800049ca:	84aa                	mv	s1,a0
    800049cc:	c551                	beqz	a0,80004a58 <sys_link+0xde>
  ilock(ip);
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	32a080e7          	jalr	810(ra) # 80002cf8 <ilock>
  if(ip->type == T_DIR){
    800049d6:	04449703          	lh	a4,68(s1)
    800049da:	4785                	li	a5,1
    800049dc:	08f70463          	beq	a4,a5,80004a64 <sys_link+0xea>
  ip->nlink++;
    800049e0:	04a4d783          	lhu	a5,74(s1)
    800049e4:	2785                	addiw	a5,a5,1
    800049e6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049ea:	8526                	mv	a0,s1
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	240080e7          	jalr	576(ra) # 80002c2c <iupdate>
  iunlock(ip);
    800049f4:	8526                	mv	a0,s1
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	3c4080e7          	jalr	964(ra) # 80002dba <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049fe:	fd040593          	addi	a1,s0,-48
    80004a02:	f5040513          	addi	a0,s0,-176
    80004a06:	fffff097          	auipc	ra,0xfffff
    80004a0a:	acc080e7          	jalr	-1332(ra) # 800034d2 <nameiparent>
    80004a0e:	892a                	mv	s2,a0
    80004a10:	c935                	beqz	a0,80004a84 <sys_link+0x10a>
  ilock(dp);
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	2e6080e7          	jalr	742(ra) # 80002cf8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a1a:	00092703          	lw	a4,0(s2)
    80004a1e:	409c                	lw	a5,0(s1)
    80004a20:	04f71d63          	bne	a4,a5,80004a7a <sys_link+0x100>
    80004a24:	40d0                	lw	a2,4(s1)
    80004a26:	fd040593          	addi	a1,s0,-48
    80004a2a:	854a                	mv	a0,s2
    80004a2c:	fffff097          	auipc	ra,0xfffff
    80004a30:	9c6080e7          	jalr	-1594(ra) # 800033f2 <dirlink>
    80004a34:	04054363          	bltz	a0,80004a7a <sys_link+0x100>
  iunlockput(dp);
    80004a38:	854a                	mv	a0,s2
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	520080e7          	jalr	1312(ra) # 80002f5a <iunlockput>
  iput(ip);
    80004a42:	8526                	mv	a0,s1
    80004a44:	ffffe097          	auipc	ra,0xffffe
    80004a48:	46e080e7          	jalr	1134(ra) # 80002eb2 <iput>
  end_op();
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	d06080e7          	jalr	-762(ra) # 80003752 <end_op>
  return 0;
    80004a54:	4781                	li	a5,0
    80004a56:	a085                	j	80004ab6 <sys_link+0x13c>
    end_op();
    80004a58:	fffff097          	auipc	ra,0xfffff
    80004a5c:	cfa080e7          	jalr	-774(ra) # 80003752 <end_op>
    return -1;
    80004a60:	57fd                	li	a5,-1
    80004a62:	a891                	j	80004ab6 <sys_link+0x13c>
    iunlockput(ip);
    80004a64:	8526                	mv	a0,s1
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	4f4080e7          	jalr	1268(ra) # 80002f5a <iunlockput>
    end_op();
    80004a6e:	fffff097          	auipc	ra,0xfffff
    80004a72:	ce4080e7          	jalr	-796(ra) # 80003752 <end_op>
    return -1;
    80004a76:	57fd                	li	a5,-1
    80004a78:	a83d                	j	80004ab6 <sys_link+0x13c>
    iunlockput(dp);
    80004a7a:	854a                	mv	a0,s2
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	4de080e7          	jalr	1246(ra) # 80002f5a <iunlockput>
  ilock(ip);
    80004a84:	8526                	mv	a0,s1
    80004a86:	ffffe097          	auipc	ra,0xffffe
    80004a8a:	272080e7          	jalr	626(ra) # 80002cf8 <ilock>
  ip->nlink--;
    80004a8e:	04a4d783          	lhu	a5,74(s1)
    80004a92:	37fd                	addiw	a5,a5,-1
    80004a94:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a98:	8526                	mv	a0,s1
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	192080e7          	jalr	402(ra) # 80002c2c <iupdate>
  iunlockput(ip);
    80004aa2:	8526                	mv	a0,s1
    80004aa4:	ffffe097          	auipc	ra,0xffffe
    80004aa8:	4b6080e7          	jalr	1206(ra) # 80002f5a <iunlockput>
  end_op();
    80004aac:	fffff097          	auipc	ra,0xfffff
    80004ab0:	ca6080e7          	jalr	-858(ra) # 80003752 <end_op>
  return -1;
    80004ab4:	57fd                	li	a5,-1
}
    80004ab6:	853e                	mv	a0,a5
    80004ab8:	70b2                	ld	ra,296(sp)
    80004aba:	7412                	ld	s0,288(sp)
    80004abc:	64f2                	ld	s1,280(sp)
    80004abe:	6952                	ld	s2,272(sp)
    80004ac0:	6155                	addi	sp,sp,304
    80004ac2:	8082                	ret

0000000080004ac4 <sys_unlink>:
{
    80004ac4:	7151                	addi	sp,sp,-240
    80004ac6:	f586                	sd	ra,232(sp)
    80004ac8:	f1a2                	sd	s0,224(sp)
    80004aca:	eda6                	sd	s1,216(sp)
    80004acc:	e9ca                	sd	s2,208(sp)
    80004ace:	e5ce                	sd	s3,200(sp)
    80004ad0:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ad2:	08000613          	li	a2,128
    80004ad6:	f3040593          	addi	a1,s0,-208
    80004ada:	4501                	li	a0,0
    80004adc:	ffffd097          	auipc	ra,0xffffd
    80004ae0:	61a080e7          	jalr	1562(ra) # 800020f6 <argstr>
    80004ae4:	18054163          	bltz	a0,80004c66 <sys_unlink+0x1a2>
  begin_op();
    80004ae8:	fffff097          	auipc	ra,0xfffff
    80004aec:	bec080e7          	jalr	-1044(ra) # 800036d4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004af0:	fb040593          	addi	a1,s0,-80
    80004af4:	f3040513          	addi	a0,s0,-208
    80004af8:	fffff097          	auipc	ra,0xfffff
    80004afc:	9da080e7          	jalr	-1574(ra) # 800034d2 <nameiparent>
    80004b00:	84aa                	mv	s1,a0
    80004b02:	c979                	beqz	a0,80004bd8 <sys_unlink+0x114>
  ilock(dp);
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	1f4080e7          	jalr	500(ra) # 80002cf8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b0c:	00004597          	auipc	a1,0x4
    80004b10:	c1458593          	addi	a1,a1,-1004 # 80008720 <syscalls+0x2f8>
    80004b14:	fb040513          	addi	a0,s0,-80
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	6aa080e7          	jalr	1706(ra) # 800031c2 <namecmp>
    80004b20:	14050a63          	beqz	a0,80004c74 <sys_unlink+0x1b0>
    80004b24:	00004597          	auipc	a1,0x4
    80004b28:	c0458593          	addi	a1,a1,-1020 # 80008728 <syscalls+0x300>
    80004b2c:	fb040513          	addi	a0,s0,-80
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	692080e7          	jalr	1682(ra) # 800031c2 <namecmp>
    80004b38:	12050e63          	beqz	a0,80004c74 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b3c:	f2c40613          	addi	a2,s0,-212
    80004b40:	fb040593          	addi	a1,s0,-80
    80004b44:	8526                	mv	a0,s1
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	696080e7          	jalr	1686(ra) # 800031dc <dirlookup>
    80004b4e:	892a                	mv	s2,a0
    80004b50:	12050263          	beqz	a0,80004c74 <sys_unlink+0x1b0>
  ilock(ip);
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	1a4080e7          	jalr	420(ra) # 80002cf8 <ilock>
  if(ip->nlink < 1)
    80004b5c:	04a91783          	lh	a5,74(s2)
    80004b60:	08f05263          	blez	a5,80004be4 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b64:	04491703          	lh	a4,68(s2)
    80004b68:	4785                	li	a5,1
    80004b6a:	08f70563          	beq	a4,a5,80004bf4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b6e:	4641                	li	a2,16
    80004b70:	4581                	li	a1,0
    80004b72:	fc040513          	addi	a0,s0,-64
    80004b76:	ffffb097          	auipc	ra,0xffffb
    80004b7a:	604080e7          	jalr	1540(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b7e:	4741                	li	a4,16
    80004b80:	f2c42683          	lw	a3,-212(s0)
    80004b84:	fc040613          	addi	a2,s0,-64
    80004b88:	4581                	li	a1,0
    80004b8a:	8526                	mv	a0,s1
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	518080e7          	jalr	1304(ra) # 800030a4 <writei>
    80004b94:	47c1                	li	a5,16
    80004b96:	0af51563          	bne	a0,a5,80004c40 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b9a:	04491703          	lh	a4,68(s2)
    80004b9e:	4785                	li	a5,1
    80004ba0:	0af70863          	beq	a4,a5,80004c50 <sys_unlink+0x18c>
  iunlockput(dp);
    80004ba4:	8526                	mv	a0,s1
    80004ba6:	ffffe097          	auipc	ra,0xffffe
    80004baa:	3b4080e7          	jalr	948(ra) # 80002f5a <iunlockput>
  ip->nlink--;
    80004bae:	04a95783          	lhu	a5,74(s2)
    80004bb2:	37fd                	addiw	a5,a5,-1
    80004bb4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bb8:	854a                	mv	a0,s2
    80004bba:	ffffe097          	auipc	ra,0xffffe
    80004bbe:	072080e7          	jalr	114(ra) # 80002c2c <iupdate>
  iunlockput(ip);
    80004bc2:	854a                	mv	a0,s2
    80004bc4:	ffffe097          	auipc	ra,0xffffe
    80004bc8:	396080e7          	jalr	918(ra) # 80002f5a <iunlockput>
  end_op();
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	b86080e7          	jalr	-1146(ra) # 80003752 <end_op>
  return 0;
    80004bd4:	4501                	li	a0,0
    80004bd6:	a84d                	j	80004c88 <sys_unlink+0x1c4>
    end_op();
    80004bd8:	fffff097          	auipc	ra,0xfffff
    80004bdc:	b7a080e7          	jalr	-1158(ra) # 80003752 <end_op>
    return -1;
    80004be0:	557d                	li	a0,-1
    80004be2:	a05d                	j	80004c88 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004be4:	00004517          	auipc	a0,0x4
    80004be8:	b6c50513          	addi	a0,a0,-1172 # 80008750 <syscalls+0x328>
    80004bec:	00001097          	auipc	ra,0x1
    80004bf0:	194080e7          	jalr	404(ra) # 80005d80 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bf4:	04c92703          	lw	a4,76(s2)
    80004bf8:	02000793          	li	a5,32
    80004bfc:	f6e7f9e3          	bgeu	a5,a4,80004b6e <sys_unlink+0xaa>
    80004c00:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c04:	4741                	li	a4,16
    80004c06:	86ce                	mv	a3,s3
    80004c08:	f1840613          	addi	a2,s0,-232
    80004c0c:	4581                	li	a1,0
    80004c0e:	854a                	mv	a0,s2
    80004c10:	ffffe097          	auipc	ra,0xffffe
    80004c14:	39c080e7          	jalr	924(ra) # 80002fac <readi>
    80004c18:	47c1                	li	a5,16
    80004c1a:	00f51b63          	bne	a0,a5,80004c30 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c1e:	f1845783          	lhu	a5,-232(s0)
    80004c22:	e7a1                	bnez	a5,80004c6a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c24:	29c1                	addiw	s3,s3,16
    80004c26:	04c92783          	lw	a5,76(s2)
    80004c2a:	fcf9ede3          	bltu	s3,a5,80004c04 <sys_unlink+0x140>
    80004c2e:	b781                	j	80004b6e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c30:	00004517          	auipc	a0,0x4
    80004c34:	b3850513          	addi	a0,a0,-1224 # 80008768 <syscalls+0x340>
    80004c38:	00001097          	auipc	ra,0x1
    80004c3c:	148080e7          	jalr	328(ra) # 80005d80 <panic>
    panic("unlink: writei");
    80004c40:	00004517          	auipc	a0,0x4
    80004c44:	b4050513          	addi	a0,a0,-1216 # 80008780 <syscalls+0x358>
    80004c48:	00001097          	auipc	ra,0x1
    80004c4c:	138080e7          	jalr	312(ra) # 80005d80 <panic>
    dp->nlink--;
    80004c50:	04a4d783          	lhu	a5,74(s1)
    80004c54:	37fd                	addiw	a5,a5,-1
    80004c56:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c5a:	8526                	mv	a0,s1
    80004c5c:	ffffe097          	auipc	ra,0xffffe
    80004c60:	fd0080e7          	jalr	-48(ra) # 80002c2c <iupdate>
    80004c64:	b781                	j	80004ba4 <sys_unlink+0xe0>
    return -1;
    80004c66:	557d                	li	a0,-1
    80004c68:	a005                	j	80004c88 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c6a:	854a                	mv	a0,s2
    80004c6c:	ffffe097          	auipc	ra,0xffffe
    80004c70:	2ee080e7          	jalr	750(ra) # 80002f5a <iunlockput>
  iunlockput(dp);
    80004c74:	8526                	mv	a0,s1
    80004c76:	ffffe097          	auipc	ra,0xffffe
    80004c7a:	2e4080e7          	jalr	740(ra) # 80002f5a <iunlockput>
  end_op();
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	ad4080e7          	jalr	-1324(ra) # 80003752 <end_op>
  return -1;
    80004c86:	557d                	li	a0,-1
}
    80004c88:	70ae                	ld	ra,232(sp)
    80004c8a:	740e                	ld	s0,224(sp)
    80004c8c:	64ee                	ld	s1,216(sp)
    80004c8e:	694e                	ld	s2,208(sp)
    80004c90:	69ae                	ld	s3,200(sp)
    80004c92:	616d                	addi	sp,sp,240
    80004c94:	8082                	ret

0000000080004c96 <sys_open>:

uint64
sys_open(void)
{
    80004c96:	7131                	addi	sp,sp,-192
    80004c98:	fd06                	sd	ra,184(sp)
    80004c9a:	f922                	sd	s0,176(sp)
    80004c9c:	f526                	sd	s1,168(sp)
    80004c9e:	f14a                	sd	s2,160(sp)
    80004ca0:	ed4e                	sd	s3,152(sp)
    80004ca2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ca4:	08000613          	li	a2,128
    80004ca8:	f5040593          	addi	a1,s0,-176
    80004cac:	4501                	li	a0,0
    80004cae:	ffffd097          	auipc	ra,0xffffd
    80004cb2:	448080e7          	jalr	1096(ra) # 800020f6 <argstr>
    return -1;
    80004cb6:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cb8:	0c054163          	bltz	a0,80004d7a <sys_open+0xe4>
    80004cbc:	f4c40593          	addi	a1,s0,-180
    80004cc0:	4505                	li	a0,1
    80004cc2:	ffffd097          	auipc	ra,0xffffd
    80004cc6:	3f0080e7          	jalr	1008(ra) # 800020b2 <argint>
    80004cca:	0a054863          	bltz	a0,80004d7a <sys_open+0xe4>

  begin_op();
    80004cce:	fffff097          	auipc	ra,0xfffff
    80004cd2:	a06080e7          	jalr	-1530(ra) # 800036d4 <begin_op>

  if(omode & O_CREATE){
    80004cd6:	f4c42783          	lw	a5,-180(s0)
    80004cda:	2007f793          	andi	a5,a5,512
    80004cde:	cbdd                	beqz	a5,80004d94 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ce0:	4681                	li	a3,0
    80004ce2:	4601                	li	a2,0
    80004ce4:	4589                	li	a1,2
    80004ce6:	f5040513          	addi	a0,s0,-176
    80004cea:	00000097          	auipc	ra,0x0
    80004cee:	970080e7          	jalr	-1680(ra) # 8000465a <create>
    80004cf2:	892a                	mv	s2,a0
    if(ip == 0){
    80004cf4:	c959                	beqz	a0,80004d8a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cf6:	04491703          	lh	a4,68(s2)
    80004cfa:	478d                	li	a5,3
    80004cfc:	00f71763          	bne	a4,a5,80004d0a <sys_open+0x74>
    80004d00:	04695703          	lhu	a4,70(s2)
    80004d04:	47a5                	li	a5,9
    80004d06:	0ce7ec63          	bltu	a5,a4,80004dde <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d0a:	fffff097          	auipc	ra,0xfffff
    80004d0e:	dd6080e7          	jalr	-554(ra) # 80003ae0 <filealloc>
    80004d12:	89aa                	mv	s3,a0
    80004d14:	10050263          	beqz	a0,80004e18 <sys_open+0x182>
    80004d18:	00000097          	auipc	ra,0x0
    80004d1c:	900080e7          	jalr	-1792(ra) # 80004618 <fdalloc>
    80004d20:	84aa                	mv	s1,a0
    80004d22:	0e054663          	bltz	a0,80004e0e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d26:	04491703          	lh	a4,68(s2)
    80004d2a:	478d                	li	a5,3
    80004d2c:	0cf70463          	beq	a4,a5,80004df4 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d30:	4789                	li	a5,2
    80004d32:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d36:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d3a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d3e:	f4c42783          	lw	a5,-180(s0)
    80004d42:	0017c713          	xori	a4,a5,1
    80004d46:	8b05                	andi	a4,a4,1
    80004d48:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d4c:	0037f713          	andi	a4,a5,3
    80004d50:	00e03733          	snez	a4,a4
    80004d54:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d58:	4007f793          	andi	a5,a5,1024
    80004d5c:	c791                	beqz	a5,80004d68 <sys_open+0xd2>
    80004d5e:	04491703          	lh	a4,68(s2)
    80004d62:	4789                	li	a5,2
    80004d64:	08f70f63          	beq	a4,a5,80004e02 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d68:	854a                	mv	a0,s2
    80004d6a:	ffffe097          	auipc	ra,0xffffe
    80004d6e:	050080e7          	jalr	80(ra) # 80002dba <iunlock>
  end_op();
    80004d72:	fffff097          	auipc	ra,0xfffff
    80004d76:	9e0080e7          	jalr	-1568(ra) # 80003752 <end_op>

  return fd;
}
    80004d7a:	8526                	mv	a0,s1
    80004d7c:	70ea                	ld	ra,184(sp)
    80004d7e:	744a                	ld	s0,176(sp)
    80004d80:	74aa                	ld	s1,168(sp)
    80004d82:	790a                	ld	s2,160(sp)
    80004d84:	69ea                	ld	s3,152(sp)
    80004d86:	6129                	addi	sp,sp,192
    80004d88:	8082                	ret
      end_op();
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	9c8080e7          	jalr	-1592(ra) # 80003752 <end_op>
      return -1;
    80004d92:	b7e5                	j	80004d7a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d94:	f5040513          	addi	a0,s0,-176
    80004d98:	ffffe097          	auipc	ra,0xffffe
    80004d9c:	71c080e7          	jalr	1820(ra) # 800034b4 <namei>
    80004da0:	892a                	mv	s2,a0
    80004da2:	c905                	beqz	a0,80004dd2 <sys_open+0x13c>
    ilock(ip);
    80004da4:	ffffe097          	auipc	ra,0xffffe
    80004da8:	f54080e7          	jalr	-172(ra) # 80002cf8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dac:	04491703          	lh	a4,68(s2)
    80004db0:	4785                	li	a5,1
    80004db2:	f4f712e3          	bne	a4,a5,80004cf6 <sys_open+0x60>
    80004db6:	f4c42783          	lw	a5,-180(s0)
    80004dba:	dba1                	beqz	a5,80004d0a <sys_open+0x74>
      iunlockput(ip);
    80004dbc:	854a                	mv	a0,s2
    80004dbe:	ffffe097          	auipc	ra,0xffffe
    80004dc2:	19c080e7          	jalr	412(ra) # 80002f5a <iunlockput>
      end_op();
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	98c080e7          	jalr	-1652(ra) # 80003752 <end_op>
      return -1;
    80004dce:	54fd                	li	s1,-1
    80004dd0:	b76d                	j	80004d7a <sys_open+0xe4>
      end_op();
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	980080e7          	jalr	-1664(ra) # 80003752 <end_op>
      return -1;
    80004dda:	54fd                	li	s1,-1
    80004ddc:	bf79                	j	80004d7a <sys_open+0xe4>
    iunlockput(ip);
    80004dde:	854a                	mv	a0,s2
    80004de0:	ffffe097          	auipc	ra,0xffffe
    80004de4:	17a080e7          	jalr	378(ra) # 80002f5a <iunlockput>
    end_op();
    80004de8:	fffff097          	auipc	ra,0xfffff
    80004dec:	96a080e7          	jalr	-1686(ra) # 80003752 <end_op>
    return -1;
    80004df0:	54fd                	li	s1,-1
    80004df2:	b761                	j	80004d7a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004df4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004df8:	04691783          	lh	a5,70(s2)
    80004dfc:	02f99223          	sh	a5,36(s3)
    80004e00:	bf2d                	j	80004d3a <sys_open+0xa4>
    itrunc(ip);
    80004e02:	854a                	mv	a0,s2
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	002080e7          	jalr	2(ra) # 80002e06 <itrunc>
    80004e0c:	bfb1                	j	80004d68 <sys_open+0xd2>
      fileclose(f);
    80004e0e:	854e                	mv	a0,s3
    80004e10:	fffff097          	auipc	ra,0xfffff
    80004e14:	d8c080e7          	jalr	-628(ra) # 80003b9c <fileclose>
    iunlockput(ip);
    80004e18:	854a                	mv	a0,s2
    80004e1a:	ffffe097          	auipc	ra,0xffffe
    80004e1e:	140080e7          	jalr	320(ra) # 80002f5a <iunlockput>
    end_op();
    80004e22:	fffff097          	auipc	ra,0xfffff
    80004e26:	930080e7          	jalr	-1744(ra) # 80003752 <end_op>
    return -1;
    80004e2a:	54fd                	li	s1,-1
    80004e2c:	b7b9                	j	80004d7a <sys_open+0xe4>

0000000080004e2e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e2e:	7175                	addi	sp,sp,-144
    80004e30:	e506                	sd	ra,136(sp)
    80004e32:	e122                	sd	s0,128(sp)
    80004e34:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e36:	fffff097          	auipc	ra,0xfffff
    80004e3a:	89e080e7          	jalr	-1890(ra) # 800036d4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e3e:	08000613          	li	a2,128
    80004e42:	f7040593          	addi	a1,s0,-144
    80004e46:	4501                	li	a0,0
    80004e48:	ffffd097          	auipc	ra,0xffffd
    80004e4c:	2ae080e7          	jalr	686(ra) # 800020f6 <argstr>
    80004e50:	02054963          	bltz	a0,80004e82 <sys_mkdir+0x54>
    80004e54:	4681                	li	a3,0
    80004e56:	4601                	li	a2,0
    80004e58:	4585                	li	a1,1
    80004e5a:	f7040513          	addi	a0,s0,-144
    80004e5e:	fffff097          	auipc	ra,0xfffff
    80004e62:	7fc080e7          	jalr	2044(ra) # 8000465a <create>
    80004e66:	cd11                	beqz	a0,80004e82 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e68:	ffffe097          	auipc	ra,0xffffe
    80004e6c:	0f2080e7          	jalr	242(ra) # 80002f5a <iunlockput>
  end_op();
    80004e70:	fffff097          	auipc	ra,0xfffff
    80004e74:	8e2080e7          	jalr	-1822(ra) # 80003752 <end_op>
  return 0;
    80004e78:	4501                	li	a0,0
}
    80004e7a:	60aa                	ld	ra,136(sp)
    80004e7c:	640a                	ld	s0,128(sp)
    80004e7e:	6149                	addi	sp,sp,144
    80004e80:	8082                	ret
    end_op();
    80004e82:	fffff097          	auipc	ra,0xfffff
    80004e86:	8d0080e7          	jalr	-1840(ra) # 80003752 <end_op>
    return -1;
    80004e8a:	557d                	li	a0,-1
    80004e8c:	b7fd                	j	80004e7a <sys_mkdir+0x4c>

0000000080004e8e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e8e:	7135                	addi	sp,sp,-160
    80004e90:	ed06                	sd	ra,152(sp)
    80004e92:	e922                	sd	s0,144(sp)
    80004e94:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e96:	fffff097          	auipc	ra,0xfffff
    80004e9a:	83e080e7          	jalr	-1986(ra) # 800036d4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e9e:	08000613          	li	a2,128
    80004ea2:	f7040593          	addi	a1,s0,-144
    80004ea6:	4501                	li	a0,0
    80004ea8:	ffffd097          	auipc	ra,0xffffd
    80004eac:	24e080e7          	jalr	590(ra) # 800020f6 <argstr>
    80004eb0:	04054a63          	bltz	a0,80004f04 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004eb4:	f6c40593          	addi	a1,s0,-148
    80004eb8:	4505                	li	a0,1
    80004eba:	ffffd097          	auipc	ra,0xffffd
    80004ebe:	1f8080e7          	jalr	504(ra) # 800020b2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ec2:	04054163          	bltz	a0,80004f04 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004ec6:	f6840593          	addi	a1,s0,-152
    80004eca:	4509                	li	a0,2
    80004ecc:	ffffd097          	auipc	ra,0xffffd
    80004ed0:	1e6080e7          	jalr	486(ra) # 800020b2 <argint>
     argint(1, &major) < 0 ||
    80004ed4:	02054863          	bltz	a0,80004f04 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ed8:	f6841683          	lh	a3,-152(s0)
    80004edc:	f6c41603          	lh	a2,-148(s0)
    80004ee0:	458d                	li	a1,3
    80004ee2:	f7040513          	addi	a0,s0,-144
    80004ee6:	fffff097          	auipc	ra,0xfffff
    80004eea:	774080e7          	jalr	1908(ra) # 8000465a <create>
     argint(2, &minor) < 0 ||
    80004eee:	c919                	beqz	a0,80004f04 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ef0:	ffffe097          	auipc	ra,0xffffe
    80004ef4:	06a080e7          	jalr	106(ra) # 80002f5a <iunlockput>
  end_op();
    80004ef8:	fffff097          	auipc	ra,0xfffff
    80004efc:	85a080e7          	jalr	-1958(ra) # 80003752 <end_op>
  return 0;
    80004f00:	4501                	li	a0,0
    80004f02:	a031                	j	80004f0e <sys_mknod+0x80>
    end_op();
    80004f04:	fffff097          	auipc	ra,0xfffff
    80004f08:	84e080e7          	jalr	-1970(ra) # 80003752 <end_op>
    return -1;
    80004f0c:	557d                	li	a0,-1
}
    80004f0e:	60ea                	ld	ra,152(sp)
    80004f10:	644a                	ld	s0,144(sp)
    80004f12:	610d                	addi	sp,sp,160
    80004f14:	8082                	ret

0000000080004f16 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f16:	7135                	addi	sp,sp,-160
    80004f18:	ed06                	sd	ra,152(sp)
    80004f1a:	e922                	sd	s0,144(sp)
    80004f1c:	e526                	sd	s1,136(sp)
    80004f1e:	e14a                	sd	s2,128(sp)
    80004f20:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f22:	ffffc097          	auipc	ra,0xffffc
    80004f26:	00a080e7          	jalr	10(ra) # 80000f2c <myproc>
    80004f2a:	892a                	mv	s2,a0
  
  begin_op();
    80004f2c:	ffffe097          	auipc	ra,0xffffe
    80004f30:	7a8080e7          	jalr	1960(ra) # 800036d4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f34:	08000613          	li	a2,128
    80004f38:	f6040593          	addi	a1,s0,-160
    80004f3c:	4501                	li	a0,0
    80004f3e:	ffffd097          	auipc	ra,0xffffd
    80004f42:	1b8080e7          	jalr	440(ra) # 800020f6 <argstr>
    80004f46:	04054b63          	bltz	a0,80004f9c <sys_chdir+0x86>
    80004f4a:	f6040513          	addi	a0,s0,-160
    80004f4e:	ffffe097          	auipc	ra,0xffffe
    80004f52:	566080e7          	jalr	1382(ra) # 800034b4 <namei>
    80004f56:	84aa                	mv	s1,a0
    80004f58:	c131                	beqz	a0,80004f9c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f5a:	ffffe097          	auipc	ra,0xffffe
    80004f5e:	d9e080e7          	jalr	-610(ra) # 80002cf8 <ilock>
  if(ip->type != T_DIR){
    80004f62:	04449703          	lh	a4,68(s1)
    80004f66:	4785                	li	a5,1
    80004f68:	04f71063          	bne	a4,a5,80004fa8 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f6c:	8526                	mv	a0,s1
    80004f6e:	ffffe097          	auipc	ra,0xffffe
    80004f72:	e4c080e7          	jalr	-436(ra) # 80002dba <iunlock>
  iput(p->cwd);
    80004f76:	15093503          	ld	a0,336(s2)
    80004f7a:	ffffe097          	auipc	ra,0xffffe
    80004f7e:	f38080e7          	jalr	-200(ra) # 80002eb2 <iput>
  end_op();
    80004f82:	ffffe097          	auipc	ra,0xffffe
    80004f86:	7d0080e7          	jalr	2000(ra) # 80003752 <end_op>
  p->cwd = ip;
    80004f8a:	14993823          	sd	s1,336(s2)
  return 0;
    80004f8e:	4501                	li	a0,0
}
    80004f90:	60ea                	ld	ra,152(sp)
    80004f92:	644a                	ld	s0,144(sp)
    80004f94:	64aa                	ld	s1,136(sp)
    80004f96:	690a                	ld	s2,128(sp)
    80004f98:	610d                	addi	sp,sp,160
    80004f9a:	8082                	ret
    end_op();
    80004f9c:	ffffe097          	auipc	ra,0xffffe
    80004fa0:	7b6080e7          	jalr	1974(ra) # 80003752 <end_op>
    return -1;
    80004fa4:	557d                	li	a0,-1
    80004fa6:	b7ed                	j	80004f90 <sys_chdir+0x7a>
    iunlockput(ip);
    80004fa8:	8526                	mv	a0,s1
    80004faa:	ffffe097          	auipc	ra,0xffffe
    80004fae:	fb0080e7          	jalr	-80(ra) # 80002f5a <iunlockput>
    end_op();
    80004fb2:	ffffe097          	auipc	ra,0xffffe
    80004fb6:	7a0080e7          	jalr	1952(ra) # 80003752 <end_op>
    return -1;
    80004fba:	557d                	li	a0,-1
    80004fbc:	bfd1                	j	80004f90 <sys_chdir+0x7a>

0000000080004fbe <sys_exec>:

uint64
sys_exec(void)
{
    80004fbe:	7145                	addi	sp,sp,-464
    80004fc0:	e786                	sd	ra,456(sp)
    80004fc2:	e3a2                	sd	s0,448(sp)
    80004fc4:	ff26                	sd	s1,440(sp)
    80004fc6:	fb4a                	sd	s2,432(sp)
    80004fc8:	f74e                	sd	s3,424(sp)
    80004fca:	f352                	sd	s4,416(sp)
    80004fcc:	ef56                	sd	s5,408(sp)
    80004fce:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fd0:	08000613          	li	a2,128
    80004fd4:	f4040593          	addi	a1,s0,-192
    80004fd8:	4501                	li	a0,0
    80004fda:	ffffd097          	auipc	ra,0xffffd
    80004fde:	11c080e7          	jalr	284(ra) # 800020f6 <argstr>
    return -1;
    80004fe2:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fe4:	0c054b63          	bltz	a0,800050ba <sys_exec+0xfc>
    80004fe8:	e3840593          	addi	a1,s0,-456
    80004fec:	4505                	li	a0,1
    80004fee:	ffffd097          	auipc	ra,0xffffd
    80004ff2:	0e6080e7          	jalr	230(ra) # 800020d4 <argaddr>
    80004ff6:	0c054263          	bltz	a0,800050ba <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004ffa:	10000613          	li	a2,256
    80004ffe:	4581                	li	a1,0
    80005000:	e4040513          	addi	a0,s0,-448
    80005004:	ffffb097          	auipc	ra,0xffffb
    80005008:	176080e7          	jalr	374(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000500c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005010:	89a6                	mv	s3,s1
    80005012:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005014:	02000a13          	li	s4,32
    80005018:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000501c:	00391513          	slli	a0,s2,0x3
    80005020:	e3040593          	addi	a1,s0,-464
    80005024:	e3843783          	ld	a5,-456(s0)
    80005028:	953e                	add	a0,a0,a5
    8000502a:	ffffd097          	auipc	ra,0xffffd
    8000502e:	fee080e7          	jalr	-18(ra) # 80002018 <fetchaddr>
    80005032:	02054a63          	bltz	a0,80005066 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005036:	e3043783          	ld	a5,-464(s0)
    8000503a:	c3b9                	beqz	a5,80005080 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000503c:	ffffb097          	auipc	ra,0xffffb
    80005040:	0de080e7          	jalr	222(ra) # 8000011a <kalloc>
    80005044:	85aa                	mv	a1,a0
    80005046:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000504a:	cd11                	beqz	a0,80005066 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000504c:	6605                	lui	a2,0x1
    8000504e:	e3043503          	ld	a0,-464(s0)
    80005052:	ffffd097          	auipc	ra,0xffffd
    80005056:	018080e7          	jalr	24(ra) # 8000206a <fetchstr>
    8000505a:	00054663          	bltz	a0,80005066 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000505e:	0905                	addi	s2,s2,1
    80005060:	09a1                	addi	s3,s3,8
    80005062:	fb491be3          	bne	s2,s4,80005018 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005066:	f4040913          	addi	s2,s0,-192
    8000506a:	6088                	ld	a0,0(s1)
    8000506c:	c531                	beqz	a0,800050b8 <sys_exec+0xfa>
    kfree(argv[i]);
    8000506e:	ffffb097          	auipc	ra,0xffffb
    80005072:	fae080e7          	jalr	-82(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005076:	04a1                	addi	s1,s1,8
    80005078:	ff2499e3          	bne	s1,s2,8000506a <sys_exec+0xac>
  return -1;
    8000507c:	597d                	li	s2,-1
    8000507e:	a835                	j	800050ba <sys_exec+0xfc>
      argv[i] = 0;
    80005080:	0a8e                	slli	s5,s5,0x3
    80005082:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    80005086:	00878ab3          	add	s5,a5,s0
    8000508a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000508e:	e4040593          	addi	a1,s0,-448
    80005092:	f4040513          	addi	a0,s0,-192
    80005096:	fffff097          	auipc	ra,0xfffff
    8000509a:	15a080e7          	jalr	346(ra) # 800041f0 <exec>
    8000509e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050a0:	f4040993          	addi	s3,s0,-192
    800050a4:	6088                	ld	a0,0(s1)
    800050a6:	c911                	beqz	a0,800050ba <sys_exec+0xfc>
    kfree(argv[i]);
    800050a8:	ffffb097          	auipc	ra,0xffffb
    800050ac:	f74080e7          	jalr	-140(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b0:	04a1                	addi	s1,s1,8
    800050b2:	ff3499e3          	bne	s1,s3,800050a4 <sys_exec+0xe6>
    800050b6:	a011                	j	800050ba <sys_exec+0xfc>
  return -1;
    800050b8:	597d                	li	s2,-1
}
    800050ba:	854a                	mv	a0,s2
    800050bc:	60be                	ld	ra,456(sp)
    800050be:	641e                	ld	s0,448(sp)
    800050c0:	74fa                	ld	s1,440(sp)
    800050c2:	795a                	ld	s2,432(sp)
    800050c4:	79ba                	ld	s3,424(sp)
    800050c6:	7a1a                	ld	s4,416(sp)
    800050c8:	6afa                	ld	s5,408(sp)
    800050ca:	6179                	addi	sp,sp,464
    800050cc:	8082                	ret

00000000800050ce <sys_pipe>:

uint64
sys_pipe(void)
{
    800050ce:	7139                	addi	sp,sp,-64
    800050d0:	fc06                	sd	ra,56(sp)
    800050d2:	f822                	sd	s0,48(sp)
    800050d4:	f426                	sd	s1,40(sp)
    800050d6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050d8:	ffffc097          	auipc	ra,0xffffc
    800050dc:	e54080e7          	jalr	-428(ra) # 80000f2c <myproc>
    800050e0:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050e2:	fd840593          	addi	a1,s0,-40
    800050e6:	4501                	li	a0,0
    800050e8:	ffffd097          	auipc	ra,0xffffd
    800050ec:	fec080e7          	jalr	-20(ra) # 800020d4 <argaddr>
    return -1;
    800050f0:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050f2:	0e054063          	bltz	a0,800051d2 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050f6:	fc840593          	addi	a1,s0,-56
    800050fa:	fd040513          	addi	a0,s0,-48
    800050fe:	fffff097          	auipc	ra,0xfffff
    80005102:	dce080e7          	jalr	-562(ra) # 80003ecc <pipealloc>
    return -1;
    80005106:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005108:	0c054563          	bltz	a0,800051d2 <sys_pipe+0x104>
  fd0 = -1;
    8000510c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005110:	fd043503          	ld	a0,-48(s0)
    80005114:	fffff097          	auipc	ra,0xfffff
    80005118:	504080e7          	jalr	1284(ra) # 80004618 <fdalloc>
    8000511c:	fca42223          	sw	a0,-60(s0)
    80005120:	08054c63          	bltz	a0,800051b8 <sys_pipe+0xea>
    80005124:	fc843503          	ld	a0,-56(s0)
    80005128:	fffff097          	auipc	ra,0xfffff
    8000512c:	4f0080e7          	jalr	1264(ra) # 80004618 <fdalloc>
    80005130:	fca42023          	sw	a0,-64(s0)
    80005134:	06054963          	bltz	a0,800051a6 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005138:	4691                	li	a3,4
    8000513a:	fc440613          	addi	a2,s0,-60
    8000513e:	fd843583          	ld	a1,-40(s0)
    80005142:	68a8                	ld	a0,80(s1)
    80005144:	ffffc097          	auipc	ra,0xffffc
    80005148:	9c4080e7          	jalr	-1596(ra) # 80000b08 <copyout>
    8000514c:	02054063          	bltz	a0,8000516c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005150:	4691                	li	a3,4
    80005152:	fc040613          	addi	a2,s0,-64
    80005156:	fd843583          	ld	a1,-40(s0)
    8000515a:	0591                	addi	a1,a1,4
    8000515c:	68a8                	ld	a0,80(s1)
    8000515e:	ffffc097          	auipc	ra,0xffffc
    80005162:	9aa080e7          	jalr	-1622(ra) # 80000b08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005166:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005168:	06055563          	bgez	a0,800051d2 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000516c:	fc442783          	lw	a5,-60(s0)
    80005170:	07e9                	addi	a5,a5,26
    80005172:	078e                	slli	a5,a5,0x3
    80005174:	97a6                	add	a5,a5,s1
    80005176:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000517a:	fc042783          	lw	a5,-64(s0)
    8000517e:	07e9                	addi	a5,a5,26
    80005180:	078e                	slli	a5,a5,0x3
    80005182:	00f48533          	add	a0,s1,a5
    80005186:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000518a:	fd043503          	ld	a0,-48(s0)
    8000518e:	fffff097          	auipc	ra,0xfffff
    80005192:	a0e080e7          	jalr	-1522(ra) # 80003b9c <fileclose>
    fileclose(wf);
    80005196:	fc843503          	ld	a0,-56(s0)
    8000519a:	fffff097          	auipc	ra,0xfffff
    8000519e:	a02080e7          	jalr	-1534(ra) # 80003b9c <fileclose>
    return -1;
    800051a2:	57fd                	li	a5,-1
    800051a4:	a03d                	j	800051d2 <sys_pipe+0x104>
    if(fd0 >= 0)
    800051a6:	fc442783          	lw	a5,-60(s0)
    800051aa:	0007c763          	bltz	a5,800051b8 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051ae:	07e9                	addi	a5,a5,26
    800051b0:	078e                	slli	a5,a5,0x3
    800051b2:	97a6                	add	a5,a5,s1
    800051b4:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800051b8:	fd043503          	ld	a0,-48(s0)
    800051bc:	fffff097          	auipc	ra,0xfffff
    800051c0:	9e0080e7          	jalr	-1568(ra) # 80003b9c <fileclose>
    fileclose(wf);
    800051c4:	fc843503          	ld	a0,-56(s0)
    800051c8:	fffff097          	auipc	ra,0xfffff
    800051cc:	9d4080e7          	jalr	-1580(ra) # 80003b9c <fileclose>
    return -1;
    800051d0:	57fd                	li	a5,-1
}
    800051d2:	853e                	mv	a0,a5
    800051d4:	70e2                	ld	ra,56(sp)
    800051d6:	7442                	ld	s0,48(sp)
    800051d8:	74a2                	ld	s1,40(sp)
    800051da:	6121                	addi	sp,sp,64
    800051dc:	8082                	ret
	...

00000000800051e0 <kernelvec>:
    800051e0:	7111                	addi	sp,sp,-256
    800051e2:	e006                	sd	ra,0(sp)
    800051e4:	e40a                	sd	sp,8(sp)
    800051e6:	e80e                	sd	gp,16(sp)
    800051e8:	ec12                	sd	tp,24(sp)
    800051ea:	f016                	sd	t0,32(sp)
    800051ec:	f41a                	sd	t1,40(sp)
    800051ee:	f81e                	sd	t2,48(sp)
    800051f0:	fc22                	sd	s0,56(sp)
    800051f2:	e0a6                	sd	s1,64(sp)
    800051f4:	e4aa                	sd	a0,72(sp)
    800051f6:	e8ae                	sd	a1,80(sp)
    800051f8:	ecb2                	sd	a2,88(sp)
    800051fa:	f0b6                	sd	a3,96(sp)
    800051fc:	f4ba                	sd	a4,104(sp)
    800051fe:	f8be                	sd	a5,112(sp)
    80005200:	fcc2                	sd	a6,120(sp)
    80005202:	e146                	sd	a7,128(sp)
    80005204:	e54a                	sd	s2,136(sp)
    80005206:	e94e                	sd	s3,144(sp)
    80005208:	ed52                	sd	s4,152(sp)
    8000520a:	f156                	sd	s5,160(sp)
    8000520c:	f55a                	sd	s6,168(sp)
    8000520e:	f95e                	sd	s7,176(sp)
    80005210:	fd62                	sd	s8,184(sp)
    80005212:	e1e6                	sd	s9,192(sp)
    80005214:	e5ea                	sd	s10,200(sp)
    80005216:	e9ee                	sd	s11,208(sp)
    80005218:	edf2                	sd	t3,216(sp)
    8000521a:	f1f6                	sd	t4,224(sp)
    8000521c:	f5fa                	sd	t5,232(sp)
    8000521e:	f9fe                	sd	t6,240(sp)
    80005220:	cc5fc0ef          	jal	ra,80001ee4 <kerneltrap>
    80005224:	6082                	ld	ra,0(sp)
    80005226:	6122                	ld	sp,8(sp)
    80005228:	61c2                	ld	gp,16(sp)
    8000522a:	7282                	ld	t0,32(sp)
    8000522c:	7322                	ld	t1,40(sp)
    8000522e:	73c2                	ld	t2,48(sp)
    80005230:	7462                	ld	s0,56(sp)
    80005232:	6486                	ld	s1,64(sp)
    80005234:	6526                	ld	a0,72(sp)
    80005236:	65c6                	ld	a1,80(sp)
    80005238:	6666                	ld	a2,88(sp)
    8000523a:	7686                	ld	a3,96(sp)
    8000523c:	7726                	ld	a4,104(sp)
    8000523e:	77c6                	ld	a5,112(sp)
    80005240:	7866                	ld	a6,120(sp)
    80005242:	688a                	ld	a7,128(sp)
    80005244:	692a                	ld	s2,136(sp)
    80005246:	69ca                	ld	s3,144(sp)
    80005248:	6a6a                	ld	s4,152(sp)
    8000524a:	7a8a                	ld	s5,160(sp)
    8000524c:	7b2a                	ld	s6,168(sp)
    8000524e:	7bca                	ld	s7,176(sp)
    80005250:	7c6a                	ld	s8,184(sp)
    80005252:	6c8e                	ld	s9,192(sp)
    80005254:	6d2e                	ld	s10,200(sp)
    80005256:	6dce                	ld	s11,208(sp)
    80005258:	6e6e                	ld	t3,216(sp)
    8000525a:	7e8e                	ld	t4,224(sp)
    8000525c:	7f2e                	ld	t5,232(sp)
    8000525e:	7fce                	ld	t6,240(sp)
    80005260:	6111                	addi	sp,sp,256
    80005262:	10200073          	sret
    80005266:	00000013          	nop
    8000526a:	00000013          	nop
    8000526e:	0001                	nop

0000000080005270 <timervec>:
    80005270:	34051573          	csrrw	a0,mscratch,a0
    80005274:	e10c                	sd	a1,0(a0)
    80005276:	e510                	sd	a2,8(a0)
    80005278:	e914                	sd	a3,16(a0)
    8000527a:	6d0c                	ld	a1,24(a0)
    8000527c:	7110                	ld	a2,32(a0)
    8000527e:	6194                	ld	a3,0(a1)
    80005280:	96b2                	add	a3,a3,a2
    80005282:	e194                	sd	a3,0(a1)
    80005284:	4589                	li	a1,2
    80005286:	14459073          	csrw	sip,a1
    8000528a:	6914                	ld	a3,16(a0)
    8000528c:	6510                	ld	a2,8(a0)
    8000528e:	610c                	ld	a1,0(a0)
    80005290:	34051573          	csrrw	a0,mscratch,a0
    80005294:	30200073          	mret
	...

000000008000529a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000529a:	1141                	addi	sp,sp,-16
    8000529c:	e422                	sd	s0,8(sp)
    8000529e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052a0:	0c0007b7          	lui	a5,0xc000
    800052a4:	4705                	li	a4,1
    800052a6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052a8:	c3d8                	sw	a4,4(a5)
}
    800052aa:	6422                	ld	s0,8(sp)
    800052ac:	0141                	addi	sp,sp,16
    800052ae:	8082                	ret

00000000800052b0 <plicinithart>:

void
plicinithart(void)
{
    800052b0:	1141                	addi	sp,sp,-16
    800052b2:	e406                	sd	ra,8(sp)
    800052b4:	e022                	sd	s0,0(sp)
    800052b6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052b8:	ffffc097          	auipc	ra,0xffffc
    800052bc:	c48080e7          	jalr	-952(ra) # 80000f00 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052c0:	0085171b          	slliw	a4,a0,0x8
    800052c4:	0c0027b7          	lui	a5,0xc002
    800052c8:	97ba                	add	a5,a5,a4
    800052ca:	40200713          	li	a4,1026
    800052ce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052d2:	00d5151b          	slliw	a0,a0,0xd
    800052d6:	0c2017b7          	lui	a5,0xc201
    800052da:	97aa                	add	a5,a5,a0
    800052dc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052e0:	60a2                	ld	ra,8(sp)
    800052e2:	6402                	ld	s0,0(sp)
    800052e4:	0141                	addi	sp,sp,16
    800052e6:	8082                	ret

00000000800052e8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052e8:	1141                	addi	sp,sp,-16
    800052ea:	e406                	sd	ra,8(sp)
    800052ec:	e022                	sd	s0,0(sp)
    800052ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052f0:	ffffc097          	auipc	ra,0xffffc
    800052f4:	c10080e7          	jalr	-1008(ra) # 80000f00 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052f8:	00d5151b          	slliw	a0,a0,0xd
    800052fc:	0c2017b7          	lui	a5,0xc201
    80005300:	97aa                	add	a5,a5,a0
  return irq;
}
    80005302:	43c8                	lw	a0,4(a5)
    80005304:	60a2                	ld	ra,8(sp)
    80005306:	6402                	ld	s0,0(sp)
    80005308:	0141                	addi	sp,sp,16
    8000530a:	8082                	ret

000000008000530c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000530c:	1101                	addi	sp,sp,-32
    8000530e:	ec06                	sd	ra,24(sp)
    80005310:	e822                	sd	s0,16(sp)
    80005312:	e426                	sd	s1,8(sp)
    80005314:	1000                	addi	s0,sp,32
    80005316:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005318:	ffffc097          	auipc	ra,0xffffc
    8000531c:	be8080e7          	jalr	-1048(ra) # 80000f00 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005320:	00d5151b          	slliw	a0,a0,0xd
    80005324:	0c2017b7          	lui	a5,0xc201
    80005328:	97aa                	add	a5,a5,a0
    8000532a:	c3c4                	sw	s1,4(a5)
}
    8000532c:	60e2                	ld	ra,24(sp)
    8000532e:	6442                	ld	s0,16(sp)
    80005330:	64a2                	ld	s1,8(sp)
    80005332:	6105                	addi	sp,sp,32
    80005334:	8082                	ret

0000000080005336 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005336:	1141                	addi	sp,sp,-16
    80005338:	e406                	sd	ra,8(sp)
    8000533a:	e022                	sd	s0,0(sp)
    8000533c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000533e:	479d                	li	a5,7
    80005340:	06a7c863          	blt	a5,a0,800053b0 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005344:	00016717          	auipc	a4,0x16
    80005348:	cbc70713          	addi	a4,a4,-836 # 8001b000 <disk>
    8000534c:	972a                	add	a4,a4,a0
    8000534e:	6789                	lui	a5,0x2
    80005350:	97ba                	add	a5,a5,a4
    80005352:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005356:	e7ad                	bnez	a5,800053c0 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005358:	00451793          	slli	a5,a0,0x4
    8000535c:	00018717          	auipc	a4,0x18
    80005360:	ca470713          	addi	a4,a4,-860 # 8001d000 <disk+0x2000>
    80005364:	6314                	ld	a3,0(a4)
    80005366:	96be                	add	a3,a3,a5
    80005368:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000536c:	6314                	ld	a3,0(a4)
    8000536e:	96be                	add	a3,a3,a5
    80005370:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005374:	6314                	ld	a3,0(a4)
    80005376:	96be                	add	a3,a3,a5
    80005378:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000537c:	6318                	ld	a4,0(a4)
    8000537e:	97ba                	add	a5,a5,a4
    80005380:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005384:	00016717          	auipc	a4,0x16
    80005388:	c7c70713          	addi	a4,a4,-900 # 8001b000 <disk>
    8000538c:	972a                	add	a4,a4,a0
    8000538e:	6789                	lui	a5,0x2
    80005390:	97ba                	add	a5,a5,a4
    80005392:	4705                	li	a4,1
    80005394:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005398:	00018517          	auipc	a0,0x18
    8000539c:	c8050513          	addi	a0,a0,-896 # 8001d018 <disk+0x2018>
    800053a0:	ffffc097          	auipc	ra,0xffffc
    800053a4:	4ac080e7          	jalr	1196(ra) # 8000184c <wakeup>
}
    800053a8:	60a2                	ld	ra,8(sp)
    800053aa:	6402                	ld	s0,0(sp)
    800053ac:	0141                	addi	sp,sp,16
    800053ae:	8082                	ret
    panic("free_desc 1");
    800053b0:	00003517          	auipc	a0,0x3
    800053b4:	3e050513          	addi	a0,a0,992 # 80008790 <syscalls+0x368>
    800053b8:	00001097          	auipc	ra,0x1
    800053bc:	9c8080e7          	jalr	-1592(ra) # 80005d80 <panic>
    panic("free_desc 2");
    800053c0:	00003517          	auipc	a0,0x3
    800053c4:	3e050513          	addi	a0,a0,992 # 800087a0 <syscalls+0x378>
    800053c8:	00001097          	auipc	ra,0x1
    800053cc:	9b8080e7          	jalr	-1608(ra) # 80005d80 <panic>

00000000800053d0 <virtio_disk_init>:
{
    800053d0:	1101                	addi	sp,sp,-32
    800053d2:	ec06                	sd	ra,24(sp)
    800053d4:	e822                	sd	s0,16(sp)
    800053d6:	e426                	sd	s1,8(sp)
    800053d8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053da:	00003597          	auipc	a1,0x3
    800053de:	3d658593          	addi	a1,a1,982 # 800087b0 <syscalls+0x388>
    800053e2:	00018517          	auipc	a0,0x18
    800053e6:	d4650513          	addi	a0,a0,-698 # 8001d128 <disk+0x2128>
    800053ea:	00001097          	auipc	ra,0x1
    800053ee:	e3e080e7          	jalr	-450(ra) # 80006228 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053f2:	100017b7          	lui	a5,0x10001
    800053f6:	4398                	lw	a4,0(a5)
    800053f8:	2701                	sext.w	a4,a4
    800053fa:	747277b7          	lui	a5,0x74727
    800053fe:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005402:	0ef71063          	bne	a4,a5,800054e2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	43dc                	lw	a5,4(a5)
    8000540c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000540e:	4705                	li	a4,1
    80005410:	0ce79963          	bne	a5,a4,800054e2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005414:	100017b7          	lui	a5,0x10001
    80005418:	479c                	lw	a5,8(a5)
    8000541a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000541c:	4709                	li	a4,2
    8000541e:	0ce79263          	bne	a5,a4,800054e2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005422:	100017b7          	lui	a5,0x10001
    80005426:	47d8                	lw	a4,12(a5)
    80005428:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000542a:	554d47b7          	lui	a5,0x554d4
    8000542e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005432:	0af71863          	bne	a4,a5,800054e2 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005436:	100017b7          	lui	a5,0x10001
    8000543a:	4705                	li	a4,1
    8000543c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000543e:	470d                	li	a4,3
    80005440:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005442:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005444:	c7ffe6b7          	lui	a3,0xc7ffe
    80005448:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000544c:	8f75                	and	a4,a4,a3
    8000544e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005450:	472d                	li	a4,11
    80005452:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005454:	473d                	li	a4,15
    80005456:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005458:	6705                	lui	a4,0x1
    8000545a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000545c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005460:	5bdc                	lw	a5,52(a5)
    80005462:	2781                	sext.w	a5,a5
  if(max == 0)
    80005464:	c7d9                	beqz	a5,800054f2 <virtio_disk_init+0x122>
  if(max < NUM)
    80005466:	471d                	li	a4,7
    80005468:	08f77d63          	bgeu	a4,a5,80005502 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000546c:	100014b7          	lui	s1,0x10001
    80005470:	47a1                	li	a5,8
    80005472:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005474:	6609                	lui	a2,0x2
    80005476:	4581                	li	a1,0
    80005478:	00016517          	auipc	a0,0x16
    8000547c:	b8850513          	addi	a0,a0,-1144 # 8001b000 <disk>
    80005480:	ffffb097          	auipc	ra,0xffffb
    80005484:	cfa080e7          	jalr	-774(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005488:	00016717          	auipc	a4,0x16
    8000548c:	b7870713          	addi	a4,a4,-1160 # 8001b000 <disk>
    80005490:	00c75793          	srli	a5,a4,0xc
    80005494:	2781                	sext.w	a5,a5
    80005496:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005498:	00018797          	auipc	a5,0x18
    8000549c:	b6878793          	addi	a5,a5,-1176 # 8001d000 <disk+0x2000>
    800054a0:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054a2:	00016717          	auipc	a4,0x16
    800054a6:	bde70713          	addi	a4,a4,-1058 # 8001b080 <disk+0x80>
    800054aa:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054ac:	00017717          	auipc	a4,0x17
    800054b0:	b5470713          	addi	a4,a4,-1196 # 8001c000 <disk+0x1000>
    800054b4:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054b6:	4705                	li	a4,1
    800054b8:	00e78c23          	sb	a4,24(a5)
    800054bc:	00e78ca3          	sb	a4,25(a5)
    800054c0:	00e78d23          	sb	a4,26(a5)
    800054c4:	00e78da3          	sb	a4,27(a5)
    800054c8:	00e78e23          	sb	a4,28(a5)
    800054cc:	00e78ea3          	sb	a4,29(a5)
    800054d0:	00e78f23          	sb	a4,30(a5)
    800054d4:	00e78fa3          	sb	a4,31(a5)
}
    800054d8:	60e2                	ld	ra,24(sp)
    800054da:	6442                	ld	s0,16(sp)
    800054dc:	64a2                	ld	s1,8(sp)
    800054de:	6105                	addi	sp,sp,32
    800054e0:	8082                	ret
    panic("could not find virtio disk");
    800054e2:	00003517          	auipc	a0,0x3
    800054e6:	2de50513          	addi	a0,a0,734 # 800087c0 <syscalls+0x398>
    800054ea:	00001097          	auipc	ra,0x1
    800054ee:	896080e7          	jalr	-1898(ra) # 80005d80 <panic>
    panic("virtio disk has no queue 0");
    800054f2:	00003517          	auipc	a0,0x3
    800054f6:	2ee50513          	addi	a0,a0,750 # 800087e0 <syscalls+0x3b8>
    800054fa:	00001097          	auipc	ra,0x1
    800054fe:	886080e7          	jalr	-1914(ra) # 80005d80 <panic>
    panic("virtio disk max queue too short");
    80005502:	00003517          	auipc	a0,0x3
    80005506:	2fe50513          	addi	a0,a0,766 # 80008800 <syscalls+0x3d8>
    8000550a:	00001097          	auipc	ra,0x1
    8000550e:	876080e7          	jalr	-1930(ra) # 80005d80 <panic>

0000000080005512 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005512:	7119                	addi	sp,sp,-128
    80005514:	fc86                	sd	ra,120(sp)
    80005516:	f8a2                	sd	s0,112(sp)
    80005518:	f4a6                	sd	s1,104(sp)
    8000551a:	f0ca                	sd	s2,96(sp)
    8000551c:	ecce                	sd	s3,88(sp)
    8000551e:	e8d2                	sd	s4,80(sp)
    80005520:	e4d6                	sd	s5,72(sp)
    80005522:	e0da                	sd	s6,64(sp)
    80005524:	fc5e                	sd	s7,56(sp)
    80005526:	f862                	sd	s8,48(sp)
    80005528:	f466                	sd	s9,40(sp)
    8000552a:	f06a                	sd	s10,32(sp)
    8000552c:	ec6e                	sd	s11,24(sp)
    8000552e:	0100                	addi	s0,sp,128
    80005530:	8aaa                	mv	s5,a0
    80005532:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005534:	00c52c83          	lw	s9,12(a0)
    80005538:	001c9c9b          	slliw	s9,s9,0x1
    8000553c:	1c82                	slli	s9,s9,0x20
    8000553e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005542:	00018517          	auipc	a0,0x18
    80005546:	be650513          	addi	a0,a0,-1050 # 8001d128 <disk+0x2128>
    8000554a:	00001097          	auipc	ra,0x1
    8000554e:	d6e080e7          	jalr	-658(ra) # 800062b8 <acquire>
  for(int i = 0; i < 3; i++){
    80005552:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005554:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005556:	00016c17          	auipc	s8,0x16
    8000555a:	aaac0c13          	addi	s8,s8,-1366 # 8001b000 <disk>
    8000555e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005560:	4b0d                	li	s6,3
    80005562:	a0ad                	j	800055cc <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005564:	00fc0733          	add	a4,s8,a5
    80005568:	975e                	add	a4,a4,s7
    8000556a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000556e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005570:	0207c563          	bltz	a5,8000559a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005574:	2905                	addiw	s2,s2,1
    80005576:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005578:	19690c63          	beq	s2,s6,80005710 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000557c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000557e:	00018717          	auipc	a4,0x18
    80005582:	a9a70713          	addi	a4,a4,-1382 # 8001d018 <disk+0x2018>
    80005586:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005588:	00074683          	lbu	a3,0(a4)
    8000558c:	fee1                	bnez	a3,80005564 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000558e:	2785                	addiw	a5,a5,1
    80005590:	0705                	addi	a4,a4,1
    80005592:	fe979be3          	bne	a5,s1,80005588 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005596:	57fd                	li	a5,-1
    80005598:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000559a:	01205d63          	blez	s2,800055b4 <virtio_disk_rw+0xa2>
    8000559e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800055a0:	000a2503          	lw	a0,0(s4)
    800055a4:	00000097          	auipc	ra,0x0
    800055a8:	d92080e7          	jalr	-622(ra) # 80005336 <free_desc>
      for(int j = 0; j < i; j++)
    800055ac:	2d85                	addiw	s11,s11,1
    800055ae:	0a11                	addi	s4,s4,4
    800055b0:	ff2d98e3          	bne	s11,s2,800055a0 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055b4:	00018597          	auipc	a1,0x18
    800055b8:	b7458593          	addi	a1,a1,-1164 # 8001d128 <disk+0x2128>
    800055bc:	00018517          	auipc	a0,0x18
    800055c0:	a5c50513          	addi	a0,a0,-1444 # 8001d018 <disk+0x2018>
    800055c4:	ffffc097          	auipc	ra,0xffffc
    800055c8:	0fc080e7          	jalr	252(ra) # 800016c0 <sleep>
  for(int i = 0; i < 3; i++){
    800055cc:	f8040a13          	addi	s4,s0,-128
{
    800055d0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800055d2:	894e                	mv	s2,s3
    800055d4:	b765                	j	8000557c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055d6:	00018697          	auipc	a3,0x18
    800055da:	a2a6b683          	ld	a3,-1494(a3) # 8001d000 <disk+0x2000>
    800055de:	96ba                	add	a3,a3,a4
    800055e0:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055e4:	00016817          	auipc	a6,0x16
    800055e8:	a1c80813          	addi	a6,a6,-1508 # 8001b000 <disk>
    800055ec:	00018697          	auipc	a3,0x18
    800055f0:	a1468693          	addi	a3,a3,-1516 # 8001d000 <disk+0x2000>
    800055f4:	6290                	ld	a2,0(a3)
    800055f6:	963a                	add	a2,a2,a4
    800055f8:	00c65583          	lhu	a1,12(a2)
    800055fc:	0015e593          	ori	a1,a1,1
    80005600:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005604:	f8842603          	lw	a2,-120(s0)
    80005608:	628c                	ld	a1,0(a3)
    8000560a:	972e                	add	a4,a4,a1
    8000560c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005610:	20050593          	addi	a1,a0,512
    80005614:	0592                	slli	a1,a1,0x4
    80005616:	95c2                	add	a1,a1,a6
    80005618:	577d                	li	a4,-1
    8000561a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000561e:	00461713          	slli	a4,a2,0x4
    80005622:	6290                	ld	a2,0(a3)
    80005624:	963a                	add	a2,a2,a4
    80005626:	03078793          	addi	a5,a5,48
    8000562a:	97c2                	add	a5,a5,a6
    8000562c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000562e:	629c                	ld	a5,0(a3)
    80005630:	97ba                	add	a5,a5,a4
    80005632:	4605                	li	a2,1
    80005634:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005636:	629c                	ld	a5,0(a3)
    80005638:	97ba                	add	a5,a5,a4
    8000563a:	4809                	li	a6,2
    8000563c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005640:	629c                	ld	a5,0(a3)
    80005642:	97ba                	add	a5,a5,a4
    80005644:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005648:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000564c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005650:	6698                	ld	a4,8(a3)
    80005652:	00275783          	lhu	a5,2(a4)
    80005656:	8b9d                	andi	a5,a5,7
    80005658:	0786                	slli	a5,a5,0x1
    8000565a:	973e                	add	a4,a4,a5
    8000565c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005660:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005664:	6698                	ld	a4,8(a3)
    80005666:	00275783          	lhu	a5,2(a4)
    8000566a:	2785                	addiw	a5,a5,1
    8000566c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005670:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005674:	100017b7          	lui	a5,0x10001
    80005678:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000567c:	004aa783          	lw	a5,4(s5)
    80005680:	02c79163          	bne	a5,a2,800056a2 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005684:	00018917          	auipc	s2,0x18
    80005688:	aa490913          	addi	s2,s2,-1372 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    8000568c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000568e:	85ca                	mv	a1,s2
    80005690:	8556                	mv	a0,s5
    80005692:	ffffc097          	auipc	ra,0xffffc
    80005696:	02e080e7          	jalr	46(ra) # 800016c0 <sleep>
  while(b->disk == 1) {
    8000569a:	004aa783          	lw	a5,4(s5)
    8000569e:	fe9788e3          	beq	a5,s1,8000568e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800056a2:	f8042903          	lw	s2,-128(s0)
    800056a6:	20090713          	addi	a4,s2,512
    800056aa:	0712                	slli	a4,a4,0x4
    800056ac:	00016797          	auipc	a5,0x16
    800056b0:	95478793          	addi	a5,a5,-1708 # 8001b000 <disk>
    800056b4:	97ba                	add	a5,a5,a4
    800056b6:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056ba:	00018997          	auipc	s3,0x18
    800056be:	94698993          	addi	s3,s3,-1722 # 8001d000 <disk+0x2000>
    800056c2:	00491713          	slli	a4,s2,0x4
    800056c6:	0009b783          	ld	a5,0(s3)
    800056ca:	97ba                	add	a5,a5,a4
    800056cc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056d0:	854a                	mv	a0,s2
    800056d2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056d6:	00000097          	auipc	ra,0x0
    800056da:	c60080e7          	jalr	-928(ra) # 80005336 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056de:	8885                	andi	s1,s1,1
    800056e0:	f0ed                	bnez	s1,800056c2 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056e2:	00018517          	auipc	a0,0x18
    800056e6:	a4650513          	addi	a0,a0,-1466 # 8001d128 <disk+0x2128>
    800056ea:	00001097          	auipc	ra,0x1
    800056ee:	c82080e7          	jalr	-894(ra) # 8000636c <release>
}
    800056f2:	70e6                	ld	ra,120(sp)
    800056f4:	7446                	ld	s0,112(sp)
    800056f6:	74a6                	ld	s1,104(sp)
    800056f8:	7906                	ld	s2,96(sp)
    800056fa:	69e6                	ld	s3,88(sp)
    800056fc:	6a46                	ld	s4,80(sp)
    800056fe:	6aa6                	ld	s5,72(sp)
    80005700:	6b06                	ld	s6,64(sp)
    80005702:	7be2                	ld	s7,56(sp)
    80005704:	7c42                	ld	s8,48(sp)
    80005706:	7ca2                	ld	s9,40(sp)
    80005708:	7d02                	ld	s10,32(sp)
    8000570a:	6de2                	ld	s11,24(sp)
    8000570c:	6109                	addi	sp,sp,128
    8000570e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005710:	f8042503          	lw	a0,-128(s0)
    80005714:	20050793          	addi	a5,a0,512
    80005718:	0792                	slli	a5,a5,0x4
  if(write)
    8000571a:	00016817          	auipc	a6,0x16
    8000571e:	8e680813          	addi	a6,a6,-1818 # 8001b000 <disk>
    80005722:	00f80733          	add	a4,a6,a5
    80005726:	01a036b3          	snez	a3,s10
    8000572a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000572e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005732:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005736:	7679                	lui	a2,0xffffe
    80005738:	963e                	add	a2,a2,a5
    8000573a:	00018697          	auipc	a3,0x18
    8000573e:	8c668693          	addi	a3,a3,-1850 # 8001d000 <disk+0x2000>
    80005742:	6298                	ld	a4,0(a3)
    80005744:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005746:	0a878593          	addi	a1,a5,168
    8000574a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000574c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000574e:	6298                	ld	a4,0(a3)
    80005750:	9732                	add	a4,a4,a2
    80005752:	45c1                	li	a1,16
    80005754:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005756:	6298                	ld	a4,0(a3)
    80005758:	9732                	add	a4,a4,a2
    8000575a:	4585                	li	a1,1
    8000575c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005760:	f8442703          	lw	a4,-124(s0)
    80005764:	628c                	ld	a1,0(a3)
    80005766:	962e                	add	a2,a2,a1
    80005768:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000576c:	0712                	slli	a4,a4,0x4
    8000576e:	6290                	ld	a2,0(a3)
    80005770:	963a                	add	a2,a2,a4
    80005772:	058a8593          	addi	a1,s5,88
    80005776:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005778:	6294                	ld	a3,0(a3)
    8000577a:	96ba                	add	a3,a3,a4
    8000577c:	40000613          	li	a2,1024
    80005780:	c690                	sw	a2,8(a3)
  if(write)
    80005782:	e40d1ae3          	bnez	s10,800055d6 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005786:	00018697          	auipc	a3,0x18
    8000578a:	87a6b683          	ld	a3,-1926(a3) # 8001d000 <disk+0x2000>
    8000578e:	96ba                	add	a3,a3,a4
    80005790:	4609                	li	a2,2
    80005792:	00c69623          	sh	a2,12(a3)
    80005796:	b5b9                	j	800055e4 <virtio_disk_rw+0xd2>

0000000080005798 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005798:	1101                	addi	sp,sp,-32
    8000579a:	ec06                	sd	ra,24(sp)
    8000579c:	e822                	sd	s0,16(sp)
    8000579e:	e426                	sd	s1,8(sp)
    800057a0:	e04a                	sd	s2,0(sp)
    800057a2:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057a4:	00018517          	auipc	a0,0x18
    800057a8:	98450513          	addi	a0,a0,-1660 # 8001d128 <disk+0x2128>
    800057ac:	00001097          	auipc	ra,0x1
    800057b0:	b0c080e7          	jalr	-1268(ra) # 800062b8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057b4:	10001737          	lui	a4,0x10001
    800057b8:	533c                	lw	a5,96(a4)
    800057ba:	8b8d                	andi	a5,a5,3
    800057bc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057be:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057c2:	00018797          	auipc	a5,0x18
    800057c6:	83e78793          	addi	a5,a5,-1986 # 8001d000 <disk+0x2000>
    800057ca:	6b94                	ld	a3,16(a5)
    800057cc:	0207d703          	lhu	a4,32(a5)
    800057d0:	0026d783          	lhu	a5,2(a3)
    800057d4:	06f70163          	beq	a4,a5,80005836 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057d8:	00016917          	auipc	s2,0x16
    800057dc:	82890913          	addi	s2,s2,-2008 # 8001b000 <disk>
    800057e0:	00018497          	auipc	s1,0x18
    800057e4:	82048493          	addi	s1,s1,-2016 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800057e8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057ec:	6898                	ld	a4,16(s1)
    800057ee:	0204d783          	lhu	a5,32(s1)
    800057f2:	8b9d                	andi	a5,a5,7
    800057f4:	078e                	slli	a5,a5,0x3
    800057f6:	97ba                	add	a5,a5,a4
    800057f8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057fa:	20078713          	addi	a4,a5,512
    800057fe:	0712                	slli	a4,a4,0x4
    80005800:	974a                	add	a4,a4,s2
    80005802:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005806:	e731                	bnez	a4,80005852 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005808:	20078793          	addi	a5,a5,512
    8000580c:	0792                	slli	a5,a5,0x4
    8000580e:	97ca                	add	a5,a5,s2
    80005810:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005812:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005816:	ffffc097          	auipc	ra,0xffffc
    8000581a:	036080e7          	jalr	54(ra) # 8000184c <wakeup>

    disk.used_idx += 1;
    8000581e:	0204d783          	lhu	a5,32(s1)
    80005822:	2785                	addiw	a5,a5,1
    80005824:	17c2                	slli	a5,a5,0x30
    80005826:	93c1                	srli	a5,a5,0x30
    80005828:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000582c:	6898                	ld	a4,16(s1)
    8000582e:	00275703          	lhu	a4,2(a4)
    80005832:	faf71be3          	bne	a4,a5,800057e8 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005836:	00018517          	auipc	a0,0x18
    8000583a:	8f250513          	addi	a0,a0,-1806 # 8001d128 <disk+0x2128>
    8000583e:	00001097          	auipc	ra,0x1
    80005842:	b2e080e7          	jalr	-1234(ra) # 8000636c <release>
}
    80005846:	60e2                	ld	ra,24(sp)
    80005848:	6442                	ld	s0,16(sp)
    8000584a:	64a2                	ld	s1,8(sp)
    8000584c:	6902                	ld	s2,0(sp)
    8000584e:	6105                	addi	sp,sp,32
    80005850:	8082                	ret
      panic("virtio_disk_intr status");
    80005852:	00003517          	auipc	a0,0x3
    80005856:	fce50513          	addi	a0,a0,-50 # 80008820 <syscalls+0x3f8>
    8000585a:	00000097          	auipc	ra,0x0
    8000585e:	526080e7          	jalr	1318(ra) # 80005d80 <panic>

0000000080005862 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005862:	1141                	addi	sp,sp,-16
    80005864:	e422                	sd	s0,8(sp)
    80005866:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005868:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000586c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005870:	0037979b          	slliw	a5,a5,0x3
    80005874:	02004737          	lui	a4,0x2004
    80005878:	97ba                	add	a5,a5,a4
    8000587a:	0200c737          	lui	a4,0x200c
    8000587e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005882:	000f4637          	lui	a2,0xf4
    80005886:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000588a:	9732                	add	a4,a4,a2
    8000588c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000588e:	00259693          	slli	a3,a1,0x2
    80005892:	96ae                	add	a3,a3,a1
    80005894:	068e                	slli	a3,a3,0x3
    80005896:	00018717          	auipc	a4,0x18
    8000589a:	76a70713          	addi	a4,a4,1898 # 8001e000 <timer_scratch>
    8000589e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058a0:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058a2:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058a4:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058a8:	00000797          	auipc	a5,0x0
    800058ac:	9c878793          	addi	a5,a5,-1592 # 80005270 <timervec>
    800058b0:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058b4:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058b8:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058bc:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058c0:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058c4:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058c8:	30479073          	csrw	mie,a5
}
    800058cc:	6422                	ld	s0,8(sp)
    800058ce:	0141                	addi	sp,sp,16
    800058d0:	8082                	ret

00000000800058d2 <start>:
{
    800058d2:	1141                	addi	sp,sp,-16
    800058d4:	e406                	sd	ra,8(sp)
    800058d6:	e022                	sd	s0,0(sp)
    800058d8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058da:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058de:	7779                	lui	a4,0xffffe
    800058e0:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800058e4:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058e6:	6705                	lui	a4,0x1
    800058e8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058ec:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058ee:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058f2:	ffffb797          	auipc	a5,0xffffb
    800058f6:	a2e78793          	addi	a5,a5,-1490 # 80000320 <main>
    800058fa:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058fe:	4781                	li	a5,0
    80005900:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005904:	67c1                	lui	a5,0x10
    80005906:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005908:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000590c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005910:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005914:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005918:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000591c:	57fd                	li	a5,-1
    8000591e:	83a9                	srli	a5,a5,0xa
    80005920:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005924:	47bd                	li	a5,15
    80005926:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000592a:	00000097          	auipc	ra,0x0
    8000592e:	f38080e7          	jalr	-200(ra) # 80005862 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005932:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005936:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005938:	823e                	mv	tp,a5
  asm volatile("mret");
    8000593a:	30200073          	mret
}
    8000593e:	60a2                	ld	ra,8(sp)
    80005940:	6402                	ld	s0,0(sp)
    80005942:	0141                	addi	sp,sp,16
    80005944:	8082                	ret

0000000080005946 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005946:	715d                	addi	sp,sp,-80
    80005948:	e486                	sd	ra,72(sp)
    8000594a:	e0a2                	sd	s0,64(sp)
    8000594c:	fc26                	sd	s1,56(sp)
    8000594e:	f84a                	sd	s2,48(sp)
    80005950:	f44e                	sd	s3,40(sp)
    80005952:	f052                	sd	s4,32(sp)
    80005954:	ec56                	sd	s5,24(sp)
    80005956:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005958:	04c05763          	blez	a2,800059a6 <consolewrite+0x60>
    8000595c:	8a2a                	mv	s4,a0
    8000595e:	84ae                	mv	s1,a1
    80005960:	89b2                	mv	s3,a2
    80005962:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005964:	5afd                	li	s5,-1
    80005966:	4685                	li	a3,1
    80005968:	8626                	mv	a2,s1
    8000596a:	85d2                	mv	a1,s4
    8000596c:	fbf40513          	addi	a0,s0,-65
    80005970:	ffffc097          	auipc	ra,0xffffc
    80005974:	14a080e7          	jalr	330(ra) # 80001aba <either_copyin>
    80005978:	01550d63          	beq	a0,s5,80005992 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000597c:	fbf44503          	lbu	a0,-65(s0)
    80005980:	00000097          	auipc	ra,0x0
    80005984:	77e080e7          	jalr	1918(ra) # 800060fe <uartputc>
  for(i = 0; i < n; i++){
    80005988:	2905                	addiw	s2,s2,1
    8000598a:	0485                	addi	s1,s1,1
    8000598c:	fd299de3          	bne	s3,s2,80005966 <consolewrite+0x20>
    80005990:	894e                	mv	s2,s3
  }

  return i;
}
    80005992:	854a                	mv	a0,s2
    80005994:	60a6                	ld	ra,72(sp)
    80005996:	6406                	ld	s0,64(sp)
    80005998:	74e2                	ld	s1,56(sp)
    8000599a:	7942                	ld	s2,48(sp)
    8000599c:	79a2                	ld	s3,40(sp)
    8000599e:	7a02                	ld	s4,32(sp)
    800059a0:	6ae2                	ld	s5,24(sp)
    800059a2:	6161                	addi	sp,sp,80
    800059a4:	8082                	ret
  for(i = 0; i < n; i++){
    800059a6:	4901                	li	s2,0
    800059a8:	b7ed                	j	80005992 <consolewrite+0x4c>

00000000800059aa <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059aa:	7159                	addi	sp,sp,-112
    800059ac:	f486                	sd	ra,104(sp)
    800059ae:	f0a2                	sd	s0,96(sp)
    800059b0:	eca6                	sd	s1,88(sp)
    800059b2:	e8ca                	sd	s2,80(sp)
    800059b4:	e4ce                	sd	s3,72(sp)
    800059b6:	e0d2                	sd	s4,64(sp)
    800059b8:	fc56                	sd	s5,56(sp)
    800059ba:	f85a                	sd	s6,48(sp)
    800059bc:	f45e                	sd	s7,40(sp)
    800059be:	f062                	sd	s8,32(sp)
    800059c0:	ec66                	sd	s9,24(sp)
    800059c2:	e86a                	sd	s10,16(sp)
    800059c4:	1880                	addi	s0,sp,112
    800059c6:	8aaa                	mv	s5,a0
    800059c8:	8a2e                	mv	s4,a1
    800059ca:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059cc:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059d0:	00020517          	auipc	a0,0x20
    800059d4:	77050513          	addi	a0,a0,1904 # 80026140 <cons>
    800059d8:	00001097          	auipc	ra,0x1
    800059dc:	8e0080e7          	jalr	-1824(ra) # 800062b8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059e0:	00020497          	auipc	s1,0x20
    800059e4:	76048493          	addi	s1,s1,1888 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059e8:	00020917          	auipc	s2,0x20
    800059ec:	7f090913          	addi	s2,s2,2032 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800059f0:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059f2:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059f4:	4ca9                	li	s9,10
  while(n > 0){
    800059f6:	07305863          	blez	s3,80005a66 <consoleread+0xbc>
    while(cons.r == cons.w){
    800059fa:	0984a783          	lw	a5,152(s1)
    800059fe:	09c4a703          	lw	a4,156(s1)
    80005a02:	02f71463          	bne	a4,a5,80005a2a <consoleread+0x80>
      if(myproc()->killed){
    80005a06:	ffffb097          	auipc	ra,0xffffb
    80005a0a:	526080e7          	jalr	1318(ra) # 80000f2c <myproc>
    80005a0e:	551c                	lw	a5,40(a0)
    80005a10:	e7b5                	bnez	a5,80005a7c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005a12:	85a6                	mv	a1,s1
    80005a14:	854a                	mv	a0,s2
    80005a16:	ffffc097          	auipc	ra,0xffffc
    80005a1a:	caa080e7          	jalr	-854(ra) # 800016c0 <sleep>
    while(cons.r == cons.w){
    80005a1e:	0984a783          	lw	a5,152(s1)
    80005a22:	09c4a703          	lw	a4,156(s1)
    80005a26:	fef700e3          	beq	a4,a5,80005a06 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a2a:	0017871b          	addiw	a4,a5,1
    80005a2e:	08e4ac23          	sw	a4,152(s1)
    80005a32:	07f7f713          	andi	a4,a5,127
    80005a36:	9726                	add	a4,a4,s1
    80005a38:	01874703          	lbu	a4,24(a4)
    80005a3c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005a40:	077d0563          	beq	s10,s7,80005aaa <consoleread+0x100>
    cbuf = c;
    80005a44:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a48:	4685                	li	a3,1
    80005a4a:	f9f40613          	addi	a2,s0,-97
    80005a4e:	85d2                	mv	a1,s4
    80005a50:	8556                	mv	a0,s5
    80005a52:	ffffc097          	auipc	ra,0xffffc
    80005a56:	012080e7          	jalr	18(ra) # 80001a64 <either_copyout>
    80005a5a:	01850663          	beq	a0,s8,80005a66 <consoleread+0xbc>
    dst++;
    80005a5e:	0a05                	addi	s4,s4,1
    --n;
    80005a60:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005a62:	f99d1ae3          	bne	s10,s9,800059f6 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a66:	00020517          	auipc	a0,0x20
    80005a6a:	6da50513          	addi	a0,a0,1754 # 80026140 <cons>
    80005a6e:	00001097          	auipc	ra,0x1
    80005a72:	8fe080e7          	jalr	-1794(ra) # 8000636c <release>

  return target - n;
    80005a76:	413b053b          	subw	a0,s6,s3
    80005a7a:	a811                	j	80005a8e <consoleread+0xe4>
        release(&cons.lock);
    80005a7c:	00020517          	auipc	a0,0x20
    80005a80:	6c450513          	addi	a0,a0,1732 # 80026140 <cons>
    80005a84:	00001097          	auipc	ra,0x1
    80005a88:	8e8080e7          	jalr	-1816(ra) # 8000636c <release>
        return -1;
    80005a8c:	557d                	li	a0,-1
}
    80005a8e:	70a6                	ld	ra,104(sp)
    80005a90:	7406                	ld	s0,96(sp)
    80005a92:	64e6                	ld	s1,88(sp)
    80005a94:	6946                	ld	s2,80(sp)
    80005a96:	69a6                	ld	s3,72(sp)
    80005a98:	6a06                	ld	s4,64(sp)
    80005a9a:	7ae2                	ld	s5,56(sp)
    80005a9c:	7b42                	ld	s6,48(sp)
    80005a9e:	7ba2                	ld	s7,40(sp)
    80005aa0:	7c02                	ld	s8,32(sp)
    80005aa2:	6ce2                	ld	s9,24(sp)
    80005aa4:	6d42                	ld	s10,16(sp)
    80005aa6:	6165                	addi	sp,sp,112
    80005aa8:	8082                	ret
      if(n < target){
    80005aaa:	0009871b          	sext.w	a4,s3
    80005aae:	fb677ce3          	bgeu	a4,s6,80005a66 <consoleread+0xbc>
        cons.r--;
    80005ab2:	00020717          	auipc	a4,0x20
    80005ab6:	72f72323          	sw	a5,1830(a4) # 800261d8 <cons+0x98>
    80005aba:	b775                	j	80005a66 <consoleread+0xbc>

0000000080005abc <consputc>:
{
    80005abc:	1141                	addi	sp,sp,-16
    80005abe:	e406                	sd	ra,8(sp)
    80005ac0:	e022                	sd	s0,0(sp)
    80005ac2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ac4:	10000793          	li	a5,256
    80005ac8:	00f50a63          	beq	a0,a5,80005adc <consputc+0x20>
    uartputc_sync(c);
    80005acc:	00000097          	auipc	ra,0x0
    80005ad0:	560080e7          	jalr	1376(ra) # 8000602c <uartputc_sync>
}
    80005ad4:	60a2                	ld	ra,8(sp)
    80005ad6:	6402                	ld	s0,0(sp)
    80005ad8:	0141                	addi	sp,sp,16
    80005ada:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005adc:	4521                	li	a0,8
    80005ade:	00000097          	auipc	ra,0x0
    80005ae2:	54e080e7          	jalr	1358(ra) # 8000602c <uartputc_sync>
    80005ae6:	02000513          	li	a0,32
    80005aea:	00000097          	auipc	ra,0x0
    80005aee:	542080e7          	jalr	1346(ra) # 8000602c <uartputc_sync>
    80005af2:	4521                	li	a0,8
    80005af4:	00000097          	auipc	ra,0x0
    80005af8:	538080e7          	jalr	1336(ra) # 8000602c <uartputc_sync>
    80005afc:	bfe1                	j	80005ad4 <consputc+0x18>

0000000080005afe <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005afe:	1101                	addi	sp,sp,-32
    80005b00:	ec06                	sd	ra,24(sp)
    80005b02:	e822                	sd	s0,16(sp)
    80005b04:	e426                	sd	s1,8(sp)
    80005b06:	e04a                	sd	s2,0(sp)
    80005b08:	1000                	addi	s0,sp,32
    80005b0a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b0c:	00020517          	auipc	a0,0x20
    80005b10:	63450513          	addi	a0,a0,1588 # 80026140 <cons>
    80005b14:	00000097          	auipc	ra,0x0
    80005b18:	7a4080e7          	jalr	1956(ra) # 800062b8 <acquire>

  switch(c){
    80005b1c:	47d5                	li	a5,21
    80005b1e:	0af48663          	beq	s1,a5,80005bca <consoleintr+0xcc>
    80005b22:	0297ca63          	blt	a5,s1,80005b56 <consoleintr+0x58>
    80005b26:	47a1                	li	a5,8
    80005b28:	0ef48763          	beq	s1,a5,80005c16 <consoleintr+0x118>
    80005b2c:	47c1                	li	a5,16
    80005b2e:	10f49a63          	bne	s1,a5,80005c42 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b32:	ffffc097          	auipc	ra,0xffffc
    80005b36:	fde080e7          	jalr	-34(ra) # 80001b10 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b3a:	00020517          	auipc	a0,0x20
    80005b3e:	60650513          	addi	a0,a0,1542 # 80026140 <cons>
    80005b42:	00001097          	auipc	ra,0x1
    80005b46:	82a080e7          	jalr	-2006(ra) # 8000636c <release>
}
    80005b4a:	60e2                	ld	ra,24(sp)
    80005b4c:	6442                	ld	s0,16(sp)
    80005b4e:	64a2                	ld	s1,8(sp)
    80005b50:	6902                	ld	s2,0(sp)
    80005b52:	6105                	addi	sp,sp,32
    80005b54:	8082                	ret
  switch(c){
    80005b56:	07f00793          	li	a5,127
    80005b5a:	0af48e63          	beq	s1,a5,80005c16 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b5e:	00020717          	auipc	a4,0x20
    80005b62:	5e270713          	addi	a4,a4,1506 # 80026140 <cons>
    80005b66:	0a072783          	lw	a5,160(a4)
    80005b6a:	09872703          	lw	a4,152(a4)
    80005b6e:	9f99                	subw	a5,a5,a4
    80005b70:	07f00713          	li	a4,127
    80005b74:	fcf763e3          	bltu	a4,a5,80005b3a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b78:	47b5                	li	a5,13
    80005b7a:	0cf48763          	beq	s1,a5,80005c48 <consoleintr+0x14a>
      consputc(c);
    80005b7e:	8526                	mv	a0,s1
    80005b80:	00000097          	auipc	ra,0x0
    80005b84:	f3c080e7          	jalr	-196(ra) # 80005abc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b88:	00020797          	auipc	a5,0x20
    80005b8c:	5b878793          	addi	a5,a5,1464 # 80026140 <cons>
    80005b90:	0a07a703          	lw	a4,160(a5)
    80005b94:	0017069b          	addiw	a3,a4,1
    80005b98:	0006861b          	sext.w	a2,a3
    80005b9c:	0ad7a023          	sw	a3,160(a5)
    80005ba0:	07f77713          	andi	a4,a4,127
    80005ba4:	97ba                	add	a5,a5,a4
    80005ba6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005baa:	47a9                	li	a5,10
    80005bac:	0cf48563          	beq	s1,a5,80005c76 <consoleintr+0x178>
    80005bb0:	4791                	li	a5,4
    80005bb2:	0cf48263          	beq	s1,a5,80005c76 <consoleintr+0x178>
    80005bb6:	00020797          	auipc	a5,0x20
    80005bba:	6227a783          	lw	a5,1570(a5) # 800261d8 <cons+0x98>
    80005bbe:	0807879b          	addiw	a5,a5,128
    80005bc2:	f6f61ce3          	bne	a2,a5,80005b3a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bc6:	863e                	mv	a2,a5
    80005bc8:	a07d                	j	80005c76 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bca:	00020717          	auipc	a4,0x20
    80005bce:	57670713          	addi	a4,a4,1398 # 80026140 <cons>
    80005bd2:	0a072783          	lw	a5,160(a4)
    80005bd6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bda:	00020497          	auipc	s1,0x20
    80005bde:	56648493          	addi	s1,s1,1382 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005be2:	4929                	li	s2,10
    80005be4:	f4f70be3          	beq	a4,a5,80005b3a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005be8:	37fd                	addiw	a5,a5,-1
    80005bea:	07f7f713          	andi	a4,a5,127
    80005bee:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bf0:	01874703          	lbu	a4,24(a4)
    80005bf4:	f52703e3          	beq	a4,s2,80005b3a <consoleintr+0x3c>
      cons.e--;
    80005bf8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bfc:	10000513          	li	a0,256
    80005c00:	00000097          	auipc	ra,0x0
    80005c04:	ebc080e7          	jalr	-324(ra) # 80005abc <consputc>
    while(cons.e != cons.w &&
    80005c08:	0a04a783          	lw	a5,160(s1)
    80005c0c:	09c4a703          	lw	a4,156(s1)
    80005c10:	fcf71ce3          	bne	a4,a5,80005be8 <consoleintr+0xea>
    80005c14:	b71d                	j	80005b3a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c16:	00020717          	auipc	a4,0x20
    80005c1a:	52a70713          	addi	a4,a4,1322 # 80026140 <cons>
    80005c1e:	0a072783          	lw	a5,160(a4)
    80005c22:	09c72703          	lw	a4,156(a4)
    80005c26:	f0f70ae3          	beq	a4,a5,80005b3a <consoleintr+0x3c>
      cons.e--;
    80005c2a:	37fd                	addiw	a5,a5,-1
    80005c2c:	00020717          	auipc	a4,0x20
    80005c30:	5af72a23          	sw	a5,1460(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c34:	10000513          	li	a0,256
    80005c38:	00000097          	auipc	ra,0x0
    80005c3c:	e84080e7          	jalr	-380(ra) # 80005abc <consputc>
    80005c40:	bded                	j	80005b3a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c42:	ee048ce3          	beqz	s1,80005b3a <consoleintr+0x3c>
    80005c46:	bf21                	j	80005b5e <consoleintr+0x60>
      consputc(c);
    80005c48:	4529                	li	a0,10
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	e72080e7          	jalr	-398(ra) # 80005abc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c52:	00020797          	auipc	a5,0x20
    80005c56:	4ee78793          	addi	a5,a5,1262 # 80026140 <cons>
    80005c5a:	0a07a703          	lw	a4,160(a5)
    80005c5e:	0017069b          	addiw	a3,a4,1
    80005c62:	0006861b          	sext.w	a2,a3
    80005c66:	0ad7a023          	sw	a3,160(a5)
    80005c6a:	07f77713          	andi	a4,a4,127
    80005c6e:	97ba                	add	a5,a5,a4
    80005c70:	4729                	li	a4,10
    80005c72:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c76:	00020797          	auipc	a5,0x20
    80005c7a:	56c7a323          	sw	a2,1382(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005c7e:	00020517          	auipc	a0,0x20
    80005c82:	55a50513          	addi	a0,a0,1370 # 800261d8 <cons+0x98>
    80005c86:	ffffc097          	auipc	ra,0xffffc
    80005c8a:	bc6080e7          	jalr	-1082(ra) # 8000184c <wakeup>
    80005c8e:	b575                	j	80005b3a <consoleintr+0x3c>

0000000080005c90 <consoleinit>:

void
consoleinit(void)
{
    80005c90:	1141                	addi	sp,sp,-16
    80005c92:	e406                	sd	ra,8(sp)
    80005c94:	e022                	sd	s0,0(sp)
    80005c96:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c98:	00003597          	auipc	a1,0x3
    80005c9c:	ba058593          	addi	a1,a1,-1120 # 80008838 <syscalls+0x410>
    80005ca0:	00020517          	auipc	a0,0x20
    80005ca4:	4a050513          	addi	a0,a0,1184 # 80026140 <cons>
    80005ca8:	00000097          	auipc	ra,0x0
    80005cac:	580080e7          	jalr	1408(ra) # 80006228 <initlock>

  uartinit();
    80005cb0:	00000097          	auipc	ra,0x0
    80005cb4:	32c080e7          	jalr	812(ra) # 80005fdc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cb8:	00013797          	auipc	a5,0x13
    80005cbc:	41078793          	addi	a5,a5,1040 # 800190c8 <devsw>
    80005cc0:	00000717          	auipc	a4,0x0
    80005cc4:	cea70713          	addi	a4,a4,-790 # 800059aa <consoleread>
    80005cc8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cca:	00000717          	auipc	a4,0x0
    80005cce:	c7c70713          	addi	a4,a4,-900 # 80005946 <consolewrite>
    80005cd2:	ef98                	sd	a4,24(a5)
}
    80005cd4:	60a2                	ld	ra,8(sp)
    80005cd6:	6402                	ld	s0,0(sp)
    80005cd8:	0141                	addi	sp,sp,16
    80005cda:	8082                	ret

0000000080005cdc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cdc:	7179                	addi	sp,sp,-48
    80005cde:	f406                	sd	ra,40(sp)
    80005ce0:	f022                	sd	s0,32(sp)
    80005ce2:	ec26                	sd	s1,24(sp)
    80005ce4:	e84a                	sd	s2,16(sp)
    80005ce6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ce8:	c219                	beqz	a2,80005cee <printint+0x12>
    80005cea:	08054763          	bltz	a0,80005d78 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005cee:	2501                	sext.w	a0,a0
    80005cf0:	4881                	li	a7,0
    80005cf2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cf6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cf8:	2581                	sext.w	a1,a1
    80005cfa:	00003617          	auipc	a2,0x3
    80005cfe:	b6e60613          	addi	a2,a2,-1170 # 80008868 <digits>
    80005d02:	883a                	mv	a6,a4
    80005d04:	2705                	addiw	a4,a4,1
    80005d06:	02b577bb          	remuw	a5,a0,a1
    80005d0a:	1782                	slli	a5,a5,0x20
    80005d0c:	9381                	srli	a5,a5,0x20
    80005d0e:	97b2                	add	a5,a5,a2
    80005d10:	0007c783          	lbu	a5,0(a5)
    80005d14:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d18:	0005079b          	sext.w	a5,a0
    80005d1c:	02b5553b          	divuw	a0,a0,a1
    80005d20:	0685                	addi	a3,a3,1
    80005d22:	feb7f0e3          	bgeu	a5,a1,80005d02 <printint+0x26>

  if(sign)
    80005d26:	00088c63          	beqz	a7,80005d3e <printint+0x62>
    buf[i++] = '-';
    80005d2a:	fe070793          	addi	a5,a4,-32
    80005d2e:	00878733          	add	a4,a5,s0
    80005d32:	02d00793          	li	a5,45
    80005d36:	fef70823          	sb	a5,-16(a4)
    80005d3a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d3e:	02e05763          	blez	a4,80005d6c <printint+0x90>
    80005d42:	fd040793          	addi	a5,s0,-48
    80005d46:	00e784b3          	add	s1,a5,a4
    80005d4a:	fff78913          	addi	s2,a5,-1
    80005d4e:	993a                	add	s2,s2,a4
    80005d50:	377d                	addiw	a4,a4,-1
    80005d52:	1702                	slli	a4,a4,0x20
    80005d54:	9301                	srli	a4,a4,0x20
    80005d56:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d5a:	fff4c503          	lbu	a0,-1(s1)
    80005d5e:	00000097          	auipc	ra,0x0
    80005d62:	d5e080e7          	jalr	-674(ra) # 80005abc <consputc>
  while(--i >= 0)
    80005d66:	14fd                	addi	s1,s1,-1
    80005d68:	ff2499e3          	bne	s1,s2,80005d5a <printint+0x7e>
}
    80005d6c:	70a2                	ld	ra,40(sp)
    80005d6e:	7402                	ld	s0,32(sp)
    80005d70:	64e2                	ld	s1,24(sp)
    80005d72:	6942                	ld	s2,16(sp)
    80005d74:	6145                	addi	sp,sp,48
    80005d76:	8082                	ret
    x = -xx;
    80005d78:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d7c:	4885                	li	a7,1
    x = -xx;
    80005d7e:	bf95                	j	80005cf2 <printint+0x16>

0000000080005d80 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d80:	1101                	addi	sp,sp,-32
    80005d82:	ec06                	sd	ra,24(sp)
    80005d84:	e822                	sd	s0,16(sp)
    80005d86:	e426                	sd	s1,8(sp)
    80005d88:	1000                	addi	s0,sp,32
    80005d8a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d8c:	00020797          	auipc	a5,0x20
    80005d90:	4607aa23          	sw	zero,1140(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005d94:	00003517          	auipc	a0,0x3
    80005d98:	aac50513          	addi	a0,a0,-1364 # 80008840 <syscalls+0x418>
    80005d9c:	00000097          	auipc	ra,0x0
    80005da0:	02e080e7          	jalr	46(ra) # 80005dca <printf>
  printf(s);
    80005da4:	8526                	mv	a0,s1
    80005da6:	00000097          	auipc	ra,0x0
    80005daa:	024080e7          	jalr	36(ra) # 80005dca <printf>
  printf("\n");
    80005dae:	00002517          	auipc	a0,0x2
    80005db2:	29a50513          	addi	a0,a0,666 # 80008048 <etext+0x48>
    80005db6:	00000097          	auipc	ra,0x0
    80005dba:	014080e7          	jalr	20(ra) # 80005dca <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dbe:	4785                	li	a5,1
    80005dc0:	00003717          	auipc	a4,0x3
    80005dc4:	24f72e23          	sw	a5,604(a4) # 8000901c <panicked>
  for(;;)
    80005dc8:	a001                	j	80005dc8 <panic+0x48>

0000000080005dca <printf>:
{
    80005dca:	7131                	addi	sp,sp,-192
    80005dcc:	fc86                	sd	ra,120(sp)
    80005dce:	f8a2                	sd	s0,112(sp)
    80005dd0:	f4a6                	sd	s1,104(sp)
    80005dd2:	f0ca                	sd	s2,96(sp)
    80005dd4:	ecce                	sd	s3,88(sp)
    80005dd6:	e8d2                	sd	s4,80(sp)
    80005dd8:	e4d6                	sd	s5,72(sp)
    80005dda:	e0da                	sd	s6,64(sp)
    80005ddc:	fc5e                	sd	s7,56(sp)
    80005dde:	f862                	sd	s8,48(sp)
    80005de0:	f466                	sd	s9,40(sp)
    80005de2:	f06a                	sd	s10,32(sp)
    80005de4:	ec6e                	sd	s11,24(sp)
    80005de6:	0100                	addi	s0,sp,128
    80005de8:	8a2a                	mv	s4,a0
    80005dea:	e40c                	sd	a1,8(s0)
    80005dec:	e810                	sd	a2,16(s0)
    80005dee:	ec14                	sd	a3,24(s0)
    80005df0:	f018                	sd	a4,32(s0)
    80005df2:	f41c                	sd	a5,40(s0)
    80005df4:	03043823          	sd	a6,48(s0)
    80005df8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dfc:	00020d97          	auipc	s11,0x20
    80005e00:	404dad83          	lw	s11,1028(s11) # 80026200 <pr+0x18>
  if(locking)
    80005e04:	020d9b63          	bnez	s11,80005e3a <printf+0x70>
  if (fmt == 0)
    80005e08:	040a0263          	beqz	s4,80005e4c <printf+0x82>
  va_start(ap, fmt);
    80005e0c:	00840793          	addi	a5,s0,8
    80005e10:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e14:	000a4503          	lbu	a0,0(s4)
    80005e18:	14050f63          	beqz	a0,80005f76 <printf+0x1ac>
    80005e1c:	4981                	li	s3,0
    if(c != '%'){
    80005e1e:	02500a93          	li	s5,37
    switch(c){
    80005e22:	07000b93          	li	s7,112
  consputc('x');
    80005e26:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e28:	00003b17          	auipc	s6,0x3
    80005e2c:	a40b0b13          	addi	s6,s6,-1472 # 80008868 <digits>
    switch(c){
    80005e30:	07300c93          	li	s9,115
    80005e34:	06400c13          	li	s8,100
    80005e38:	a82d                	j	80005e72 <printf+0xa8>
    acquire(&pr.lock);
    80005e3a:	00020517          	auipc	a0,0x20
    80005e3e:	3ae50513          	addi	a0,a0,942 # 800261e8 <pr>
    80005e42:	00000097          	auipc	ra,0x0
    80005e46:	476080e7          	jalr	1142(ra) # 800062b8 <acquire>
    80005e4a:	bf7d                	j	80005e08 <printf+0x3e>
    panic("null fmt");
    80005e4c:	00003517          	auipc	a0,0x3
    80005e50:	a0450513          	addi	a0,a0,-1532 # 80008850 <syscalls+0x428>
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	f2c080e7          	jalr	-212(ra) # 80005d80 <panic>
      consputc(c);
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	c60080e7          	jalr	-928(ra) # 80005abc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e64:	2985                	addiw	s3,s3,1
    80005e66:	013a07b3          	add	a5,s4,s3
    80005e6a:	0007c503          	lbu	a0,0(a5)
    80005e6e:	10050463          	beqz	a0,80005f76 <printf+0x1ac>
    if(c != '%'){
    80005e72:	ff5515e3          	bne	a0,s5,80005e5c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e76:	2985                	addiw	s3,s3,1
    80005e78:	013a07b3          	add	a5,s4,s3
    80005e7c:	0007c783          	lbu	a5,0(a5)
    80005e80:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e84:	cbed                	beqz	a5,80005f76 <printf+0x1ac>
    switch(c){
    80005e86:	05778a63          	beq	a5,s7,80005eda <printf+0x110>
    80005e8a:	02fbf663          	bgeu	s7,a5,80005eb6 <printf+0xec>
    80005e8e:	09978863          	beq	a5,s9,80005f1e <printf+0x154>
    80005e92:	07800713          	li	a4,120
    80005e96:	0ce79563          	bne	a5,a4,80005f60 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005e9a:	f8843783          	ld	a5,-120(s0)
    80005e9e:	00878713          	addi	a4,a5,8
    80005ea2:	f8e43423          	sd	a4,-120(s0)
    80005ea6:	4605                	li	a2,1
    80005ea8:	85ea                	mv	a1,s10
    80005eaa:	4388                	lw	a0,0(a5)
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	e30080e7          	jalr	-464(ra) # 80005cdc <printint>
      break;
    80005eb4:	bf45                	j	80005e64 <printf+0x9a>
    switch(c){
    80005eb6:	09578f63          	beq	a5,s5,80005f54 <printf+0x18a>
    80005eba:	0b879363          	bne	a5,s8,80005f60 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005ebe:	f8843783          	ld	a5,-120(s0)
    80005ec2:	00878713          	addi	a4,a5,8
    80005ec6:	f8e43423          	sd	a4,-120(s0)
    80005eca:	4605                	li	a2,1
    80005ecc:	45a9                	li	a1,10
    80005ece:	4388                	lw	a0,0(a5)
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	e0c080e7          	jalr	-500(ra) # 80005cdc <printint>
      break;
    80005ed8:	b771                	j	80005e64 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005eda:	f8843783          	ld	a5,-120(s0)
    80005ede:	00878713          	addi	a4,a5,8
    80005ee2:	f8e43423          	sd	a4,-120(s0)
    80005ee6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005eea:	03000513          	li	a0,48
    80005eee:	00000097          	auipc	ra,0x0
    80005ef2:	bce080e7          	jalr	-1074(ra) # 80005abc <consputc>
  consputc('x');
    80005ef6:	07800513          	li	a0,120
    80005efa:	00000097          	auipc	ra,0x0
    80005efe:	bc2080e7          	jalr	-1086(ra) # 80005abc <consputc>
    80005f02:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f04:	03c95793          	srli	a5,s2,0x3c
    80005f08:	97da                	add	a5,a5,s6
    80005f0a:	0007c503          	lbu	a0,0(a5)
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	bae080e7          	jalr	-1106(ra) # 80005abc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f16:	0912                	slli	s2,s2,0x4
    80005f18:	34fd                	addiw	s1,s1,-1
    80005f1a:	f4ed                	bnez	s1,80005f04 <printf+0x13a>
    80005f1c:	b7a1                	j	80005e64 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f1e:	f8843783          	ld	a5,-120(s0)
    80005f22:	00878713          	addi	a4,a5,8
    80005f26:	f8e43423          	sd	a4,-120(s0)
    80005f2a:	6384                	ld	s1,0(a5)
    80005f2c:	cc89                	beqz	s1,80005f46 <printf+0x17c>
      for(; *s; s++)
    80005f2e:	0004c503          	lbu	a0,0(s1)
    80005f32:	d90d                	beqz	a0,80005e64 <printf+0x9a>
        consputc(*s);
    80005f34:	00000097          	auipc	ra,0x0
    80005f38:	b88080e7          	jalr	-1144(ra) # 80005abc <consputc>
      for(; *s; s++)
    80005f3c:	0485                	addi	s1,s1,1
    80005f3e:	0004c503          	lbu	a0,0(s1)
    80005f42:	f96d                	bnez	a0,80005f34 <printf+0x16a>
    80005f44:	b705                	j	80005e64 <printf+0x9a>
        s = "(null)";
    80005f46:	00003497          	auipc	s1,0x3
    80005f4a:	90248493          	addi	s1,s1,-1790 # 80008848 <syscalls+0x420>
      for(; *s; s++)
    80005f4e:	02800513          	li	a0,40
    80005f52:	b7cd                	j	80005f34 <printf+0x16a>
      consputc('%');
    80005f54:	8556                	mv	a0,s5
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	b66080e7          	jalr	-1178(ra) # 80005abc <consputc>
      break;
    80005f5e:	b719                	j	80005e64 <printf+0x9a>
      consputc('%');
    80005f60:	8556                	mv	a0,s5
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	b5a080e7          	jalr	-1190(ra) # 80005abc <consputc>
      consputc(c);
    80005f6a:	8526                	mv	a0,s1
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	b50080e7          	jalr	-1200(ra) # 80005abc <consputc>
      break;
    80005f74:	bdc5                	j	80005e64 <printf+0x9a>
  if(locking)
    80005f76:	020d9163          	bnez	s11,80005f98 <printf+0x1ce>
}
    80005f7a:	70e6                	ld	ra,120(sp)
    80005f7c:	7446                	ld	s0,112(sp)
    80005f7e:	74a6                	ld	s1,104(sp)
    80005f80:	7906                	ld	s2,96(sp)
    80005f82:	69e6                	ld	s3,88(sp)
    80005f84:	6a46                	ld	s4,80(sp)
    80005f86:	6aa6                	ld	s5,72(sp)
    80005f88:	6b06                	ld	s6,64(sp)
    80005f8a:	7be2                	ld	s7,56(sp)
    80005f8c:	7c42                	ld	s8,48(sp)
    80005f8e:	7ca2                	ld	s9,40(sp)
    80005f90:	7d02                	ld	s10,32(sp)
    80005f92:	6de2                	ld	s11,24(sp)
    80005f94:	6129                	addi	sp,sp,192
    80005f96:	8082                	ret
    release(&pr.lock);
    80005f98:	00020517          	auipc	a0,0x20
    80005f9c:	25050513          	addi	a0,a0,592 # 800261e8 <pr>
    80005fa0:	00000097          	auipc	ra,0x0
    80005fa4:	3cc080e7          	jalr	972(ra) # 8000636c <release>
}
    80005fa8:	bfc9                	j	80005f7a <printf+0x1b0>

0000000080005faa <printfinit>:
    ;
}

void
printfinit(void)
{
    80005faa:	1101                	addi	sp,sp,-32
    80005fac:	ec06                	sd	ra,24(sp)
    80005fae:	e822                	sd	s0,16(sp)
    80005fb0:	e426                	sd	s1,8(sp)
    80005fb2:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fb4:	00020497          	auipc	s1,0x20
    80005fb8:	23448493          	addi	s1,s1,564 # 800261e8 <pr>
    80005fbc:	00003597          	auipc	a1,0x3
    80005fc0:	8a458593          	addi	a1,a1,-1884 # 80008860 <syscalls+0x438>
    80005fc4:	8526                	mv	a0,s1
    80005fc6:	00000097          	auipc	ra,0x0
    80005fca:	262080e7          	jalr	610(ra) # 80006228 <initlock>
  pr.locking = 1;
    80005fce:	4785                	li	a5,1
    80005fd0:	cc9c                	sw	a5,24(s1)
}
    80005fd2:	60e2                	ld	ra,24(sp)
    80005fd4:	6442                	ld	s0,16(sp)
    80005fd6:	64a2                	ld	s1,8(sp)
    80005fd8:	6105                	addi	sp,sp,32
    80005fda:	8082                	ret

0000000080005fdc <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fdc:	1141                	addi	sp,sp,-16
    80005fde:	e406                	sd	ra,8(sp)
    80005fe0:	e022                	sd	s0,0(sp)
    80005fe2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fe4:	100007b7          	lui	a5,0x10000
    80005fe8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fec:	f8000713          	li	a4,-128
    80005ff0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ff4:	470d                	li	a4,3
    80005ff6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ffa:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ffe:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006002:	469d                	li	a3,7
    80006004:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006008:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000600c:	00003597          	auipc	a1,0x3
    80006010:	87458593          	addi	a1,a1,-1932 # 80008880 <digits+0x18>
    80006014:	00020517          	auipc	a0,0x20
    80006018:	1f450513          	addi	a0,a0,500 # 80026208 <uart_tx_lock>
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	20c080e7          	jalr	524(ra) # 80006228 <initlock>
}
    80006024:	60a2                	ld	ra,8(sp)
    80006026:	6402                	ld	s0,0(sp)
    80006028:	0141                	addi	sp,sp,16
    8000602a:	8082                	ret

000000008000602c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000602c:	1101                	addi	sp,sp,-32
    8000602e:	ec06                	sd	ra,24(sp)
    80006030:	e822                	sd	s0,16(sp)
    80006032:	e426                	sd	s1,8(sp)
    80006034:	1000                	addi	s0,sp,32
    80006036:	84aa                	mv	s1,a0
  push_off();
    80006038:	00000097          	auipc	ra,0x0
    8000603c:	234080e7          	jalr	564(ra) # 8000626c <push_off>

  if(panicked){
    80006040:	00003797          	auipc	a5,0x3
    80006044:	fdc7a783          	lw	a5,-36(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006048:	10000737          	lui	a4,0x10000
  if(panicked){
    8000604c:	c391                	beqz	a5,80006050 <uartputc_sync+0x24>
    for(;;)
    8000604e:	a001                	j	8000604e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006050:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006054:	0207f793          	andi	a5,a5,32
    80006058:	dfe5                	beqz	a5,80006050 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000605a:	0ff4f513          	zext.b	a0,s1
    8000605e:	100007b7          	lui	a5,0x10000
    80006062:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006066:	00000097          	auipc	ra,0x0
    8000606a:	2a6080e7          	jalr	678(ra) # 8000630c <pop_off>
}
    8000606e:	60e2                	ld	ra,24(sp)
    80006070:	6442                	ld	s0,16(sp)
    80006072:	64a2                	ld	s1,8(sp)
    80006074:	6105                	addi	sp,sp,32
    80006076:	8082                	ret

0000000080006078 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006078:	00003797          	auipc	a5,0x3
    8000607c:	fa87b783          	ld	a5,-88(a5) # 80009020 <uart_tx_r>
    80006080:	00003717          	auipc	a4,0x3
    80006084:	fa873703          	ld	a4,-88(a4) # 80009028 <uart_tx_w>
    80006088:	06f70a63          	beq	a4,a5,800060fc <uartstart+0x84>
{
    8000608c:	7139                	addi	sp,sp,-64
    8000608e:	fc06                	sd	ra,56(sp)
    80006090:	f822                	sd	s0,48(sp)
    80006092:	f426                	sd	s1,40(sp)
    80006094:	f04a                	sd	s2,32(sp)
    80006096:	ec4e                	sd	s3,24(sp)
    80006098:	e852                	sd	s4,16(sp)
    8000609a:	e456                	sd	s5,8(sp)
    8000609c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000609e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060a2:	00020a17          	auipc	s4,0x20
    800060a6:	166a0a13          	addi	s4,s4,358 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060aa:	00003497          	auipc	s1,0x3
    800060ae:	f7648493          	addi	s1,s1,-138 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060b2:	00003997          	auipc	s3,0x3
    800060b6:	f7698993          	addi	s3,s3,-138 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060ba:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060be:	02077713          	andi	a4,a4,32
    800060c2:	c705                	beqz	a4,800060ea <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060c4:	01f7f713          	andi	a4,a5,31
    800060c8:	9752                	add	a4,a4,s4
    800060ca:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800060ce:	0785                	addi	a5,a5,1
    800060d0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060d2:	8526                	mv	a0,s1
    800060d4:	ffffb097          	auipc	ra,0xffffb
    800060d8:	778080e7          	jalr	1912(ra) # 8000184c <wakeup>
    
    WriteReg(THR, c);
    800060dc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060e0:	609c                	ld	a5,0(s1)
    800060e2:	0009b703          	ld	a4,0(s3)
    800060e6:	fcf71ae3          	bne	a4,a5,800060ba <uartstart+0x42>
  }
}
    800060ea:	70e2                	ld	ra,56(sp)
    800060ec:	7442                	ld	s0,48(sp)
    800060ee:	74a2                	ld	s1,40(sp)
    800060f0:	7902                	ld	s2,32(sp)
    800060f2:	69e2                	ld	s3,24(sp)
    800060f4:	6a42                	ld	s4,16(sp)
    800060f6:	6aa2                	ld	s5,8(sp)
    800060f8:	6121                	addi	sp,sp,64
    800060fa:	8082                	ret
    800060fc:	8082                	ret

00000000800060fe <uartputc>:
{
    800060fe:	7179                	addi	sp,sp,-48
    80006100:	f406                	sd	ra,40(sp)
    80006102:	f022                	sd	s0,32(sp)
    80006104:	ec26                	sd	s1,24(sp)
    80006106:	e84a                	sd	s2,16(sp)
    80006108:	e44e                	sd	s3,8(sp)
    8000610a:	e052                	sd	s4,0(sp)
    8000610c:	1800                	addi	s0,sp,48
    8000610e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006110:	00020517          	auipc	a0,0x20
    80006114:	0f850513          	addi	a0,a0,248 # 80026208 <uart_tx_lock>
    80006118:	00000097          	auipc	ra,0x0
    8000611c:	1a0080e7          	jalr	416(ra) # 800062b8 <acquire>
  if(panicked){
    80006120:	00003797          	auipc	a5,0x3
    80006124:	efc7a783          	lw	a5,-260(a5) # 8000901c <panicked>
    80006128:	c391                	beqz	a5,8000612c <uartputc+0x2e>
    for(;;)
    8000612a:	a001                	j	8000612a <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000612c:	00003717          	auipc	a4,0x3
    80006130:	efc73703          	ld	a4,-260(a4) # 80009028 <uart_tx_w>
    80006134:	00003797          	auipc	a5,0x3
    80006138:	eec7b783          	ld	a5,-276(a5) # 80009020 <uart_tx_r>
    8000613c:	02078793          	addi	a5,a5,32
    80006140:	02e79b63          	bne	a5,a4,80006176 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006144:	00020997          	auipc	s3,0x20
    80006148:	0c498993          	addi	s3,s3,196 # 80026208 <uart_tx_lock>
    8000614c:	00003497          	auipc	s1,0x3
    80006150:	ed448493          	addi	s1,s1,-300 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006154:	00003917          	auipc	s2,0x3
    80006158:	ed490913          	addi	s2,s2,-300 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000615c:	85ce                	mv	a1,s3
    8000615e:	8526                	mv	a0,s1
    80006160:	ffffb097          	auipc	ra,0xffffb
    80006164:	560080e7          	jalr	1376(ra) # 800016c0 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006168:	00093703          	ld	a4,0(s2)
    8000616c:	609c                	ld	a5,0(s1)
    8000616e:	02078793          	addi	a5,a5,32
    80006172:	fee785e3          	beq	a5,a4,8000615c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006176:	00020497          	auipc	s1,0x20
    8000617a:	09248493          	addi	s1,s1,146 # 80026208 <uart_tx_lock>
    8000617e:	01f77793          	andi	a5,a4,31
    80006182:	97a6                	add	a5,a5,s1
    80006184:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006188:	0705                	addi	a4,a4,1
    8000618a:	00003797          	auipc	a5,0x3
    8000618e:	e8e7bf23          	sd	a4,-354(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006192:	00000097          	auipc	ra,0x0
    80006196:	ee6080e7          	jalr	-282(ra) # 80006078 <uartstart>
      release(&uart_tx_lock);
    8000619a:	8526                	mv	a0,s1
    8000619c:	00000097          	auipc	ra,0x0
    800061a0:	1d0080e7          	jalr	464(ra) # 8000636c <release>
}
    800061a4:	70a2                	ld	ra,40(sp)
    800061a6:	7402                	ld	s0,32(sp)
    800061a8:	64e2                	ld	s1,24(sp)
    800061aa:	6942                	ld	s2,16(sp)
    800061ac:	69a2                	ld	s3,8(sp)
    800061ae:	6a02                	ld	s4,0(sp)
    800061b0:	6145                	addi	sp,sp,48
    800061b2:	8082                	ret

00000000800061b4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061b4:	1141                	addi	sp,sp,-16
    800061b6:	e422                	sd	s0,8(sp)
    800061b8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061ba:	100007b7          	lui	a5,0x10000
    800061be:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061c2:	8b85                	andi	a5,a5,1
    800061c4:	cb81                	beqz	a5,800061d4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800061c6:	100007b7          	lui	a5,0x10000
    800061ca:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800061ce:	6422                	ld	s0,8(sp)
    800061d0:	0141                	addi	sp,sp,16
    800061d2:	8082                	ret
    return -1;
    800061d4:	557d                	li	a0,-1
    800061d6:	bfe5                	j	800061ce <uartgetc+0x1a>

00000000800061d8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061d8:	1101                	addi	sp,sp,-32
    800061da:	ec06                	sd	ra,24(sp)
    800061dc:	e822                	sd	s0,16(sp)
    800061de:	e426                	sd	s1,8(sp)
    800061e0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061e2:	54fd                	li	s1,-1
    800061e4:	a029                	j	800061ee <uartintr+0x16>
      break;
    consoleintr(c);
    800061e6:	00000097          	auipc	ra,0x0
    800061ea:	918080e7          	jalr	-1768(ra) # 80005afe <consoleintr>
    int c = uartgetc();
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	fc6080e7          	jalr	-58(ra) # 800061b4 <uartgetc>
    if(c == -1)
    800061f6:	fe9518e3          	bne	a0,s1,800061e6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061fa:	00020497          	auipc	s1,0x20
    800061fe:	00e48493          	addi	s1,s1,14 # 80026208 <uart_tx_lock>
    80006202:	8526                	mv	a0,s1
    80006204:	00000097          	auipc	ra,0x0
    80006208:	0b4080e7          	jalr	180(ra) # 800062b8 <acquire>
  uartstart();
    8000620c:	00000097          	auipc	ra,0x0
    80006210:	e6c080e7          	jalr	-404(ra) # 80006078 <uartstart>
  release(&uart_tx_lock);
    80006214:	8526                	mv	a0,s1
    80006216:	00000097          	auipc	ra,0x0
    8000621a:	156080e7          	jalr	342(ra) # 8000636c <release>
}
    8000621e:	60e2                	ld	ra,24(sp)
    80006220:	6442                	ld	s0,16(sp)
    80006222:	64a2                	ld	s1,8(sp)
    80006224:	6105                	addi	sp,sp,32
    80006226:	8082                	ret

0000000080006228 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006228:	1141                	addi	sp,sp,-16
    8000622a:	e422                	sd	s0,8(sp)
    8000622c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000622e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006230:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006234:	00053823          	sd	zero,16(a0)
}
    80006238:	6422                	ld	s0,8(sp)
    8000623a:	0141                	addi	sp,sp,16
    8000623c:	8082                	ret

000000008000623e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000623e:	411c                	lw	a5,0(a0)
    80006240:	e399                	bnez	a5,80006246 <holding+0x8>
    80006242:	4501                	li	a0,0
  return r;
}
    80006244:	8082                	ret
{
    80006246:	1101                	addi	sp,sp,-32
    80006248:	ec06                	sd	ra,24(sp)
    8000624a:	e822                	sd	s0,16(sp)
    8000624c:	e426                	sd	s1,8(sp)
    8000624e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006250:	6904                	ld	s1,16(a0)
    80006252:	ffffb097          	auipc	ra,0xffffb
    80006256:	cbe080e7          	jalr	-834(ra) # 80000f10 <mycpu>
    8000625a:	40a48533          	sub	a0,s1,a0
    8000625e:	00153513          	seqz	a0,a0
}
    80006262:	60e2                	ld	ra,24(sp)
    80006264:	6442                	ld	s0,16(sp)
    80006266:	64a2                	ld	s1,8(sp)
    80006268:	6105                	addi	sp,sp,32
    8000626a:	8082                	ret

000000008000626c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000626c:	1101                	addi	sp,sp,-32
    8000626e:	ec06                	sd	ra,24(sp)
    80006270:	e822                	sd	s0,16(sp)
    80006272:	e426                	sd	s1,8(sp)
    80006274:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006276:	100024f3          	csrr	s1,sstatus
    8000627a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000627e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006280:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006284:	ffffb097          	auipc	ra,0xffffb
    80006288:	c8c080e7          	jalr	-884(ra) # 80000f10 <mycpu>
    8000628c:	5d3c                	lw	a5,120(a0)
    8000628e:	cf89                	beqz	a5,800062a8 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006290:	ffffb097          	auipc	ra,0xffffb
    80006294:	c80080e7          	jalr	-896(ra) # 80000f10 <mycpu>
    80006298:	5d3c                	lw	a5,120(a0)
    8000629a:	2785                	addiw	a5,a5,1
    8000629c:	dd3c                	sw	a5,120(a0)
}
    8000629e:	60e2                	ld	ra,24(sp)
    800062a0:	6442                	ld	s0,16(sp)
    800062a2:	64a2                	ld	s1,8(sp)
    800062a4:	6105                	addi	sp,sp,32
    800062a6:	8082                	ret
    mycpu()->intena = old;
    800062a8:	ffffb097          	auipc	ra,0xffffb
    800062ac:	c68080e7          	jalr	-920(ra) # 80000f10 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062b0:	8085                	srli	s1,s1,0x1
    800062b2:	8885                	andi	s1,s1,1
    800062b4:	dd64                	sw	s1,124(a0)
    800062b6:	bfe9                	j	80006290 <push_off+0x24>

00000000800062b8 <acquire>:
{
    800062b8:	1101                	addi	sp,sp,-32
    800062ba:	ec06                	sd	ra,24(sp)
    800062bc:	e822                	sd	s0,16(sp)
    800062be:	e426                	sd	s1,8(sp)
    800062c0:	1000                	addi	s0,sp,32
    800062c2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	fa8080e7          	jalr	-88(ra) # 8000626c <push_off>
  if(holding(lk))
    800062cc:	8526                	mv	a0,s1
    800062ce:	00000097          	auipc	ra,0x0
    800062d2:	f70080e7          	jalr	-144(ra) # 8000623e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062d6:	4705                	li	a4,1
  if(holding(lk))
    800062d8:	e115                	bnez	a0,800062fc <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062da:	87ba                	mv	a5,a4
    800062dc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062e0:	2781                	sext.w	a5,a5
    800062e2:	ffe5                	bnez	a5,800062da <acquire+0x22>
  __sync_synchronize();
    800062e4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062e8:	ffffb097          	auipc	ra,0xffffb
    800062ec:	c28080e7          	jalr	-984(ra) # 80000f10 <mycpu>
    800062f0:	e888                	sd	a0,16(s1)
}
    800062f2:	60e2                	ld	ra,24(sp)
    800062f4:	6442                	ld	s0,16(sp)
    800062f6:	64a2                	ld	s1,8(sp)
    800062f8:	6105                	addi	sp,sp,32
    800062fa:	8082                	ret
    panic("acquire");
    800062fc:	00002517          	auipc	a0,0x2
    80006300:	58c50513          	addi	a0,a0,1420 # 80008888 <digits+0x20>
    80006304:	00000097          	auipc	ra,0x0
    80006308:	a7c080e7          	jalr	-1412(ra) # 80005d80 <panic>

000000008000630c <pop_off>:

void
pop_off(void)
{
    8000630c:	1141                	addi	sp,sp,-16
    8000630e:	e406                	sd	ra,8(sp)
    80006310:	e022                	sd	s0,0(sp)
    80006312:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006314:	ffffb097          	auipc	ra,0xffffb
    80006318:	bfc080e7          	jalr	-1028(ra) # 80000f10 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000631c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006320:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006322:	e78d                	bnez	a5,8000634c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006324:	5d3c                	lw	a5,120(a0)
    80006326:	02f05b63          	blez	a5,8000635c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000632a:	37fd                	addiw	a5,a5,-1
    8000632c:	0007871b          	sext.w	a4,a5
    80006330:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006332:	eb09                	bnez	a4,80006344 <pop_off+0x38>
    80006334:	5d7c                	lw	a5,124(a0)
    80006336:	c799                	beqz	a5,80006344 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006338:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000633c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006340:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006344:	60a2                	ld	ra,8(sp)
    80006346:	6402                	ld	s0,0(sp)
    80006348:	0141                	addi	sp,sp,16
    8000634a:	8082                	ret
    panic("pop_off - interruptible");
    8000634c:	00002517          	auipc	a0,0x2
    80006350:	54450513          	addi	a0,a0,1348 # 80008890 <digits+0x28>
    80006354:	00000097          	auipc	ra,0x0
    80006358:	a2c080e7          	jalr	-1492(ra) # 80005d80 <panic>
    panic("pop_off");
    8000635c:	00002517          	auipc	a0,0x2
    80006360:	54c50513          	addi	a0,a0,1356 # 800088a8 <digits+0x40>
    80006364:	00000097          	auipc	ra,0x0
    80006368:	a1c080e7          	jalr	-1508(ra) # 80005d80 <panic>

000000008000636c <release>:
{
    8000636c:	1101                	addi	sp,sp,-32
    8000636e:	ec06                	sd	ra,24(sp)
    80006370:	e822                	sd	s0,16(sp)
    80006372:	e426                	sd	s1,8(sp)
    80006374:	1000                	addi	s0,sp,32
    80006376:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006378:	00000097          	auipc	ra,0x0
    8000637c:	ec6080e7          	jalr	-314(ra) # 8000623e <holding>
    80006380:	c115                	beqz	a0,800063a4 <release+0x38>
  lk->cpu = 0;
    80006382:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006386:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000638a:	0f50000f          	fence	iorw,ow
    8000638e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006392:	00000097          	auipc	ra,0x0
    80006396:	f7a080e7          	jalr	-134(ra) # 8000630c <pop_off>
}
    8000639a:	60e2                	ld	ra,24(sp)
    8000639c:	6442                	ld	s0,16(sp)
    8000639e:	64a2                	ld	s1,8(sp)
    800063a0:	6105                	addi	sp,sp,32
    800063a2:	8082                	ret
    panic("release");
    800063a4:	00002517          	auipc	a0,0x2
    800063a8:	50c50513          	addi	a0,a0,1292 # 800088b0 <digits+0x48>
    800063ac:	00000097          	auipc	ra,0x0
    800063b0:	9d4080e7          	jalr	-1580(ra) # 80005d80 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
