
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9e013103          	ld	sp,-1568(sp) # 800089e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	79c050ef          	jal	ra,800057b2 <start>

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
    8000004c:	17c080e7          	jalr	380(ra) # 800001c4 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	13e080e7          	jalr	318(ra) # 80006198 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1de080e7          	jalr	478(ra) # 8000624c <release>
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
    8000008e:	bd6080e7          	jalr	-1066(ra) # 80005c60 <panic>

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
    800000fa:	012080e7          	jalr	18(ra) # 80006108 <initlock>
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
    80000132:	06a080e7          	jalr	106(ra) # 80006198 <acquire>
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
    8000014a:	106080e7          	jalr	262(ra) # 8000624c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	070080e7          	jalr	112(ra) # 800001c4 <memset>
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
    80000174:	0dc080e7          	jalr	220(ra) # 8000624c <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <count_free_mem>:

uint64 count_free_mem(void);
uint64 count_free_mem(void){
    8000017a:	1101                	addi	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	addi	s0,sp,32
  uint64 free_mem = 0;
  acquire(&kmem.lock);
    80000184:	00009497          	auipc	s1,0x9
    80000188:	eac48493          	addi	s1,s1,-340 # 80009030 <kmem>
    8000018c:	8526                	mv	a0,s1
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	00a080e7          	jalr	10(ra) # 80006198 <acquire>
  for(struct run* freepage=kmem.freelist; freepage; freepage=freepage->next)
    80000196:	6c9c                	ld	a5,24(s1)
    80000198:	c785                	beqz	a5,800001c0 <count_free_mem+0x46>
  uint64 free_mem = 0;
    8000019a:	4481                	li	s1,0
    free_mem += PGSIZE;
    8000019c:	6705                	lui	a4,0x1
    8000019e:	94ba                	add	s1,s1,a4
  for(struct run* freepage=kmem.freelist; freepage; freepage=freepage->next)
    800001a0:	639c                	ld	a5,0(a5)
    800001a2:	fff5                	bnez	a5,8000019e <count_free_mem+0x24>
  release(&kmem.lock);
    800001a4:	00009517          	auipc	a0,0x9
    800001a8:	e8c50513          	addi	a0,a0,-372 # 80009030 <kmem>
    800001ac:	00006097          	auipc	ra,0x6
    800001b0:	0a0080e7          	jalr	160(ra) # 8000624c <release>
  return free_mem;
}
    800001b4:	8526                	mv	a0,s1
    800001b6:	60e2                	ld	ra,24(sp)
    800001b8:	6442                	ld	s0,16(sp)
    800001ba:	64a2                	ld	s1,8(sp)
    800001bc:	6105                	addi	sp,sp,32
    800001be:	8082                	ret
  uint64 free_mem = 0;
    800001c0:	4481                	li	s1,0
    800001c2:	b7cd                	j	800001a4 <count_free_mem+0x2a>

00000000800001c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c4:	1141                	addi	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001ca:	ca19                	beqz	a2,800001e0 <memset+0x1c>
    800001cc:	87aa                	mv	a5,a0
    800001ce:	1602                	slli	a2,a2,0x20
    800001d0:	9201                	srli	a2,a2,0x20
    800001d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001da:	0785                	addi	a5,a5,1
    800001dc:	fee79de3          	bne	a5,a4,800001d6 <memset+0x12>
  }
  return dst;
}
    800001e0:	6422                	ld	s0,8(sp)
    800001e2:	0141                	addi	sp,sp,16
    800001e4:	8082                	ret

00000000800001e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e6:	1141                	addi	sp,sp,-16
    800001e8:	e422                	sd	s0,8(sp)
    800001ea:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ec:	ca05                	beqz	a2,8000021c <memcmp+0x36>
    800001ee:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f2:	1682                	slli	a3,a3,0x20
    800001f4:	9281                	srli	a3,a3,0x20
    800001f6:	0685                	addi	a3,a3,1
    800001f8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fa:	00054783          	lbu	a5,0(a0)
    800001fe:	0005c703          	lbu	a4,0(a1)
    80000202:	00e79863          	bne	a5,a4,80000212 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000206:	0505                	addi	a0,a0,1
    80000208:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020a:	fed518e3          	bne	a0,a3,800001fa <memcmp+0x14>
  }

  return 0;
    8000020e:	4501                	li	a0,0
    80000210:	a019                	j	80000216 <memcmp+0x30>
      return *s1 - *s2;
    80000212:	40e7853b          	subw	a0,a5,a4
}
    80000216:	6422                	ld	s0,8(sp)
    80000218:	0141                	addi	sp,sp,16
    8000021a:	8082                	ret
  return 0;
    8000021c:	4501                	li	a0,0
    8000021e:	bfe5                	j	80000216 <memcmp+0x30>

0000000080000220 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000220:	1141                	addi	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000226:	c205                	beqz	a2,80000246 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000228:	02a5e263          	bltu	a1,a0,8000024c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022c:	1602                	slli	a2,a2,0x20
    8000022e:	9201                	srli	a2,a2,0x20
    80000230:	00c587b3          	add	a5,a1,a2
{
    80000234:	872a                	mv	a4,a0
      *d++ = *s++;
    80000236:	0585                	addi	a1,a1,1
    80000238:	0705                	addi	a4,a4,1 # 1001 <_entry-0x7fffefff>
    8000023a:	fff5c683          	lbu	a3,-1(a1)
    8000023e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000242:	fef59ae3          	bne	a1,a5,80000236 <memmove+0x16>

  return dst;
}
    80000246:	6422                	ld	s0,8(sp)
    80000248:	0141                	addi	sp,sp,16
    8000024a:	8082                	ret
  if(s < d && s + n > d){
    8000024c:	02061693          	slli	a3,a2,0x20
    80000250:	9281                	srli	a3,a3,0x20
    80000252:	00d58733          	add	a4,a1,a3
    80000256:	fce57be3          	bgeu	a0,a4,8000022c <memmove+0xc>
    d += n;
    8000025a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000025c:	fff6079b          	addiw	a5,a2,-1
    80000260:	1782                	slli	a5,a5,0x20
    80000262:	9381                	srli	a5,a5,0x20
    80000264:	fff7c793          	not	a5,a5
    80000268:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000026a:	177d                	addi	a4,a4,-1
    8000026c:	16fd                	addi	a3,a3,-1
    8000026e:	00074603          	lbu	a2,0(a4)
    80000272:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000276:	fee79ae3          	bne	a5,a4,8000026a <memmove+0x4a>
    8000027a:	b7f1                	j	80000246 <memmove+0x26>

000000008000027c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000284:	00000097          	auipc	ra,0x0
    80000288:	f9c080e7          	jalr	-100(ra) # 80000220 <memmove>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	addi	sp,sp,16
    80000292:	8082                	ret

0000000080000294 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e422                	sd	s0,8(sp)
    80000298:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000029a:	ce11                	beqz	a2,800002b6 <strncmp+0x22>
    8000029c:	00054783          	lbu	a5,0(a0)
    800002a0:	cf89                	beqz	a5,800002ba <strncmp+0x26>
    800002a2:	0005c703          	lbu	a4,0(a1)
    800002a6:	00f71a63          	bne	a4,a5,800002ba <strncmp+0x26>
    n--, p++, q++;
    800002aa:	367d                	addiw	a2,a2,-1
    800002ac:	0505                	addi	a0,a0,1
    800002ae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b0:	f675                	bnez	a2,8000029c <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b2:	4501                	li	a0,0
    800002b4:	a809                	j	800002c6 <strncmp+0x32>
    800002b6:	4501                	li	a0,0
    800002b8:	a039                	j	800002c6 <strncmp+0x32>
  if(n == 0)
    800002ba:	ca09                	beqz	a2,800002cc <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002bc:	00054503          	lbu	a0,0(a0)
    800002c0:	0005c783          	lbu	a5,0(a1)
    800002c4:	9d1d                	subw	a0,a0,a5
}
    800002c6:	6422                	ld	s0,8(sp)
    800002c8:	0141                	addi	sp,sp,16
    800002ca:	8082                	ret
    return 0;
    800002cc:	4501                	li	a0,0
    800002ce:	bfe5                	j	800002c6 <strncmp+0x32>

00000000800002d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d0:	1141                	addi	sp,sp,-16
    800002d2:	e422                	sd	s0,8(sp)
    800002d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002d6:	872a                	mv	a4,a0
    800002d8:	8832                	mv	a6,a2
    800002da:	367d                	addiw	a2,a2,-1
    800002dc:	01005963          	blez	a6,800002ee <strncpy+0x1e>
    800002e0:	0705                	addi	a4,a4,1
    800002e2:	0005c783          	lbu	a5,0(a1)
    800002e6:	fef70fa3          	sb	a5,-1(a4)
    800002ea:	0585                	addi	a1,a1,1
    800002ec:	f7f5                	bnez	a5,800002d8 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002ee:	86ba                	mv	a3,a4
    800002f0:	00c05c63          	blez	a2,80000308 <strncpy+0x38>
    *s++ = 0;
    800002f4:	0685                	addi	a3,a3,1
    800002f6:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002fa:	40d707bb          	subw	a5,a4,a3
    800002fe:	37fd                	addiw	a5,a5,-1
    80000300:	010787bb          	addw	a5,a5,a6
    80000304:	fef048e3          	bgtz	a5,800002f4 <strncpy+0x24>
  return os;
}
    80000308:	6422                	ld	s0,8(sp)
    8000030a:	0141                	addi	sp,sp,16
    8000030c:	8082                	ret

000000008000030e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000030e:	1141                	addi	sp,sp,-16
    80000310:	e422                	sd	s0,8(sp)
    80000312:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000314:	02c05363          	blez	a2,8000033a <safestrcpy+0x2c>
    80000318:	fff6069b          	addiw	a3,a2,-1
    8000031c:	1682                	slli	a3,a3,0x20
    8000031e:	9281                	srli	a3,a3,0x20
    80000320:	96ae                	add	a3,a3,a1
    80000322:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000324:	00d58963          	beq	a1,a3,80000336 <safestrcpy+0x28>
    80000328:	0585                	addi	a1,a1,1
    8000032a:	0785                	addi	a5,a5,1
    8000032c:	fff5c703          	lbu	a4,-1(a1)
    80000330:	fee78fa3          	sb	a4,-1(a5)
    80000334:	fb65                	bnez	a4,80000324 <safestrcpy+0x16>
    ;
  *s = 0;
    80000336:	00078023          	sb	zero,0(a5)
  return os;
}
    8000033a:	6422                	ld	s0,8(sp)
    8000033c:	0141                	addi	sp,sp,16
    8000033e:	8082                	ret

0000000080000340 <strlen>:

int
strlen(const char *s)
{
    80000340:	1141                	addi	sp,sp,-16
    80000342:	e422                	sd	s0,8(sp)
    80000344:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000346:	00054783          	lbu	a5,0(a0)
    8000034a:	cf91                	beqz	a5,80000366 <strlen+0x26>
    8000034c:	0505                	addi	a0,a0,1
    8000034e:	87aa                	mv	a5,a0
    80000350:	4685                	li	a3,1
    80000352:	9e89                	subw	a3,a3,a0
    80000354:	00f6853b          	addw	a0,a3,a5
    80000358:	0785                	addi	a5,a5,1
    8000035a:	fff7c703          	lbu	a4,-1(a5)
    8000035e:	fb7d                	bnez	a4,80000354 <strlen+0x14>
    ;
  return n;
}
    80000360:	6422                	ld	s0,8(sp)
    80000362:	0141                	addi	sp,sp,16
    80000364:	8082                	ret
  for(n = 0; s[n]; n++)
    80000366:	4501                	li	a0,0
    80000368:	bfe5                	j	80000360 <strlen+0x20>

000000008000036a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000036a:	1141                	addi	sp,sp,-16
    8000036c:	e406                	sd	ra,8(sp)
    8000036e:	e022                	sd	s0,0(sp)
    80000370:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000372:	00001097          	auipc	ra,0x1
    80000376:	af0080e7          	jalr	-1296(ra) # 80000e62 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000037a:	00009717          	auipc	a4,0x9
    8000037e:	c8670713          	addi	a4,a4,-890 # 80009000 <started>
  if(cpuid() == 0){
    80000382:	c139                	beqz	a0,800003c8 <main+0x5e>
    while(started == 0)
    80000384:	431c                	lw	a5,0(a4)
    80000386:	2781                	sext.w	a5,a5
    80000388:	dff5                	beqz	a5,80000384 <main+0x1a>
      ;
    __sync_synchronize();
    8000038a:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000038e:	00001097          	auipc	ra,0x1
    80000392:	ad4080e7          	jalr	-1324(ra) # 80000e62 <cpuid>
    80000396:	85aa                	mv	a1,a0
    80000398:	00008517          	auipc	a0,0x8
    8000039c:	ca050513          	addi	a0,a0,-864 # 80008038 <etext+0x38>
    800003a0:	00006097          	auipc	ra,0x6
    800003a4:	90a080e7          	jalr	-1782(ra) # 80005caa <printf>
    kvminithart();    // turn on paging
    800003a8:	00000097          	auipc	ra,0x0
    800003ac:	0d8080e7          	jalr	216(ra) # 80000480 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003b0:	00001097          	auipc	ra,0x1
    800003b4:	76a080e7          	jalr	1898(ra) # 80001b1a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003b8:	00005097          	auipc	ra,0x5
    800003bc:	dd8080e7          	jalr	-552(ra) # 80005190 <plicinithart>
  }

  scheduler();        
    800003c0:	00001097          	auipc	ra,0x1
    800003c4:	fe8080e7          	jalr	-24(ra) # 800013a8 <scheduler>
    consoleinit();
    800003c8:	00005097          	auipc	ra,0x5
    800003cc:	7a8080e7          	jalr	1960(ra) # 80005b70 <consoleinit>
    printfinit();
    800003d0:	00006097          	auipc	ra,0x6
    800003d4:	aba080e7          	jalr	-1350(ra) # 80005e8a <printfinit>
    printf("\n");
    800003d8:	00008517          	auipc	a0,0x8
    800003dc:	c7050513          	addi	a0,a0,-912 # 80008048 <etext+0x48>
    800003e0:	00006097          	auipc	ra,0x6
    800003e4:	8ca080e7          	jalr	-1846(ra) # 80005caa <printf>
    printf("xv6 kernel is booting\n");
    800003e8:	00008517          	auipc	a0,0x8
    800003ec:	c3850513          	addi	a0,a0,-968 # 80008020 <etext+0x20>
    800003f0:	00006097          	auipc	ra,0x6
    800003f4:	8ba080e7          	jalr	-1862(ra) # 80005caa <printf>
    printf("\n");
    800003f8:	00008517          	auipc	a0,0x8
    800003fc:	c5050513          	addi	a0,a0,-944 # 80008048 <etext+0x48>
    80000400:	00006097          	auipc	ra,0x6
    80000404:	8aa080e7          	jalr	-1878(ra) # 80005caa <printf>
    kinit();         // physical page allocator
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	cd6080e7          	jalr	-810(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    80000410:	00000097          	auipc	ra,0x0
    80000414:	322080e7          	jalr	802(ra) # 80000732 <kvminit>
    kvminithart();   // turn on paging
    80000418:	00000097          	auipc	ra,0x0
    8000041c:	068080e7          	jalr	104(ra) # 80000480 <kvminithart>
    procinit();      // process table
    80000420:	00001097          	auipc	ra,0x1
    80000424:	992080e7          	jalr	-1646(ra) # 80000db2 <procinit>
    trapinit();      // trap vectors
    80000428:	00001097          	auipc	ra,0x1
    8000042c:	6ca080e7          	jalr	1738(ra) # 80001af2 <trapinit>
    trapinithart();  // install kernel trap vector
    80000430:	00001097          	auipc	ra,0x1
    80000434:	6ea080e7          	jalr	1770(ra) # 80001b1a <trapinithart>
    plicinit();      // set up interrupt controller
    80000438:	00005097          	auipc	ra,0x5
    8000043c:	d42080e7          	jalr	-702(ra) # 8000517a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000440:	00005097          	auipc	ra,0x5
    80000444:	d50080e7          	jalr	-688(ra) # 80005190 <plicinithart>
    binit();         // buffer cache
    80000448:	00002097          	auipc	ra,0x2
    8000044c:	f0e080e7          	jalr	-242(ra) # 80002356 <binit>
    iinit();         // inode table
    80000450:	00002097          	auipc	ra,0x2
    80000454:	59c080e7          	jalr	1436(ra) # 800029ec <iinit>
    fileinit();      // file table
    80000458:	00003097          	auipc	ra,0x3
    8000045c:	54e080e7          	jalr	1358(ra) # 800039a6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000460:	00005097          	auipc	ra,0x5
    80000464:	e50080e7          	jalr	-432(ra) # 800052b0 <virtio_disk_init>
    userinit();      // first user process
    80000468:	00001097          	auipc	ra,0x1
    8000046c:	cfe080e7          	jalr	-770(ra) # 80001166 <userinit>
    __sync_synchronize();
    80000470:	0ff0000f          	fence
    started = 1;
    80000474:	4785                	li	a5,1
    80000476:	00009717          	auipc	a4,0x9
    8000047a:	b8f72523          	sw	a5,-1142(a4) # 80009000 <started>
    8000047e:	b789                	j	800003c0 <main+0x56>

0000000080000480 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000480:	1141                	addi	sp,sp,-16
    80000482:	e422                	sd	s0,8(sp)
    80000484:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000486:	00009797          	auipc	a5,0x9
    8000048a:	b827b783          	ld	a5,-1150(a5) # 80009008 <kernel_pagetable>
    8000048e:	83b1                	srli	a5,a5,0xc
    80000490:	577d                	li	a4,-1
    80000492:	177e                	slli	a4,a4,0x3f
    80000494:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000496:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000049a:	12000073          	sfence.vma
  sfence_vma();
}
    8000049e:	6422                	ld	s0,8(sp)
    800004a0:	0141                	addi	sp,sp,16
    800004a2:	8082                	ret

00000000800004a4 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004a4:	7139                	addi	sp,sp,-64
    800004a6:	fc06                	sd	ra,56(sp)
    800004a8:	f822                	sd	s0,48(sp)
    800004aa:	f426                	sd	s1,40(sp)
    800004ac:	f04a                	sd	s2,32(sp)
    800004ae:	ec4e                	sd	s3,24(sp)
    800004b0:	e852                	sd	s4,16(sp)
    800004b2:	e456                	sd	s5,8(sp)
    800004b4:	e05a                	sd	s6,0(sp)
    800004b6:	0080                	addi	s0,sp,64
    800004b8:	84aa                	mv	s1,a0
    800004ba:	89ae                	mv	s3,a1
    800004bc:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004be:	57fd                	li	a5,-1
    800004c0:	83e9                	srli	a5,a5,0x1a
    800004c2:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004c4:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004c6:	04b7f263          	bgeu	a5,a1,8000050a <walk+0x66>
    panic("walk");
    800004ca:	00008517          	auipc	a0,0x8
    800004ce:	b8650513          	addi	a0,a0,-1146 # 80008050 <etext+0x50>
    800004d2:	00005097          	auipc	ra,0x5
    800004d6:	78e080e7          	jalr	1934(ra) # 80005c60 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004da:	060a8663          	beqz	s5,80000546 <walk+0xa2>
    800004de:	00000097          	auipc	ra,0x0
    800004e2:	c3c080e7          	jalr	-964(ra) # 8000011a <kalloc>
    800004e6:	84aa                	mv	s1,a0
    800004e8:	c529                	beqz	a0,80000532 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004ea:	6605                	lui	a2,0x1
    800004ec:	4581                	li	a1,0
    800004ee:	00000097          	auipc	ra,0x0
    800004f2:	cd6080e7          	jalr	-810(ra) # 800001c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004f6:	00c4d793          	srli	a5,s1,0xc
    800004fa:	07aa                	slli	a5,a5,0xa
    800004fc:	0017e793          	ori	a5,a5,1
    80000500:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000504:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    80000506:	036a0063          	beq	s4,s6,80000526 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000050a:	0149d933          	srl	s2,s3,s4
    8000050e:	1ff97913          	andi	s2,s2,511
    80000512:	090e                	slli	s2,s2,0x3
    80000514:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000516:	00093483          	ld	s1,0(s2)
    8000051a:	0014f793          	andi	a5,s1,1
    8000051e:	dfd5                	beqz	a5,800004da <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000520:	80a9                	srli	s1,s1,0xa
    80000522:	04b2                	slli	s1,s1,0xc
    80000524:	b7c5                	j	80000504 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000526:	00c9d513          	srli	a0,s3,0xc
    8000052a:	1ff57513          	andi	a0,a0,511
    8000052e:	050e                	slli	a0,a0,0x3
    80000530:	9526                	add	a0,a0,s1
}
    80000532:	70e2                	ld	ra,56(sp)
    80000534:	7442                	ld	s0,48(sp)
    80000536:	74a2                	ld	s1,40(sp)
    80000538:	7902                	ld	s2,32(sp)
    8000053a:	69e2                	ld	s3,24(sp)
    8000053c:	6a42                	ld	s4,16(sp)
    8000053e:	6aa2                	ld	s5,8(sp)
    80000540:	6b02                	ld	s6,0(sp)
    80000542:	6121                	addi	sp,sp,64
    80000544:	8082                	ret
        return 0;
    80000546:	4501                	li	a0,0
    80000548:	b7ed                	j	80000532 <walk+0x8e>

000000008000054a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000054a:	57fd                	li	a5,-1
    8000054c:	83e9                	srli	a5,a5,0x1a
    8000054e:	00b7f463          	bgeu	a5,a1,80000556 <walkaddr+0xc>
    return 0;
    80000552:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000554:	8082                	ret
{
    80000556:	1141                	addi	sp,sp,-16
    80000558:	e406                	sd	ra,8(sp)
    8000055a:	e022                	sd	s0,0(sp)
    8000055c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000055e:	4601                	li	a2,0
    80000560:	00000097          	auipc	ra,0x0
    80000564:	f44080e7          	jalr	-188(ra) # 800004a4 <walk>
  if(pte == 0)
    80000568:	c105                	beqz	a0,80000588 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000056a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000056c:	0117f693          	andi	a3,a5,17
    80000570:	4745                	li	a4,17
    return 0;
    80000572:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000574:	00e68663          	beq	a3,a4,80000580 <walkaddr+0x36>
}
    80000578:	60a2                	ld	ra,8(sp)
    8000057a:	6402                	ld	s0,0(sp)
    8000057c:	0141                	addi	sp,sp,16
    8000057e:	8082                	ret
  pa = PTE2PA(*pte);
    80000580:	83a9                	srli	a5,a5,0xa
    80000582:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000586:	bfcd                	j	80000578 <walkaddr+0x2e>
    return 0;
    80000588:	4501                	li	a0,0
    8000058a:	b7fd                	j	80000578 <walkaddr+0x2e>

000000008000058c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000058c:	715d                	addi	sp,sp,-80
    8000058e:	e486                	sd	ra,72(sp)
    80000590:	e0a2                	sd	s0,64(sp)
    80000592:	fc26                	sd	s1,56(sp)
    80000594:	f84a                	sd	s2,48(sp)
    80000596:	f44e                	sd	s3,40(sp)
    80000598:	f052                	sd	s4,32(sp)
    8000059a:	ec56                	sd	s5,24(sp)
    8000059c:	e85a                	sd	s6,16(sp)
    8000059e:	e45e                	sd	s7,8(sp)
    800005a0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a2:	c639                	beqz	a2,800005f0 <mappages+0x64>
    800005a4:	8aaa                	mv	s5,a0
    800005a6:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005a8:	777d                	lui	a4,0xfffff
    800005aa:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800005ae:	fff58993          	addi	s3,a1,-1
    800005b2:	99b2                	add	s3,s3,a2
    800005b4:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800005b8:	893e                	mv	s2,a5
    800005ba:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005be:	6b85                	lui	s7,0x1
    800005c0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c4:	4605                	li	a2,1
    800005c6:	85ca                	mv	a1,s2
    800005c8:	8556                	mv	a0,s5
    800005ca:	00000097          	auipc	ra,0x0
    800005ce:	eda080e7          	jalr	-294(ra) # 800004a4 <walk>
    800005d2:	cd1d                	beqz	a0,80000610 <mappages+0x84>
    if(*pte & PTE_V)
    800005d4:	611c                	ld	a5,0(a0)
    800005d6:	8b85                	andi	a5,a5,1
    800005d8:	e785                	bnez	a5,80000600 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005da:	80b1                	srli	s1,s1,0xc
    800005dc:	04aa                	slli	s1,s1,0xa
    800005de:	0164e4b3          	or	s1,s1,s6
    800005e2:	0014e493          	ori	s1,s1,1
    800005e6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005e8:	05390063          	beq	s2,s3,80000628 <mappages+0x9c>
    a += PGSIZE;
    800005ec:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ee:	bfc9                	j	800005c0 <mappages+0x34>
    panic("mappages: size");
    800005f0:	00008517          	auipc	a0,0x8
    800005f4:	a6850513          	addi	a0,a0,-1432 # 80008058 <etext+0x58>
    800005f8:	00005097          	auipc	ra,0x5
    800005fc:	668080e7          	jalr	1640(ra) # 80005c60 <panic>
      panic("mappages: remap");
    80000600:	00008517          	auipc	a0,0x8
    80000604:	a6850513          	addi	a0,a0,-1432 # 80008068 <etext+0x68>
    80000608:	00005097          	auipc	ra,0x5
    8000060c:	658080e7          	jalr	1624(ra) # 80005c60 <panic>
      return -1;
    80000610:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000612:	60a6                	ld	ra,72(sp)
    80000614:	6406                	ld	s0,64(sp)
    80000616:	74e2                	ld	s1,56(sp)
    80000618:	7942                	ld	s2,48(sp)
    8000061a:	79a2                	ld	s3,40(sp)
    8000061c:	7a02                	ld	s4,32(sp)
    8000061e:	6ae2                	ld	s5,24(sp)
    80000620:	6b42                	ld	s6,16(sp)
    80000622:	6ba2                	ld	s7,8(sp)
    80000624:	6161                	addi	sp,sp,80
    80000626:	8082                	ret
  return 0;
    80000628:	4501                	li	a0,0
    8000062a:	b7e5                	j	80000612 <mappages+0x86>

000000008000062c <kvmmap>:
{
    8000062c:	1141                	addi	sp,sp,-16
    8000062e:	e406                	sd	ra,8(sp)
    80000630:	e022                	sd	s0,0(sp)
    80000632:	0800                	addi	s0,sp,16
    80000634:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000636:	86b2                	mv	a3,a2
    80000638:	863e                	mv	a2,a5
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	f52080e7          	jalr	-174(ra) # 8000058c <mappages>
    80000642:	e509                	bnez	a0,8000064c <kvmmap+0x20>
}
    80000644:	60a2                	ld	ra,8(sp)
    80000646:	6402                	ld	s0,0(sp)
    80000648:	0141                	addi	sp,sp,16
    8000064a:	8082                	ret
    panic("kvmmap");
    8000064c:	00008517          	auipc	a0,0x8
    80000650:	a2c50513          	addi	a0,a0,-1492 # 80008078 <etext+0x78>
    80000654:	00005097          	auipc	ra,0x5
    80000658:	60c080e7          	jalr	1548(ra) # 80005c60 <panic>

000000008000065c <kvmmake>:
{
    8000065c:	1101                	addi	sp,sp,-32
    8000065e:	ec06                	sd	ra,24(sp)
    80000660:	e822                	sd	s0,16(sp)
    80000662:	e426                	sd	s1,8(sp)
    80000664:	e04a                	sd	s2,0(sp)
    80000666:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	ab2080e7          	jalr	-1358(ra) # 8000011a <kalloc>
    80000670:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000672:	6605                	lui	a2,0x1
    80000674:	4581                	li	a1,0
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	b4e080e7          	jalr	-1202(ra) # 800001c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000067e:	4719                	li	a4,6
    80000680:	6685                	lui	a3,0x1
    80000682:	10000637          	lui	a2,0x10000
    80000686:	100005b7          	lui	a1,0x10000
    8000068a:	8526                	mv	a0,s1
    8000068c:	00000097          	auipc	ra,0x0
    80000690:	fa0080e7          	jalr	-96(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000694:	4719                	li	a4,6
    80000696:	6685                	lui	a3,0x1
    80000698:	10001637          	lui	a2,0x10001
    8000069c:	100015b7          	lui	a1,0x10001
    800006a0:	8526                	mv	a0,s1
    800006a2:	00000097          	auipc	ra,0x0
    800006a6:	f8a080e7          	jalr	-118(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006aa:	4719                	li	a4,6
    800006ac:	004006b7          	lui	a3,0x400
    800006b0:	0c000637          	lui	a2,0xc000
    800006b4:	0c0005b7          	lui	a1,0xc000
    800006b8:	8526                	mv	a0,s1
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	f72080e7          	jalr	-142(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c2:	00008917          	auipc	s2,0x8
    800006c6:	93e90913          	addi	s2,s2,-1730 # 80008000 <etext>
    800006ca:	4729                	li	a4,10
    800006cc:	80008697          	auipc	a3,0x80008
    800006d0:	93468693          	addi	a3,a3,-1740 # 8000 <_entry-0x7fff8000>
    800006d4:	4605                	li	a2,1
    800006d6:	067e                	slli	a2,a2,0x1f
    800006d8:	85b2                	mv	a1,a2
    800006da:	8526                	mv	a0,s1
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	f50080e7          	jalr	-176(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006e4:	4719                	li	a4,6
    800006e6:	46c5                	li	a3,17
    800006e8:	06ee                	slli	a3,a3,0x1b
    800006ea:	412686b3          	sub	a3,a3,s2
    800006ee:	864a                	mv	a2,s2
    800006f0:	85ca                	mv	a1,s2
    800006f2:	8526                	mv	a0,s1
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f38080e7          	jalr	-200(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006fc:	4729                	li	a4,10
    800006fe:	6685                	lui	a3,0x1
    80000700:	00007617          	auipc	a2,0x7
    80000704:	90060613          	addi	a2,a2,-1792 # 80007000 <_trampoline>
    80000708:	040005b7          	lui	a1,0x4000
    8000070c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000070e:	05b2                	slli	a1,a1,0xc
    80000710:	8526                	mv	a0,s1
    80000712:	00000097          	auipc	ra,0x0
    80000716:	f1a080e7          	jalr	-230(ra) # 8000062c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000071a:	8526                	mv	a0,s1
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	600080e7          	jalr	1536(ra) # 80000d1c <proc_mapstacks>
}
    80000724:	8526                	mv	a0,s1
    80000726:	60e2                	ld	ra,24(sp)
    80000728:	6442                	ld	s0,16(sp)
    8000072a:	64a2                	ld	s1,8(sp)
    8000072c:	6902                	ld	s2,0(sp)
    8000072e:	6105                	addi	sp,sp,32
    80000730:	8082                	ret

0000000080000732 <kvminit>:
{
    80000732:	1141                	addi	sp,sp,-16
    80000734:	e406                	sd	ra,8(sp)
    80000736:	e022                	sd	s0,0(sp)
    80000738:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	f22080e7          	jalr	-222(ra) # 8000065c <kvmmake>
    80000742:	00009797          	auipc	a5,0x9
    80000746:	8ca7b323          	sd	a0,-1850(a5) # 80009008 <kernel_pagetable>
}
    8000074a:	60a2                	ld	ra,8(sp)
    8000074c:	6402                	ld	s0,0(sp)
    8000074e:	0141                	addi	sp,sp,16
    80000750:	8082                	ret

0000000080000752 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000752:	715d                	addi	sp,sp,-80
    80000754:	e486                	sd	ra,72(sp)
    80000756:	e0a2                	sd	s0,64(sp)
    80000758:	fc26                	sd	s1,56(sp)
    8000075a:	f84a                	sd	s2,48(sp)
    8000075c:	f44e                	sd	s3,40(sp)
    8000075e:	f052                	sd	s4,32(sp)
    80000760:	ec56                	sd	s5,24(sp)
    80000762:	e85a                	sd	s6,16(sp)
    80000764:	e45e                	sd	s7,8(sp)
    80000766:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000768:	03459793          	slli	a5,a1,0x34
    8000076c:	e795                	bnez	a5,80000798 <uvmunmap+0x46>
    8000076e:	8a2a                	mv	s4,a0
    80000770:	892e                	mv	s2,a1
    80000772:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000774:	0632                	slli	a2,a2,0xc
    80000776:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000077a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077c:	6b05                	lui	s6,0x1
    8000077e:	0735e263          	bltu	a1,s3,800007e2 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000782:	60a6                	ld	ra,72(sp)
    80000784:	6406                	ld	s0,64(sp)
    80000786:	74e2                	ld	s1,56(sp)
    80000788:	7942                	ld	s2,48(sp)
    8000078a:	79a2                	ld	s3,40(sp)
    8000078c:	7a02                	ld	s4,32(sp)
    8000078e:	6ae2                	ld	s5,24(sp)
    80000790:	6b42                	ld	s6,16(sp)
    80000792:	6ba2                	ld	s7,8(sp)
    80000794:	6161                	addi	sp,sp,80
    80000796:	8082                	ret
    panic("uvmunmap: not aligned");
    80000798:	00008517          	auipc	a0,0x8
    8000079c:	8e850513          	addi	a0,a0,-1816 # 80008080 <etext+0x80>
    800007a0:	00005097          	auipc	ra,0x5
    800007a4:	4c0080e7          	jalr	1216(ra) # 80005c60 <panic>
      panic("uvmunmap: walk");
    800007a8:	00008517          	auipc	a0,0x8
    800007ac:	8f050513          	addi	a0,a0,-1808 # 80008098 <etext+0x98>
    800007b0:	00005097          	auipc	ra,0x5
    800007b4:	4b0080e7          	jalr	1200(ra) # 80005c60 <panic>
      panic("uvmunmap: not mapped");
    800007b8:	00008517          	auipc	a0,0x8
    800007bc:	8f050513          	addi	a0,a0,-1808 # 800080a8 <etext+0xa8>
    800007c0:	00005097          	auipc	ra,0x5
    800007c4:	4a0080e7          	jalr	1184(ra) # 80005c60 <panic>
      panic("uvmunmap: not a leaf");
    800007c8:	00008517          	auipc	a0,0x8
    800007cc:	8f850513          	addi	a0,a0,-1800 # 800080c0 <etext+0xc0>
    800007d0:	00005097          	auipc	ra,0x5
    800007d4:	490080e7          	jalr	1168(ra) # 80005c60 <panic>
    *pte = 0;
    800007d8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007dc:	995a                	add	s2,s2,s6
    800007de:	fb3972e3          	bgeu	s2,s3,80000782 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007e2:	4601                	li	a2,0
    800007e4:	85ca                	mv	a1,s2
    800007e6:	8552                	mv	a0,s4
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	cbc080e7          	jalr	-836(ra) # 800004a4 <walk>
    800007f0:	84aa                	mv	s1,a0
    800007f2:	d95d                	beqz	a0,800007a8 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007f4:	6108                	ld	a0,0(a0)
    800007f6:	00157793          	andi	a5,a0,1
    800007fa:	dfdd                	beqz	a5,800007b8 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007fc:	3ff57793          	andi	a5,a0,1023
    80000800:	fd7784e3          	beq	a5,s7,800007c8 <uvmunmap+0x76>
    if(do_free){
    80000804:	fc0a8ae3          	beqz	s5,800007d8 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80000808:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000080a:	0532                	slli	a0,a0,0xc
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	810080e7          	jalr	-2032(ra) # 8000001c <kfree>
    80000814:	b7d1                	j	800007d8 <uvmunmap+0x86>

0000000080000816 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000816:	1101                	addi	sp,sp,-32
    80000818:	ec06                	sd	ra,24(sp)
    8000081a:	e822                	sd	s0,16(sp)
    8000081c:	e426                	sd	s1,8(sp)
    8000081e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	8fa080e7          	jalr	-1798(ra) # 8000011a <kalloc>
    80000828:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000082a:	c519                	beqz	a0,80000838 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000082c:	6605                	lui	a2,0x1
    8000082e:	4581                	li	a1,0
    80000830:	00000097          	auipc	ra,0x0
    80000834:	994080e7          	jalr	-1644(ra) # 800001c4 <memset>
  return pagetable;
}
    80000838:	8526                	mv	a0,s1
    8000083a:	60e2                	ld	ra,24(sp)
    8000083c:	6442                	ld	s0,16(sp)
    8000083e:	64a2                	ld	s1,8(sp)
    80000840:	6105                	addi	sp,sp,32
    80000842:	8082                	ret

0000000080000844 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000844:	7179                	addi	sp,sp,-48
    80000846:	f406                	sd	ra,40(sp)
    80000848:	f022                	sd	s0,32(sp)
    8000084a:	ec26                	sd	s1,24(sp)
    8000084c:	e84a                	sd	s2,16(sp)
    8000084e:	e44e                	sd	s3,8(sp)
    80000850:	e052                	sd	s4,0(sp)
    80000852:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000854:	6785                	lui	a5,0x1
    80000856:	04f67863          	bgeu	a2,a5,800008a6 <uvminit+0x62>
    8000085a:	8a2a                	mv	s4,a0
    8000085c:	89ae                	mv	s3,a1
    8000085e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000860:	00000097          	auipc	ra,0x0
    80000864:	8ba080e7          	jalr	-1862(ra) # 8000011a <kalloc>
    80000868:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000086a:	6605                	lui	a2,0x1
    8000086c:	4581                	li	a1,0
    8000086e:	00000097          	auipc	ra,0x0
    80000872:	956080e7          	jalr	-1706(ra) # 800001c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000876:	4779                	li	a4,30
    80000878:	86ca                	mv	a3,s2
    8000087a:	6605                	lui	a2,0x1
    8000087c:	4581                	li	a1,0
    8000087e:	8552                	mv	a0,s4
    80000880:	00000097          	auipc	ra,0x0
    80000884:	d0c080e7          	jalr	-756(ra) # 8000058c <mappages>
  memmove(mem, src, sz);
    80000888:	8626                	mv	a2,s1
    8000088a:	85ce                	mv	a1,s3
    8000088c:	854a                	mv	a0,s2
    8000088e:	00000097          	auipc	ra,0x0
    80000892:	992080e7          	jalr	-1646(ra) # 80000220 <memmove>
}
    80000896:	70a2                	ld	ra,40(sp)
    80000898:	7402                	ld	s0,32(sp)
    8000089a:	64e2                	ld	s1,24(sp)
    8000089c:	6942                	ld	s2,16(sp)
    8000089e:	69a2                	ld	s3,8(sp)
    800008a0:	6a02                	ld	s4,0(sp)
    800008a2:	6145                	addi	sp,sp,48
    800008a4:	8082                	ret
    panic("inituvm: more than a page");
    800008a6:	00008517          	auipc	a0,0x8
    800008aa:	83250513          	addi	a0,a0,-1998 # 800080d8 <etext+0xd8>
    800008ae:	00005097          	auipc	ra,0x5
    800008b2:	3b2080e7          	jalr	946(ra) # 80005c60 <panic>

00000000800008b6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008b6:	1101                	addi	sp,sp,-32
    800008b8:	ec06                	sd	ra,24(sp)
    800008ba:	e822                	sd	s0,16(sp)
    800008bc:	e426                	sd	s1,8(sp)
    800008be:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c2:	00b67d63          	bgeu	a2,a1,800008dc <uvmdealloc+0x26>
    800008c6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008c8:	6785                	lui	a5,0x1
    800008ca:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008cc:	00f60733          	add	a4,a2,a5
    800008d0:	76fd                	lui	a3,0xfffff
    800008d2:	8f75                	and	a4,a4,a3
    800008d4:	97ae                	add	a5,a5,a1
    800008d6:	8ff5                	and	a5,a5,a3
    800008d8:	00f76863          	bltu	a4,a5,800008e8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008dc:	8526                	mv	a0,s1
    800008de:	60e2                	ld	ra,24(sp)
    800008e0:	6442                	ld	s0,16(sp)
    800008e2:	64a2                	ld	s1,8(sp)
    800008e4:	6105                	addi	sp,sp,32
    800008e6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008e8:	8f99                	sub	a5,a5,a4
    800008ea:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ec:	4685                	li	a3,1
    800008ee:	0007861b          	sext.w	a2,a5
    800008f2:	85ba                	mv	a1,a4
    800008f4:	00000097          	auipc	ra,0x0
    800008f8:	e5e080e7          	jalr	-418(ra) # 80000752 <uvmunmap>
    800008fc:	b7c5                	j	800008dc <uvmdealloc+0x26>

00000000800008fe <uvmalloc>:
  if(newsz < oldsz)
    800008fe:	0ab66163          	bltu	a2,a1,800009a0 <uvmalloc+0xa2>
{
    80000902:	7139                	addi	sp,sp,-64
    80000904:	fc06                	sd	ra,56(sp)
    80000906:	f822                	sd	s0,48(sp)
    80000908:	f426                	sd	s1,40(sp)
    8000090a:	f04a                	sd	s2,32(sp)
    8000090c:	ec4e                	sd	s3,24(sp)
    8000090e:	e852                	sd	s4,16(sp)
    80000910:	e456                	sd	s5,8(sp)
    80000912:	0080                	addi	s0,sp,64
    80000914:	8aaa                	mv	s5,a0
    80000916:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000918:	6785                	lui	a5,0x1
    8000091a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000091c:	95be                	add	a1,a1,a5
    8000091e:	77fd                	lui	a5,0xfffff
    80000920:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000924:	08c9f063          	bgeu	s3,a2,800009a4 <uvmalloc+0xa6>
    80000928:	894e                	mv	s2,s3
    mem = kalloc();
    8000092a:	fffff097          	auipc	ra,0xfffff
    8000092e:	7f0080e7          	jalr	2032(ra) # 8000011a <kalloc>
    80000932:	84aa                	mv	s1,a0
    if(mem == 0){
    80000934:	c51d                	beqz	a0,80000962 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000936:	6605                	lui	a2,0x1
    80000938:	4581                	li	a1,0
    8000093a:	00000097          	auipc	ra,0x0
    8000093e:	88a080e7          	jalr	-1910(ra) # 800001c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000942:	4779                	li	a4,30
    80000944:	86a6                	mv	a3,s1
    80000946:	6605                	lui	a2,0x1
    80000948:	85ca                	mv	a1,s2
    8000094a:	8556                	mv	a0,s5
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	c40080e7          	jalr	-960(ra) # 8000058c <mappages>
    80000954:	e905                	bnez	a0,80000984 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000956:	6785                	lui	a5,0x1
    80000958:	993e                	add	s2,s2,a5
    8000095a:	fd4968e3          	bltu	s2,s4,8000092a <uvmalloc+0x2c>
  return newsz;
    8000095e:	8552                	mv	a0,s4
    80000960:	a809                	j	80000972 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000962:	864e                	mv	a2,s3
    80000964:	85ca                	mv	a1,s2
    80000966:	8556                	mv	a0,s5
    80000968:	00000097          	auipc	ra,0x0
    8000096c:	f4e080e7          	jalr	-178(ra) # 800008b6 <uvmdealloc>
      return 0;
    80000970:	4501                	li	a0,0
}
    80000972:	70e2                	ld	ra,56(sp)
    80000974:	7442                	ld	s0,48(sp)
    80000976:	74a2                	ld	s1,40(sp)
    80000978:	7902                	ld	s2,32(sp)
    8000097a:	69e2                	ld	s3,24(sp)
    8000097c:	6a42                	ld	s4,16(sp)
    8000097e:	6aa2                	ld	s5,8(sp)
    80000980:	6121                	addi	sp,sp,64
    80000982:	8082                	ret
      kfree(mem);
    80000984:	8526                	mv	a0,s1
    80000986:	fffff097          	auipc	ra,0xfffff
    8000098a:	696080e7          	jalr	1686(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000098e:	864e                	mv	a2,s3
    80000990:	85ca                	mv	a1,s2
    80000992:	8556                	mv	a0,s5
    80000994:	00000097          	auipc	ra,0x0
    80000998:	f22080e7          	jalr	-222(ra) # 800008b6 <uvmdealloc>
      return 0;
    8000099c:	4501                	li	a0,0
    8000099e:	bfd1                	j	80000972 <uvmalloc+0x74>
    return oldsz;
    800009a0:	852e                	mv	a0,a1
}
    800009a2:	8082                	ret
  return newsz;
    800009a4:	8532                	mv	a0,a2
    800009a6:	b7f1                	j	80000972 <uvmalloc+0x74>

00000000800009a8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009a8:	7179                	addi	sp,sp,-48
    800009aa:	f406                	sd	ra,40(sp)
    800009ac:	f022                	sd	s0,32(sp)
    800009ae:	ec26                	sd	s1,24(sp)
    800009b0:	e84a                	sd	s2,16(sp)
    800009b2:	e44e                	sd	s3,8(sp)
    800009b4:	e052                	sd	s4,0(sp)
    800009b6:	1800                	addi	s0,sp,48
    800009b8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009ba:	84aa                	mv	s1,a0
    800009bc:	6905                	lui	s2,0x1
    800009be:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c0:	4985                	li	s3,1
    800009c2:	a829                	j	800009dc <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009c4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009c6:	00c79513          	slli	a0,a5,0xc
    800009ca:	00000097          	auipc	ra,0x0
    800009ce:	fde080e7          	jalr	-34(ra) # 800009a8 <freewalk>
      pagetable[i] = 0;
    800009d2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009d6:	04a1                	addi	s1,s1,8
    800009d8:	03248163          	beq	s1,s2,800009fa <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009dc:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009de:	00f7f713          	andi	a4,a5,15
    800009e2:	ff3701e3          	beq	a4,s3,800009c4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009e6:	8b85                	andi	a5,a5,1
    800009e8:	d7fd                	beqz	a5,800009d6 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009ea:	00007517          	auipc	a0,0x7
    800009ee:	70e50513          	addi	a0,a0,1806 # 800080f8 <etext+0xf8>
    800009f2:	00005097          	auipc	ra,0x5
    800009f6:	26e080e7          	jalr	622(ra) # 80005c60 <panic>
    }
  }
  kfree((void*)pagetable);
    800009fa:	8552                	mv	a0,s4
    800009fc:	fffff097          	auipc	ra,0xfffff
    80000a00:	620080e7          	jalr	1568(ra) # 8000001c <kfree>
}
    80000a04:	70a2                	ld	ra,40(sp)
    80000a06:	7402                	ld	s0,32(sp)
    80000a08:	64e2                	ld	s1,24(sp)
    80000a0a:	6942                	ld	s2,16(sp)
    80000a0c:	69a2                	ld	s3,8(sp)
    80000a0e:	6a02                	ld	s4,0(sp)
    80000a10:	6145                	addi	sp,sp,48
    80000a12:	8082                	ret

0000000080000a14 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a14:	1101                	addi	sp,sp,-32
    80000a16:	ec06                	sd	ra,24(sp)
    80000a18:	e822                	sd	s0,16(sp)
    80000a1a:	e426                	sd	s1,8(sp)
    80000a1c:	1000                	addi	s0,sp,32
    80000a1e:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a20:	e999                	bnez	a1,80000a36 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a22:	8526                	mv	a0,s1
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	f84080e7          	jalr	-124(ra) # 800009a8 <freewalk>
}
    80000a2c:	60e2                	ld	ra,24(sp)
    80000a2e:	6442                	ld	s0,16(sp)
    80000a30:	64a2                	ld	s1,8(sp)
    80000a32:	6105                	addi	sp,sp,32
    80000a34:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a36:	6785                	lui	a5,0x1
    80000a38:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a3a:	95be                	add	a1,a1,a5
    80000a3c:	4685                	li	a3,1
    80000a3e:	00c5d613          	srli	a2,a1,0xc
    80000a42:	4581                	li	a1,0
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	d0e080e7          	jalr	-754(ra) # 80000752 <uvmunmap>
    80000a4c:	bfd9                	j	80000a22 <uvmfree+0xe>

0000000080000a4e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a4e:	c679                	beqz	a2,80000b1c <uvmcopy+0xce>
{
    80000a50:	715d                	addi	sp,sp,-80
    80000a52:	e486                	sd	ra,72(sp)
    80000a54:	e0a2                	sd	s0,64(sp)
    80000a56:	fc26                	sd	s1,56(sp)
    80000a58:	f84a                	sd	s2,48(sp)
    80000a5a:	f44e                	sd	s3,40(sp)
    80000a5c:	f052                	sd	s4,32(sp)
    80000a5e:	ec56                	sd	s5,24(sp)
    80000a60:	e85a                	sd	s6,16(sp)
    80000a62:	e45e                	sd	s7,8(sp)
    80000a64:	0880                	addi	s0,sp,80
    80000a66:	8b2a                	mv	s6,a0
    80000a68:	8aae                	mv	s5,a1
    80000a6a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a6c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a6e:	4601                	li	a2,0
    80000a70:	85ce                	mv	a1,s3
    80000a72:	855a                	mv	a0,s6
    80000a74:	00000097          	auipc	ra,0x0
    80000a78:	a30080e7          	jalr	-1488(ra) # 800004a4 <walk>
    80000a7c:	c531                	beqz	a0,80000ac8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a7e:	6118                	ld	a4,0(a0)
    80000a80:	00177793          	andi	a5,a4,1
    80000a84:	cbb1                	beqz	a5,80000ad8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a86:	00a75593          	srli	a1,a4,0xa
    80000a8a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a8e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a92:	fffff097          	auipc	ra,0xfffff
    80000a96:	688080e7          	jalr	1672(ra) # 8000011a <kalloc>
    80000a9a:	892a                	mv	s2,a0
    80000a9c:	c939                	beqz	a0,80000af2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a9e:	6605                	lui	a2,0x1
    80000aa0:	85de                	mv	a1,s7
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	77e080e7          	jalr	1918(ra) # 80000220 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aaa:	8726                	mv	a4,s1
    80000aac:	86ca                	mv	a3,s2
    80000aae:	6605                	lui	a2,0x1
    80000ab0:	85ce                	mv	a1,s3
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	ad8080e7          	jalr	-1320(ra) # 8000058c <mappages>
    80000abc:	e515                	bnez	a0,80000ae8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000abe:	6785                	lui	a5,0x1
    80000ac0:	99be                	add	s3,s3,a5
    80000ac2:	fb49e6e3          	bltu	s3,s4,80000a6e <uvmcopy+0x20>
    80000ac6:	a081                	j	80000b06 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ac8:	00007517          	auipc	a0,0x7
    80000acc:	64050513          	addi	a0,a0,1600 # 80008108 <etext+0x108>
    80000ad0:	00005097          	auipc	ra,0x5
    80000ad4:	190080e7          	jalr	400(ra) # 80005c60 <panic>
      panic("uvmcopy: page not present");
    80000ad8:	00007517          	auipc	a0,0x7
    80000adc:	65050513          	addi	a0,a0,1616 # 80008128 <etext+0x128>
    80000ae0:	00005097          	auipc	ra,0x5
    80000ae4:	180080e7          	jalr	384(ra) # 80005c60 <panic>
      kfree(mem);
    80000ae8:	854a                	mv	a0,s2
    80000aea:	fffff097          	auipc	ra,0xfffff
    80000aee:	532080e7          	jalr	1330(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af2:	4685                	li	a3,1
    80000af4:	00c9d613          	srli	a2,s3,0xc
    80000af8:	4581                	li	a1,0
    80000afa:	8556                	mv	a0,s5
    80000afc:	00000097          	auipc	ra,0x0
    80000b00:	c56080e7          	jalr	-938(ra) # 80000752 <uvmunmap>
  return -1;
    80000b04:	557d                	li	a0,-1
}
    80000b06:	60a6                	ld	ra,72(sp)
    80000b08:	6406                	ld	s0,64(sp)
    80000b0a:	74e2                	ld	s1,56(sp)
    80000b0c:	7942                	ld	s2,48(sp)
    80000b0e:	79a2                	ld	s3,40(sp)
    80000b10:	7a02                	ld	s4,32(sp)
    80000b12:	6ae2                	ld	s5,24(sp)
    80000b14:	6b42                	ld	s6,16(sp)
    80000b16:	6ba2                	ld	s7,8(sp)
    80000b18:	6161                	addi	sp,sp,80
    80000b1a:	8082                	ret
  return 0;
    80000b1c:	4501                	li	a0,0
}
    80000b1e:	8082                	ret

0000000080000b20 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b20:	1141                	addi	sp,sp,-16
    80000b22:	e406                	sd	ra,8(sp)
    80000b24:	e022                	sd	s0,0(sp)
    80000b26:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b28:	4601                	li	a2,0
    80000b2a:	00000097          	auipc	ra,0x0
    80000b2e:	97a080e7          	jalr	-1670(ra) # 800004a4 <walk>
  if(pte == 0)
    80000b32:	c901                	beqz	a0,80000b42 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b34:	611c                	ld	a5,0(a0)
    80000b36:	9bbd                	andi	a5,a5,-17
    80000b38:	e11c                	sd	a5,0(a0)
}
    80000b3a:	60a2                	ld	ra,8(sp)
    80000b3c:	6402                	ld	s0,0(sp)
    80000b3e:	0141                	addi	sp,sp,16
    80000b40:	8082                	ret
    panic("uvmclear");
    80000b42:	00007517          	auipc	a0,0x7
    80000b46:	60650513          	addi	a0,a0,1542 # 80008148 <etext+0x148>
    80000b4a:	00005097          	auipc	ra,0x5
    80000b4e:	116080e7          	jalr	278(ra) # 80005c60 <panic>

0000000080000b52 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b52:	c6bd                	beqz	a3,80000bc0 <copyout+0x6e>
{
    80000b54:	715d                	addi	sp,sp,-80
    80000b56:	e486                	sd	ra,72(sp)
    80000b58:	e0a2                	sd	s0,64(sp)
    80000b5a:	fc26                	sd	s1,56(sp)
    80000b5c:	f84a                	sd	s2,48(sp)
    80000b5e:	f44e                	sd	s3,40(sp)
    80000b60:	f052                	sd	s4,32(sp)
    80000b62:	ec56                	sd	s5,24(sp)
    80000b64:	e85a                	sd	s6,16(sp)
    80000b66:	e45e                	sd	s7,8(sp)
    80000b68:	e062                	sd	s8,0(sp)
    80000b6a:	0880                	addi	s0,sp,80
    80000b6c:	8b2a                	mv	s6,a0
    80000b6e:	8c2e                	mv	s8,a1
    80000b70:	8a32                	mv	s4,a2
    80000b72:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b74:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b76:	6a85                	lui	s5,0x1
    80000b78:	a015                	j	80000b9c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b7a:	9562                	add	a0,a0,s8
    80000b7c:	0004861b          	sext.w	a2,s1
    80000b80:	85d2                	mv	a1,s4
    80000b82:	41250533          	sub	a0,a0,s2
    80000b86:	fffff097          	auipc	ra,0xfffff
    80000b8a:	69a080e7          	jalr	1690(ra) # 80000220 <memmove>

    len -= n;
    80000b8e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b92:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b94:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b98:	02098263          	beqz	s3,80000bbc <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b9c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ba0:	85ca                	mv	a1,s2
    80000ba2:	855a                	mv	a0,s6
    80000ba4:	00000097          	auipc	ra,0x0
    80000ba8:	9a6080e7          	jalr	-1626(ra) # 8000054a <walkaddr>
    if(pa0 == 0)
    80000bac:	cd01                	beqz	a0,80000bc4 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bae:	418904b3          	sub	s1,s2,s8
    80000bb2:	94d6                	add	s1,s1,s5
    80000bb4:	fc99f3e3          	bgeu	s3,s1,80000b7a <copyout+0x28>
    80000bb8:	84ce                	mv	s1,s3
    80000bba:	b7c1                	j	80000b7a <copyout+0x28>
  }
  return 0;
    80000bbc:	4501                	li	a0,0
    80000bbe:	a021                	j	80000bc6 <copyout+0x74>
    80000bc0:	4501                	li	a0,0
}
    80000bc2:	8082                	ret
      return -1;
    80000bc4:	557d                	li	a0,-1
}
    80000bc6:	60a6                	ld	ra,72(sp)
    80000bc8:	6406                	ld	s0,64(sp)
    80000bca:	74e2                	ld	s1,56(sp)
    80000bcc:	7942                	ld	s2,48(sp)
    80000bce:	79a2                	ld	s3,40(sp)
    80000bd0:	7a02                	ld	s4,32(sp)
    80000bd2:	6ae2                	ld	s5,24(sp)
    80000bd4:	6b42                	ld	s6,16(sp)
    80000bd6:	6ba2                	ld	s7,8(sp)
    80000bd8:	6c02                	ld	s8,0(sp)
    80000bda:	6161                	addi	sp,sp,80
    80000bdc:	8082                	ret

0000000080000bde <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bde:	caa5                	beqz	a3,80000c4e <copyin+0x70>
{
    80000be0:	715d                	addi	sp,sp,-80
    80000be2:	e486                	sd	ra,72(sp)
    80000be4:	e0a2                	sd	s0,64(sp)
    80000be6:	fc26                	sd	s1,56(sp)
    80000be8:	f84a                	sd	s2,48(sp)
    80000bea:	f44e                	sd	s3,40(sp)
    80000bec:	f052                	sd	s4,32(sp)
    80000bee:	ec56                	sd	s5,24(sp)
    80000bf0:	e85a                	sd	s6,16(sp)
    80000bf2:	e45e                	sd	s7,8(sp)
    80000bf4:	e062                	sd	s8,0(sp)
    80000bf6:	0880                	addi	s0,sp,80
    80000bf8:	8b2a                	mv	s6,a0
    80000bfa:	8a2e                	mv	s4,a1
    80000bfc:	8c32                	mv	s8,a2
    80000bfe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c00:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c02:	6a85                	lui	s5,0x1
    80000c04:	a01d                	j	80000c2a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c06:	018505b3          	add	a1,a0,s8
    80000c0a:	0004861b          	sext.w	a2,s1
    80000c0e:	412585b3          	sub	a1,a1,s2
    80000c12:	8552                	mv	a0,s4
    80000c14:	fffff097          	auipc	ra,0xfffff
    80000c18:	60c080e7          	jalr	1548(ra) # 80000220 <memmove>

    len -= n;
    80000c1c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c20:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c22:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c26:	02098263          	beqz	s3,80000c4a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c2a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c2e:	85ca                	mv	a1,s2
    80000c30:	855a                	mv	a0,s6
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	918080e7          	jalr	-1768(ra) # 8000054a <walkaddr>
    if(pa0 == 0)
    80000c3a:	cd01                	beqz	a0,80000c52 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c3c:	418904b3          	sub	s1,s2,s8
    80000c40:	94d6                	add	s1,s1,s5
    80000c42:	fc99f2e3          	bgeu	s3,s1,80000c06 <copyin+0x28>
    80000c46:	84ce                	mv	s1,s3
    80000c48:	bf7d                	j	80000c06 <copyin+0x28>
  }
  return 0;
    80000c4a:	4501                	li	a0,0
    80000c4c:	a021                	j	80000c54 <copyin+0x76>
    80000c4e:	4501                	li	a0,0
}
    80000c50:	8082                	ret
      return -1;
    80000c52:	557d                	li	a0,-1
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
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret

0000000080000c6c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c6c:	c2dd                	beqz	a3,80000d12 <copyinstr+0xa6>
{
    80000c6e:	715d                	addi	sp,sp,-80
    80000c70:	e486                	sd	ra,72(sp)
    80000c72:	e0a2                	sd	s0,64(sp)
    80000c74:	fc26                	sd	s1,56(sp)
    80000c76:	f84a                	sd	s2,48(sp)
    80000c78:	f44e                	sd	s3,40(sp)
    80000c7a:	f052                	sd	s4,32(sp)
    80000c7c:	ec56                	sd	s5,24(sp)
    80000c7e:	e85a                	sd	s6,16(sp)
    80000c80:	e45e                	sd	s7,8(sp)
    80000c82:	0880                	addi	s0,sp,80
    80000c84:	8a2a                	mv	s4,a0
    80000c86:	8b2e                	mv	s6,a1
    80000c88:	8bb2                	mv	s7,a2
    80000c8a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c8c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c8e:	6985                	lui	s3,0x1
    80000c90:	a02d                	j	80000cba <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c92:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c96:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c98:	37fd                	addiw	a5,a5,-1
    80000c9a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c9e:	60a6                	ld	ra,72(sp)
    80000ca0:	6406                	ld	s0,64(sp)
    80000ca2:	74e2                	ld	s1,56(sp)
    80000ca4:	7942                	ld	s2,48(sp)
    80000ca6:	79a2                	ld	s3,40(sp)
    80000ca8:	7a02                	ld	s4,32(sp)
    80000caa:	6ae2                	ld	s5,24(sp)
    80000cac:	6b42                	ld	s6,16(sp)
    80000cae:	6ba2                	ld	s7,8(sp)
    80000cb0:	6161                	addi	sp,sp,80
    80000cb2:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb4:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cb8:	c8a9                	beqz	s1,80000d0a <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000cba:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cbe:	85ca                	mv	a1,s2
    80000cc0:	8552                	mv	a0,s4
    80000cc2:	00000097          	auipc	ra,0x0
    80000cc6:	888080e7          	jalr	-1912(ra) # 8000054a <walkaddr>
    if(pa0 == 0)
    80000cca:	c131                	beqz	a0,80000d0e <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000ccc:	417906b3          	sub	a3,s2,s7
    80000cd0:	96ce                	add	a3,a3,s3
    80000cd2:	00d4f363          	bgeu	s1,a3,80000cd8 <copyinstr+0x6c>
    80000cd6:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cd8:	955e                	add	a0,a0,s7
    80000cda:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cde:	daf9                	beqz	a3,80000cb4 <copyinstr+0x48>
    80000ce0:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ce2:	41650633          	sub	a2,a0,s6
    80000ce6:	fff48593          	addi	a1,s1,-1
    80000cea:	95da                	add	a1,a1,s6
    while(n > 0){
    80000cec:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000cee:	00f60733          	add	a4,a2,a5
    80000cf2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cf6:	df51                	beqz	a4,80000c92 <copyinstr+0x26>
        *dst = *p;
    80000cf8:	00e78023          	sb	a4,0(a5)
      --max;
    80000cfc:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000d00:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d02:	fed796e3          	bne	a5,a3,80000cee <copyinstr+0x82>
      dst++;
    80000d06:	8b3e                	mv	s6,a5
    80000d08:	b775                	j	80000cb4 <copyinstr+0x48>
    80000d0a:	4781                	li	a5,0
    80000d0c:	b771                	j	80000c98 <copyinstr+0x2c>
      return -1;
    80000d0e:	557d                	li	a0,-1
    80000d10:	b779                	j	80000c9e <copyinstr+0x32>
  int got_null = 0;
    80000d12:	4781                	li	a5,0
  if(got_null){
    80000d14:	37fd                	addiw	a5,a5,-1
    80000d16:	0007851b          	sext.w	a0,a5
}
    80000d1a:	8082                	ret

0000000080000d1c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d1c:	7139                	addi	sp,sp,-64
    80000d1e:	fc06                	sd	ra,56(sp)
    80000d20:	f822                	sd	s0,48(sp)
    80000d22:	f426                	sd	s1,40(sp)
    80000d24:	f04a                	sd	s2,32(sp)
    80000d26:	ec4e                	sd	s3,24(sp)
    80000d28:	e852                	sd	s4,16(sp)
    80000d2a:	e456                	sd	s5,8(sp)
    80000d2c:	e05a                	sd	s6,0(sp)
    80000d2e:	0080                	addi	s0,sp,64
    80000d30:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d32:	00008497          	auipc	s1,0x8
    80000d36:	74e48493          	addi	s1,s1,1870 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d3a:	8b26                	mv	s6,s1
    80000d3c:	00007a97          	auipc	s5,0x7
    80000d40:	2c4a8a93          	addi	s5,s5,708 # 80008000 <etext>
    80000d44:	04000937          	lui	s2,0x4000
    80000d48:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d4a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4c:	0000ea17          	auipc	s4,0xe
    80000d50:	334a0a13          	addi	s4,s4,820 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d54:	fffff097          	auipc	ra,0xfffff
    80000d58:	3c6080e7          	jalr	966(ra) # 8000011a <kalloc>
    80000d5c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d5e:	c131                	beqz	a0,80000da2 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d60:	416485b3          	sub	a1,s1,s6
    80000d64:	8591                	srai	a1,a1,0x4
    80000d66:	000ab783          	ld	a5,0(s5)
    80000d6a:	02f585b3          	mul	a1,a1,a5
    80000d6e:	2585                	addiw	a1,a1,1
    80000d70:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d74:	4719                	li	a4,6
    80000d76:	6685                	lui	a3,0x1
    80000d78:	40b905b3          	sub	a1,s2,a1
    80000d7c:	854e                	mv	a0,s3
    80000d7e:	00000097          	auipc	ra,0x0
    80000d82:	8ae080e7          	jalr	-1874(ra) # 8000062c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d86:	17048493          	addi	s1,s1,368
    80000d8a:	fd4495e3          	bne	s1,s4,80000d54 <proc_mapstacks+0x38>
  }
}
    80000d8e:	70e2                	ld	ra,56(sp)
    80000d90:	7442                	ld	s0,48(sp)
    80000d92:	74a2                	ld	s1,40(sp)
    80000d94:	7902                	ld	s2,32(sp)
    80000d96:	69e2                	ld	s3,24(sp)
    80000d98:	6a42                	ld	s4,16(sp)
    80000d9a:	6aa2                	ld	s5,8(sp)
    80000d9c:	6b02                	ld	s6,0(sp)
    80000d9e:	6121                	addi	sp,sp,64
    80000da0:	8082                	ret
      panic("kalloc");
    80000da2:	00007517          	auipc	a0,0x7
    80000da6:	3b650513          	addi	a0,a0,950 # 80008158 <etext+0x158>
    80000daa:	00005097          	auipc	ra,0x5
    80000dae:	eb6080e7          	jalr	-330(ra) # 80005c60 <panic>

0000000080000db2 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000db2:	7139                	addi	sp,sp,-64
    80000db4:	fc06                	sd	ra,56(sp)
    80000db6:	f822                	sd	s0,48(sp)
    80000db8:	f426                	sd	s1,40(sp)
    80000dba:	f04a                	sd	s2,32(sp)
    80000dbc:	ec4e                	sd	s3,24(sp)
    80000dbe:	e852                	sd	s4,16(sp)
    80000dc0:	e456                	sd	s5,8(sp)
    80000dc2:	e05a                	sd	s6,0(sp)
    80000dc4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dc6:	00007597          	auipc	a1,0x7
    80000dca:	39a58593          	addi	a1,a1,922 # 80008160 <etext+0x160>
    80000dce:	00008517          	auipc	a0,0x8
    80000dd2:	28250513          	addi	a0,a0,642 # 80009050 <pid_lock>
    80000dd6:	00005097          	auipc	ra,0x5
    80000dda:	332080e7          	jalr	818(ra) # 80006108 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dde:	00007597          	auipc	a1,0x7
    80000de2:	38a58593          	addi	a1,a1,906 # 80008168 <etext+0x168>
    80000de6:	00008517          	auipc	a0,0x8
    80000dea:	28250513          	addi	a0,a0,642 # 80009068 <wait_lock>
    80000dee:	00005097          	auipc	ra,0x5
    80000df2:	31a080e7          	jalr	794(ra) # 80006108 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df6:	00008497          	auipc	s1,0x8
    80000dfa:	68a48493          	addi	s1,s1,1674 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dfe:	00007b17          	auipc	s6,0x7
    80000e02:	37ab0b13          	addi	s6,s6,890 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e06:	8aa6                	mv	s5,s1
    80000e08:	00007a17          	auipc	s4,0x7
    80000e0c:	1f8a0a13          	addi	s4,s4,504 # 80008000 <etext>
    80000e10:	04000937          	lui	s2,0x4000
    80000e14:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e16:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e18:	0000e997          	auipc	s3,0xe
    80000e1c:	26898993          	addi	s3,s3,616 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000e20:	85da                	mv	a1,s6
    80000e22:	8526                	mv	a0,s1
    80000e24:	00005097          	auipc	ra,0x5
    80000e28:	2e4080e7          	jalr	740(ra) # 80006108 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e2c:	415487b3          	sub	a5,s1,s5
    80000e30:	8791                	srai	a5,a5,0x4
    80000e32:	000a3703          	ld	a4,0(s4)
    80000e36:	02e787b3          	mul	a5,a5,a4
    80000e3a:	2785                	addiw	a5,a5,1
    80000e3c:	00d7979b          	slliw	a5,a5,0xd
    80000e40:	40f907b3          	sub	a5,s2,a5
    80000e44:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e46:	17048493          	addi	s1,s1,368
    80000e4a:	fd349be3          	bne	s1,s3,80000e20 <procinit+0x6e>
  }
}
    80000e4e:	70e2                	ld	ra,56(sp)
    80000e50:	7442                	ld	s0,48(sp)
    80000e52:	74a2                	ld	s1,40(sp)
    80000e54:	7902                	ld	s2,32(sp)
    80000e56:	69e2                	ld	s3,24(sp)
    80000e58:	6a42                	ld	s4,16(sp)
    80000e5a:	6aa2                	ld	s5,8(sp)
    80000e5c:	6b02                	ld	s6,0(sp)
    80000e5e:	6121                	addi	sp,sp,64
    80000e60:	8082                	ret

0000000080000e62 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e422                	sd	s0,8(sp)
    80000e66:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e68:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e6a:	2501                	sext.w	a0,a0
    80000e6c:	6422                	ld	s0,8(sp)
    80000e6e:	0141                	addi	sp,sp,16
    80000e70:	8082                	ret

0000000080000e72 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e72:	1141                	addi	sp,sp,-16
    80000e74:	e422                	sd	s0,8(sp)
    80000e76:	0800                	addi	s0,sp,16
    80000e78:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e7e:	00008517          	auipc	a0,0x8
    80000e82:	20250513          	addi	a0,a0,514 # 80009080 <cpus>
    80000e86:	953e                	add	a0,a0,a5
    80000e88:	6422                	ld	s0,8(sp)
    80000e8a:	0141                	addi	sp,sp,16
    80000e8c:	8082                	ret

0000000080000e8e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e8e:	1101                	addi	sp,sp,-32
    80000e90:	ec06                	sd	ra,24(sp)
    80000e92:	e822                	sd	s0,16(sp)
    80000e94:	e426                	sd	s1,8(sp)
    80000e96:	1000                	addi	s0,sp,32
  push_off();
    80000e98:	00005097          	auipc	ra,0x5
    80000e9c:	2b4080e7          	jalr	692(ra) # 8000614c <push_off>
    80000ea0:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ea2:	2781                	sext.w	a5,a5
    80000ea4:	079e                	slli	a5,a5,0x7
    80000ea6:	00008717          	auipc	a4,0x8
    80000eaa:	1aa70713          	addi	a4,a4,426 # 80009050 <pid_lock>
    80000eae:	97ba                	add	a5,a5,a4
    80000eb0:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eb2:	00005097          	auipc	ra,0x5
    80000eb6:	33a080e7          	jalr	826(ra) # 800061ec <pop_off>
  return p;
}
    80000eba:	8526                	mv	a0,s1
    80000ebc:	60e2                	ld	ra,24(sp)
    80000ebe:	6442                	ld	s0,16(sp)
    80000ec0:	64a2                	ld	s1,8(sp)
    80000ec2:	6105                	addi	sp,sp,32
    80000ec4:	8082                	ret

0000000080000ec6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ec6:	1141                	addi	sp,sp,-16
    80000ec8:	e406                	sd	ra,8(sp)
    80000eca:	e022                	sd	s0,0(sp)
    80000ecc:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ece:	00000097          	auipc	ra,0x0
    80000ed2:	fc0080e7          	jalr	-64(ra) # 80000e8e <myproc>
    80000ed6:	00005097          	auipc	ra,0x5
    80000eda:	376080e7          	jalr	886(ra) # 8000624c <release>

  if (first) {
    80000ede:	00008797          	auipc	a5,0x8
    80000ee2:	a027a783          	lw	a5,-1534(a5) # 800088e0 <first.1>
    80000ee6:	eb89                	bnez	a5,80000ef8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ee8:	00001097          	auipc	ra,0x1
    80000eec:	c4a080e7          	jalr	-950(ra) # 80001b32 <usertrapret>
}
    80000ef0:	60a2                	ld	ra,8(sp)
    80000ef2:	6402                	ld	s0,0(sp)
    80000ef4:	0141                	addi	sp,sp,16
    80000ef6:	8082                	ret
    first = 0;
    80000ef8:	00008797          	auipc	a5,0x8
    80000efc:	9e07a423          	sw	zero,-1560(a5) # 800088e0 <first.1>
    fsinit(ROOTDEV);
    80000f00:	4505                	li	a0,1
    80000f02:	00002097          	auipc	ra,0x2
    80000f06:	a6a080e7          	jalr	-1430(ra) # 8000296c <fsinit>
    80000f0a:	bff9                	j	80000ee8 <forkret+0x22>

0000000080000f0c <allocpid>:
allocpid() {
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f18:	00008917          	auipc	s2,0x8
    80000f1c:	13890913          	addi	s2,s2,312 # 80009050 <pid_lock>
    80000f20:	854a                	mv	a0,s2
    80000f22:	00005097          	auipc	ra,0x5
    80000f26:	276080e7          	jalr	630(ra) # 80006198 <acquire>
  pid = nextpid;
    80000f2a:	00008797          	auipc	a5,0x8
    80000f2e:	9ba78793          	addi	a5,a5,-1606 # 800088e4 <nextpid>
    80000f32:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f34:	0014871b          	addiw	a4,s1,1
    80000f38:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f3a:	854a                	mv	a0,s2
    80000f3c:	00005097          	auipc	ra,0x5
    80000f40:	310080e7          	jalr	784(ra) # 8000624c <release>
}
    80000f44:	8526                	mv	a0,s1
    80000f46:	60e2                	ld	ra,24(sp)
    80000f48:	6442                	ld	s0,16(sp)
    80000f4a:	64a2                	ld	s1,8(sp)
    80000f4c:	6902                	ld	s2,0(sp)
    80000f4e:	6105                	addi	sp,sp,32
    80000f50:	8082                	ret

0000000080000f52 <proc_pagetable>:
{
    80000f52:	1101                	addi	sp,sp,-32
    80000f54:	ec06                	sd	ra,24(sp)
    80000f56:	e822                	sd	s0,16(sp)
    80000f58:	e426                	sd	s1,8(sp)
    80000f5a:	e04a                	sd	s2,0(sp)
    80000f5c:	1000                	addi	s0,sp,32
    80000f5e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f60:	00000097          	auipc	ra,0x0
    80000f64:	8b6080e7          	jalr	-1866(ra) # 80000816 <uvmcreate>
    80000f68:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f6a:	c121                	beqz	a0,80000faa <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f6c:	4729                	li	a4,10
    80000f6e:	00006697          	auipc	a3,0x6
    80000f72:	09268693          	addi	a3,a3,146 # 80007000 <_trampoline>
    80000f76:	6605                	lui	a2,0x1
    80000f78:	040005b7          	lui	a1,0x4000
    80000f7c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f7e:	05b2                	slli	a1,a1,0xc
    80000f80:	fffff097          	auipc	ra,0xfffff
    80000f84:	60c080e7          	jalr	1548(ra) # 8000058c <mappages>
    80000f88:	02054863          	bltz	a0,80000fb8 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f8c:	4719                	li	a4,6
    80000f8e:	05893683          	ld	a3,88(s2)
    80000f92:	6605                	lui	a2,0x1
    80000f94:	020005b7          	lui	a1,0x2000
    80000f98:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f9a:	05b6                	slli	a1,a1,0xd
    80000f9c:	8526                	mv	a0,s1
    80000f9e:	fffff097          	auipc	ra,0xfffff
    80000fa2:	5ee080e7          	jalr	1518(ra) # 8000058c <mappages>
    80000fa6:	02054163          	bltz	a0,80000fc8 <proc_pagetable+0x76>
}
    80000faa:	8526                	mv	a0,s1
    80000fac:	60e2                	ld	ra,24(sp)
    80000fae:	6442                	ld	s0,16(sp)
    80000fb0:	64a2                	ld	s1,8(sp)
    80000fb2:	6902                	ld	s2,0(sp)
    80000fb4:	6105                	addi	sp,sp,32
    80000fb6:	8082                	ret
    uvmfree(pagetable, 0);
    80000fb8:	4581                	li	a1,0
    80000fba:	8526                	mv	a0,s1
    80000fbc:	00000097          	auipc	ra,0x0
    80000fc0:	a58080e7          	jalr	-1448(ra) # 80000a14 <uvmfree>
    return 0;
    80000fc4:	4481                	li	s1,0
    80000fc6:	b7d5                	j	80000faa <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	040005b7          	lui	a1,0x4000
    80000fd0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fd2:	05b2                	slli	a1,a1,0xc
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	77c080e7          	jalr	1916(ra) # 80000752 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fde:	4581                	li	a1,0
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	00000097          	auipc	ra,0x0
    80000fe6:	a32080e7          	jalr	-1486(ra) # 80000a14 <uvmfree>
    return 0;
    80000fea:	4481                	li	s1,0
    80000fec:	bf7d                	j	80000faa <proc_pagetable+0x58>

0000000080000fee <proc_freepagetable>:
{
    80000fee:	1101                	addi	sp,sp,-32
    80000ff0:	ec06                	sd	ra,24(sp)
    80000ff2:	e822                	sd	s0,16(sp)
    80000ff4:	e426                	sd	s1,8(sp)
    80000ff6:	e04a                	sd	s2,0(sp)
    80000ff8:	1000                	addi	s0,sp,32
    80000ffa:	84aa                	mv	s1,a0
    80000ffc:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ffe:	4681                	li	a3,0
    80001000:	4605                	li	a2,1
    80001002:	040005b7          	lui	a1,0x4000
    80001006:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001008:	05b2                	slli	a1,a1,0xc
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	748080e7          	jalr	1864(ra) # 80000752 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001012:	4681                	li	a3,0
    80001014:	4605                	li	a2,1
    80001016:	020005b7          	lui	a1,0x2000
    8000101a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000101c:	05b6                	slli	a1,a1,0xd
    8000101e:	8526                	mv	a0,s1
    80001020:	fffff097          	auipc	ra,0xfffff
    80001024:	732080e7          	jalr	1842(ra) # 80000752 <uvmunmap>
  uvmfree(pagetable, sz);
    80001028:	85ca                	mv	a1,s2
    8000102a:	8526                	mv	a0,s1
    8000102c:	00000097          	auipc	ra,0x0
    80001030:	9e8080e7          	jalr	-1560(ra) # 80000a14 <uvmfree>
}
    80001034:	60e2                	ld	ra,24(sp)
    80001036:	6442                	ld	s0,16(sp)
    80001038:	64a2                	ld	s1,8(sp)
    8000103a:	6902                	ld	s2,0(sp)
    8000103c:	6105                	addi	sp,sp,32
    8000103e:	8082                	ret

0000000080001040 <freeproc>:
{
    80001040:	1101                	addi	sp,sp,-32
    80001042:	ec06                	sd	ra,24(sp)
    80001044:	e822                	sd	s0,16(sp)
    80001046:	e426                	sd	s1,8(sp)
    80001048:	1000                	addi	s0,sp,32
    8000104a:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000104c:	6d28                	ld	a0,88(a0)
    8000104e:	c509                	beqz	a0,80001058 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001050:	fffff097          	auipc	ra,0xfffff
    80001054:	fcc080e7          	jalr	-52(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001058:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000105c:	68a8                	ld	a0,80(s1)
    8000105e:	c511                	beqz	a0,8000106a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001060:	64ac                	ld	a1,72(s1)
    80001062:	00000097          	auipc	ra,0x0
    80001066:	f8c080e7          	jalr	-116(ra) # 80000fee <proc_freepagetable>
  p->pagetable = 0;
    8000106a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000106e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001072:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001076:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000107a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000107e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001082:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001086:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000108a:	0004ac23          	sw	zero,24(s1)
}
    8000108e:	60e2                	ld	ra,24(sp)
    80001090:	6442                	ld	s0,16(sp)
    80001092:	64a2                	ld	s1,8(sp)
    80001094:	6105                	addi	sp,sp,32
    80001096:	8082                	ret

0000000080001098 <allocproc>:
{
    80001098:	1101                	addi	sp,sp,-32
    8000109a:	ec06                	sd	ra,24(sp)
    8000109c:	e822                	sd	s0,16(sp)
    8000109e:	e426                	sd	s1,8(sp)
    800010a0:	e04a                	sd	s2,0(sp)
    800010a2:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a4:	00008497          	auipc	s1,0x8
    800010a8:	3dc48493          	addi	s1,s1,988 # 80009480 <proc>
    800010ac:	0000e917          	auipc	s2,0xe
    800010b0:	fd490913          	addi	s2,s2,-44 # 8000f080 <tickslock>
    acquire(&p->lock);
    800010b4:	8526                	mv	a0,s1
    800010b6:	00005097          	auipc	ra,0x5
    800010ba:	0e2080e7          	jalr	226(ra) # 80006198 <acquire>
    if(p->state == UNUSED) {
    800010be:	4c9c                	lw	a5,24(s1)
    800010c0:	cf81                	beqz	a5,800010d8 <allocproc+0x40>
      release(&p->lock);
    800010c2:	8526                	mv	a0,s1
    800010c4:	00005097          	auipc	ra,0x5
    800010c8:	188080e7          	jalr	392(ra) # 8000624c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010cc:	17048493          	addi	s1,s1,368
    800010d0:	ff2492e3          	bne	s1,s2,800010b4 <allocproc+0x1c>
  return 0;
    800010d4:	4481                	li	s1,0
    800010d6:	a889                	j	80001128 <allocproc+0x90>
  p->pid = allocpid();
    800010d8:	00000097          	auipc	ra,0x0
    800010dc:	e34080e7          	jalr	-460(ra) # 80000f0c <allocpid>
    800010e0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010e2:	4785                	li	a5,1
    800010e4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010e6:	fffff097          	auipc	ra,0xfffff
    800010ea:	034080e7          	jalr	52(ra) # 8000011a <kalloc>
    800010ee:	892a                	mv	s2,a0
    800010f0:	eca8                	sd	a0,88(s1)
    800010f2:	c131                	beqz	a0,80001136 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010f4:	8526                	mv	a0,s1
    800010f6:	00000097          	auipc	ra,0x0
    800010fa:	e5c080e7          	jalr	-420(ra) # 80000f52 <proc_pagetable>
    800010fe:	892a                	mv	s2,a0
    80001100:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001102:	c531                	beqz	a0,8000114e <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001104:	07000613          	li	a2,112
    80001108:	4581                	li	a1,0
    8000110a:	06048513          	addi	a0,s1,96
    8000110e:	fffff097          	auipc	ra,0xfffff
    80001112:	0b6080e7          	jalr	182(ra) # 800001c4 <memset>
  p->context.ra = (uint64)forkret;
    80001116:	00000797          	auipc	a5,0x0
    8000111a:	db078793          	addi	a5,a5,-592 # 80000ec6 <forkret>
    8000111e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001120:	60bc                	ld	a5,64(s1)
    80001122:	6705                	lui	a4,0x1
    80001124:	97ba                	add	a5,a5,a4
    80001126:	f4bc                	sd	a5,104(s1)
}
    80001128:	8526                	mv	a0,s1
    8000112a:	60e2                	ld	ra,24(sp)
    8000112c:	6442                	ld	s0,16(sp)
    8000112e:	64a2                	ld	s1,8(sp)
    80001130:	6902                	ld	s2,0(sp)
    80001132:	6105                	addi	sp,sp,32
    80001134:	8082                	ret
    freeproc(p);
    80001136:	8526                	mv	a0,s1
    80001138:	00000097          	auipc	ra,0x0
    8000113c:	f08080e7          	jalr	-248(ra) # 80001040 <freeproc>
    release(&p->lock);
    80001140:	8526                	mv	a0,s1
    80001142:	00005097          	auipc	ra,0x5
    80001146:	10a080e7          	jalr	266(ra) # 8000624c <release>
    return 0;
    8000114a:	84ca                	mv	s1,s2
    8000114c:	bff1                	j	80001128 <allocproc+0x90>
    freeproc(p);
    8000114e:	8526                	mv	a0,s1
    80001150:	00000097          	auipc	ra,0x0
    80001154:	ef0080e7          	jalr	-272(ra) # 80001040 <freeproc>
    release(&p->lock);
    80001158:	8526                	mv	a0,s1
    8000115a:	00005097          	auipc	ra,0x5
    8000115e:	0f2080e7          	jalr	242(ra) # 8000624c <release>
    return 0;
    80001162:	84ca                	mv	s1,s2
    80001164:	b7d1                	j	80001128 <allocproc+0x90>

0000000080001166 <userinit>:
{
    80001166:	1101                	addi	sp,sp,-32
    80001168:	ec06                	sd	ra,24(sp)
    8000116a:	e822                	sd	s0,16(sp)
    8000116c:	e426                	sd	s1,8(sp)
    8000116e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001170:	00000097          	auipc	ra,0x0
    80001174:	f28080e7          	jalr	-216(ra) # 80001098 <allocproc>
    80001178:	84aa                	mv	s1,a0
  initproc = p;
    8000117a:	00008797          	auipc	a5,0x8
    8000117e:	e8a7bb23          	sd	a0,-362(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001182:	03400613          	li	a2,52
    80001186:	00007597          	auipc	a1,0x7
    8000118a:	76a58593          	addi	a1,a1,1898 # 800088f0 <initcode>
    8000118e:	6928                	ld	a0,80(a0)
    80001190:	fffff097          	auipc	ra,0xfffff
    80001194:	6b4080e7          	jalr	1716(ra) # 80000844 <uvminit>
  p->sz = PGSIZE;
    80001198:	6785                	lui	a5,0x1
    8000119a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000119c:	6cb8                	ld	a4,88(s1)
    8000119e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011a2:	6cb8                	ld	a4,88(s1)
    800011a4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011a6:	4641                	li	a2,16
    800011a8:	00007597          	auipc	a1,0x7
    800011ac:	fd858593          	addi	a1,a1,-40 # 80008180 <etext+0x180>
    800011b0:	15848513          	addi	a0,s1,344
    800011b4:	fffff097          	auipc	ra,0xfffff
    800011b8:	15a080e7          	jalr	346(ra) # 8000030e <safestrcpy>
  p->cwd = namei("/");
    800011bc:	00007517          	auipc	a0,0x7
    800011c0:	fd450513          	addi	a0,a0,-44 # 80008190 <etext+0x190>
    800011c4:	00002097          	auipc	ra,0x2
    800011c8:	1de080e7          	jalr	478(ra) # 800033a2 <namei>
    800011cc:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011d0:	478d                	li	a5,3
    800011d2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011d4:	8526                	mv	a0,s1
    800011d6:	00005097          	auipc	ra,0x5
    800011da:	076080e7          	jalr	118(ra) # 8000624c <release>
}
    800011de:	60e2                	ld	ra,24(sp)
    800011e0:	6442                	ld	s0,16(sp)
    800011e2:	64a2                	ld	s1,8(sp)
    800011e4:	6105                	addi	sp,sp,32
    800011e6:	8082                	ret

00000000800011e8 <growproc>:
{
    800011e8:	1101                	addi	sp,sp,-32
    800011ea:	ec06                	sd	ra,24(sp)
    800011ec:	e822                	sd	s0,16(sp)
    800011ee:	e426                	sd	s1,8(sp)
    800011f0:	e04a                	sd	s2,0(sp)
    800011f2:	1000                	addi	s0,sp,32
    800011f4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011f6:	00000097          	auipc	ra,0x0
    800011fa:	c98080e7          	jalr	-872(ra) # 80000e8e <myproc>
    800011fe:	892a                	mv	s2,a0
  sz = p->sz;
    80001200:	652c                	ld	a1,72(a0)
    80001202:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001206:	00904f63          	bgtz	s1,80001224 <growproc+0x3c>
  } else if(n < 0){
    8000120a:	0204cd63          	bltz	s1,80001244 <growproc+0x5c>
  p->sz = sz;
    8000120e:	1782                	slli	a5,a5,0x20
    80001210:	9381                	srli	a5,a5,0x20
    80001212:	04f93423          	sd	a5,72(s2)
  return 0;
    80001216:	4501                	li	a0,0
}
    80001218:	60e2                	ld	ra,24(sp)
    8000121a:	6442                	ld	s0,16(sp)
    8000121c:	64a2                	ld	s1,8(sp)
    8000121e:	6902                	ld	s2,0(sp)
    80001220:	6105                	addi	sp,sp,32
    80001222:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001224:	00f4863b          	addw	a2,s1,a5
    80001228:	1602                	slli	a2,a2,0x20
    8000122a:	9201                	srli	a2,a2,0x20
    8000122c:	1582                	slli	a1,a1,0x20
    8000122e:	9181                	srli	a1,a1,0x20
    80001230:	6928                	ld	a0,80(a0)
    80001232:	fffff097          	auipc	ra,0xfffff
    80001236:	6cc080e7          	jalr	1740(ra) # 800008fe <uvmalloc>
    8000123a:	0005079b          	sext.w	a5,a0
    8000123e:	fbe1                	bnez	a5,8000120e <growproc+0x26>
      return -1;
    80001240:	557d                	li	a0,-1
    80001242:	bfd9                	j	80001218 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001244:	00f4863b          	addw	a2,s1,a5
    80001248:	1602                	slli	a2,a2,0x20
    8000124a:	9201                	srli	a2,a2,0x20
    8000124c:	1582                	slli	a1,a1,0x20
    8000124e:	9181                	srli	a1,a1,0x20
    80001250:	6928                	ld	a0,80(a0)
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	664080e7          	jalr	1636(ra) # 800008b6 <uvmdealloc>
    8000125a:	0005079b          	sext.w	a5,a0
    8000125e:	bf45                	j	8000120e <growproc+0x26>

0000000080001260 <fork>:
{
    80001260:	7139                	addi	sp,sp,-64
    80001262:	fc06                	sd	ra,56(sp)
    80001264:	f822                	sd	s0,48(sp)
    80001266:	f426                	sd	s1,40(sp)
    80001268:	f04a                	sd	s2,32(sp)
    8000126a:	ec4e                	sd	s3,24(sp)
    8000126c:	e852                	sd	s4,16(sp)
    8000126e:	e456                	sd	s5,8(sp)
    80001270:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001272:	00000097          	auipc	ra,0x0
    80001276:	c1c080e7          	jalr	-996(ra) # 80000e8e <myproc>
    8000127a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000127c:	00000097          	auipc	ra,0x0
    80001280:	e1c080e7          	jalr	-484(ra) # 80001098 <allocproc>
    80001284:	12050063          	beqz	a0,800013a4 <fork+0x144>
    80001288:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000128a:	048ab603          	ld	a2,72(s5)
    8000128e:	692c                	ld	a1,80(a0)
    80001290:	050ab503          	ld	a0,80(s5)
    80001294:	fffff097          	auipc	ra,0xfffff
    80001298:	7ba080e7          	jalr	1978(ra) # 80000a4e <uvmcopy>
    8000129c:	04054863          	bltz	a0,800012ec <fork+0x8c>
  np->sz = p->sz;
    800012a0:	048ab783          	ld	a5,72(s5)
    800012a4:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012a8:	058ab683          	ld	a3,88(s5)
    800012ac:	87b6                	mv	a5,a3
    800012ae:	0589b703          	ld	a4,88(s3)
    800012b2:	12068693          	addi	a3,a3,288
    800012b6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ba:	6788                	ld	a0,8(a5)
    800012bc:	6b8c                	ld	a1,16(a5)
    800012be:	6f90                	ld	a2,24(a5)
    800012c0:	01073023          	sd	a6,0(a4)
    800012c4:	e708                	sd	a0,8(a4)
    800012c6:	eb0c                	sd	a1,16(a4)
    800012c8:	ef10                	sd	a2,24(a4)
    800012ca:	02078793          	addi	a5,a5,32
    800012ce:	02070713          	addi	a4,a4,32
    800012d2:	fed792e3          	bne	a5,a3,800012b6 <fork+0x56>
  np->trapframe->a0 = 0;
    800012d6:	0589b783          	ld	a5,88(s3)
    800012da:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012de:	0d0a8493          	addi	s1,s5,208
    800012e2:	0d098913          	addi	s2,s3,208
    800012e6:	150a8a13          	addi	s4,s5,336
    800012ea:	a00d                	j	8000130c <fork+0xac>
    freeproc(np);
    800012ec:	854e                	mv	a0,s3
    800012ee:	00000097          	auipc	ra,0x0
    800012f2:	d52080e7          	jalr	-686(ra) # 80001040 <freeproc>
    release(&np->lock);
    800012f6:	854e                	mv	a0,s3
    800012f8:	00005097          	auipc	ra,0x5
    800012fc:	f54080e7          	jalr	-172(ra) # 8000624c <release>
    return -1;
    80001300:	597d                	li	s2,-1
    80001302:	a079                	j	80001390 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001304:	04a1                	addi	s1,s1,8
    80001306:	0921                	addi	s2,s2,8
    80001308:	01448b63          	beq	s1,s4,8000131e <fork+0xbe>
    if(p->ofile[i])
    8000130c:	6088                	ld	a0,0(s1)
    8000130e:	d97d                	beqz	a0,80001304 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001310:	00002097          	auipc	ra,0x2
    80001314:	728080e7          	jalr	1832(ra) # 80003a38 <filedup>
    80001318:	00a93023          	sd	a0,0(s2)
    8000131c:	b7e5                	j	80001304 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000131e:	150ab503          	ld	a0,336(s5)
    80001322:	00002097          	auipc	ra,0x2
    80001326:	886080e7          	jalr	-1914(ra) # 80002ba8 <idup>
    8000132a:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000132e:	4641                	li	a2,16
    80001330:	158a8593          	addi	a1,s5,344
    80001334:	15898513          	addi	a0,s3,344
    80001338:	fffff097          	auipc	ra,0xfffff
    8000133c:	fd6080e7          	jalr	-42(ra) # 8000030e <safestrcpy>
  pid = np->pid;
    80001340:	0309a903          	lw	s2,48(s3)
  np->trace_mask = p->trace_mask;
    80001344:	168aa783          	lw	a5,360(s5)
    80001348:	16f9a423          	sw	a5,360(s3)
  release(&np->lock);
    8000134c:	854e                	mv	a0,s3
    8000134e:	00005097          	auipc	ra,0x5
    80001352:	efe080e7          	jalr	-258(ra) # 8000624c <release>
  acquire(&wait_lock);
    80001356:	00008497          	auipc	s1,0x8
    8000135a:	d1248493          	addi	s1,s1,-750 # 80009068 <wait_lock>
    8000135e:	8526                	mv	a0,s1
    80001360:	00005097          	auipc	ra,0x5
    80001364:	e38080e7          	jalr	-456(ra) # 80006198 <acquire>
  np->parent = p;
    80001368:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000136c:	8526                	mv	a0,s1
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	ede080e7          	jalr	-290(ra) # 8000624c <release>
  acquire(&np->lock);
    80001376:	854e                	mv	a0,s3
    80001378:	00005097          	auipc	ra,0x5
    8000137c:	e20080e7          	jalr	-480(ra) # 80006198 <acquire>
  np->state = RUNNABLE;
    80001380:	478d                	li	a5,3
    80001382:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001386:	854e                	mv	a0,s3
    80001388:	00005097          	auipc	ra,0x5
    8000138c:	ec4080e7          	jalr	-316(ra) # 8000624c <release>
}
    80001390:	854a                	mv	a0,s2
    80001392:	70e2                	ld	ra,56(sp)
    80001394:	7442                	ld	s0,48(sp)
    80001396:	74a2                	ld	s1,40(sp)
    80001398:	7902                	ld	s2,32(sp)
    8000139a:	69e2                	ld	s3,24(sp)
    8000139c:	6a42                	ld	s4,16(sp)
    8000139e:	6aa2                	ld	s5,8(sp)
    800013a0:	6121                	addi	sp,sp,64
    800013a2:	8082                	ret
    return -1;
    800013a4:	597d                	li	s2,-1
    800013a6:	b7ed                	j	80001390 <fork+0x130>

00000000800013a8 <scheduler>:
{
    800013a8:	7139                	addi	sp,sp,-64
    800013aa:	fc06                	sd	ra,56(sp)
    800013ac:	f822                	sd	s0,48(sp)
    800013ae:	f426                	sd	s1,40(sp)
    800013b0:	f04a                	sd	s2,32(sp)
    800013b2:	ec4e                	sd	s3,24(sp)
    800013b4:	e852                	sd	s4,16(sp)
    800013b6:	e456                	sd	s5,8(sp)
    800013b8:	e05a                	sd	s6,0(sp)
    800013ba:	0080                	addi	s0,sp,64
    800013bc:	8792                	mv	a5,tp
  int id = r_tp();
    800013be:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013c0:	00779a93          	slli	s5,a5,0x7
    800013c4:	00008717          	auipc	a4,0x8
    800013c8:	c8c70713          	addi	a4,a4,-884 # 80009050 <pid_lock>
    800013cc:	9756                	add	a4,a4,s5
    800013ce:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d2:	00008717          	auipc	a4,0x8
    800013d6:	cb670713          	addi	a4,a4,-842 # 80009088 <cpus+0x8>
    800013da:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013dc:	498d                	li	s3,3
        p->state = RUNNING;
    800013de:	4b11                	li	s6,4
        c->proc = p;
    800013e0:	079e                	slli	a5,a5,0x7
    800013e2:	00008a17          	auipc	s4,0x8
    800013e6:	c6ea0a13          	addi	s4,s4,-914 # 80009050 <pid_lock>
    800013ea:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ec:	0000e917          	auipc	s2,0xe
    800013f0:	c9490913          	addi	s2,s2,-876 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013fc:	10079073          	csrw	sstatus,a5
    80001400:	00008497          	auipc	s1,0x8
    80001404:	08048493          	addi	s1,s1,128 # 80009480 <proc>
    80001408:	a811                	j	8000141c <scheduler+0x74>
      release(&p->lock);
    8000140a:	8526                	mv	a0,s1
    8000140c:	00005097          	auipc	ra,0x5
    80001410:	e40080e7          	jalr	-448(ra) # 8000624c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001414:	17048493          	addi	s1,s1,368
    80001418:	fd248ee3          	beq	s1,s2,800013f4 <scheduler+0x4c>
      acquire(&p->lock);
    8000141c:	8526                	mv	a0,s1
    8000141e:	00005097          	auipc	ra,0x5
    80001422:	d7a080e7          	jalr	-646(ra) # 80006198 <acquire>
      if(p->state == RUNNABLE) {
    80001426:	4c9c                	lw	a5,24(s1)
    80001428:	ff3791e3          	bne	a5,s3,8000140a <scheduler+0x62>
        p->state = RUNNING;
    8000142c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001430:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001434:	06048593          	addi	a1,s1,96
    80001438:	8556                	mv	a0,s5
    8000143a:	00000097          	auipc	ra,0x0
    8000143e:	64e080e7          	jalr	1614(ra) # 80001a88 <swtch>
        c->proc = 0;
    80001442:	020a3823          	sd	zero,48(s4)
    80001446:	b7d1                	j	8000140a <scheduler+0x62>

0000000080001448 <sched>:
{
    80001448:	7179                	addi	sp,sp,-48
    8000144a:	f406                	sd	ra,40(sp)
    8000144c:	f022                	sd	s0,32(sp)
    8000144e:	ec26                	sd	s1,24(sp)
    80001450:	e84a                	sd	s2,16(sp)
    80001452:	e44e                	sd	s3,8(sp)
    80001454:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001456:	00000097          	auipc	ra,0x0
    8000145a:	a38080e7          	jalr	-1480(ra) # 80000e8e <myproc>
    8000145e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001460:	00005097          	auipc	ra,0x5
    80001464:	cbe080e7          	jalr	-834(ra) # 8000611e <holding>
    80001468:	c93d                	beqz	a0,800014de <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000146a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000146c:	2781                	sext.w	a5,a5
    8000146e:	079e                	slli	a5,a5,0x7
    80001470:	00008717          	auipc	a4,0x8
    80001474:	be070713          	addi	a4,a4,-1056 # 80009050 <pid_lock>
    80001478:	97ba                	add	a5,a5,a4
    8000147a:	0a87a703          	lw	a4,168(a5)
    8000147e:	4785                	li	a5,1
    80001480:	06f71763          	bne	a4,a5,800014ee <sched+0xa6>
  if(p->state == RUNNING)
    80001484:	4c98                	lw	a4,24(s1)
    80001486:	4791                	li	a5,4
    80001488:	06f70b63          	beq	a4,a5,800014fe <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000148c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001490:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001492:	efb5                	bnez	a5,8000150e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001494:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001496:	00008917          	auipc	s2,0x8
    8000149a:	bba90913          	addi	s2,s2,-1094 # 80009050 <pid_lock>
    8000149e:	2781                	sext.w	a5,a5
    800014a0:	079e                	slli	a5,a5,0x7
    800014a2:	97ca                	add	a5,a5,s2
    800014a4:	0ac7a983          	lw	s3,172(a5)
    800014a8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014aa:	2781                	sext.w	a5,a5
    800014ac:	079e                	slli	a5,a5,0x7
    800014ae:	00008597          	auipc	a1,0x8
    800014b2:	bda58593          	addi	a1,a1,-1062 # 80009088 <cpus+0x8>
    800014b6:	95be                	add	a1,a1,a5
    800014b8:	06048513          	addi	a0,s1,96
    800014bc:	00000097          	auipc	ra,0x0
    800014c0:	5cc080e7          	jalr	1484(ra) # 80001a88 <swtch>
    800014c4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c6:	2781                	sext.w	a5,a5
    800014c8:	079e                	slli	a5,a5,0x7
    800014ca:	993e                	add	s2,s2,a5
    800014cc:	0b392623          	sw	s3,172(s2)
}
    800014d0:	70a2                	ld	ra,40(sp)
    800014d2:	7402                	ld	s0,32(sp)
    800014d4:	64e2                	ld	s1,24(sp)
    800014d6:	6942                	ld	s2,16(sp)
    800014d8:	69a2                	ld	s3,8(sp)
    800014da:	6145                	addi	sp,sp,48
    800014dc:	8082                	ret
    panic("sched p->lock");
    800014de:	00007517          	auipc	a0,0x7
    800014e2:	cba50513          	addi	a0,a0,-838 # 80008198 <etext+0x198>
    800014e6:	00004097          	auipc	ra,0x4
    800014ea:	77a080e7          	jalr	1914(ra) # 80005c60 <panic>
    panic("sched locks");
    800014ee:	00007517          	auipc	a0,0x7
    800014f2:	cba50513          	addi	a0,a0,-838 # 800081a8 <etext+0x1a8>
    800014f6:	00004097          	auipc	ra,0x4
    800014fa:	76a080e7          	jalr	1898(ra) # 80005c60 <panic>
    panic("sched running");
    800014fe:	00007517          	auipc	a0,0x7
    80001502:	cba50513          	addi	a0,a0,-838 # 800081b8 <etext+0x1b8>
    80001506:	00004097          	auipc	ra,0x4
    8000150a:	75a080e7          	jalr	1882(ra) # 80005c60 <panic>
    panic("sched interruptible");
    8000150e:	00007517          	auipc	a0,0x7
    80001512:	cba50513          	addi	a0,a0,-838 # 800081c8 <etext+0x1c8>
    80001516:	00004097          	auipc	ra,0x4
    8000151a:	74a080e7          	jalr	1866(ra) # 80005c60 <panic>

000000008000151e <yield>:
{
    8000151e:	1101                	addi	sp,sp,-32
    80001520:	ec06                	sd	ra,24(sp)
    80001522:	e822                	sd	s0,16(sp)
    80001524:	e426                	sd	s1,8(sp)
    80001526:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001528:	00000097          	auipc	ra,0x0
    8000152c:	966080e7          	jalr	-1690(ra) # 80000e8e <myproc>
    80001530:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001532:	00005097          	auipc	ra,0x5
    80001536:	c66080e7          	jalr	-922(ra) # 80006198 <acquire>
  p->state = RUNNABLE;
    8000153a:	478d                	li	a5,3
    8000153c:	cc9c                	sw	a5,24(s1)
  sched();
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	f0a080e7          	jalr	-246(ra) # 80001448 <sched>
  release(&p->lock);
    80001546:	8526                	mv	a0,s1
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	d04080e7          	jalr	-764(ra) # 8000624c <release>
}
    80001550:	60e2                	ld	ra,24(sp)
    80001552:	6442                	ld	s0,16(sp)
    80001554:	64a2                	ld	s1,8(sp)
    80001556:	6105                	addi	sp,sp,32
    80001558:	8082                	ret

000000008000155a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000155a:	7179                	addi	sp,sp,-48
    8000155c:	f406                	sd	ra,40(sp)
    8000155e:	f022                	sd	s0,32(sp)
    80001560:	ec26                	sd	s1,24(sp)
    80001562:	e84a                	sd	s2,16(sp)
    80001564:	e44e                	sd	s3,8(sp)
    80001566:	1800                	addi	s0,sp,48
    80001568:	89aa                	mv	s3,a0
    8000156a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000156c:	00000097          	auipc	ra,0x0
    80001570:	922080e7          	jalr	-1758(ra) # 80000e8e <myproc>
    80001574:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001576:	00005097          	auipc	ra,0x5
    8000157a:	c22080e7          	jalr	-990(ra) # 80006198 <acquire>
  release(lk);
    8000157e:	854a                	mv	a0,s2
    80001580:	00005097          	auipc	ra,0x5
    80001584:	ccc080e7          	jalr	-820(ra) # 8000624c <release>

  // Go to sleep.
  p->chan = chan;
    80001588:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000158c:	4789                	li	a5,2
    8000158e:	cc9c                	sw	a5,24(s1)

  sched();
    80001590:	00000097          	auipc	ra,0x0
    80001594:	eb8080e7          	jalr	-328(ra) # 80001448 <sched>

  // Tidy up.
  p->chan = 0;
    80001598:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000159c:	8526                	mv	a0,s1
    8000159e:	00005097          	auipc	ra,0x5
    800015a2:	cae080e7          	jalr	-850(ra) # 8000624c <release>
  acquire(lk);
    800015a6:	854a                	mv	a0,s2
    800015a8:	00005097          	auipc	ra,0x5
    800015ac:	bf0080e7          	jalr	-1040(ra) # 80006198 <acquire>
}
    800015b0:	70a2                	ld	ra,40(sp)
    800015b2:	7402                	ld	s0,32(sp)
    800015b4:	64e2                	ld	s1,24(sp)
    800015b6:	6942                	ld	s2,16(sp)
    800015b8:	69a2                	ld	s3,8(sp)
    800015ba:	6145                	addi	sp,sp,48
    800015bc:	8082                	ret

00000000800015be <wait>:
{
    800015be:	715d                	addi	sp,sp,-80
    800015c0:	e486                	sd	ra,72(sp)
    800015c2:	e0a2                	sd	s0,64(sp)
    800015c4:	fc26                	sd	s1,56(sp)
    800015c6:	f84a                	sd	s2,48(sp)
    800015c8:	f44e                	sd	s3,40(sp)
    800015ca:	f052                	sd	s4,32(sp)
    800015cc:	ec56                	sd	s5,24(sp)
    800015ce:	e85a                	sd	s6,16(sp)
    800015d0:	e45e                	sd	s7,8(sp)
    800015d2:	e062                	sd	s8,0(sp)
    800015d4:	0880                	addi	s0,sp,80
    800015d6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	8b6080e7          	jalr	-1866(ra) # 80000e8e <myproc>
    800015e0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e2:	00008517          	auipc	a0,0x8
    800015e6:	a8650513          	addi	a0,a0,-1402 # 80009068 <wait_lock>
    800015ea:	00005097          	auipc	ra,0x5
    800015ee:	bae080e7          	jalr	-1106(ra) # 80006198 <acquire>
    havekids = 0;
    800015f2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f4:	4a15                	li	s4,5
        havekids = 1;
    800015f6:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015f8:	0000e997          	auipc	s3,0xe
    800015fc:	a8898993          	addi	s3,s3,-1400 # 8000f080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001600:	00008c17          	auipc	s8,0x8
    80001604:	a68c0c13          	addi	s8,s8,-1432 # 80009068 <wait_lock>
    havekids = 0;
    80001608:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000160a:	00008497          	auipc	s1,0x8
    8000160e:	e7648493          	addi	s1,s1,-394 # 80009480 <proc>
    80001612:	a0bd                	j	80001680 <wait+0xc2>
          pid = np->pid;
    80001614:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001618:	000b0e63          	beqz	s6,80001634 <wait+0x76>
    8000161c:	4691                	li	a3,4
    8000161e:	02c48613          	addi	a2,s1,44
    80001622:	85da                	mv	a1,s6
    80001624:	05093503          	ld	a0,80(s2)
    80001628:	fffff097          	auipc	ra,0xfffff
    8000162c:	52a080e7          	jalr	1322(ra) # 80000b52 <copyout>
    80001630:	02054563          	bltz	a0,8000165a <wait+0x9c>
          freeproc(np);
    80001634:	8526                	mv	a0,s1
    80001636:	00000097          	auipc	ra,0x0
    8000163a:	a0a080e7          	jalr	-1526(ra) # 80001040 <freeproc>
          release(&np->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	00005097          	auipc	ra,0x5
    80001644:	c0c080e7          	jalr	-1012(ra) # 8000624c <release>
          release(&wait_lock);
    80001648:	00008517          	auipc	a0,0x8
    8000164c:	a2050513          	addi	a0,a0,-1504 # 80009068 <wait_lock>
    80001650:	00005097          	auipc	ra,0x5
    80001654:	bfc080e7          	jalr	-1028(ra) # 8000624c <release>
          return pid;
    80001658:	a09d                	j	800016be <wait+0x100>
            release(&np->lock);
    8000165a:	8526                	mv	a0,s1
    8000165c:	00005097          	auipc	ra,0x5
    80001660:	bf0080e7          	jalr	-1040(ra) # 8000624c <release>
            release(&wait_lock);
    80001664:	00008517          	auipc	a0,0x8
    80001668:	a0450513          	addi	a0,a0,-1532 # 80009068 <wait_lock>
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	be0080e7          	jalr	-1056(ra) # 8000624c <release>
            return -1;
    80001674:	59fd                	li	s3,-1
    80001676:	a0a1                	j	800016be <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001678:	17048493          	addi	s1,s1,368
    8000167c:	03348463          	beq	s1,s3,800016a4 <wait+0xe6>
      if(np->parent == p){
    80001680:	7c9c                	ld	a5,56(s1)
    80001682:	ff279be3          	bne	a5,s2,80001678 <wait+0xba>
        acquire(&np->lock);
    80001686:	8526                	mv	a0,s1
    80001688:	00005097          	auipc	ra,0x5
    8000168c:	b10080e7          	jalr	-1264(ra) # 80006198 <acquire>
        if(np->state == ZOMBIE){
    80001690:	4c9c                	lw	a5,24(s1)
    80001692:	f94781e3          	beq	a5,s4,80001614 <wait+0x56>
        release(&np->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	00005097          	auipc	ra,0x5
    8000169c:	bb4080e7          	jalr	-1100(ra) # 8000624c <release>
        havekids = 1;
    800016a0:	8756                	mv	a4,s5
    800016a2:	bfd9                	j	80001678 <wait+0xba>
    if(!havekids || p->killed){
    800016a4:	c701                	beqz	a4,800016ac <wait+0xee>
    800016a6:	02892783          	lw	a5,40(s2)
    800016aa:	c79d                	beqz	a5,800016d8 <wait+0x11a>
      release(&wait_lock);
    800016ac:	00008517          	auipc	a0,0x8
    800016b0:	9bc50513          	addi	a0,a0,-1604 # 80009068 <wait_lock>
    800016b4:	00005097          	auipc	ra,0x5
    800016b8:	b98080e7          	jalr	-1128(ra) # 8000624c <release>
      return -1;
    800016bc:	59fd                	li	s3,-1
}
    800016be:	854e                	mv	a0,s3
    800016c0:	60a6                	ld	ra,72(sp)
    800016c2:	6406                	ld	s0,64(sp)
    800016c4:	74e2                	ld	s1,56(sp)
    800016c6:	7942                	ld	s2,48(sp)
    800016c8:	79a2                	ld	s3,40(sp)
    800016ca:	7a02                	ld	s4,32(sp)
    800016cc:	6ae2                	ld	s5,24(sp)
    800016ce:	6b42                	ld	s6,16(sp)
    800016d0:	6ba2                	ld	s7,8(sp)
    800016d2:	6c02                	ld	s8,0(sp)
    800016d4:	6161                	addi	sp,sp,80
    800016d6:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d8:	85e2                	mv	a1,s8
    800016da:	854a                	mv	a0,s2
    800016dc:	00000097          	auipc	ra,0x0
    800016e0:	e7e080e7          	jalr	-386(ra) # 8000155a <sleep>
    havekids = 0;
    800016e4:	b715                	j	80001608 <wait+0x4a>

00000000800016e6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e6:	7139                	addi	sp,sp,-64
    800016e8:	fc06                	sd	ra,56(sp)
    800016ea:	f822                	sd	s0,48(sp)
    800016ec:	f426                	sd	s1,40(sp)
    800016ee:	f04a                	sd	s2,32(sp)
    800016f0:	ec4e                	sd	s3,24(sp)
    800016f2:	e852                	sd	s4,16(sp)
    800016f4:	e456                	sd	s5,8(sp)
    800016f6:	0080                	addi	s0,sp,64
    800016f8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016fa:	00008497          	auipc	s1,0x8
    800016fe:	d8648493          	addi	s1,s1,-634 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001702:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001704:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001706:	0000e917          	auipc	s2,0xe
    8000170a:	97a90913          	addi	s2,s2,-1670 # 8000f080 <tickslock>
    8000170e:	a811                	j	80001722 <wakeup+0x3c>
      }
      release(&p->lock);
    80001710:	8526                	mv	a0,s1
    80001712:	00005097          	auipc	ra,0x5
    80001716:	b3a080e7          	jalr	-1222(ra) # 8000624c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000171a:	17048493          	addi	s1,s1,368
    8000171e:	03248663          	beq	s1,s2,8000174a <wakeup+0x64>
    if(p != myproc()){
    80001722:	fffff097          	auipc	ra,0xfffff
    80001726:	76c080e7          	jalr	1900(ra) # 80000e8e <myproc>
    8000172a:	fea488e3          	beq	s1,a0,8000171a <wakeup+0x34>
      acquire(&p->lock);
    8000172e:	8526                	mv	a0,s1
    80001730:	00005097          	auipc	ra,0x5
    80001734:	a68080e7          	jalr	-1432(ra) # 80006198 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001738:	4c9c                	lw	a5,24(s1)
    8000173a:	fd379be3          	bne	a5,s3,80001710 <wakeup+0x2a>
    8000173e:	709c                	ld	a5,32(s1)
    80001740:	fd4798e3          	bne	a5,s4,80001710 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001744:	0154ac23          	sw	s5,24(s1)
    80001748:	b7e1                	j	80001710 <wakeup+0x2a>
    }
  }
}
    8000174a:	70e2                	ld	ra,56(sp)
    8000174c:	7442                	ld	s0,48(sp)
    8000174e:	74a2                	ld	s1,40(sp)
    80001750:	7902                	ld	s2,32(sp)
    80001752:	69e2                	ld	s3,24(sp)
    80001754:	6a42                	ld	s4,16(sp)
    80001756:	6aa2                	ld	s5,8(sp)
    80001758:	6121                	addi	sp,sp,64
    8000175a:	8082                	ret

000000008000175c <reparent>:
{
    8000175c:	7179                	addi	sp,sp,-48
    8000175e:	f406                	sd	ra,40(sp)
    80001760:	f022                	sd	s0,32(sp)
    80001762:	ec26                	sd	s1,24(sp)
    80001764:	e84a                	sd	s2,16(sp)
    80001766:	e44e                	sd	s3,8(sp)
    80001768:	e052                	sd	s4,0(sp)
    8000176a:	1800                	addi	s0,sp,48
    8000176c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000176e:	00008497          	auipc	s1,0x8
    80001772:	d1248493          	addi	s1,s1,-750 # 80009480 <proc>
      pp->parent = initproc;
    80001776:	00008a17          	auipc	s4,0x8
    8000177a:	89aa0a13          	addi	s4,s4,-1894 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177e:	0000e997          	auipc	s3,0xe
    80001782:	90298993          	addi	s3,s3,-1790 # 8000f080 <tickslock>
    80001786:	a029                	j	80001790 <reparent+0x34>
    80001788:	17048493          	addi	s1,s1,368
    8000178c:	01348d63          	beq	s1,s3,800017a6 <reparent+0x4a>
    if(pp->parent == p){
    80001790:	7c9c                	ld	a5,56(s1)
    80001792:	ff279be3          	bne	a5,s2,80001788 <reparent+0x2c>
      pp->parent = initproc;
    80001796:	000a3503          	ld	a0,0(s4)
    8000179a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	f4a080e7          	jalr	-182(ra) # 800016e6 <wakeup>
    800017a4:	b7d5                	j	80001788 <reparent+0x2c>
}
    800017a6:	70a2                	ld	ra,40(sp)
    800017a8:	7402                	ld	s0,32(sp)
    800017aa:	64e2                	ld	s1,24(sp)
    800017ac:	6942                	ld	s2,16(sp)
    800017ae:	69a2                	ld	s3,8(sp)
    800017b0:	6a02                	ld	s4,0(sp)
    800017b2:	6145                	addi	sp,sp,48
    800017b4:	8082                	ret

00000000800017b6 <exit>:
{
    800017b6:	7179                	addi	sp,sp,-48
    800017b8:	f406                	sd	ra,40(sp)
    800017ba:	f022                	sd	s0,32(sp)
    800017bc:	ec26                	sd	s1,24(sp)
    800017be:	e84a                	sd	s2,16(sp)
    800017c0:	e44e                	sd	s3,8(sp)
    800017c2:	e052                	sd	s4,0(sp)
    800017c4:	1800                	addi	s0,sp,48
    800017c6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c8:	fffff097          	auipc	ra,0xfffff
    800017cc:	6c6080e7          	jalr	1734(ra) # 80000e8e <myproc>
    800017d0:	89aa                	mv	s3,a0
  if(p == initproc)
    800017d2:	00008797          	auipc	a5,0x8
    800017d6:	83e7b783          	ld	a5,-1986(a5) # 80009010 <initproc>
    800017da:	0d050493          	addi	s1,a0,208
    800017de:	15050913          	addi	s2,a0,336
    800017e2:	02a79363          	bne	a5,a0,80001808 <exit+0x52>
    panic("init exiting");
    800017e6:	00007517          	auipc	a0,0x7
    800017ea:	9fa50513          	addi	a0,a0,-1542 # 800081e0 <etext+0x1e0>
    800017ee:	00004097          	auipc	ra,0x4
    800017f2:	472080e7          	jalr	1138(ra) # 80005c60 <panic>
      fileclose(f);
    800017f6:	00002097          	auipc	ra,0x2
    800017fa:	294080e7          	jalr	660(ra) # 80003a8a <fileclose>
      p->ofile[fd] = 0;
    800017fe:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001802:	04a1                	addi	s1,s1,8
    80001804:	01248563          	beq	s1,s2,8000180e <exit+0x58>
    if(p->ofile[fd]){
    80001808:	6088                	ld	a0,0(s1)
    8000180a:	f575                	bnez	a0,800017f6 <exit+0x40>
    8000180c:	bfdd                	j	80001802 <exit+0x4c>
  begin_op();
    8000180e:	00002097          	auipc	ra,0x2
    80001812:	db4080e7          	jalr	-588(ra) # 800035c2 <begin_op>
  iput(p->cwd);
    80001816:	1509b503          	ld	a0,336(s3)
    8000181a:	00001097          	auipc	ra,0x1
    8000181e:	586080e7          	jalr	1414(ra) # 80002da0 <iput>
  end_op();
    80001822:	00002097          	auipc	ra,0x2
    80001826:	e1e080e7          	jalr	-482(ra) # 80003640 <end_op>
  p->cwd = 0;
    8000182a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000182e:	00008497          	auipc	s1,0x8
    80001832:	83a48493          	addi	s1,s1,-1990 # 80009068 <wait_lock>
    80001836:	8526                	mv	a0,s1
    80001838:	00005097          	auipc	ra,0x5
    8000183c:	960080e7          	jalr	-1696(ra) # 80006198 <acquire>
  reparent(p);
    80001840:	854e                	mv	a0,s3
    80001842:	00000097          	auipc	ra,0x0
    80001846:	f1a080e7          	jalr	-230(ra) # 8000175c <reparent>
  wakeup(p->parent);
    8000184a:	0389b503          	ld	a0,56(s3)
    8000184e:	00000097          	auipc	ra,0x0
    80001852:	e98080e7          	jalr	-360(ra) # 800016e6 <wakeup>
  acquire(&p->lock);
    80001856:	854e                	mv	a0,s3
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	940080e7          	jalr	-1728(ra) # 80006198 <acquire>
  p->xstate = status;
    80001860:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001864:	4795                	li	a5,5
    80001866:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000186a:	8526                	mv	a0,s1
    8000186c:	00005097          	auipc	ra,0x5
    80001870:	9e0080e7          	jalr	-1568(ra) # 8000624c <release>
  sched();
    80001874:	00000097          	auipc	ra,0x0
    80001878:	bd4080e7          	jalr	-1068(ra) # 80001448 <sched>
  panic("zombie exit");
    8000187c:	00007517          	auipc	a0,0x7
    80001880:	97450513          	addi	a0,a0,-1676 # 800081f0 <etext+0x1f0>
    80001884:	00004097          	auipc	ra,0x4
    80001888:	3dc080e7          	jalr	988(ra) # 80005c60 <panic>

000000008000188c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000188c:	7179                	addi	sp,sp,-48
    8000188e:	f406                	sd	ra,40(sp)
    80001890:	f022                	sd	s0,32(sp)
    80001892:	ec26                	sd	s1,24(sp)
    80001894:	e84a                	sd	s2,16(sp)
    80001896:	e44e                	sd	s3,8(sp)
    80001898:	1800                	addi	s0,sp,48
    8000189a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000189c:	00008497          	auipc	s1,0x8
    800018a0:	be448493          	addi	s1,s1,-1052 # 80009480 <proc>
    800018a4:	0000d997          	auipc	s3,0xd
    800018a8:	7dc98993          	addi	s3,s3,2012 # 8000f080 <tickslock>
    acquire(&p->lock);
    800018ac:	8526                	mv	a0,s1
    800018ae:	00005097          	auipc	ra,0x5
    800018b2:	8ea080e7          	jalr	-1814(ra) # 80006198 <acquire>
    if(p->pid == pid){
    800018b6:	589c                	lw	a5,48(s1)
    800018b8:	01278d63          	beq	a5,s2,800018d2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018bc:	8526                	mv	a0,s1
    800018be:	00005097          	auipc	ra,0x5
    800018c2:	98e080e7          	jalr	-1650(ra) # 8000624c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c6:	17048493          	addi	s1,s1,368
    800018ca:	ff3491e3          	bne	s1,s3,800018ac <kill+0x20>
  }
  return -1;
    800018ce:	557d                	li	a0,-1
    800018d0:	a829                	j	800018ea <kill+0x5e>
      p->killed = 1;
    800018d2:	4785                	li	a5,1
    800018d4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d6:	4c98                	lw	a4,24(s1)
    800018d8:	4789                	li	a5,2
    800018da:	00f70f63          	beq	a4,a5,800018f8 <kill+0x6c>
      release(&p->lock);
    800018de:	8526                	mv	a0,s1
    800018e0:	00005097          	auipc	ra,0x5
    800018e4:	96c080e7          	jalr	-1684(ra) # 8000624c <release>
      return 0;
    800018e8:	4501                	li	a0,0
}
    800018ea:	70a2                	ld	ra,40(sp)
    800018ec:	7402                	ld	s0,32(sp)
    800018ee:	64e2                	ld	s1,24(sp)
    800018f0:	6942                	ld	s2,16(sp)
    800018f2:	69a2                	ld	s3,8(sp)
    800018f4:	6145                	addi	sp,sp,48
    800018f6:	8082                	ret
        p->state = RUNNABLE;
    800018f8:	478d                	li	a5,3
    800018fa:	cc9c                	sw	a5,24(s1)
    800018fc:	b7cd                	j	800018de <kill+0x52>

00000000800018fe <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018fe:	7179                	addi	sp,sp,-48
    80001900:	f406                	sd	ra,40(sp)
    80001902:	f022                	sd	s0,32(sp)
    80001904:	ec26                	sd	s1,24(sp)
    80001906:	e84a                	sd	s2,16(sp)
    80001908:	e44e                	sd	s3,8(sp)
    8000190a:	e052                	sd	s4,0(sp)
    8000190c:	1800                	addi	s0,sp,48
    8000190e:	84aa                	mv	s1,a0
    80001910:	892e                	mv	s2,a1
    80001912:	89b2                	mv	s3,a2
    80001914:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001916:	fffff097          	auipc	ra,0xfffff
    8000191a:	578080e7          	jalr	1400(ra) # 80000e8e <myproc>
  if(user_dst){
    8000191e:	c08d                	beqz	s1,80001940 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001920:	86d2                	mv	a3,s4
    80001922:	864e                	mv	a2,s3
    80001924:	85ca                	mv	a1,s2
    80001926:	6928                	ld	a0,80(a0)
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	22a080e7          	jalr	554(ra) # 80000b52 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001930:	70a2                	ld	ra,40(sp)
    80001932:	7402                	ld	s0,32(sp)
    80001934:	64e2                	ld	s1,24(sp)
    80001936:	6942                	ld	s2,16(sp)
    80001938:	69a2                	ld	s3,8(sp)
    8000193a:	6a02                	ld	s4,0(sp)
    8000193c:	6145                	addi	sp,sp,48
    8000193e:	8082                	ret
    memmove((char *)dst, src, len);
    80001940:	000a061b          	sext.w	a2,s4
    80001944:	85ce                	mv	a1,s3
    80001946:	854a                	mv	a0,s2
    80001948:	fffff097          	auipc	ra,0xfffff
    8000194c:	8d8080e7          	jalr	-1832(ra) # 80000220 <memmove>
    return 0;
    80001950:	8526                	mv	a0,s1
    80001952:	bff9                	j	80001930 <either_copyout+0x32>

0000000080001954 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001954:	7179                	addi	sp,sp,-48
    80001956:	f406                	sd	ra,40(sp)
    80001958:	f022                	sd	s0,32(sp)
    8000195a:	ec26                	sd	s1,24(sp)
    8000195c:	e84a                	sd	s2,16(sp)
    8000195e:	e44e                	sd	s3,8(sp)
    80001960:	e052                	sd	s4,0(sp)
    80001962:	1800                	addi	s0,sp,48
    80001964:	892a                	mv	s2,a0
    80001966:	84ae                	mv	s1,a1
    80001968:	89b2                	mv	s3,a2
    8000196a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000196c:	fffff097          	auipc	ra,0xfffff
    80001970:	522080e7          	jalr	1314(ra) # 80000e8e <myproc>
  if(user_src){
    80001974:	c08d                	beqz	s1,80001996 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001976:	86d2                	mv	a3,s4
    80001978:	864e                	mv	a2,s3
    8000197a:	85ca                	mv	a1,s2
    8000197c:	6928                	ld	a0,80(a0)
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	260080e7          	jalr	608(ra) # 80000bde <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001986:	70a2                	ld	ra,40(sp)
    80001988:	7402                	ld	s0,32(sp)
    8000198a:	64e2                	ld	s1,24(sp)
    8000198c:	6942                	ld	s2,16(sp)
    8000198e:	69a2                	ld	s3,8(sp)
    80001990:	6a02                	ld	s4,0(sp)
    80001992:	6145                	addi	sp,sp,48
    80001994:	8082                	ret
    memmove(dst, (char*)src, len);
    80001996:	000a061b          	sext.w	a2,s4
    8000199a:	85ce                	mv	a1,s3
    8000199c:	854a                	mv	a0,s2
    8000199e:	fffff097          	auipc	ra,0xfffff
    800019a2:	882080e7          	jalr	-1918(ra) # 80000220 <memmove>
    return 0;
    800019a6:	8526                	mv	a0,s1
    800019a8:	bff9                	j	80001986 <either_copyin+0x32>

00000000800019aa <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019aa:	715d                	addi	sp,sp,-80
    800019ac:	e486                	sd	ra,72(sp)
    800019ae:	e0a2                	sd	s0,64(sp)
    800019b0:	fc26                	sd	s1,56(sp)
    800019b2:	f84a                	sd	s2,48(sp)
    800019b4:	f44e                	sd	s3,40(sp)
    800019b6:	f052                	sd	s4,32(sp)
    800019b8:	ec56                	sd	s5,24(sp)
    800019ba:	e85a                	sd	s6,16(sp)
    800019bc:	e45e                	sd	s7,8(sp)
    800019be:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c0:	00006517          	auipc	a0,0x6
    800019c4:	68850513          	addi	a0,a0,1672 # 80008048 <etext+0x48>
    800019c8:	00004097          	auipc	ra,0x4
    800019cc:	2e2080e7          	jalr	738(ra) # 80005caa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d0:	00008497          	auipc	s1,0x8
    800019d4:	c0848493          	addi	s1,s1,-1016 # 800095d8 <proc+0x158>
    800019d8:	0000e917          	auipc	s2,0xe
    800019dc:	80090913          	addi	s2,s2,-2048 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e2:	00007997          	auipc	s3,0x7
    800019e6:	81e98993          	addi	s3,s3,-2018 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019ea:	00007a97          	auipc	s5,0x7
    800019ee:	81ea8a93          	addi	s5,s5,-2018 # 80008208 <etext+0x208>
    printf("\n");
    800019f2:	00006a17          	auipc	s4,0x6
    800019f6:	656a0a13          	addi	s4,s4,1622 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019fa:	00007b97          	auipc	s7,0x7
    800019fe:	846b8b93          	addi	s7,s7,-1978 # 80008240 <states.0>
    80001a02:	a00d                	j	80001a24 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a04:	ed86a583          	lw	a1,-296(a3)
    80001a08:	8556                	mv	a0,s5
    80001a0a:	00004097          	auipc	ra,0x4
    80001a0e:	2a0080e7          	jalr	672(ra) # 80005caa <printf>
    printf("\n");
    80001a12:	8552                	mv	a0,s4
    80001a14:	00004097          	auipc	ra,0x4
    80001a18:	296080e7          	jalr	662(ra) # 80005caa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a1c:	17048493          	addi	s1,s1,368
    80001a20:	03248263          	beq	s1,s2,80001a44 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a24:	86a6                	mv	a3,s1
    80001a26:	ec04a783          	lw	a5,-320(s1)
    80001a2a:	dbed                	beqz	a5,80001a1c <procdump+0x72>
      state = "???";
    80001a2c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2e:	fcfb6be3          	bltu	s6,a5,80001a04 <procdump+0x5a>
    80001a32:	02079713          	slli	a4,a5,0x20
    80001a36:	01d75793          	srli	a5,a4,0x1d
    80001a3a:	97de                	add	a5,a5,s7
    80001a3c:	6390                	ld	a2,0(a5)
    80001a3e:	f279                	bnez	a2,80001a04 <procdump+0x5a>
      state = "???";
    80001a40:	864e                	mv	a2,s3
    80001a42:	b7c9                	j	80001a04 <procdump+0x5a>
  }
}
    80001a44:	60a6                	ld	ra,72(sp)
    80001a46:	6406                	ld	s0,64(sp)
    80001a48:	74e2                	ld	s1,56(sp)
    80001a4a:	7942                	ld	s2,48(sp)
    80001a4c:	79a2                	ld	s3,40(sp)
    80001a4e:	7a02                	ld	s4,32(sp)
    80001a50:	6ae2                	ld	s5,24(sp)
    80001a52:	6b42                	ld	s6,16(sp)
    80001a54:	6ba2                	ld	s7,8(sp)
    80001a56:	6161                	addi	sp,sp,80
    80001a58:	8082                	ret

0000000080001a5a <count_unused_proc>:

uint64 count_unused_proc(void);
uint64 count_unused_proc(void){
    80001a5a:	1141                	addi	sp,sp,-16
    80001a5c:	e422                	sd	s0,8(sp)
    80001a5e:	0800                	addi	s0,sp,16
  uint64 num_unused_proc = 0;
  for(struct proc* p=proc; p<proc+NPROC; p++){
    80001a60:	00008797          	auipc	a5,0x8
    80001a64:	a2078793          	addi	a5,a5,-1504 # 80009480 <proc>
  uint64 num_unused_proc = 0;
    80001a68:	4501                	li	a0,0
  for(struct proc* p=proc; p<proc+NPROC; p++){
    80001a6a:	0000d697          	auipc	a3,0xd
    80001a6e:	61668693          	addi	a3,a3,1558 # 8000f080 <tickslock>
    // acquire(&p->lock);
    if(p->state!=UNUSED)
    80001a72:	4f98                	lw	a4,24(a5)
      num_unused_proc += 1;
    80001a74:	00e03733          	snez	a4,a4
    80001a78:	953a                	add	a0,a0,a4
  for(struct proc* p=proc; p<proc+NPROC; p++){
    80001a7a:	17078793          	addi	a5,a5,368
    80001a7e:	fed79ae3          	bne	a5,a3,80001a72 <count_unused_proc+0x18>
    // release(&p->lock);
  }
  return num_unused_proc;
}
    80001a82:	6422                	ld	s0,8(sp)
    80001a84:	0141                	addi	sp,sp,16
    80001a86:	8082                	ret

0000000080001a88 <swtch>:
    80001a88:	00153023          	sd	ra,0(a0)
    80001a8c:	00253423          	sd	sp,8(a0)
    80001a90:	e900                	sd	s0,16(a0)
    80001a92:	ed04                	sd	s1,24(a0)
    80001a94:	03253023          	sd	s2,32(a0)
    80001a98:	03353423          	sd	s3,40(a0)
    80001a9c:	03453823          	sd	s4,48(a0)
    80001aa0:	03553c23          	sd	s5,56(a0)
    80001aa4:	05653023          	sd	s6,64(a0)
    80001aa8:	05753423          	sd	s7,72(a0)
    80001aac:	05853823          	sd	s8,80(a0)
    80001ab0:	05953c23          	sd	s9,88(a0)
    80001ab4:	07a53023          	sd	s10,96(a0)
    80001ab8:	07b53423          	sd	s11,104(a0)
    80001abc:	0005b083          	ld	ra,0(a1)
    80001ac0:	0085b103          	ld	sp,8(a1)
    80001ac4:	6980                	ld	s0,16(a1)
    80001ac6:	6d84                	ld	s1,24(a1)
    80001ac8:	0205b903          	ld	s2,32(a1)
    80001acc:	0285b983          	ld	s3,40(a1)
    80001ad0:	0305ba03          	ld	s4,48(a1)
    80001ad4:	0385ba83          	ld	s5,56(a1)
    80001ad8:	0405bb03          	ld	s6,64(a1)
    80001adc:	0485bb83          	ld	s7,72(a1)
    80001ae0:	0505bc03          	ld	s8,80(a1)
    80001ae4:	0585bc83          	ld	s9,88(a1)
    80001ae8:	0605bd03          	ld	s10,96(a1)
    80001aec:	0685bd83          	ld	s11,104(a1)
    80001af0:	8082                	ret

0000000080001af2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001af2:	1141                	addi	sp,sp,-16
    80001af4:	e406                	sd	ra,8(sp)
    80001af6:	e022                	sd	s0,0(sp)
    80001af8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001afa:	00006597          	auipc	a1,0x6
    80001afe:	77658593          	addi	a1,a1,1910 # 80008270 <states.0+0x30>
    80001b02:	0000d517          	auipc	a0,0xd
    80001b06:	57e50513          	addi	a0,a0,1406 # 8000f080 <tickslock>
    80001b0a:	00004097          	auipc	ra,0x4
    80001b0e:	5fe080e7          	jalr	1534(ra) # 80006108 <initlock>
}
    80001b12:	60a2                	ld	ra,8(sp)
    80001b14:	6402                	ld	s0,0(sp)
    80001b16:	0141                	addi	sp,sp,16
    80001b18:	8082                	ret

0000000080001b1a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b1a:	1141                	addi	sp,sp,-16
    80001b1c:	e422                	sd	s0,8(sp)
    80001b1e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b20:	00003797          	auipc	a5,0x3
    80001b24:	5a078793          	addi	a5,a5,1440 # 800050c0 <kernelvec>
    80001b28:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b2c:	6422                	ld	s0,8(sp)
    80001b2e:	0141                	addi	sp,sp,16
    80001b30:	8082                	ret

0000000080001b32 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b32:	1141                	addi	sp,sp,-16
    80001b34:	e406                	sd	ra,8(sp)
    80001b36:	e022                	sd	s0,0(sp)
    80001b38:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b3a:	fffff097          	auipc	ra,0xfffff
    80001b3e:	354080e7          	jalr	852(ra) # 80000e8e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b42:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b46:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b48:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b4c:	00005697          	auipc	a3,0x5
    80001b50:	4b468693          	addi	a3,a3,1204 # 80007000 <_trampoline>
    80001b54:	00005717          	auipc	a4,0x5
    80001b58:	4ac70713          	addi	a4,a4,1196 # 80007000 <_trampoline>
    80001b5c:	8f15                	sub	a4,a4,a3
    80001b5e:	040007b7          	lui	a5,0x4000
    80001b62:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b64:	07b2                	slli	a5,a5,0xc
    80001b66:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b68:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b6c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b6e:	18002673          	csrr	a2,satp
    80001b72:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b74:	6d30                	ld	a2,88(a0)
    80001b76:	6138                	ld	a4,64(a0)
    80001b78:	6585                	lui	a1,0x1
    80001b7a:	972e                	add	a4,a4,a1
    80001b7c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b7e:	6d38                	ld	a4,88(a0)
    80001b80:	00000617          	auipc	a2,0x0
    80001b84:	13860613          	addi	a2,a2,312 # 80001cb8 <usertrap>
    80001b88:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b8a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b8c:	8612                	mv	a2,tp
    80001b8e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b90:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b94:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b98:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b9c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ba0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ba2:	6f18                	ld	a4,24(a4)
    80001ba4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ba8:	692c                	ld	a1,80(a0)
    80001baa:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bac:	00005717          	auipc	a4,0x5
    80001bb0:	4e470713          	addi	a4,a4,1252 # 80007090 <userret>
    80001bb4:	8f15                	sub	a4,a4,a3
    80001bb6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bb8:	577d                	li	a4,-1
    80001bba:	177e                	slli	a4,a4,0x3f
    80001bbc:	8dd9                	or	a1,a1,a4
    80001bbe:	02000537          	lui	a0,0x2000
    80001bc2:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001bc4:	0536                	slli	a0,a0,0xd
    80001bc6:	9782                	jalr	a5
}
    80001bc8:	60a2                	ld	ra,8(sp)
    80001bca:	6402                	ld	s0,0(sp)
    80001bcc:	0141                	addi	sp,sp,16
    80001bce:	8082                	ret

0000000080001bd0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bd0:	1101                	addi	sp,sp,-32
    80001bd2:	ec06                	sd	ra,24(sp)
    80001bd4:	e822                	sd	s0,16(sp)
    80001bd6:	e426                	sd	s1,8(sp)
    80001bd8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bda:	0000d497          	auipc	s1,0xd
    80001bde:	4a648493          	addi	s1,s1,1190 # 8000f080 <tickslock>
    80001be2:	8526                	mv	a0,s1
    80001be4:	00004097          	auipc	ra,0x4
    80001be8:	5b4080e7          	jalr	1460(ra) # 80006198 <acquire>
  ticks++;
    80001bec:	00007517          	auipc	a0,0x7
    80001bf0:	42c50513          	addi	a0,a0,1068 # 80009018 <ticks>
    80001bf4:	411c                	lw	a5,0(a0)
    80001bf6:	2785                	addiw	a5,a5,1
    80001bf8:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bfa:	00000097          	auipc	ra,0x0
    80001bfe:	aec080e7          	jalr	-1300(ra) # 800016e6 <wakeup>
  release(&tickslock);
    80001c02:	8526                	mv	a0,s1
    80001c04:	00004097          	auipc	ra,0x4
    80001c08:	648080e7          	jalr	1608(ra) # 8000624c <release>
}
    80001c0c:	60e2                	ld	ra,24(sp)
    80001c0e:	6442                	ld	s0,16(sp)
    80001c10:	64a2                	ld	s1,8(sp)
    80001c12:	6105                	addi	sp,sp,32
    80001c14:	8082                	ret

0000000080001c16 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c16:	1101                	addi	sp,sp,-32
    80001c18:	ec06                	sd	ra,24(sp)
    80001c1a:	e822                	sd	s0,16(sp)
    80001c1c:	e426                	sd	s1,8(sp)
    80001c1e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c20:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c24:	00074d63          	bltz	a4,80001c3e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c28:	57fd                	li	a5,-1
    80001c2a:	17fe                	slli	a5,a5,0x3f
    80001c2c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c2e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c30:	06f70363          	beq	a4,a5,80001c96 <devintr+0x80>
  }
}
    80001c34:	60e2                	ld	ra,24(sp)
    80001c36:	6442                	ld	s0,16(sp)
    80001c38:	64a2                	ld	s1,8(sp)
    80001c3a:	6105                	addi	sp,sp,32
    80001c3c:	8082                	ret
     (scause & 0xff) == 9){
    80001c3e:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c42:	46a5                	li	a3,9
    80001c44:	fed792e3          	bne	a5,a3,80001c28 <devintr+0x12>
    int irq = plic_claim();
    80001c48:	00003097          	auipc	ra,0x3
    80001c4c:	580080e7          	jalr	1408(ra) # 800051c8 <plic_claim>
    80001c50:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c52:	47a9                	li	a5,10
    80001c54:	02f50763          	beq	a0,a5,80001c82 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c58:	4785                	li	a5,1
    80001c5a:	02f50963          	beq	a0,a5,80001c8c <devintr+0x76>
    return 1;
    80001c5e:	4505                	li	a0,1
    } else if(irq){
    80001c60:	d8f1                	beqz	s1,80001c34 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c62:	85a6                	mv	a1,s1
    80001c64:	00006517          	auipc	a0,0x6
    80001c68:	61450513          	addi	a0,a0,1556 # 80008278 <states.0+0x38>
    80001c6c:	00004097          	auipc	ra,0x4
    80001c70:	03e080e7          	jalr	62(ra) # 80005caa <printf>
      plic_complete(irq);
    80001c74:	8526                	mv	a0,s1
    80001c76:	00003097          	auipc	ra,0x3
    80001c7a:	576080e7          	jalr	1398(ra) # 800051ec <plic_complete>
    return 1;
    80001c7e:	4505                	li	a0,1
    80001c80:	bf55                	j	80001c34 <devintr+0x1e>
      uartintr();
    80001c82:	00004097          	auipc	ra,0x4
    80001c86:	436080e7          	jalr	1078(ra) # 800060b8 <uartintr>
    80001c8a:	b7ed                	j	80001c74 <devintr+0x5e>
      virtio_disk_intr();
    80001c8c:	00004097          	auipc	ra,0x4
    80001c90:	9ec080e7          	jalr	-1556(ra) # 80005678 <virtio_disk_intr>
    80001c94:	b7c5                	j	80001c74 <devintr+0x5e>
    if(cpuid() == 0){
    80001c96:	fffff097          	auipc	ra,0xfffff
    80001c9a:	1cc080e7          	jalr	460(ra) # 80000e62 <cpuid>
    80001c9e:	c901                	beqz	a0,80001cae <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ca0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ca4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ca6:	14479073          	csrw	sip,a5
    return 2;
    80001caa:	4509                	li	a0,2
    80001cac:	b761                	j	80001c34 <devintr+0x1e>
      clockintr();
    80001cae:	00000097          	auipc	ra,0x0
    80001cb2:	f22080e7          	jalr	-222(ra) # 80001bd0 <clockintr>
    80001cb6:	b7ed                	j	80001ca0 <devintr+0x8a>

0000000080001cb8 <usertrap>:
{
    80001cb8:	1101                	addi	sp,sp,-32
    80001cba:	ec06                	sd	ra,24(sp)
    80001cbc:	e822                	sd	s0,16(sp)
    80001cbe:	e426                	sd	s1,8(sp)
    80001cc0:	e04a                	sd	s2,0(sp)
    80001cc2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cc4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cc8:	1007f793          	andi	a5,a5,256
    80001ccc:	e3ad                	bnez	a5,80001d2e <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cce:	00003797          	auipc	a5,0x3
    80001cd2:	3f278793          	addi	a5,a5,1010 # 800050c0 <kernelvec>
    80001cd6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cda:	fffff097          	auipc	ra,0xfffff
    80001cde:	1b4080e7          	jalr	436(ra) # 80000e8e <myproc>
    80001ce2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ce4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ce6:	14102773          	csrr	a4,sepc
    80001cea:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cec:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cf0:	47a1                	li	a5,8
    80001cf2:	04f71c63          	bne	a4,a5,80001d4a <usertrap+0x92>
    if(p->killed)
    80001cf6:	551c                	lw	a5,40(a0)
    80001cf8:	e3b9                	bnez	a5,80001d3e <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cfa:	6cb8                	ld	a4,88(s1)
    80001cfc:	6f1c                	ld	a5,24(a4)
    80001cfe:	0791                	addi	a5,a5,4
    80001d00:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d02:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d06:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d0a:	10079073          	csrw	sstatus,a5
    syscall();
    80001d0e:	00000097          	auipc	ra,0x0
    80001d12:	2e0080e7          	jalr	736(ra) # 80001fee <syscall>
  if(p->killed)
    80001d16:	549c                	lw	a5,40(s1)
    80001d18:	ebc1                	bnez	a5,80001da8 <usertrap+0xf0>
  usertrapret();
    80001d1a:	00000097          	auipc	ra,0x0
    80001d1e:	e18080e7          	jalr	-488(ra) # 80001b32 <usertrapret>
}
    80001d22:	60e2                	ld	ra,24(sp)
    80001d24:	6442                	ld	s0,16(sp)
    80001d26:	64a2                	ld	s1,8(sp)
    80001d28:	6902                	ld	s2,0(sp)
    80001d2a:	6105                	addi	sp,sp,32
    80001d2c:	8082                	ret
    panic("usertrap: not from user mode");
    80001d2e:	00006517          	auipc	a0,0x6
    80001d32:	56a50513          	addi	a0,a0,1386 # 80008298 <states.0+0x58>
    80001d36:	00004097          	auipc	ra,0x4
    80001d3a:	f2a080e7          	jalr	-214(ra) # 80005c60 <panic>
      exit(-1);
    80001d3e:	557d                	li	a0,-1
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	a76080e7          	jalr	-1418(ra) # 800017b6 <exit>
    80001d48:	bf4d                	j	80001cfa <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d4a:	00000097          	auipc	ra,0x0
    80001d4e:	ecc080e7          	jalr	-308(ra) # 80001c16 <devintr>
    80001d52:	892a                	mv	s2,a0
    80001d54:	c501                	beqz	a0,80001d5c <usertrap+0xa4>
  if(p->killed)
    80001d56:	549c                	lw	a5,40(s1)
    80001d58:	c3a1                	beqz	a5,80001d98 <usertrap+0xe0>
    80001d5a:	a815                	j	80001d8e <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d5c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d60:	5890                	lw	a2,48(s1)
    80001d62:	00006517          	auipc	a0,0x6
    80001d66:	55650513          	addi	a0,a0,1366 # 800082b8 <states.0+0x78>
    80001d6a:	00004097          	auipc	ra,0x4
    80001d6e:	f40080e7          	jalr	-192(ra) # 80005caa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d72:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d76:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d7a:	00006517          	auipc	a0,0x6
    80001d7e:	56e50513          	addi	a0,a0,1390 # 800082e8 <states.0+0xa8>
    80001d82:	00004097          	auipc	ra,0x4
    80001d86:	f28080e7          	jalr	-216(ra) # 80005caa <printf>
    p->killed = 1;
    80001d8a:	4785                	li	a5,1
    80001d8c:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d8e:	557d                	li	a0,-1
    80001d90:	00000097          	auipc	ra,0x0
    80001d94:	a26080e7          	jalr	-1498(ra) # 800017b6 <exit>
  if(which_dev == 2)
    80001d98:	4789                	li	a5,2
    80001d9a:	f8f910e3          	bne	s2,a5,80001d1a <usertrap+0x62>
    yield();
    80001d9e:	fffff097          	auipc	ra,0xfffff
    80001da2:	780080e7          	jalr	1920(ra) # 8000151e <yield>
    80001da6:	bf95                	j	80001d1a <usertrap+0x62>
  int which_dev = 0;
    80001da8:	4901                	li	s2,0
    80001daa:	b7d5                	j	80001d8e <usertrap+0xd6>

0000000080001dac <kerneltrap>:
{
    80001dac:	7179                	addi	sp,sp,-48
    80001dae:	f406                	sd	ra,40(sp)
    80001db0:	f022                	sd	s0,32(sp)
    80001db2:	ec26                	sd	s1,24(sp)
    80001db4:	e84a                	sd	s2,16(sp)
    80001db6:	e44e                	sd	s3,8(sp)
    80001db8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dba:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dbe:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dc2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dc6:	1004f793          	andi	a5,s1,256
    80001dca:	cb85                	beqz	a5,80001dfa <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dcc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dd0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dd2:	ef85                	bnez	a5,80001e0a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dd4:	00000097          	auipc	ra,0x0
    80001dd8:	e42080e7          	jalr	-446(ra) # 80001c16 <devintr>
    80001ddc:	cd1d                	beqz	a0,80001e1a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dde:	4789                	li	a5,2
    80001de0:	06f50a63          	beq	a0,a5,80001e54 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001de4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001de8:	10049073          	csrw	sstatus,s1
}
    80001dec:	70a2                	ld	ra,40(sp)
    80001dee:	7402                	ld	s0,32(sp)
    80001df0:	64e2                	ld	s1,24(sp)
    80001df2:	6942                	ld	s2,16(sp)
    80001df4:	69a2                	ld	s3,8(sp)
    80001df6:	6145                	addi	sp,sp,48
    80001df8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dfa:	00006517          	auipc	a0,0x6
    80001dfe:	50e50513          	addi	a0,a0,1294 # 80008308 <states.0+0xc8>
    80001e02:	00004097          	auipc	ra,0x4
    80001e06:	e5e080e7          	jalr	-418(ra) # 80005c60 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e0a:	00006517          	auipc	a0,0x6
    80001e0e:	52650513          	addi	a0,a0,1318 # 80008330 <states.0+0xf0>
    80001e12:	00004097          	auipc	ra,0x4
    80001e16:	e4e080e7          	jalr	-434(ra) # 80005c60 <panic>
    printf("scause %p\n", scause);
    80001e1a:	85ce                	mv	a1,s3
    80001e1c:	00006517          	auipc	a0,0x6
    80001e20:	53450513          	addi	a0,a0,1332 # 80008350 <states.0+0x110>
    80001e24:	00004097          	auipc	ra,0x4
    80001e28:	e86080e7          	jalr	-378(ra) # 80005caa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e30:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e34:	00006517          	auipc	a0,0x6
    80001e38:	52c50513          	addi	a0,a0,1324 # 80008360 <states.0+0x120>
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	e6e080e7          	jalr	-402(ra) # 80005caa <printf>
    panic("kerneltrap");
    80001e44:	00006517          	auipc	a0,0x6
    80001e48:	53450513          	addi	a0,a0,1332 # 80008378 <states.0+0x138>
    80001e4c:	00004097          	auipc	ra,0x4
    80001e50:	e14080e7          	jalr	-492(ra) # 80005c60 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e54:	fffff097          	auipc	ra,0xfffff
    80001e58:	03a080e7          	jalr	58(ra) # 80000e8e <myproc>
    80001e5c:	d541                	beqz	a0,80001de4 <kerneltrap+0x38>
    80001e5e:	fffff097          	auipc	ra,0xfffff
    80001e62:	030080e7          	jalr	48(ra) # 80000e8e <myproc>
    80001e66:	4d18                	lw	a4,24(a0)
    80001e68:	4791                	li	a5,4
    80001e6a:	f6f71de3          	bne	a4,a5,80001de4 <kerneltrap+0x38>
    yield();
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	6b0080e7          	jalr	1712(ra) # 8000151e <yield>
    80001e76:	b7bd                	j	80001de4 <kerneltrap+0x38>

0000000080001e78 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e78:	1101                	addi	sp,sp,-32
    80001e7a:	ec06                	sd	ra,24(sp)
    80001e7c:	e822                	sd	s0,16(sp)
    80001e7e:	e426                	sd	s1,8(sp)
    80001e80:	1000                	addi	s0,sp,32
    80001e82:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	00a080e7          	jalr	10(ra) # 80000e8e <myproc>
  switch (n) {
    80001e8c:	4795                	li	a5,5
    80001e8e:	0497e163          	bltu	a5,s1,80001ed0 <argraw+0x58>
    80001e92:	048a                	slli	s1,s1,0x2
    80001e94:	00006717          	auipc	a4,0x6
    80001e98:	5dc70713          	addi	a4,a4,1500 # 80008470 <states.0+0x230>
    80001e9c:	94ba                	add	s1,s1,a4
    80001e9e:	409c                	lw	a5,0(s1)
    80001ea0:	97ba                	add	a5,a5,a4
    80001ea2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ea4:	6d3c                	ld	a5,88(a0)
    80001ea6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ea8:	60e2                	ld	ra,24(sp)
    80001eaa:	6442                	ld	s0,16(sp)
    80001eac:	64a2                	ld	s1,8(sp)
    80001eae:	6105                	addi	sp,sp,32
    80001eb0:	8082                	ret
    return p->trapframe->a1;
    80001eb2:	6d3c                	ld	a5,88(a0)
    80001eb4:	7fa8                	ld	a0,120(a5)
    80001eb6:	bfcd                	j	80001ea8 <argraw+0x30>
    return p->trapframe->a2;
    80001eb8:	6d3c                	ld	a5,88(a0)
    80001eba:	63c8                	ld	a0,128(a5)
    80001ebc:	b7f5                	j	80001ea8 <argraw+0x30>
    return p->trapframe->a3;
    80001ebe:	6d3c                	ld	a5,88(a0)
    80001ec0:	67c8                	ld	a0,136(a5)
    80001ec2:	b7dd                	j	80001ea8 <argraw+0x30>
    return p->trapframe->a4;
    80001ec4:	6d3c                	ld	a5,88(a0)
    80001ec6:	6bc8                	ld	a0,144(a5)
    80001ec8:	b7c5                	j	80001ea8 <argraw+0x30>
    return p->trapframe->a5;
    80001eca:	6d3c                	ld	a5,88(a0)
    80001ecc:	6fc8                	ld	a0,152(a5)
    80001ece:	bfe9                	j	80001ea8 <argraw+0x30>
  panic("argraw");
    80001ed0:	00006517          	auipc	a0,0x6
    80001ed4:	4b850513          	addi	a0,a0,1208 # 80008388 <states.0+0x148>
    80001ed8:	00004097          	auipc	ra,0x4
    80001edc:	d88080e7          	jalr	-632(ra) # 80005c60 <panic>

0000000080001ee0 <fetchaddr>:
{
    80001ee0:	1101                	addi	sp,sp,-32
    80001ee2:	ec06                	sd	ra,24(sp)
    80001ee4:	e822                	sd	s0,16(sp)
    80001ee6:	e426                	sd	s1,8(sp)
    80001ee8:	e04a                	sd	s2,0(sp)
    80001eea:	1000                	addi	s0,sp,32
    80001eec:	84aa                	mv	s1,a0
    80001eee:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ef0:	fffff097          	auipc	ra,0xfffff
    80001ef4:	f9e080e7          	jalr	-98(ra) # 80000e8e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001ef8:	653c                	ld	a5,72(a0)
    80001efa:	02f4f863          	bgeu	s1,a5,80001f2a <fetchaddr+0x4a>
    80001efe:	00848713          	addi	a4,s1,8
    80001f02:	02e7e663          	bltu	a5,a4,80001f2e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f06:	46a1                	li	a3,8
    80001f08:	8626                	mv	a2,s1
    80001f0a:	85ca                	mv	a1,s2
    80001f0c:	6928                	ld	a0,80(a0)
    80001f0e:	fffff097          	auipc	ra,0xfffff
    80001f12:	cd0080e7          	jalr	-816(ra) # 80000bde <copyin>
    80001f16:	00a03533          	snez	a0,a0
    80001f1a:	40a00533          	neg	a0,a0
}
    80001f1e:	60e2                	ld	ra,24(sp)
    80001f20:	6442                	ld	s0,16(sp)
    80001f22:	64a2                	ld	s1,8(sp)
    80001f24:	6902                	ld	s2,0(sp)
    80001f26:	6105                	addi	sp,sp,32
    80001f28:	8082                	ret
    return -1;
    80001f2a:	557d                	li	a0,-1
    80001f2c:	bfcd                	j	80001f1e <fetchaddr+0x3e>
    80001f2e:	557d                	li	a0,-1
    80001f30:	b7fd                	j	80001f1e <fetchaddr+0x3e>

0000000080001f32 <fetchstr>:
{
    80001f32:	7179                	addi	sp,sp,-48
    80001f34:	f406                	sd	ra,40(sp)
    80001f36:	f022                	sd	s0,32(sp)
    80001f38:	ec26                	sd	s1,24(sp)
    80001f3a:	e84a                	sd	s2,16(sp)
    80001f3c:	e44e                	sd	s3,8(sp)
    80001f3e:	1800                	addi	s0,sp,48
    80001f40:	892a                	mv	s2,a0
    80001f42:	84ae                	mv	s1,a1
    80001f44:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	f48080e7          	jalr	-184(ra) # 80000e8e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f4e:	86ce                	mv	a3,s3
    80001f50:	864a                	mv	a2,s2
    80001f52:	85a6                	mv	a1,s1
    80001f54:	6928                	ld	a0,80(a0)
    80001f56:	fffff097          	auipc	ra,0xfffff
    80001f5a:	d16080e7          	jalr	-746(ra) # 80000c6c <copyinstr>
  if(err < 0)
    80001f5e:	00054763          	bltz	a0,80001f6c <fetchstr+0x3a>
  return strlen(buf);
    80001f62:	8526                	mv	a0,s1
    80001f64:	ffffe097          	auipc	ra,0xffffe
    80001f68:	3dc080e7          	jalr	988(ra) # 80000340 <strlen>
}
    80001f6c:	70a2                	ld	ra,40(sp)
    80001f6e:	7402                	ld	s0,32(sp)
    80001f70:	64e2                	ld	s1,24(sp)
    80001f72:	6942                	ld	s2,16(sp)
    80001f74:	69a2                	ld	s3,8(sp)
    80001f76:	6145                	addi	sp,sp,48
    80001f78:	8082                	ret

0000000080001f7a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f7a:	1101                	addi	sp,sp,-32
    80001f7c:	ec06                	sd	ra,24(sp)
    80001f7e:	e822                	sd	s0,16(sp)
    80001f80:	e426                	sd	s1,8(sp)
    80001f82:	1000                	addi	s0,sp,32
    80001f84:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f86:	00000097          	auipc	ra,0x0
    80001f8a:	ef2080e7          	jalr	-270(ra) # 80001e78 <argraw>
    80001f8e:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f90:	4501                	li	a0,0
    80001f92:	60e2                	ld	ra,24(sp)
    80001f94:	6442                	ld	s0,16(sp)
    80001f96:	64a2                	ld	s1,8(sp)
    80001f98:	6105                	addi	sp,sp,32
    80001f9a:	8082                	ret

0000000080001f9c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f9c:	1101                	addi	sp,sp,-32
    80001f9e:	ec06                	sd	ra,24(sp)
    80001fa0:	e822                	sd	s0,16(sp)
    80001fa2:	e426                	sd	s1,8(sp)
    80001fa4:	1000                	addi	s0,sp,32
    80001fa6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fa8:	00000097          	auipc	ra,0x0
    80001fac:	ed0080e7          	jalr	-304(ra) # 80001e78 <argraw>
    80001fb0:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fb2:	4501                	li	a0,0
    80001fb4:	60e2                	ld	ra,24(sp)
    80001fb6:	6442                	ld	s0,16(sp)
    80001fb8:	64a2                	ld	s1,8(sp)
    80001fba:	6105                	addi	sp,sp,32
    80001fbc:	8082                	ret

0000000080001fbe <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fbe:	1101                	addi	sp,sp,-32
    80001fc0:	ec06                	sd	ra,24(sp)
    80001fc2:	e822                	sd	s0,16(sp)
    80001fc4:	e426                	sd	s1,8(sp)
    80001fc6:	e04a                	sd	s2,0(sp)
    80001fc8:	1000                	addi	s0,sp,32
    80001fca:	84ae                	mv	s1,a1
    80001fcc:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fce:	00000097          	auipc	ra,0x0
    80001fd2:	eaa080e7          	jalr	-342(ra) # 80001e78 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fd6:	864a                	mv	a2,s2
    80001fd8:	85a6                	mv	a1,s1
    80001fda:	00000097          	auipc	ra,0x0
    80001fde:	f58080e7          	jalr	-168(ra) # 80001f32 <fetchstr>
}
    80001fe2:	60e2                	ld	ra,24(sp)
    80001fe4:	6442                	ld	s0,16(sp)
    80001fe6:	64a2                	ld	s1,8(sp)
    80001fe8:	6902                	ld	s2,0(sp)
    80001fea:	6105                	addi	sp,sp,32
    80001fec:	8082                	ret

0000000080001fee <syscall>:
    "trace"
};

void
syscall(void)
{
    80001fee:	7179                	addi	sp,sp,-48
    80001ff0:	f406                	sd	ra,40(sp)
    80001ff2:	f022                	sd	s0,32(sp)
    80001ff4:	ec26                	sd	s1,24(sp)
    80001ff6:	e84a                	sd	s2,16(sp)
    80001ff8:	e44e                	sd	s3,8(sp)
    80001ffa:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001ffc:	fffff097          	auipc	ra,0xfffff
    80002000:	e92080e7          	jalr	-366(ra) # 80000e8e <myproc>
    80002004:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002006:	05853903          	ld	s2,88(a0)
    8000200a:	0a893783          	ld	a5,168(s2)
    8000200e:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002012:	37fd                	addiw	a5,a5,-1
    80002014:	4759                	li	a4,22
    80002016:	04f76863          	bltu	a4,a5,80002066 <syscall+0x78>
    8000201a:	00399713          	slli	a4,s3,0x3
    8000201e:	00006797          	auipc	a5,0x6
    80002022:	46a78793          	addi	a5,a5,1130 # 80008488 <syscalls>
    80002026:	97ba                	add	a5,a5,a4
    80002028:	639c                	ld	a5,0(a5)
    8000202a:	cf95                	beqz	a5,80002066 <syscall+0x78>
    p->trapframe->a0 = syscalls[num]();
    8000202c:	9782                	jalr	a5
    8000202e:	06a93823          	sd	a0,112(s2)
    if(p->trace_mask&(1<<num)){
    80002032:	1684a783          	lw	a5,360(s1)
    80002036:	4137d7bb          	sraw	a5,a5,s3
    8000203a:	8b85                	andi	a5,a5,1
    8000203c:	c7a1                	beqz	a5,80002084 <syscall+0x96>
      printf("%d: syscall %s -> %d\n", p->pid, syscall_names[num-1], p->trapframe->a0);
    8000203e:	6cb8                	ld	a4,88(s1)
    80002040:	39fd                	addiw	s3,s3,-1
    80002042:	098e                	slli	s3,s3,0x3
    80002044:	00007797          	auipc	a5,0x7
    80002048:	8e478793          	addi	a5,a5,-1820 # 80008928 <syscall_names>
    8000204c:	97ce                	add	a5,a5,s3
    8000204e:	7b34                	ld	a3,112(a4)
    80002050:	6390                	ld	a2,0(a5)
    80002052:	588c                	lw	a1,48(s1)
    80002054:	00006517          	auipc	a0,0x6
    80002058:	33c50513          	addi	a0,a0,828 # 80008390 <states.0+0x150>
    8000205c:	00004097          	auipc	ra,0x4
    80002060:	c4e080e7          	jalr	-946(ra) # 80005caa <printf>
    80002064:	a005                	j	80002084 <syscall+0x96>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002066:	86ce                	mv	a3,s3
    80002068:	15848613          	addi	a2,s1,344
    8000206c:	588c                	lw	a1,48(s1)
    8000206e:	00006517          	auipc	a0,0x6
    80002072:	33a50513          	addi	a0,a0,826 # 800083a8 <states.0+0x168>
    80002076:	00004097          	auipc	ra,0x4
    8000207a:	c34080e7          	jalr	-972(ra) # 80005caa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000207e:	6cbc                	ld	a5,88(s1)
    80002080:	577d                	li	a4,-1
    80002082:	fbb8                	sd	a4,112(a5)
  }
}
    80002084:	70a2                	ld	ra,40(sp)
    80002086:	7402                	ld	s0,32(sp)
    80002088:	64e2                	ld	s1,24(sp)
    8000208a:	6942                	ld	s2,16(sp)
    8000208c:	69a2                	ld	s3,8(sp)
    8000208e:	6145                	addi	sp,sp,48
    80002090:	8082                	ret

0000000080002092 <sys_exit>:
#include "proc.h"
#include "kernel/sysinfo.h"

uint64
sys_exit(void)
{
    80002092:	1101                	addi	sp,sp,-32
    80002094:	ec06                	sd	ra,24(sp)
    80002096:	e822                	sd	s0,16(sp)
    80002098:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000209a:	fec40593          	addi	a1,s0,-20
    8000209e:	4501                	li	a0,0
    800020a0:	00000097          	auipc	ra,0x0
    800020a4:	eda080e7          	jalr	-294(ra) # 80001f7a <argint>
    return -1;
    800020a8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020aa:	00054963          	bltz	a0,800020bc <sys_exit+0x2a>
  exit(n);
    800020ae:	fec42503          	lw	a0,-20(s0)
    800020b2:	fffff097          	auipc	ra,0xfffff
    800020b6:	704080e7          	jalr	1796(ra) # 800017b6 <exit>
  return 0;  // not reached
    800020ba:	4781                	li	a5,0
}
    800020bc:	853e                	mv	a0,a5
    800020be:	60e2                	ld	ra,24(sp)
    800020c0:	6442                	ld	s0,16(sp)
    800020c2:	6105                	addi	sp,sp,32
    800020c4:	8082                	ret

00000000800020c6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020c6:	1141                	addi	sp,sp,-16
    800020c8:	e406                	sd	ra,8(sp)
    800020ca:	e022                	sd	s0,0(sp)
    800020cc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	dc0080e7          	jalr	-576(ra) # 80000e8e <myproc>
}
    800020d6:	5908                	lw	a0,48(a0)
    800020d8:	60a2                	ld	ra,8(sp)
    800020da:	6402                	ld	s0,0(sp)
    800020dc:	0141                	addi	sp,sp,16
    800020de:	8082                	ret

00000000800020e0 <sys_fork>:

uint64
sys_fork(void)
{
    800020e0:	1141                	addi	sp,sp,-16
    800020e2:	e406                	sd	ra,8(sp)
    800020e4:	e022                	sd	s0,0(sp)
    800020e6:	0800                	addi	s0,sp,16
  return fork();
    800020e8:	fffff097          	auipc	ra,0xfffff
    800020ec:	178080e7          	jalr	376(ra) # 80001260 <fork>
}
    800020f0:	60a2                	ld	ra,8(sp)
    800020f2:	6402                	ld	s0,0(sp)
    800020f4:	0141                	addi	sp,sp,16
    800020f6:	8082                	ret

00000000800020f8 <sys_wait>:

uint64
sys_wait(void)
{
    800020f8:	1101                	addi	sp,sp,-32
    800020fa:	ec06                	sd	ra,24(sp)
    800020fc:	e822                	sd	s0,16(sp)
    800020fe:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002100:	fe840593          	addi	a1,s0,-24
    80002104:	4501                	li	a0,0
    80002106:	00000097          	auipc	ra,0x0
    8000210a:	e96080e7          	jalr	-362(ra) # 80001f9c <argaddr>
    8000210e:	87aa                	mv	a5,a0
    return -1;
    80002110:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002112:	0007c863          	bltz	a5,80002122 <sys_wait+0x2a>
  return wait(p);
    80002116:	fe843503          	ld	a0,-24(s0)
    8000211a:	fffff097          	auipc	ra,0xfffff
    8000211e:	4a4080e7          	jalr	1188(ra) # 800015be <wait>
}
    80002122:	60e2                	ld	ra,24(sp)
    80002124:	6442                	ld	s0,16(sp)
    80002126:	6105                	addi	sp,sp,32
    80002128:	8082                	ret

000000008000212a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000212a:	7179                	addi	sp,sp,-48
    8000212c:	f406                	sd	ra,40(sp)
    8000212e:	f022                	sd	s0,32(sp)
    80002130:	ec26                	sd	s1,24(sp)
    80002132:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002134:	fdc40593          	addi	a1,s0,-36
    80002138:	4501                	li	a0,0
    8000213a:	00000097          	auipc	ra,0x0
    8000213e:	e40080e7          	jalr	-448(ra) # 80001f7a <argint>
    80002142:	87aa                	mv	a5,a0
    return -1;
    80002144:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002146:	0207c063          	bltz	a5,80002166 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	d44080e7          	jalr	-700(ra) # 80000e8e <myproc>
    80002152:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002154:	fdc42503          	lw	a0,-36(s0)
    80002158:	fffff097          	auipc	ra,0xfffff
    8000215c:	090080e7          	jalr	144(ra) # 800011e8 <growproc>
    80002160:	00054863          	bltz	a0,80002170 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002164:	8526                	mv	a0,s1
}
    80002166:	70a2                	ld	ra,40(sp)
    80002168:	7402                	ld	s0,32(sp)
    8000216a:	64e2                	ld	s1,24(sp)
    8000216c:	6145                	addi	sp,sp,48
    8000216e:	8082                	ret
    return -1;
    80002170:	557d                	li	a0,-1
    80002172:	bfd5                	j	80002166 <sys_sbrk+0x3c>

0000000080002174 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002174:	7139                	addi	sp,sp,-64
    80002176:	fc06                	sd	ra,56(sp)
    80002178:	f822                	sd	s0,48(sp)
    8000217a:	f426                	sd	s1,40(sp)
    8000217c:	f04a                	sd	s2,32(sp)
    8000217e:	ec4e                	sd	s3,24(sp)
    80002180:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002182:	fcc40593          	addi	a1,s0,-52
    80002186:	4501                	li	a0,0
    80002188:	00000097          	auipc	ra,0x0
    8000218c:	df2080e7          	jalr	-526(ra) # 80001f7a <argint>
    return -1;
    80002190:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002192:	06054563          	bltz	a0,800021fc <sys_sleep+0x88>
  acquire(&tickslock);
    80002196:	0000d517          	auipc	a0,0xd
    8000219a:	eea50513          	addi	a0,a0,-278 # 8000f080 <tickslock>
    8000219e:	00004097          	auipc	ra,0x4
    800021a2:	ffa080e7          	jalr	-6(ra) # 80006198 <acquire>
  ticks0 = ticks;
    800021a6:	00007917          	auipc	s2,0x7
    800021aa:	e7292903          	lw	s2,-398(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021ae:	fcc42783          	lw	a5,-52(s0)
    800021b2:	cf85                	beqz	a5,800021ea <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021b4:	0000d997          	auipc	s3,0xd
    800021b8:	ecc98993          	addi	s3,s3,-308 # 8000f080 <tickslock>
    800021bc:	00007497          	auipc	s1,0x7
    800021c0:	e5c48493          	addi	s1,s1,-420 # 80009018 <ticks>
    if(myproc()->killed){
    800021c4:	fffff097          	auipc	ra,0xfffff
    800021c8:	cca080e7          	jalr	-822(ra) # 80000e8e <myproc>
    800021cc:	551c                	lw	a5,40(a0)
    800021ce:	ef9d                	bnez	a5,8000220c <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021d0:	85ce                	mv	a1,s3
    800021d2:	8526                	mv	a0,s1
    800021d4:	fffff097          	auipc	ra,0xfffff
    800021d8:	386080e7          	jalr	902(ra) # 8000155a <sleep>
  while(ticks - ticks0 < n){
    800021dc:	409c                	lw	a5,0(s1)
    800021de:	412787bb          	subw	a5,a5,s2
    800021e2:	fcc42703          	lw	a4,-52(s0)
    800021e6:	fce7efe3          	bltu	a5,a4,800021c4 <sys_sleep+0x50>
  }
  release(&tickslock);
    800021ea:	0000d517          	auipc	a0,0xd
    800021ee:	e9650513          	addi	a0,a0,-362 # 8000f080 <tickslock>
    800021f2:	00004097          	auipc	ra,0x4
    800021f6:	05a080e7          	jalr	90(ra) # 8000624c <release>
  return 0;
    800021fa:	4781                	li	a5,0
}
    800021fc:	853e                	mv	a0,a5
    800021fe:	70e2                	ld	ra,56(sp)
    80002200:	7442                	ld	s0,48(sp)
    80002202:	74a2                	ld	s1,40(sp)
    80002204:	7902                	ld	s2,32(sp)
    80002206:	69e2                	ld	s3,24(sp)
    80002208:	6121                	addi	sp,sp,64
    8000220a:	8082                	ret
      release(&tickslock);
    8000220c:	0000d517          	auipc	a0,0xd
    80002210:	e7450513          	addi	a0,a0,-396 # 8000f080 <tickslock>
    80002214:	00004097          	auipc	ra,0x4
    80002218:	038080e7          	jalr	56(ra) # 8000624c <release>
      return -1;
    8000221c:	57fd                	li	a5,-1
    8000221e:	bff9                	j	800021fc <sys_sleep+0x88>

0000000080002220 <sys_kill>:

uint64
sys_kill(void)
{
    80002220:	1101                	addi	sp,sp,-32
    80002222:	ec06                	sd	ra,24(sp)
    80002224:	e822                	sd	s0,16(sp)
    80002226:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002228:	fec40593          	addi	a1,s0,-20
    8000222c:	4501                	li	a0,0
    8000222e:	00000097          	auipc	ra,0x0
    80002232:	d4c080e7          	jalr	-692(ra) # 80001f7a <argint>
    80002236:	87aa                	mv	a5,a0
    return -1;
    80002238:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000223a:	0007c863          	bltz	a5,8000224a <sys_kill+0x2a>
  return kill(pid);
    8000223e:	fec42503          	lw	a0,-20(s0)
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	64a080e7          	jalr	1610(ra) # 8000188c <kill>
}
    8000224a:	60e2                	ld	ra,24(sp)
    8000224c:	6442                	ld	s0,16(sp)
    8000224e:	6105                	addi	sp,sp,32
    80002250:	8082                	ret

0000000080002252 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002252:	1101                	addi	sp,sp,-32
    80002254:	ec06                	sd	ra,24(sp)
    80002256:	e822                	sd	s0,16(sp)
    80002258:	e426                	sd	s1,8(sp)
    8000225a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000225c:	0000d517          	auipc	a0,0xd
    80002260:	e2450513          	addi	a0,a0,-476 # 8000f080 <tickslock>
    80002264:	00004097          	auipc	ra,0x4
    80002268:	f34080e7          	jalr	-204(ra) # 80006198 <acquire>
  xticks = ticks;
    8000226c:	00007497          	auipc	s1,0x7
    80002270:	dac4a483          	lw	s1,-596(s1) # 80009018 <ticks>
  release(&tickslock);
    80002274:	0000d517          	auipc	a0,0xd
    80002278:	e0c50513          	addi	a0,a0,-500 # 8000f080 <tickslock>
    8000227c:	00004097          	auipc	ra,0x4
    80002280:	fd0080e7          	jalr	-48(ra) # 8000624c <release>
  return xticks;
}
    80002284:	02049513          	slli	a0,s1,0x20
    80002288:	9101                	srli	a0,a0,0x20
    8000228a:	60e2                	ld	ra,24(sp)
    8000228c:	6442                	ld	s0,16(sp)
    8000228e:	64a2                	ld	s1,8(sp)
    80002290:	6105                	addi	sp,sp,32
    80002292:	8082                	ret

0000000080002294 <sys_trace>:

uint64
sys_trace(void)
{
    80002294:	7179                	addi	sp,sp,-48
    80002296:	f406                	sd	ra,40(sp)
    80002298:	f022                	sd	s0,32(sp)
    8000229a:	ec26                	sd	s1,24(sp)
    8000229c:	1800                	addi	s0,sp,48
  int mask;
  struct proc* p = myproc();
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	bf0080e7          	jalr	-1040(ra) # 80000e8e <myproc>
    800022a6:	84aa                	mv	s1,a0
  argint(0, &mask);
    800022a8:	fdc40593          	addi	a1,s0,-36
    800022ac:	4501                	li	a0,0
    800022ae:	00000097          	auipc	ra,0x0
    800022b2:	ccc080e7          	jalr	-820(ra) # 80001f7a <argint>
  acquire(&p->lock);
    800022b6:	8526                	mv	a0,s1
    800022b8:	00004097          	auipc	ra,0x4
    800022bc:	ee0080e7          	jalr	-288(ra) # 80006198 <acquire>
  p->trace_mask = mask;
    800022c0:	fdc42783          	lw	a5,-36(s0)
    800022c4:	16f4a423          	sw	a5,360(s1)
  release(&p->lock);
    800022c8:	8526                	mv	a0,s1
    800022ca:	00004097          	auipc	ra,0x4
    800022ce:	f82080e7          	jalr	-126(ra) # 8000624c <release>
  return 0;
}
    800022d2:	4501                	li	a0,0
    800022d4:	70a2                	ld	ra,40(sp)
    800022d6:	7402                	ld	s0,32(sp)
    800022d8:	64e2                	ld	s1,24(sp)
    800022da:	6145                	addi	sp,sp,48
    800022dc:	8082                	ret

00000000800022de <sys_sysinfo>:

struct sysinfo;
uint64
sys_sysinfo(void)
{
    800022de:	7139                	addi	sp,sp,-64
    800022e0:	fc06                	sd	ra,56(sp)
    800022e2:	f822                	sd	s0,48(sp)
    800022e4:	f426                	sd	s1,40(sp)
    800022e6:	0080                	addi	s0,sp,64
  uint64 p = 0;
    800022e8:	fc043c23          	sd	zero,-40(s0)
  // printf("%p", &p);
  if (argaddr(0, &p) < 0) {  // 将用户传入的地址写入 user_addr
    800022ec:	fd840593          	addi	a1,s0,-40
    800022f0:	4501                	li	a0,0
    800022f2:	00000097          	auipc	ra,0x0
    800022f6:	caa080e7          	jalr	-854(ra) # 80001f9c <argaddr>
    return -1;  // 获取参数失败
    800022fa:	57fd                	li	a5,-1
  if (argaddr(0, &p) < 0) {  // 将用户传入的地址写入 user_addr
    800022fc:	04054763          	bltz	a0,8000234a <sys_sysinfo+0x6c>
  }
  struct proc *process = myproc();
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	b8e080e7          	jalr	-1138(ra) # 80000e8e <myproc>
    80002308:	84aa                	mv	s1,a0
  if(walkaddr(process->pagetable, (uint64)p) == 0){
    8000230a:	fd843583          	ld	a1,-40(s0)
    8000230e:	6928                	ld	a0,80(a0)
    80002310:	ffffe097          	auipc	ra,0xffffe
    80002314:	23a080e7          	jalr	570(ra) # 8000054a <walkaddr>
    return -1;
    80002318:	57fd                	li	a5,-1
  if(walkaddr(process->pagetable, (uint64)p) == 0){
    8000231a:	c905                	beqz	a0,8000234a <sys_sysinfo+0x6c>
  }

  struct sysinfo info;
  extern uint64 count_free_mem(void);
  extern uint64 count_unused_proc(void);
  (&info)->freemem = (uint64)count_free_mem();
    8000231c:	ffffe097          	auipc	ra,0xffffe
    80002320:	e5e080e7          	jalr	-418(ra) # 8000017a <count_free_mem>
    80002324:	fca43423          	sd	a0,-56(s0)
  (&info)->nproc = count_unused_proc();
    80002328:	fffff097          	auipc	ra,0xfffff
    8000232c:	732080e7          	jalr	1842(ra) # 80001a5a <count_unused_proc>
    80002330:	fca43823          	sd	a0,-48(s0)
  
  copyout(process->pagetable, p, (char*)&info, sizeof(struct sysinfo));
    80002334:	46c1                	li	a3,16
    80002336:	fc840613          	addi	a2,s0,-56
    8000233a:	fd843583          	ld	a1,-40(s0)
    8000233e:	68a8                	ld	a0,80(s1)
    80002340:	fffff097          	auipc	ra,0xfffff
    80002344:	812080e7          	jalr	-2030(ra) # 80000b52 <copyout>
  return 0;
    80002348:	4781                	li	a5,0
}
    8000234a:	853e                	mv	a0,a5
    8000234c:	70e2                	ld	ra,56(sp)
    8000234e:	7442                	ld	s0,48(sp)
    80002350:	74a2                	ld	s1,40(sp)
    80002352:	6121                	addi	sp,sp,64
    80002354:	8082                	ret

0000000080002356 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002356:	7179                	addi	sp,sp,-48
    80002358:	f406                	sd	ra,40(sp)
    8000235a:	f022                	sd	s0,32(sp)
    8000235c:	ec26                	sd	s1,24(sp)
    8000235e:	e84a                	sd	s2,16(sp)
    80002360:	e44e                	sd	s3,8(sp)
    80002362:	e052                	sd	s4,0(sp)
    80002364:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002366:	00006597          	auipc	a1,0x6
    8000236a:	1e258593          	addi	a1,a1,482 # 80008548 <syscalls+0xc0>
    8000236e:	0000d517          	auipc	a0,0xd
    80002372:	d2a50513          	addi	a0,a0,-726 # 8000f098 <bcache>
    80002376:	00004097          	auipc	ra,0x4
    8000237a:	d92080e7          	jalr	-622(ra) # 80006108 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000237e:	00015797          	auipc	a5,0x15
    80002382:	d1a78793          	addi	a5,a5,-742 # 80017098 <bcache+0x8000>
    80002386:	00015717          	auipc	a4,0x15
    8000238a:	f7a70713          	addi	a4,a4,-134 # 80017300 <bcache+0x8268>
    8000238e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002392:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002396:	0000d497          	auipc	s1,0xd
    8000239a:	d1a48493          	addi	s1,s1,-742 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000239e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023a0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023a2:	00006a17          	auipc	s4,0x6
    800023a6:	1aea0a13          	addi	s4,s4,430 # 80008550 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023aa:	2b893783          	ld	a5,696(s2)
    800023ae:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023b0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023b4:	85d2                	mv	a1,s4
    800023b6:	01048513          	addi	a0,s1,16
    800023ba:	00001097          	auipc	ra,0x1
    800023be:	4c2080e7          	jalr	1218(ra) # 8000387c <initsleeplock>
    bcache.head.next->prev = b;
    800023c2:	2b893783          	ld	a5,696(s2)
    800023c6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023c8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023cc:	45848493          	addi	s1,s1,1112
    800023d0:	fd349de3          	bne	s1,s3,800023aa <binit+0x54>
  }
}
    800023d4:	70a2                	ld	ra,40(sp)
    800023d6:	7402                	ld	s0,32(sp)
    800023d8:	64e2                	ld	s1,24(sp)
    800023da:	6942                	ld	s2,16(sp)
    800023dc:	69a2                	ld	s3,8(sp)
    800023de:	6a02                	ld	s4,0(sp)
    800023e0:	6145                	addi	sp,sp,48
    800023e2:	8082                	ret

00000000800023e4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023e4:	7179                	addi	sp,sp,-48
    800023e6:	f406                	sd	ra,40(sp)
    800023e8:	f022                	sd	s0,32(sp)
    800023ea:	ec26                	sd	s1,24(sp)
    800023ec:	e84a                	sd	s2,16(sp)
    800023ee:	e44e                	sd	s3,8(sp)
    800023f0:	1800                	addi	s0,sp,48
    800023f2:	892a                	mv	s2,a0
    800023f4:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023f6:	0000d517          	auipc	a0,0xd
    800023fa:	ca250513          	addi	a0,a0,-862 # 8000f098 <bcache>
    800023fe:	00004097          	auipc	ra,0x4
    80002402:	d9a080e7          	jalr	-614(ra) # 80006198 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002406:	00015497          	auipc	s1,0x15
    8000240a:	f4a4b483          	ld	s1,-182(s1) # 80017350 <bcache+0x82b8>
    8000240e:	00015797          	auipc	a5,0x15
    80002412:	ef278793          	addi	a5,a5,-270 # 80017300 <bcache+0x8268>
    80002416:	02f48f63          	beq	s1,a5,80002454 <bread+0x70>
    8000241a:	873e                	mv	a4,a5
    8000241c:	a021                	j	80002424 <bread+0x40>
    8000241e:	68a4                	ld	s1,80(s1)
    80002420:	02e48a63          	beq	s1,a4,80002454 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002424:	449c                	lw	a5,8(s1)
    80002426:	ff279ce3          	bne	a5,s2,8000241e <bread+0x3a>
    8000242a:	44dc                	lw	a5,12(s1)
    8000242c:	ff3799e3          	bne	a5,s3,8000241e <bread+0x3a>
      b->refcnt++;
    80002430:	40bc                	lw	a5,64(s1)
    80002432:	2785                	addiw	a5,a5,1
    80002434:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002436:	0000d517          	auipc	a0,0xd
    8000243a:	c6250513          	addi	a0,a0,-926 # 8000f098 <bcache>
    8000243e:	00004097          	auipc	ra,0x4
    80002442:	e0e080e7          	jalr	-498(ra) # 8000624c <release>
      acquiresleep(&b->lock);
    80002446:	01048513          	addi	a0,s1,16
    8000244a:	00001097          	auipc	ra,0x1
    8000244e:	46c080e7          	jalr	1132(ra) # 800038b6 <acquiresleep>
      return b;
    80002452:	a8b9                	j	800024b0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002454:	00015497          	auipc	s1,0x15
    80002458:	ef44b483          	ld	s1,-268(s1) # 80017348 <bcache+0x82b0>
    8000245c:	00015797          	auipc	a5,0x15
    80002460:	ea478793          	addi	a5,a5,-348 # 80017300 <bcache+0x8268>
    80002464:	00f48863          	beq	s1,a5,80002474 <bread+0x90>
    80002468:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000246a:	40bc                	lw	a5,64(s1)
    8000246c:	cf81                	beqz	a5,80002484 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000246e:	64a4                	ld	s1,72(s1)
    80002470:	fee49de3          	bne	s1,a4,8000246a <bread+0x86>
  panic("bget: no buffers");
    80002474:	00006517          	auipc	a0,0x6
    80002478:	0e450513          	addi	a0,a0,228 # 80008558 <syscalls+0xd0>
    8000247c:	00003097          	auipc	ra,0x3
    80002480:	7e4080e7          	jalr	2020(ra) # 80005c60 <panic>
      b->dev = dev;
    80002484:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002488:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000248c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002490:	4785                	li	a5,1
    80002492:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002494:	0000d517          	auipc	a0,0xd
    80002498:	c0450513          	addi	a0,a0,-1020 # 8000f098 <bcache>
    8000249c:	00004097          	auipc	ra,0x4
    800024a0:	db0080e7          	jalr	-592(ra) # 8000624c <release>
      acquiresleep(&b->lock);
    800024a4:	01048513          	addi	a0,s1,16
    800024a8:	00001097          	auipc	ra,0x1
    800024ac:	40e080e7          	jalr	1038(ra) # 800038b6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024b0:	409c                	lw	a5,0(s1)
    800024b2:	cb89                	beqz	a5,800024c4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024b4:	8526                	mv	a0,s1
    800024b6:	70a2                	ld	ra,40(sp)
    800024b8:	7402                	ld	s0,32(sp)
    800024ba:	64e2                	ld	s1,24(sp)
    800024bc:	6942                	ld	s2,16(sp)
    800024be:	69a2                	ld	s3,8(sp)
    800024c0:	6145                	addi	sp,sp,48
    800024c2:	8082                	ret
    virtio_disk_rw(b, 0);
    800024c4:	4581                	li	a1,0
    800024c6:	8526                	mv	a0,s1
    800024c8:	00003097          	auipc	ra,0x3
    800024cc:	f2a080e7          	jalr	-214(ra) # 800053f2 <virtio_disk_rw>
    b->valid = 1;
    800024d0:	4785                	li	a5,1
    800024d2:	c09c                	sw	a5,0(s1)
  return b;
    800024d4:	b7c5                	j	800024b4 <bread+0xd0>

00000000800024d6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024d6:	1101                	addi	sp,sp,-32
    800024d8:	ec06                	sd	ra,24(sp)
    800024da:	e822                	sd	s0,16(sp)
    800024dc:	e426                	sd	s1,8(sp)
    800024de:	1000                	addi	s0,sp,32
    800024e0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024e2:	0541                	addi	a0,a0,16
    800024e4:	00001097          	auipc	ra,0x1
    800024e8:	46c080e7          	jalr	1132(ra) # 80003950 <holdingsleep>
    800024ec:	cd01                	beqz	a0,80002504 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024ee:	4585                	li	a1,1
    800024f0:	8526                	mv	a0,s1
    800024f2:	00003097          	auipc	ra,0x3
    800024f6:	f00080e7          	jalr	-256(ra) # 800053f2 <virtio_disk_rw>
}
    800024fa:	60e2                	ld	ra,24(sp)
    800024fc:	6442                	ld	s0,16(sp)
    800024fe:	64a2                	ld	s1,8(sp)
    80002500:	6105                	addi	sp,sp,32
    80002502:	8082                	ret
    panic("bwrite");
    80002504:	00006517          	auipc	a0,0x6
    80002508:	06c50513          	addi	a0,a0,108 # 80008570 <syscalls+0xe8>
    8000250c:	00003097          	auipc	ra,0x3
    80002510:	754080e7          	jalr	1876(ra) # 80005c60 <panic>

0000000080002514 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002514:	1101                	addi	sp,sp,-32
    80002516:	ec06                	sd	ra,24(sp)
    80002518:	e822                	sd	s0,16(sp)
    8000251a:	e426                	sd	s1,8(sp)
    8000251c:	e04a                	sd	s2,0(sp)
    8000251e:	1000                	addi	s0,sp,32
    80002520:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002522:	01050913          	addi	s2,a0,16
    80002526:	854a                	mv	a0,s2
    80002528:	00001097          	auipc	ra,0x1
    8000252c:	428080e7          	jalr	1064(ra) # 80003950 <holdingsleep>
    80002530:	c92d                	beqz	a0,800025a2 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002532:	854a                	mv	a0,s2
    80002534:	00001097          	auipc	ra,0x1
    80002538:	3d8080e7          	jalr	984(ra) # 8000390c <releasesleep>

  acquire(&bcache.lock);
    8000253c:	0000d517          	auipc	a0,0xd
    80002540:	b5c50513          	addi	a0,a0,-1188 # 8000f098 <bcache>
    80002544:	00004097          	auipc	ra,0x4
    80002548:	c54080e7          	jalr	-940(ra) # 80006198 <acquire>
  b->refcnt--;
    8000254c:	40bc                	lw	a5,64(s1)
    8000254e:	37fd                	addiw	a5,a5,-1
    80002550:	0007871b          	sext.w	a4,a5
    80002554:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002556:	eb05                	bnez	a4,80002586 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002558:	68bc                	ld	a5,80(s1)
    8000255a:	64b8                	ld	a4,72(s1)
    8000255c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000255e:	64bc                	ld	a5,72(s1)
    80002560:	68b8                	ld	a4,80(s1)
    80002562:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002564:	00015797          	auipc	a5,0x15
    80002568:	b3478793          	addi	a5,a5,-1228 # 80017098 <bcache+0x8000>
    8000256c:	2b87b703          	ld	a4,696(a5)
    80002570:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002572:	00015717          	auipc	a4,0x15
    80002576:	d8e70713          	addi	a4,a4,-626 # 80017300 <bcache+0x8268>
    8000257a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000257c:	2b87b703          	ld	a4,696(a5)
    80002580:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002582:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002586:	0000d517          	auipc	a0,0xd
    8000258a:	b1250513          	addi	a0,a0,-1262 # 8000f098 <bcache>
    8000258e:	00004097          	auipc	ra,0x4
    80002592:	cbe080e7          	jalr	-834(ra) # 8000624c <release>
}
    80002596:	60e2                	ld	ra,24(sp)
    80002598:	6442                	ld	s0,16(sp)
    8000259a:	64a2                	ld	s1,8(sp)
    8000259c:	6902                	ld	s2,0(sp)
    8000259e:	6105                	addi	sp,sp,32
    800025a0:	8082                	ret
    panic("brelse");
    800025a2:	00006517          	auipc	a0,0x6
    800025a6:	fd650513          	addi	a0,a0,-42 # 80008578 <syscalls+0xf0>
    800025aa:	00003097          	auipc	ra,0x3
    800025ae:	6b6080e7          	jalr	1718(ra) # 80005c60 <panic>

00000000800025b2 <bpin>:

void
bpin(struct buf *b) {
    800025b2:	1101                	addi	sp,sp,-32
    800025b4:	ec06                	sd	ra,24(sp)
    800025b6:	e822                	sd	s0,16(sp)
    800025b8:	e426                	sd	s1,8(sp)
    800025ba:	1000                	addi	s0,sp,32
    800025bc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025be:	0000d517          	auipc	a0,0xd
    800025c2:	ada50513          	addi	a0,a0,-1318 # 8000f098 <bcache>
    800025c6:	00004097          	auipc	ra,0x4
    800025ca:	bd2080e7          	jalr	-1070(ra) # 80006198 <acquire>
  b->refcnt++;
    800025ce:	40bc                	lw	a5,64(s1)
    800025d0:	2785                	addiw	a5,a5,1
    800025d2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025d4:	0000d517          	auipc	a0,0xd
    800025d8:	ac450513          	addi	a0,a0,-1340 # 8000f098 <bcache>
    800025dc:	00004097          	auipc	ra,0x4
    800025e0:	c70080e7          	jalr	-912(ra) # 8000624c <release>
}
    800025e4:	60e2                	ld	ra,24(sp)
    800025e6:	6442                	ld	s0,16(sp)
    800025e8:	64a2                	ld	s1,8(sp)
    800025ea:	6105                	addi	sp,sp,32
    800025ec:	8082                	ret

00000000800025ee <bunpin>:

void
bunpin(struct buf *b) {
    800025ee:	1101                	addi	sp,sp,-32
    800025f0:	ec06                	sd	ra,24(sp)
    800025f2:	e822                	sd	s0,16(sp)
    800025f4:	e426                	sd	s1,8(sp)
    800025f6:	1000                	addi	s0,sp,32
    800025f8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025fa:	0000d517          	auipc	a0,0xd
    800025fe:	a9e50513          	addi	a0,a0,-1378 # 8000f098 <bcache>
    80002602:	00004097          	auipc	ra,0x4
    80002606:	b96080e7          	jalr	-1130(ra) # 80006198 <acquire>
  b->refcnt--;
    8000260a:	40bc                	lw	a5,64(s1)
    8000260c:	37fd                	addiw	a5,a5,-1
    8000260e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002610:	0000d517          	auipc	a0,0xd
    80002614:	a8850513          	addi	a0,a0,-1400 # 8000f098 <bcache>
    80002618:	00004097          	auipc	ra,0x4
    8000261c:	c34080e7          	jalr	-972(ra) # 8000624c <release>
}
    80002620:	60e2                	ld	ra,24(sp)
    80002622:	6442                	ld	s0,16(sp)
    80002624:	64a2                	ld	s1,8(sp)
    80002626:	6105                	addi	sp,sp,32
    80002628:	8082                	ret

000000008000262a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000262a:	1101                	addi	sp,sp,-32
    8000262c:	ec06                	sd	ra,24(sp)
    8000262e:	e822                	sd	s0,16(sp)
    80002630:	e426                	sd	s1,8(sp)
    80002632:	e04a                	sd	s2,0(sp)
    80002634:	1000                	addi	s0,sp,32
    80002636:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002638:	00d5d59b          	srliw	a1,a1,0xd
    8000263c:	00015797          	auipc	a5,0x15
    80002640:	1387a783          	lw	a5,312(a5) # 80017774 <sb+0x1c>
    80002644:	9dbd                	addw	a1,a1,a5
    80002646:	00000097          	auipc	ra,0x0
    8000264a:	d9e080e7          	jalr	-610(ra) # 800023e4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000264e:	0074f713          	andi	a4,s1,7
    80002652:	4785                	li	a5,1
    80002654:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002658:	14ce                	slli	s1,s1,0x33
    8000265a:	90d9                	srli	s1,s1,0x36
    8000265c:	00950733          	add	a4,a0,s1
    80002660:	05874703          	lbu	a4,88(a4)
    80002664:	00e7f6b3          	and	a3,a5,a4
    80002668:	c69d                	beqz	a3,80002696 <bfree+0x6c>
    8000266a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000266c:	94aa                	add	s1,s1,a0
    8000266e:	fff7c793          	not	a5,a5
    80002672:	8f7d                	and	a4,a4,a5
    80002674:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002678:	00001097          	auipc	ra,0x1
    8000267c:	120080e7          	jalr	288(ra) # 80003798 <log_write>
  brelse(bp);
    80002680:	854a                	mv	a0,s2
    80002682:	00000097          	auipc	ra,0x0
    80002686:	e92080e7          	jalr	-366(ra) # 80002514 <brelse>
}
    8000268a:	60e2                	ld	ra,24(sp)
    8000268c:	6442                	ld	s0,16(sp)
    8000268e:	64a2                	ld	s1,8(sp)
    80002690:	6902                	ld	s2,0(sp)
    80002692:	6105                	addi	sp,sp,32
    80002694:	8082                	ret
    panic("freeing free block");
    80002696:	00006517          	auipc	a0,0x6
    8000269a:	eea50513          	addi	a0,a0,-278 # 80008580 <syscalls+0xf8>
    8000269e:	00003097          	auipc	ra,0x3
    800026a2:	5c2080e7          	jalr	1474(ra) # 80005c60 <panic>

00000000800026a6 <balloc>:
{
    800026a6:	711d                	addi	sp,sp,-96
    800026a8:	ec86                	sd	ra,88(sp)
    800026aa:	e8a2                	sd	s0,80(sp)
    800026ac:	e4a6                	sd	s1,72(sp)
    800026ae:	e0ca                	sd	s2,64(sp)
    800026b0:	fc4e                	sd	s3,56(sp)
    800026b2:	f852                	sd	s4,48(sp)
    800026b4:	f456                	sd	s5,40(sp)
    800026b6:	f05a                	sd	s6,32(sp)
    800026b8:	ec5e                	sd	s7,24(sp)
    800026ba:	e862                	sd	s8,16(sp)
    800026bc:	e466                	sd	s9,8(sp)
    800026be:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026c0:	00015797          	auipc	a5,0x15
    800026c4:	09c7a783          	lw	a5,156(a5) # 8001775c <sb+0x4>
    800026c8:	cbc1                	beqz	a5,80002758 <balloc+0xb2>
    800026ca:	8baa                	mv	s7,a0
    800026cc:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026ce:	00015b17          	auipc	s6,0x15
    800026d2:	08ab0b13          	addi	s6,s6,138 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026d8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026da:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026dc:	6c89                	lui	s9,0x2
    800026de:	a831                	j	800026fa <balloc+0x54>
    brelse(bp);
    800026e0:	854a                	mv	a0,s2
    800026e2:	00000097          	auipc	ra,0x0
    800026e6:	e32080e7          	jalr	-462(ra) # 80002514 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026ea:	015c87bb          	addw	a5,s9,s5
    800026ee:	00078a9b          	sext.w	s5,a5
    800026f2:	004b2703          	lw	a4,4(s6)
    800026f6:	06eaf163          	bgeu	s5,a4,80002758 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800026fa:	41fad79b          	sraiw	a5,s5,0x1f
    800026fe:	0137d79b          	srliw	a5,a5,0x13
    80002702:	015787bb          	addw	a5,a5,s5
    80002706:	40d7d79b          	sraiw	a5,a5,0xd
    8000270a:	01cb2583          	lw	a1,28(s6)
    8000270e:	9dbd                	addw	a1,a1,a5
    80002710:	855e                	mv	a0,s7
    80002712:	00000097          	auipc	ra,0x0
    80002716:	cd2080e7          	jalr	-814(ra) # 800023e4 <bread>
    8000271a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000271c:	004b2503          	lw	a0,4(s6)
    80002720:	000a849b          	sext.w	s1,s5
    80002724:	8762                	mv	a4,s8
    80002726:	faa4fde3          	bgeu	s1,a0,800026e0 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000272a:	00777693          	andi	a3,a4,7
    8000272e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002732:	41f7579b          	sraiw	a5,a4,0x1f
    80002736:	01d7d79b          	srliw	a5,a5,0x1d
    8000273a:	9fb9                	addw	a5,a5,a4
    8000273c:	4037d79b          	sraiw	a5,a5,0x3
    80002740:	00f90633          	add	a2,s2,a5
    80002744:	05864603          	lbu	a2,88(a2)
    80002748:	00c6f5b3          	and	a1,a3,a2
    8000274c:	cd91                	beqz	a1,80002768 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000274e:	2705                	addiw	a4,a4,1
    80002750:	2485                	addiw	s1,s1,1
    80002752:	fd471ae3          	bne	a4,s4,80002726 <balloc+0x80>
    80002756:	b769                	j	800026e0 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002758:	00006517          	auipc	a0,0x6
    8000275c:	e4050513          	addi	a0,a0,-448 # 80008598 <syscalls+0x110>
    80002760:	00003097          	auipc	ra,0x3
    80002764:	500080e7          	jalr	1280(ra) # 80005c60 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002768:	97ca                	add	a5,a5,s2
    8000276a:	8e55                	or	a2,a2,a3
    8000276c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002770:	854a                	mv	a0,s2
    80002772:	00001097          	auipc	ra,0x1
    80002776:	026080e7          	jalr	38(ra) # 80003798 <log_write>
        brelse(bp);
    8000277a:	854a                	mv	a0,s2
    8000277c:	00000097          	auipc	ra,0x0
    80002780:	d98080e7          	jalr	-616(ra) # 80002514 <brelse>
  bp = bread(dev, bno);
    80002784:	85a6                	mv	a1,s1
    80002786:	855e                	mv	a0,s7
    80002788:	00000097          	auipc	ra,0x0
    8000278c:	c5c080e7          	jalr	-932(ra) # 800023e4 <bread>
    80002790:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002792:	40000613          	li	a2,1024
    80002796:	4581                	li	a1,0
    80002798:	05850513          	addi	a0,a0,88
    8000279c:	ffffe097          	auipc	ra,0xffffe
    800027a0:	a28080e7          	jalr	-1496(ra) # 800001c4 <memset>
  log_write(bp);
    800027a4:	854a                	mv	a0,s2
    800027a6:	00001097          	auipc	ra,0x1
    800027aa:	ff2080e7          	jalr	-14(ra) # 80003798 <log_write>
  brelse(bp);
    800027ae:	854a                	mv	a0,s2
    800027b0:	00000097          	auipc	ra,0x0
    800027b4:	d64080e7          	jalr	-668(ra) # 80002514 <brelse>
}
    800027b8:	8526                	mv	a0,s1
    800027ba:	60e6                	ld	ra,88(sp)
    800027bc:	6446                	ld	s0,80(sp)
    800027be:	64a6                	ld	s1,72(sp)
    800027c0:	6906                	ld	s2,64(sp)
    800027c2:	79e2                	ld	s3,56(sp)
    800027c4:	7a42                	ld	s4,48(sp)
    800027c6:	7aa2                	ld	s5,40(sp)
    800027c8:	7b02                	ld	s6,32(sp)
    800027ca:	6be2                	ld	s7,24(sp)
    800027cc:	6c42                	ld	s8,16(sp)
    800027ce:	6ca2                	ld	s9,8(sp)
    800027d0:	6125                	addi	sp,sp,96
    800027d2:	8082                	ret

00000000800027d4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027d4:	7179                	addi	sp,sp,-48
    800027d6:	f406                	sd	ra,40(sp)
    800027d8:	f022                	sd	s0,32(sp)
    800027da:	ec26                	sd	s1,24(sp)
    800027dc:	e84a                	sd	s2,16(sp)
    800027de:	e44e                	sd	s3,8(sp)
    800027e0:	e052                	sd	s4,0(sp)
    800027e2:	1800                	addi	s0,sp,48
    800027e4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027e6:	47ad                	li	a5,11
    800027e8:	04b7fe63          	bgeu	a5,a1,80002844 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027ec:	ff45849b          	addiw	s1,a1,-12
    800027f0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027f4:	0ff00793          	li	a5,255
    800027f8:	0ae7e463          	bltu	a5,a4,800028a0 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027fc:	08052583          	lw	a1,128(a0)
    80002800:	c5b5                	beqz	a1,8000286c <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002802:	00092503          	lw	a0,0(s2)
    80002806:	00000097          	auipc	ra,0x0
    8000280a:	bde080e7          	jalr	-1058(ra) # 800023e4 <bread>
    8000280e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002810:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002814:	02049713          	slli	a4,s1,0x20
    80002818:	01e75593          	srli	a1,a4,0x1e
    8000281c:	00b784b3          	add	s1,a5,a1
    80002820:	0004a983          	lw	s3,0(s1)
    80002824:	04098e63          	beqz	s3,80002880 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002828:	8552                	mv	a0,s4
    8000282a:	00000097          	auipc	ra,0x0
    8000282e:	cea080e7          	jalr	-790(ra) # 80002514 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002832:	854e                	mv	a0,s3
    80002834:	70a2                	ld	ra,40(sp)
    80002836:	7402                	ld	s0,32(sp)
    80002838:	64e2                	ld	s1,24(sp)
    8000283a:	6942                	ld	s2,16(sp)
    8000283c:	69a2                	ld	s3,8(sp)
    8000283e:	6a02                	ld	s4,0(sp)
    80002840:	6145                	addi	sp,sp,48
    80002842:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002844:	02059793          	slli	a5,a1,0x20
    80002848:	01e7d593          	srli	a1,a5,0x1e
    8000284c:	00b504b3          	add	s1,a0,a1
    80002850:	0504a983          	lw	s3,80(s1)
    80002854:	fc099fe3          	bnez	s3,80002832 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002858:	4108                	lw	a0,0(a0)
    8000285a:	00000097          	auipc	ra,0x0
    8000285e:	e4c080e7          	jalr	-436(ra) # 800026a6 <balloc>
    80002862:	0005099b          	sext.w	s3,a0
    80002866:	0534a823          	sw	s3,80(s1)
    8000286a:	b7e1                	j	80002832 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000286c:	4108                	lw	a0,0(a0)
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	e38080e7          	jalr	-456(ra) # 800026a6 <balloc>
    80002876:	0005059b          	sext.w	a1,a0
    8000287a:	08b92023          	sw	a1,128(s2)
    8000287e:	b751                	j	80002802 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002880:	00092503          	lw	a0,0(s2)
    80002884:	00000097          	auipc	ra,0x0
    80002888:	e22080e7          	jalr	-478(ra) # 800026a6 <balloc>
    8000288c:	0005099b          	sext.w	s3,a0
    80002890:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002894:	8552                	mv	a0,s4
    80002896:	00001097          	auipc	ra,0x1
    8000289a:	f02080e7          	jalr	-254(ra) # 80003798 <log_write>
    8000289e:	b769                	j	80002828 <bmap+0x54>
  panic("bmap: out of range");
    800028a0:	00006517          	auipc	a0,0x6
    800028a4:	d1050513          	addi	a0,a0,-752 # 800085b0 <syscalls+0x128>
    800028a8:	00003097          	auipc	ra,0x3
    800028ac:	3b8080e7          	jalr	952(ra) # 80005c60 <panic>

00000000800028b0 <iget>:
{
    800028b0:	7179                	addi	sp,sp,-48
    800028b2:	f406                	sd	ra,40(sp)
    800028b4:	f022                	sd	s0,32(sp)
    800028b6:	ec26                	sd	s1,24(sp)
    800028b8:	e84a                	sd	s2,16(sp)
    800028ba:	e44e                	sd	s3,8(sp)
    800028bc:	e052                	sd	s4,0(sp)
    800028be:	1800                	addi	s0,sp,48
    800028c0:	89aa                	mv	s3,a0
    800028c2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028c4:	00015517          	auipc	a0,0x15
    800028c8:	eb450513          	addi	a0,a0,-332 # 80017778 <itable>
    800028cc:	00004097          	auipc	ra,0x4
    800028d0:	8cc080e7          	jalr	-1844(ra) # 80006198 <acquire>
  empty = 0;
    800028d4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028d6:	00015497          	auipc	s1,0x15
    800028da:	eba48493          	addi	s1,s1,-326 # 80017790 <itable+0x18>
    800028de:	00017697          	auipc	a3,0x17
    800028e2:	94268693          	addi	a3,a3,-1726 # 80019220 <log>
    800028e6:	a039                	j	800028f4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028e8:	02090b63          	beqz	s2,8000291e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ec:	08848493          	addi	s1,s1,136
    800028f0:	02d48a63          	beq	s1,a3,80002924 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028f4:	449c                	lw	a5,8(s1)
    800028f6:	fef059e3          	blez	a5,800028e8 <iget+0x38>
    800028fa:	4098                	lw	a4,0(s1)
    800028fc:	ff3716e3          	bne	a4,s3,800028e8 <iget+0x38>
    80002900:	40d8                	lw	a4,4(s1)
    80002902:	ff4713e3          	bne	a4,s4,800028e8 <iget+0x38>
      ip->ref++;
    80002906:	2785                	addiw	a5,a5,1
    80002908:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000290a:	00015517          	auipc	a0,0x15
    8000290e:	e6e50513          	addi	a0,a0,-402 # 80017778 <itable>
    80002912:	00004097          	auipc	ra,0x4
    80002916:	93a080e7          	jalr	-1734(ra) # 8000624c <release>
      return ip;
    8000291a:	8926                	mv	s2,s1
    8000291c:	a03d                	j	8000294a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000291e:	f7f9                	bnez	a5,800028ec <iget+0x3c>
    80002920:	8926                	mv	s2,s1
    80002922:	b7e9                	j	800028ec <iget+0x3c>
  if(empty == 0)
    80002924:	02090c63          	beqz	s2,8000295c <iget+0xac>
  ip->dev = dev;
    80002928:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000292c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002930:	4785                	li	a5,1
    80002932:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002936:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000293a:	00015517          	auipc	a0,0x15
    8000293e:	e3e50513          	addi	a0,a0,-450 # 80017778 <itable>
    80002942:	00004097          	auipc	ra,0x4
    80002946:	90a080e7          	jalr	-1782(ra) # 8000624c <release>
}
    8000294a:	854a                	mv	a0,s2
    8000294c:	70a2                	ld	ra,40(sp)
    8000294e:	7402                	ld	s0,32(sp)
    80002950:	64e2                	ld	s1,24(sp)
    80002952:	6942                	ld	s2,16(sp)
    80002954:	69a2                	ld	s3,8(sp)
    80002956:	6a02                	ld	s4,0(sp)
    80002958:	6145                	addi	sp,sp,48
    8000295a:	8082                	ret
    panic("iget: no inodes");
    8000295c:	00006517          	auipc	a0,0x6
    80002960:	c6c50513          	addi	a0,a0,-916 # 800085c8 <syscalls+0x140>
    80002964:	00003097          	auipc	ra,0x3
    80002968:	2fc080e7          	jalr	764(ra) # 80005c60 <panic>

000000008000296c <fsinit>:
fsinit(int dev) {
    8000296c:	7179                	addi	sp,sp,-48
    8000296e:	f406                	sd	ra,40(sp)
    80002970:	f022                	sd	s0,32(sp)
    80002972:	ec26                	sd	s1,24(sp)
    80002974:	e84a                	sd	s2,16(sp)
    80002976:	e44e                	sd	s3,8(sp)
    80002978:	1800                	addi	s0,sp,48
    8000297a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000297c:	4585                	li	a1,1
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	a66080e7          	jalr	-1434(ra) # 800023e4 <bread>
    80002986:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002988:	00015997          	auipc	s3,0x15
    8000298c:	dd098993          	addi	s3,s3,-560 # 80017758 <sb>
    80002990:	02000613          	li	a2,32
    80002994:	05850593          	addi	a1,a0,88
    80002998:	854e                	mv	a0,s3
    8000299a:	ffffe097          	auipc	ra,0xffffe
    8000299e:	886080e7          	jalr	-1914(ra) # 80000220 <memmove>
  brelse(bp);
    800029a2:	8526                	mv	a0,s1
    800029a4:	00000097          	auipc	ra,0x0
    800029a8:	b70080e7          	jalr	-1168(ra) # 80002514 <brelse>
  if(sb.magic != FSMAGIC)
    800029ac:	0009a703          	lw	a4,0(s3)
    800029b0:	102037b7          	lui	a5,0x10203
    800029b4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029b8:	02f71263          	bne	a4,a5,800029dc <fsinit+0x70>
  initlog(dev, &sb);
    800029bc:	00015597          	auipc	a1,0x15
    800029c0:	d9c58593          	addi	a1,a1,-612 # 80017758 <sb>
    800029c4:	854a                	mv	a0,s2
    800029c6:	00001097          	auipc	ra,0x1
    800029ca:	b56080e7          	jalr	-1194(ra) # 8000351c <initlog>
}
    800029ce:	70a2                	ld	ra,40(sp)
    800029d0:	7402                	ld	s0,32(sp)
    800029d2:	64e2                	ld	s1,24(sp)
    800029d4:	6942                	ld	s2,16(sp)
    800029d6:	69a2                	ld	s3,8(sp)
    800029d8:	6145                	addi	sp,sp,48
    800029da:	8082                	ret
    panic("invalid file system");
    800029dc:	00006517          	auipc	a0,0x6
    800029e0:	bfc50513          	addi	a0,a0,-1028 # 800085d8 <syscalls+0x150>
    800029e4:	00003097          	auipc	ra,0x3
    800029e8:	27c080e7          	jalr	636(ra) # 80005c60 <panic>

00000000800029ec <iinit>:
{
    800029ec:	7179                	addi	sp,sp,-48
    800029ee:	f406                	sd	ra,40(sp)
    800029f0:	f022                	sd	s0,32(sp)
    800029f2:	ec26                	sd	s1,24(sp)
    800029f4:	e84a                	sd	s2,16(sp)
    800029f6:	e44e                	sd	s3,8(sp)
    800029f8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029fa:	00006597          	auipc	a1,0x6
    800029fe:	bf658593          	addi	a1,a1,-1034 # 800085f0 <syscalls+0x168>
    80002a02:	00015517          	auipc	a0,0x15
    80002a06:	d7650513          	addi	a0,a0,-650 # 80017778 <itable>
    80002a0a:	00003097          	auipc	ra,0x3
    80002a0e:	6fe080e7          	jalr	1790(ra) # 80006108 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a12:	00015497          	auipc	s1,0x15
    80002a16:	d8e48493          	addi	s1,s1,-626 # 800177a0 <itable+0x28>
    80002a1a:	00017997          	auipc	s3,0x17
    80002a1e:	81698993          	addi	s3,s3,-2026 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a22:	00006917          	auipc	s2,0x6
    80002a26:	bd690913          	addi	s2,s2,-1066 # 800085f8 <syscalls+0x170>
    80002a2a:	85ca                	mv	a1,s2
    80002a2c:	8526                	mv	a0,s1
    80002a2e:	00001097          	auipc	ra,0x1
    80002a32:	e4e080e7          	jalr	-434(ra) # 8000387c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a36:	08848493          	addi	s1,s1,136
    80002a3a:	ff3498e3          	bne	s1,s3,80002a2a <iinit+0x3e>
}
    80002a3e:	70a2                	ld	ra,40(sp)
    80002a40:	7402                	ld	s0,32(sp)
    80002a42:	64e2                	ld	s1,24(sp)
    80002a44:	6942                	ld	s2,16(sp)
    80002a46:	69a2                	ld	s3,8(sp)
    80002a48:	6145                	addi	sp,sp,48
    80002a4a:	8082                	ret

0000000080002a4c <ialloc>:
{
    80002a4c:	715d                	addi	sp,sp,-80
    80002a4e:	e486                	sd	ra,72(sp)
    80002a50:	e0a2                	sd	s0,64(sp)
    80002a52:	fc26                	sd	s1,56(sp)
    80002a54:	f84a                	sd	s2,48(sp)
    80002a56:	f44e                	sd	s3,40(sp)
    80002a58:	f052                	sd	s4,32(sp)
    80002a5a:	ec56                	sd	s5,24(sp)
    80002a5c:	e85a                	sd	s6,16(sp)
    80002a5e:	e45e                	sd	s7,8(sp)
    80002a60:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a62:	00015717          	auipc	a4,0x15
    80002a66:	d0272703          	lw	a4,-766(a4) # 80017764 <sb+0xc>
    80002a6a:	4785                	li	a5,1
    80002a6c:	04e7fa63          	bgeu	a5,a4,80002ac0 <ialloc+0x74>
    80002a70:	8aaa                	mv	s5,a0
    80002a72:	8bae                	mv	s7,a1
    80002a74:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a76:	00015a17          	auipc	s4,0x15
    80002a7a:	ce2a0a13          	addi	s4,s4,-798 # 80017758 <sb>
    80002a7e:	00048b1b          	sext.w	s6,s1
    80002a82:	0044d593          	srli	a1,s1,0x4
    80002a86:	018a2783          	lw	a5,24(s4)
    80002a8a:	9dbd                	addw	a1,a1,a5
    80002a8c:	8556                	mv	a0,s5
    80002a8e:	00000097          	auipc	ra,0x0
    80002a92:	956080e7          	jalr	-1706(ra) # 800023e4 <bread>
    80002a96:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a98:	05850993          	addi	s3,a0,88
    80002a9c:	00f4f793          	andi	a5,s1,15
    80002aa0:	079a                	slli	a5,a5,0x6
    80002aa2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002aa4:	00099783          	lh	a5,0(s3)
    80002aa8:	c785                	beqz	a5,80002ad0 <ialloc+0x84>
    brelse(bp);
    80002aaa:	00000097          	auipc	ra,0x0
    80002aae:	a6a080e7          	jalr	-1430(ra) # 80002514 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ab2:	0485                	addi	s1,s1,1
    80002ab4:	00ca2703          	lw	a4,12(s4)
    80002ab8:	0004879b          	sext.w	a5,s1
    80002abc:	fce7e1e3          	bltu	a5,a4,80002a7e <ialloc+0x32>
  panic("ialloc: no inodes");
    80002ac0:	00006517          	auipc	a0,0x6
    80002ac4:	b4050513          	addi	a0,a0,-1216 # 80008600 <syscalls+0x178>
    80002ac8:	00003097          	auipc	ra,0x3
    80002acc:	198080e7          	jalr	408(ra) # 80005c60 <panic>
      memset(dip, 0, sizeof(*dip));
    80002ad0:	04000613          	li	a2,64
    80002ad4:	4581                	li	a1,0
    80002ad6:	854e                	mv	a0,s3
    80002ad8:	ffffd097          	auipc	ra,0xffffd
    80002adc:	6ec080e7          	jalr	1772(ra) # 800001c4 <memset>
      dip->type = type;
    80002ae0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ae4:	854a                	mv	a0,s2
    80002ae6:	00001097          	auipc	ra,0x1
    80002aea:	cb2080e7          	jalr	-846(ra) # 80003798 <log_write>
      brelse(bp);
    80002aee:	854a                	mv	a0,s2
    80002af0:	00000097          	auipc	ra,0x0
    80002af4:	a24080e7          	jalr	-1500(ra) # 80002514 <brelse>
      return iget(dev, inum);
    80002af8:	85da                	mv	a1,s6
    80002afa:	8556                	mv	a0,s5
    80002afc:	00000097          	auipc	ra,0x0
    80002b00:	db4080e7          	jalr	-588(ra) # 800028b0 <iget>
}
    80002b04:	60a6                	ld	ra,72(sp)
    80002b06:	6406                	ld	s0,64(sp)
    80002b08:	74e2                	ld	s1,56(sp)
    80002b0a:	7942                	ld	s2,48(sp)
    80002b0c:	79a2                	ld	s3,40(sp)
    80002b0e:	7a02                	ld	s4,32(sp)
    80002b10:	6ae2                	ld	s5,24(sp)
    80002b12:	6b42                	ld	s6,16(sp)
    80002b14:	6ba2                	ld	s7,8(sp)
    80002b16:	6161                	addi	sp,sp,80
    80002b18:	8082                	ret

0000000080002b1a <iupdate>:
{
    80002b1a:	1101                	addi	sp,sp,-32
    80002b1c:	ec06                	sd	ra,24(sp)
    80002b1e:	e822                	sd	s0,16(sp)
    80002b20:	e426                	sd	s1,8(sp)
    80002b22:	e04a                	sd	s2,0(sp)
    80002b24:	1000                	addi	s0,sp,32
    80002b26:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b28:	415c                	lw	a5,4(a0)
    80002b2a:	0047d79b          	srliw	a5,a5,0x4
    80002b2e:	00015597          	auipc	a1,0x15
    80002b32:	c425a583          	lw	a1,-958(a1) # 80017770 <sb+0x18>
    80002b36:	9dbd                	addw	a1,a1,a5
    80002b38:	4108                	lw	a0,0(a0)
    80002b3a:	00000097          	auipc	ra,0x0
    80002b3e:	8aa080e7          	jalr	-1878(ra) # 800023e4 <bread>
    80002b42:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b44:	05850793          	addi	a5,a0,88
    80002b48:	40d8                	lw	a4,4(s1)
    80002b4a:	8b3d                	andi	a4,a4,15
    80002b4c:	071a                	slli	a4,a4,0x6
    80002b4e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b50:	04449703          	lh	a4,68(s1)
    80002b54:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b58:	04649703          	lh	a4,70(s1)
    80002b5c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b60:	04849703          	lh	a4,72(s1)
    80002b64:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b68:	04a49703          	lh	a4,74(s1)
    80002b6c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b70:	44f8                	lw	a4,76(s1)
    80002b72:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b74:	03400613          	li	a2,52
    80002b78:	05048593          	addi	a1,s1,80
    80002b7c:	00c78513          	addi	a0,a5,12
    80002b80:	ffffd097          	auipc	ra,0xffffd
    80002b84:	6a0080e7          	jalr	1696(ra) # 80000220 <memmove>
  log_write(bp);
    80002b88:	854a                	mv	a0,s2
    80002b8a:	00001097          	auipc	ra,0x1
    80002b8e:	c0e080e7          	jalr	-1010(ra) # 80003798 <log_write>
  brelse(bp);
    80002b92:	854a                	mv	a0,s2
    80002b94:	00000097          	auipc	ra,0x0
    80002b98:	980080e7          	jalr	-1664(ra) # 80002514 <brelse>
}
    80002b9c:	60e2                	ld	ra,24(sp)
    80002b9e:	6442                	ld	s0,16(sp)
    80002ba0:	64a2                	ld	s1,8(sp)
    80002ba2:	6902                	ld	s2,0(sp)
    80002ba4:	6105                	addi	sp,sp,32
    80002ba6:	8082                	ret

0000000080002ba8 <idup>:
{
    80002ba8:	1101                	addi	sp,sp,-32
    80002baa:	ec06                	sd	ra,24(sp)
    80002bac:	e822                	sd	s0,16(sp)
    80002bae:	e426                	sd	s1,8(sp)
    80002bb0:	1000                	addi	s0,sp,32
    80002bb2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bb4:	00015517          	auipc	a0,0x15
    80002bb8:	bc450513          	addi	a0,a0,-1084 # 80017778 <itable>
    80002bbc:	00003097          	auipc	ra,0x3
    80002bc0:	5dc080e7          	jalr	1500(ra) # 80006198 <acquire>
  ip->ref++;
    80002bc4:	449c                	lw	a5,8(s1)
    80002bc6:	2785                	addiw	a5,a5,1
    80002bc8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bca:	00015517          	auipc	a0,0x15
    80002bce:	bae50513          	addi	a0,a0,-1106 # 80017778 <itable>
    80002bd2:	00003097          	auipc	ra,0x3
    80002bd6:	67a080e7          	jalr	1658(ra) # 8000624c <release>
}
    80002bda:	8526                	mv	a0,s1
    80002bdc:	60e2                	ld	ra,24(sp)
    80002bde:	6442                	ld	s0,16(sp)
    80002be0:	64a2                	ld	s1,8(sp)
    80002be2:	6105                	addi	sp,sp,32
    80002be4:	8082                	ret

0000000080002be6 <ilock>:
{
    80002be6:	1101                	addi	sp,sp,-32
    80002be8:	ec06                	sd	ra,24(sp)
    80002bea:	e822                	sd	s0,16(sp)
    80002bec:	e426                	sd	s1,8(sp)
    80002bee:	e04a                	sd	s2,0(sp)
    80002bf0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bf2:	c115                	beqz	a0,80002c16 <ilock+0x30>
    80002bf4:	84aa                	mv	s1,a0
    80002bf6:	451c                	lw	a5,8(a0)
    80002bf8:	00f05f63          	blez	a5,80002c16 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bfc:	0541                	addi	a0,a0,16
    80002bfe:	00001097          	auipc	ra,0x1
    80002c02:	cb8080e7          	jalr	-840(ra) # 800038b6 <acquiresleep>
  if(ip->valid == 0){
    80002c06:	40bc                	lw	a5,64(s1)
    80002c08:	cf99                	beqz	a5,80002c26 <ilock+0x40>
}
    80002c0a:	60e2                	ld	ra,24(sp)
    80002c0c:	6442                	ld	s0,16(sp)
    80002c0e:	64a2                	ld	s1,8(sp)
    80002c10:	6902                	ld	s2,0(sp)
    80002c12:	6105                	addi	sp,sp,32
    80002c14:	8082                	ret
    panic("ilock");
    80002c16:	00006517          	auipc	a0,0x6
    80002c1a:	a0250513          	addi	a0,a0,-1534 # 80008618 <syscalls+0x190>
    80002c1e:	00003097          	auipc	ra,0x3
    80002c22:	042080e7          	jalr	66(ra) # 80005c60 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c26:	40dc                	lw	a5,4(s1)
    80002c28:	0047d79b          	srliw	a5,a5,0x4
    80002c2c:	00015597          	auipc	a1,0x15
    80002c30:	b445a583          	lw	a1,-1212(a1) # 80017770 <sb+0x18>
    80002c34:	9dbd                	addw	a1,a1,a5
    80002c36:	4088                	lw	a0,0(s1)
    80002c38:	fffff097          	auipc	ra,0xfffff
    80002c3c:	7ac080e7          	jalr	1964(ra) # 800023e4 <bread>
    80002c40:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c42:	05850593          	addi	a1,a0,88
    80002c46:	40dc                	lw	a5,4(s1)
    80002c48:	8bbd                	andi	a5,a5,15
    80002c4a:	079a                	slli	a5,a5,0x6
    80002c4c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c4e:	00059783          	lh	a5,0(a1)
    80002c52:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c56:	00259783          	lh	a5,2(a1)
    80002c5a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c5e:	00459783          	lh	a5,4(a1)
    80002c62:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c66:	00659783          	lh	a5,6(a1)
    80002c6a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c6e:	459c                	lw	a5,8(a1)
    80002c70:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c72:	03400613          	li	a2,52
    80002c76:	05b1                	addi	a1,a1,12
    80002c78:	05048513          	addi	a0,s1,80
    80002c7c:	ffffd097          	auipc	ra,0xffffd
    80002c80:	5a4080e7          	jalr	1444(ra) # 80000220 <memmove>
    brelse(bp);
    80002c84:	854a                	mv	a0,s2
    80002c86:	00000097          	auipc	ra,0x0
    80002c8a:	88e080e7          	jalr	-1906(ra) # 80002514 <brelse>
    ip->valid = 1;
    80002c8e:	4785                	li	a5,1
    80002c90:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c92:	04449783          	lh	a5,68(s1)
    80002c96:	fbb5                	bnez	a5,80002c0a <ilock+0x24>
      panic("ilock: no type");
    80002c98:	00006517          	auipc	a0,0x6
    80002c9c:	98850513          	addi	a0,a0,-1656 # 80008620 <syscalls+0x198>
    80002ca0:	00003097          	auipc	ra,0x3
    80002ca4:	fc0080e7          	jalr	-64(ra) # 80005c60 <panic>

0000000080002ca8 <iunlock>:
{
    80002ca8:	1101                	addi	sp,sp,-32
    80002caa:	ec06                	sd	ra,24(sp)
    80002cac:	e822                	sd	s0,16(sp)
    80002cae:	e426                	sd	s1,8(sp)
    80002cb0:	e04a                	sd	s2,0(sp)
    80002cb2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cb4:	c905                	beqz	a0,80002ce4 <iunlock+0x3c>
    80002cb6:	84aa                	mv	s1,a0
    80002cb8:	01050913          	addi	s2,a0,16
    80002cbc:	854a                	mv	a0,s2
    80002cbe:	00001097          	auipc	ra,0x1
    80002cc2:	c92080e7          	jalr	-878(ra) # 80003950 <holdingsleep>
    80002cc6:	cd19                	beqz	a0,80002ce4 <iunlock+0x3c>
    80002cc8:	449c                	lw	a5,8(s1)
    80002cca:	00f05d63          	blez	a5,80002ce4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cce:	854a                	mv	a0,s2
    80002cd0:	00001097          	auipc	ra,0x1
    80002cd4:	c3c080e7          	jalr	-964(ra) # 8000390c <releasesleep>
}
    80002cd8:	60e2                	ld	ra,24(sp)
    80002cda:	6442                	ld	s0,16(sp)
    80002cdc:	64a2                	ld	s1,8(sp)
    80002cde:	6902                	ld	s2,0(sp)
    80002ce0:	6105                	addi	sp,sp,32
    80002ce2:	8082                	ret
    panic("iunlock");
    80002ce4:	00006517          	auipc	a0,0x6
    80002ce8:	94c50513          	addi	a0,a0,-1716 # 80008630 <syscalls+0x1a8>
    80002cec:	00003097          	auipc	ra,0x3
    80002cf0:	f74080e7          	jalr	-140(ra) # 80005c60 <panic>

0000000080002cf4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cf4:	7179                	addi	sp,sp,-48
    80002cf6:	f406                	sd	ra,40(sp)
    80002cf8:	f022                	sd	s0,32(sp)
    80002cfa:	ec26                	sd	s1,24(sp)
    80002cfc:	e84a                	sd	s2,16(sp)
    80002cfe:	e44e                	sd	s3,8(sp)
    80002d00:	e052                	sd	s4,0(sp)
    80002d02:	1800                	addi	s0,sp,48
    80002d04:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d06:	05050493          	addi	s1,a0,80
    80002d0a:	08050913          	addi	s2,a0,128
    80002d0e:	a021                	j	80002d16 <itrunc+0x22>
    80002d10:	0491                	addi	s1,s1,4
    80002d12:	01248d63          	beq	s1,s2,80002d2c <itrunc+0x38>
    if(ip->addrs[i]){
    80002d16:	408c                	lw	a1,0(s1)
    80002d18:	dde5                	beqz	a1,80002d10 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d1a:	0009a503          	lw	a0,0(s3)
    80002d1e:	00000097          	auipc	ra,0x0
    80002d22:	90c080e7          	jalr	-1780(ra) # 8000262a <bfree>
      ip->addrs[i] = 0;
    80002d26:	0004a023          	sw	zero,0(s1)
    80002d2a:	b7dd                	j	80002d10 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d2c:	0809a583          	lw	a1,128(s3)
    80002d30:	e185                	bnez	a1,80002d50 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d32:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d36:	854e                	mv	a0,s3
    80002d38:	00000097          	auipc	ra,0x0
    80002d3c:	de2080e7          	jalr	-542(ra) # 80002b1a <iupdate>
}
    80002d40:	70a2                	ld	ra,40(sp)
    80002d42:	7402                	ld	s0,32(sp)
    80002d44:	64e2                	ld	s1,24(sp)
    80002d46:	6942                	ld	s2,16(sp)
    80002d48:	69a2                	ld	s3,8(sp)
    80002d4a:	6a02                	ld	s4,0(sp)
    80002d4c:	6145                	addi	sp,sp,48
    80002d4e:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d50:	0009a503          	lw	a0,0(s3)
    80002d54:	fffff097          	auipc	ra,0xfffff
    80002d58:	690080e7          	jalr	1680(ra) # 800023e4 <bread>
    80002d5c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d5e:	05850493          	addi	s1,a0,88
    80002d62:	45850913          	addi	s2,a0,1112
    80002d66:	a021                	j	80002d6e <itrunc+0x7a>
    80002d68:	0491                	addi	s1,s1,4
    80002d6a:	01248b63          	beq	s1,s2,80002d80 <itrunc+0x8c>
      if(a[j])
    80002d6e:	408c                	lw	a1,0(s1)
    80002d70:	dde5                	beqz	a1,80002d68 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d72:	0009a503          	lw	a0,0(s3)
    80002d76:	00000097          	auipc	ra,0x0
    80002d7a:	8b4080e7          	jalr	-1868(ra) # 8000262a <bfree>
    80002d7e:	b7ed                	j	80002d68 <itrunc+0x74>
    brelse(bp);
    80002d80:	8552                	mv	a0,s4
    80002d82:	fffff097          	auipc	ra,0xfffff
    80002d86:	792080e7          	jalr	1938(ra) # 80002514 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d8a:	0809a583          	lw	a1,128(s3)
    80002d8e:	0009a503          	lw	a0,0(s3)
    80002d92:	00000097          	auipc	ra,0x0
    80002d96:	898080e7          	jalr	-1896(ra) # 8000262a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d9a:	0809a023          	sw	zero,128(s3)
    80002d9e:	bf51                	j	80002d32 <itrunc+0x3e>

0000000080002da0 <iput>:
{
    80002da0:	1101                	addi	sp,sp,-32
    80002da2:	ec06                	sd	ra,24(sp)
    80002da4:	e822                	sd	s0,16(sp)
    80002da6:	e426                	sd	s1,8(sp)
    80002da8:	e04a                	sd	s2,0(sp)
    80002daa:	1000                	addi	s0,sp,32
    80002dac:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dae:	00015517          	auipc	a0,0x15
    80002db2:	9ca50513          	addi	a0,a0,-1590 # 80017778 <itable>
    80002db6:	00003097          	auipc	ra,0x3
    80002dba:	3e2080e7          	jalr	994(ra) # 80006198 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dbe:	4498                	lw	a4,8(s1)
    80002dc0:	4785                	li	a5,1
    80002dc2:	02f70363          	beq	a4,a5,80002de8 <iput+0x48>
  ip->ref--;
    80002dc6:	449c                	lw	a5,8(s1)
    80002dc8:	37fd                	addiw	a5,a5,-1
    80002dca:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dcc:	00015517          	auipc	a0,0x15
    80002dd0:	9ac50513          	addi	a0,a0,-1620 # 80017778 <itable>
    80002dd4:	00003097          	auipc	ra,0x3
    80002dd8:	478080e7          	jalr	1144(ra) # 8000624c <release>
}
    80002ddc:	60e2                	ld	ra,24(sp)
    80002dde:	6442                	ld	s0,16(sp)
    80002de0:	64a2                	ld	s1,8(sp)
    80002de2:	6902                	ld	s2,0(sp)
    80002de4:	6105                	addi	sp,sp,32
    80002de6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002de8:	40bc                	lw	a5,64(s1)
    80002dea:	dff1                	beqz	a5,80002dc6 <iput+0x26>
    80002dec:	04a49783          	lh	a5,74(s1)
    80002df0:	fbf9                	bnez	a5,80002dc6 <iput+0x26>
    acquiresleep(&ip->lock);
    80002df2:	01048913          	addi	s2,s1,16
    80002df6:	854a                	mv	a0,s2
    80002df8:	00001097          	auipc	ra,0x1
    80002dfc:	abe080e7          	jalr	-1346(ra) # 800038b6 <acquiresleep>
    release(&itable.lock);
    80002e00:	00015517          	auipc	a0,0x15
    80002e04:	97850513          	addi	a0,a0,-1672 # 80017778 <itable>
    80002e08:	00003097          	auipc	ra,0x3
    80002e0c:	444080e7          	jalr	1092(ra) # 8000624c <release>
    itrunc(ip);
    80002e10:	8526                	mv	a0,s1
    80002e12:	00000097          	auipc	ra,0x0
    80002e16:	ee2080e7          	jalr	-286(ra) # 80002cf4 <itrunc>
    ip->type = 0;
    80002e1a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e1e:	8526                	mv	a0,s1
    80002e20:	00000097          	auipc	ra,0x0
    80002e24:	cfa080e7          	jalr	-774(ra) # 80002b1a <iupdate>
    ip->valid = 0;
    80002e28:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e2c:	854a                	mv	a0,s2
    80002e2e:	00001097          	auipc	ra,0x1
    80002e32:	ade080e7          	jalr	-1314(ra) # 8000390c <releasesleep>
    acquire(&itable.lock);
    80002e36:	00015517          	auipc	a0,0x15
    80002e3a:	94250513          	addi	a0,a0,-1726 # 80017778 <itable>
    80002e3e:	00003097          	auipc	ra,0x3
    80002e42:	35a080e7          	jalr	858(ra) # 80006198 <acquire>
    80002e46:	b741                	j	80002dc6 <iput+0x26>

0000000080002e48 <iunlockput>:
{
    80002e48:	1101                	addi	sp,sp,-32
    80002e4a:	ec06                	sd	ra,24(sp)
    80002e4c:	e822                	sd	s0,16(sp)
    80002e4e:	e426                	sd	s1,8(sp)
    80002e50:	1000                	addi	s0,sp,32
    80002e52:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e54:	00000097          	auipc	ra,0x0
    80002e58:	e54080e7          	jalr	-428(ra) # 80002ca8 <iunlock>
  iput(ip);
    80002e5c:	8526                	mv	a0,s1
    80002e5e:	00000097          	auipc	ra,0x0
    80002e62:	f42080e7          	jalr	-190(ra) # 80002da0 <iput>
}
    80002e66:	60e2                	ld	ra,24(sp)
    80002e68:	6442                	ld	s0,16(sp)
    80002e6a:	64a2                	ld	s1,8(sp)
    80002e6c:	6105                	addi	sp,sp,32
    80002e6e:	8082                	ret

0000000080002e70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e70:	1141                	addi	sp,sp,-16
    80002e72:	e422                	sd	s0,8(sp)
    80002e74:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e76:	411c                	lw	a5,0(a0)
    80002e78:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e7a:	415c                	lw	a5,4(a0)
    80002e7c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e7e:	04451783          	lh	a5,68(a0)
    80002e82:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e86:	04a51783          	lh	a5,74(a0)
    80002e8a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e8e:	04c56783          	lwu	a5,76(a0)
    80002e92:	e99c                	sd	a5,16(a1)
}
    80002e94:	6422                	ld	s0,8(sp)
    80002e96:	0141                	addi	sp,sp,16
    80002e98:	8082                	ret

0000000080002e9a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e9a:	457c                	lw	a5,76(a0)
    80002e9c:	0ed7e963          	bltu	a5,a3,80002f8e <readi+0xf4>
{
    80002ea0:	7159                	addi	sp,sp,-112
    80002ea2:	f486                	sd	ra,104(sp)
    80002ea4:	f0a2                	sd	s0,96(sp)
    80002ea6:	eca6                	sd	s1,88(sp)
    80002ea8:	e8ca                	sd	s2,80(sp)
    80002eaa:	e4ce                	sd	s3,72(sp)
    80002eac:	e0d2                	sd	s4,64(sp)
    80002eae:	fc56                	sd	s5,56(sp)
    80002eb0:	f85a                	sd	s6,48(sp)
    80002eb2:	f45e                	sd	s7,40(sp)
    80002eb4:	f062                	sd	s8,32(sp)
    80002eb6:	ec66                	sd	s9,24(sp)
    80002eb8:	e86a                	sd	s10,16(sp)
    80002eba:	e46e                	sd	s11,8(sp)
    80002ebc:	1880                	addi	s0,sp,112
    80002ebe:	8baa                	mv	s7,a0
    80002ec0:	8c2e                	mv	s8,a1
    80002ec2:	8ab2                	mv	s5,a2
    80002ec4:	84b6                	mv	s1,a3
    80002ec6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ec8:	9f35                	addw	a4,a4,a3
    return 0;
    80002eca:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ecc:	0ad76063          	bltu	a4,a3,80002f6c <readi+0xd2>
  if(off + n > ip->size)
    80002ed0:	00e7f463          	bgeu	a5,a4,80002ed8 <readi+0x3e>
    n = ip->size - off;
    80002ed4:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ed8:	0a0b0963          	beqz	s6,80002f8a <readi+0xf0>
    80002edc:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ede:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ee2:	5cfd                	li	s9,-1
    80002ee4:	a82d                	j	80002f1e <readi+0x84>
    80002ee6:	020a1d93          	slli	s11,s4,0x20
    80002eea:	020ddd93          	srli	s11,s11,0x20
    80002eee:	05890613          	addi	a2,s2,88
    80002ef2:	86ee                	mv	a3,s11
    80002ef4:	963a                	add	a2,a2,a4
    80002ef6:	85d6                	mv	a1,s5
    80002ef8:	8562                	mv	a0,s8
    80002efa:	fffff097          	auipc	ra,0xfffff
    80002efe:	a04080e7          	jalr	-1532(ra) # 800018fe <either_copyout>
    80002f02:	05950d63          	beq	a0,s9,80002f5c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f06:	854a                	mv	a0,s2
    80002f08:	fffff097          	auipc	ra,0xfffff
    80002f0c:	60c080e7          	jalr	1548(ra) # 80002514 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f10:	013a09bb          	addw	s3,s4,s3
    80002f14:	009a04bb          	addw	s1,s4,s1
    80002f18:	9aee                	add	s5,s5,s11
    80002f1a:	0569f763          	bgeu	s3,s6,80002f68 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f1e:	000ba903          	lw	s2,0(s7)
    80002f22:	00a4d59b          	srliw	a1,s1,0xa
    80002f26:	855e                	mv	a0,s7
    80002f28:	00000097          	auipc	ra,0x0
    80002f2c:	8ac080e7          	jalr	-1876(ra) # 800027d4 <bmap>
    80002f30:	0005059b          	sext.w	a1,a0
    80002f34:	854a                	mv	a0,s2
    80002f36:	fffff097          	auipc	ra,0xfffff
    80002f3a:	4ae080e7          	jalr	1198(ra) # 800023e4 <bread>
    80002f3e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f40:	3ff4f713          	andi	a4,s1,1023
    80002f44:	40ed07bb          	subw	a5,s10,a4
    80002f48:	413b06bb          	subw	a3,s6,s3
    80002f4c:	8a3e                	mv	s4,a5
    80002f4e:	2781                	sext.w	a5,a5
    80002f50:	0006861b          	sext.w	a2,a3
    80002f54:	f8f679e3          	bgeu	a2,a5,80002ee6 <readi+0x4c>
    80002f58:	8a36                	mv	s4,a3
    80002f5a:	b771                	j	80002ee6 <readi+0x4c>
      brelse(bp);
    80002f5c:	854a                	mv	a0,s2
    80002f5e:	fffff097          	auipc	ra,0xfffff
    80002f62:	5b6080e7          	jalr	1462(ra) # 80002514 <brelse>
      tot = -1;
    80002f66:	59fd                	li	s3,-1
  }
  return tot;
    80002f68:	0009851b          	sext.w	a0,s3
}
    80002f6c:	70a6                	ld	ra,104(sp)
    80002f6e:	7406                	ld	s0,96(sp)
    80002f70:	64e6                	ld	s1,88(sp)
    80002f72:	6946                	ld	s2,80(sp)
    80002f74:	69a6                	ld	s3,72(sp)
    80002f76:	6a06                	ld	s4,64(sp)
    80002f78:	7ae2                	ld	s5,56(sp)
    80002f7a:	7b42                	ld	s6,48(sp)
    80002f7c:	7ba2                	ld	s7,40(sp)
    80002f7e:	7c02                	ld	s8,32(sp)
    80002f80:	6ce2                	ld	s9,24(sp)
    80002f82:	6d42                	ld	s10,16(sp)
    80002f84:	6da2                	ld	s11,8(sp)
    80002f86:	6165                	addi	sp,sp,112
    80002f88:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f8a:	89da                	mv	s3,s6
    80002f8c:	bff1                	j	80002f68 <readi+0xce>
    return 0;
    80002f8e:	4501                	li	a0,0
}
    80002f90:	8082                	ret

0000000080002f92 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f92:	457c                	lw	a5,76(a0)
    80002f94:	10d7e863          	bltu	a5,a3,800030a4 <writei+0x112>
{
    80002f98:	7159                	addi	sp,sp,-112
    80002f9a:	f486                	sd	ra,104(sp)
    80002f9c:	f0a2                	sd	s0,96(sp)
    80002f9e:	eca6                	sd	s1,88(sp)
    80002fa0:	e8ca                	sd	s2,80(sp)
    80002fa2:	e4ce                	sd	s3,72(sp)
    80002fa4:	e0d2                	sd	s4,64(sp)
    80002fa6:	fc56                	sd	s5,56(sp)
    80002fa8:	f85a                	sd	s6,48(sp)
    80002faa:	f45e                	sd	s7,40(sp)
    80002fac:	f062                	sd	s8,32(sp)
    80002fae:	ec66                	sd	s9,24(sp)
    80002fb0:	e86a                	sd	s10,16(sp)
    80002fb2:	e46e                	sd	s11,8(sp)
    80002fb4:	1880                	addi	s0,sp,112
    80002fb6:	8b2a                	mv	s6,a0
    80002fb8:	8c2e                	mv	s8,a1
    80002fba:	8ab2                	mv	s5,a2
    80002fbc:	8936                	mv	s2,a3
    80002fbe:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fc0:	00e687bb          	addw	a5,a3,a4
    80002fc4:	0ed7e263          	bltu	a5,a3,800030a8 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fc8:	00043737          	lui	a4,0x43
    80002fcc:	0ef76063          	bltu	a4,a5,800030ac <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fd0:	0c0b8863          	beqz	s7,800030a0 <writei+0x10e>
    80002fd4:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fd6:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fda:	5cfd                	li	s9,-1
    80002fdc:	a091                	j	80003020 <writei+0x8e>
    80002fde:	02099d93          	slli	s11,s3,0x20
    80002fe2:	020ddd93          	srli	s11,s11,0x20
    80002fe6:	05848513          	addi	a0,s1,88
    80002fea:	86ee                	mv	a3,s11
    80002fec:	8656                	mv	a2,s5
    80002fee:	85e2                	mv	a1,s8
    80002ff0:	953a                	add	a0,a0,a4
    80002ff2:	fffff097          	auipc	ra,0xfffff
    80002ff6:	962080e7          	jalr	-1694(ra) # 80001954 <either_copyin>
    80002ffa:	07950263          	beq	a0,s9,8000305e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ffe:	8526                	mv	a0,s1
    80003000:	00000097          	auipc	ra,0x0
    80003004:	798080e7          	jalr	1944(ra) # 80003798 <log_write>
    brelse(bp);
    80003008:	8526                	mv	a0,s1
    8000300a:	fffff097          	auipc	ra,0xfffff
    8000300e:	50a080e7          	jalr	1290(ra) # 80002514 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003012:	01498a3b          	addw	s4,s3,s4
    80003016:	0129893b          	addw	s2,s3,s2
    8000301a:	9aee                	add	s5,s5,s11
    8000301c:	057a7663          	bgeu	s4,s7,80003068 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003020:	000b2483          	lw	s1,0(s6)
    80003024:	00a9559b          	srliw	a1,s2,0xa
    80003028:	855a                	mv	a0,s6
    8000302a:	fffff097          	auipc	ra,0xfffff
    8000302e:	7aa080e7          	jalr	1962(ra) # 800027d4 <bmap>
    80003032:	0005059b          	sext.w	a1,a0
    80003036:	8526                	mv	a0,s1
    80003038:	fffff097          	auipc	ra,0xfffff
    8000303c:	3ac080e7          	jalr	940(ra) # 800023e4 <bread>
    80003040:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003042:	3ff97713          	andi	a4,s2,1023
    80003046:	40ed07bb          	subw	a5,s10,a4
    8000304a:	414b86bb          	subw	a3,s7,s4
    8000304e:	89be                	mv	s3,a5
    80003050:	2781                	sext.w	a5,a5
    80003052:	0006861b          	sext.w	a2,a3
    80003056:	f8f674e3          	bgeu	a2,a5,80002fde <writei+0x4c>
    8000305a:	89b6                	mv	s3,a3
    8000305c:	b749                	j	80002fde <writei+0x4c>
      brelse(bp);
    8000305e:	8526                	mv	a0,s1
    80003060:	fffff097          	auipc	ra,0xfffff
    80003064:	4b4080e7          	jalr	1204(ra) # 80002514 <brelse>
  }

  if(off > ip->size)
    80003068:	04cb2783          	lw	a5,76(s6)
    8000306c:	0127f463          	bgeu	a5,s2,80003074 <writei+0xe2>
    ip->size = off;
    80003070:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003074:	855a                	mv	a0,s6
    80003076:	00000097          	auipc	ra,0x0
    8000307a:	aa4080e7          	jalr	-1372(ra) # 80002b1a <iupdate>

  return tot;
    8000307e:	000a051b          	sext.w	a0,s4
}
    80003082:	70a6                	ld	ra,104(sp)
    80003084:	7406                	ld	s0,96(sp)
    80003086:	64e6                	ld	s1,88(sp)
    80003088:	6946                	ld	s2,80(sp)
    8000308a:	69a6                	ld	s3,72(sp)
    8000308c:	6a06                	ld	s4,64(sp)
    8000308e:	7ae2                	ld	s5,56(sp)
    80003090:	7b42                	ld	s6,48(sp)
    80003092:	7ba2                	ld	s7,40(sp)
    80003094:	7c02                	ld	s8,32(sp)
    80003096:	6ce2                	ld	s9,24(sp)
    80003098:	6d42                	ld	s10,16(sp)
    8000309a:	6da2                	ld	s11,8(sp)
    8000309c:	6165                	addi	sp,sp,112
    8000309e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030a0:	8a5e                	mv	s4,s7
    800030a2:	bfc9                	j	80003074 <writei+0xe2>
    return -1;
    800030a4:	557d                	li	a0,-1
}
    800030a6:	8082                	ret
    return -1;
    800030a8:	557d                	li	a0,-1
    800030aa:	bfe1                	j	80003082 <writei+0xf0>
    return -1;
    800030ac:	557d                	li	a0,-1
    800030ae:	bfd1                	j	80003082 <writei+0xf0>

00000000800030b0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030b0:	1141                	addi	sp,sp,-16
    800030b2:	e406                	sd	ra,8(sp)
    800030b4:	e022                	sd	s0,0(sp)
    800030b6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030b8:	4639                	li	a2,14
    800030ba:	ffffd097          	auipc	ra,0xffffd
    800030be:	1da080e7          	jalr	474(ra) # 80000294 <strncmp>
}
    800030c2:	60a2                	ld	ra,8(sp)
    800030c4:	6402                	ld	s0,0(sp)
    800030c6:	0141                	addi	sp,sp,16
    800030c8:	8082                	ret

00000000800030ca <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030ca:	7139                	addi	sp,sp,-64
    800030cc:	fc06                	sd	ra,56(sp)
    800030ce:	f822                	sd	s0,48(sp)
    800030d0:	f426                	sd	s1,40(sp)
    800030d2:	f04a                	sd	s2,32(sp)
    800030d4:	ec4e                	sd	s3,24(sp)
    800030d6:	e852                	sd	s4,16(sp)
    800030d8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030da:	04451703          	lh	a4,68(a0)
    800030de:	4785                	li	a5,1
    800030e0:	00f71a63          	bne	a4,a5,800030f4 <dirlookup+0x2a>
    800030e4:	892a                	mv	s2,a0
    800030e6:	89ae                	mv	s3,a1
    800030e8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ea:	457c                	lw	a5,76(a0)
    800030ec:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030ee:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030f0:	e79d                	bnez	a5,8000311e <dirlookup+0x54>
    800030f2:	a8a5                	j	8000316a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030f4:	00005517          	auipc	a0,0x5
    800030f8:	54450513          	addi	a0,a0,1348 # 80008638 <syscalls+0x1b0>
    800030fc:	00003097          	auipc	ra,0x3
    80003100:	b64080e7          	jalr	-1180(ra) # 80005c60 <panic>
      panic("dirlookup read");
    80003104:	00005517          	auipc	a0,0x5
    80003108:	54c50513          	addi	a0,a0,1356 # 80008650 <syscalls+0x1c8>
    8000310c:	00003097          	auipc	ra,0x3
    80003110:	b54080e7          	jalr	-1196(ra) # 80005c60 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003114:	24c1                	addiw	s1,s1,16
    80003116:	04c92783          	lw	a5,76(s2)
    8000311a:	04f4f763          	bgeu	s1,a5,80003168 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000311e:	4741                	li	a4,16
    80003120:	86a6                	mv	a3,s1
    80003122:	fc040613          	addi	a2,s0,-64
    80003126:	4581                	li	a1,0
    80003128:	854a                	mv	a0,s2
    8000312a:	00000097          	auipc	ra,0x0
    8000312e:	d70080e7          	jalr	-656(ra) # 80002e9a <readi>
    80003132:	47c1                	li	a5,16
    80003134:	fcf518e3          	bne	a0,a5,80003104 <dirlookup+0x3a>
    if(de.inum == 0)
    80003138:	fc045783          	lhu	a5,-64(s0)
    8000313c:	dfe1                	beqz	a5,80003114 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000313e:	fc240593          	addi	a1,s0,-62
    80003142:	854e                	mv	a0,s3
    80003144:	00000097          	auipc	ra,0x0
    80003148:	f6c080e7          	jalr	-148(ra) # 800030b0 <namecmp>
    8000314c:	f561                	bnez	a0,80003114 <dirlookup+0x4a>
      if(poff)
    8000314e:	000a0463          	beqz	s4,80003156 <dirlookup+0x8c>
        *poff = off;
    80003152:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003156:	fc045583          	lhu	a1,-64(s0)
    8000315a:	00092503          	lw	a0,0(s2)
    8000315e:	fffff097          	auipc	ra,0xfffff
    80003162:	752080e7          	jalr	1874(ra) # 800028b0 <iget>
    80003166:	a011                	j	8000316a <dirlookup+0xa0>
  return 0;
    80003168:	4501                	li	a0,0
}
    8000316a:	70e2                	ld	ra,56(sp)
    8000316c:	7442                	ld	s0,48(sp)
    8000316e:	74a2                	ld	s1,40(sp)
    80003170:	7902                	ld	s2,32(sp)
    80003172:	69e2                	ld	s3,24(sp)
    80003174:	6a42                	ld	s4,16(sp)
    80003176:	6121                	addi	sp,sp,64
    80003178:	8082                	ret

000000008000317a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000317a:	711d                	addi	sp,sp,-96
    8000317c:	ec86                	sd	ra,88(sp)
    8000317e:	e8a2                	sd	s0,80(sp)
    80003180:	e4a6                	sd	s1,72(sp)
    80003182:	e0ca                	sd	s2,64(sp)
    80003184:	fc4e                	sd	s3,56(sp)
    80003186:	f852                	sd	s4,48(sp)
    80003188:	f456                	sd	s5,40(sp)
    8000318a:	f05a                	sd	s6,32(sp)
    8000318c:	ec5e                	sd	s7,24(sp)
    8000318e:	e862                	sd	s8,16(sp)
    80003190:	e466                	sd	s9,8(sp)
    80003192:	e06a                	sd	s10,0(sp)
    80003194:	1080                	addi	s0,sp,96
    80003196:	84aa                	mv	s1,a0
    80003198:	8b2e                	mv	s6,a1
    8000319a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000319c:	00054703          	lbu	a4,0(a0)
    800031a0:	02f00793          	li	a5,47
    800031a4:	02f70363          	beq	a4,a5,800031ca <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031a8:	ffffe097          	auipc	ra,0xffffe
    800031ac:	ce6080e7          	jalr	-794(ra) # 80000e8e <myproc>
    800031b0:	15053503          	ld	a0,336(a0)
    800031b4:	00000097          	auipc	ra,0x0
    800031b8:	9f4080e7          	jalr	-1548(ra) # 80002ba8 <idup>
    800031bc:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031be:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031c2:	4cb5                	li	s9,13
  len = path - s;
    800031c4:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031c6:	4c05                	li	s8,1
    800031c8:	a87d                	j	80003286 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800031ca:	4585                	li	a1,1
    800031cc:	4505                	li	a0,1
    800031ce:	fffff097          	auipc	ra,0xfffff
    800031d2:	6e2080e7          	jalr	1762(ra) # 800028b0 <iget>
    800031d6:	8a2a                	mv	s4,a0
    800031d8:	b7dd                	j	800031be <namex+0x44>
      iunlockput(ip);
    800031da:	8552                	mv	a0,s4
    800031dc:	00000097          	auipc	ra,0x0
    800031e0:	c6c080e7          	jalr	-916(ra) # 80002e48 <iunlockput>
      return 0;
    800031e4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031e6:	8552                	mv	a0,s4
    800031e8:	60e6                	ld	ra,88(sp)
    800031ea:	6446                	ld	s0,80(sp)
    800031ec:	64a6                	ld	s1,72(sp)
    800031ee:	6906                	ld	s2,64(sp)
    800031f0:	79e2                	ld	s3,56(sp)
    800031f2:	7a42                	ld	s4,48(sp)
    800031f4:	7aa2                	ld	s5,40(sp)
    800031f6:	7b02                	ld	s6,32(sp)
    800031f8:	6be2                	ld	s7,24(sp)
    800031fa:	6c42                	ld	s8,16(sp)
    800031fc:	6ca2                	ld	s9,8(sp)
    800031fe:	6d02                	ld	s10,0(sp)
    80003200:	6125                	addi	sp,sp,96
    80003202:	8082                	ret
      iunlock(ip);
    80003204:	8552                	mv	a0,s4
    80003206:	00000097          	auipc	ra,0x0
    8000320a:	aa2080e7          	jalr	-1374(ra) # 80002ca8 <iunlock>
      return ip;
    8000320e:	bfe1                	j	800031e6 <namex+0x6c>
      iunlockput(ip);
    80003210:	8552                	mv	a0,s4
    80003212:	00000097          	auipc	ra,0x0
    80003216:	c36080e7          	jalr	-970(ra) # 80002e48 <iunlockput>
      return 0;
    8000321a:	8a4e                	mv	s4,s3
    8000321c:	b7e9                	j	800031e6 <namex+0x6c>
  len = path - s;
    8000321e:	40998633          	sub	a2,s3,s1
    80003222:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003226:	09acd863          	bge	s9,s10,800032b6 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000322a:	4639                	li	a2,14
    8000322c:	85a6                	mv	a1,s1
    8000322e:	8556                	mv	a0,s5
    80003230:	ffffd097          	auipc	ra,0xffffd
    80003234:	ff0080e7          	jalr	-16(ra) # 80000220 <memmove>
    80003238:	84ce                	mv	s1,s3
  while(*path == '/')
    8000323a:	0004c783          	lbu	a5,0(s1)
    8000323e:	01279763          	bne	a5,s2,8000324c <namex+0xd2>
    path++;
    80003242:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003244:	0004c783          	lbu	a5,0(s1)
    80003248:	ff278de3          	beq	a5,s2,80003242 <namex+0xc8>
    ilock(ip);
    8000324c:	8552                	mv	a0,s4
    8000324e:	00000097          	auipc	ra,0x0
    80003252:	998080e7          	jalr	-1640(ra) # 80002be6 <ilock>
    if(ip->type != T_DIR){
    80003256:	044a1783          	lh	a5,68(s4)
    8000325a:	f98790e3          	bne	a5,s8,800031da <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000325e:	000b0563          	beqz	s6,80003268 <namex+0xee>
    80003262:	0004c783          	lbu	a5,0(s1)
    80003266:	dfd9                	beqz	a5,80003204 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003268:	865e                	mv	a2,s7
    8000326a:	85d6                	mv	a1,s5
    8000326c:	8552                	mv	a0,s4
    8000326e:	00000097          	auipc	ra,0x0
    80003272:	e5c080e7          	jalr	-420(ra) # 800030ca <dirlookup>
    80003276:	89aa                	mv	s3,a0
    80003278:	dd41                	beqz	a0,80003210 <namex+0x96>
    iunlockput(ip);
    8000327a:	8552                	mv	a0,s4
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	bcc080e7          	jalr	-1076(ra) # 80002e48 <iunlockput>
    ip = next;
    80003284:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003286:	0004c783          	lbu	a5,0(s1)
    8000328a:	01279763          	bne	a5,s2,80003298 <namex+0x11e>
    path++;
    8000328e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003290:	0004c783          	lbu	a5,0(s1)
    80003294:	ff278de3          	beq	a5,s2,8000328e <namex+0x114>
  if(*path == 0)
    80003298:	cb9d                	beqz	a5,800032ce <namex+0x154>
  while(*path != '/' && *path != 0)
    8000329a:	0004c783          	lbu	a5,0(s1)
    8000329e:	89a6                	mv	s3,s1
  len = path - s;
    800032a0:	8d5e                	mv	s10,s7
    800032a2:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032a4:	01278963          	beq	a5,s2,800032b6 <namex+0x13c>
    800032a8:	dbbd                	beqz	a5,8000321e <namex+0xa4>
    path++;
    800032aa:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032ac:	0009c783          	lbu	a5,0(s3)
    800032b0:	ff279ce3          	bne	a5,s2,800032a8 <namex+0x12e>
    800032b4:	b7ad                	j	8000321e <namex+0xa4>
    memmove(name, s, len);
    800032b6:	2601                	sext.w	a2,a2
    800032b8:	85a6                	mv	a1,s1
    800032ba:	8556                	mv	a0,s5
    800032bc:	ffffd097          	auipc	ra,0xffffd
    800032c0:	f64080e7          	jalr	-156(ra) # 80000220 <memmove>
    name[len] = 0;
    800032c4:	9d56                	add	s10,s10,s5
    800032c6:	000d0023          	sb	zero,0(s10)
    800032ca:	84ce                	mv	s1,s3
    800032cc:	b7bd                	j	8000323a <namex+0xc0>
  if(nameiparent){
    800032ce:	f00b0ce3          	beqz	s6,800031e6 <namex+0x6c>
    iput(ip);
    800032d2:	8552                	mv	a0,s4
    800032d4:	00000097          	auipc	ra,0x0
    800032d8:	acc080e7          	jalr	-1332(ra) # 80002da0 <iput>
    return 0;
    800032dc:	4a01                	li	s4,0
    800032de:	b721                	j	800031e6 <namex+0x6c>

00000000800032e0 <dirlink>:
{
    800032e0:	7139                	addi	sp,sp,-64
    800032e2:	fc06                	sd	ra,56(sp)
    800032e4:	f822                	sd	s0,48(sp)
    800032e6:	f426                	sd	s1,40(sp)
    800032e8:	f04a                	sd	s2,32(sp)
    800032ea:	ec4e                	sd	s3,24(sp)
    800032ec:	e852                	sd	s4,16(sp)
    800032ee:	0080                	addi	s0,sp,64
    800032f0:	892a                	mv	s2,a0
    800032f2:	8a2e                	mv	s4,a1
    800032f4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032f6:	4601                	li	a2,0
    800032f8:	00000097          	auipc	ra,0x0
    800032fc:	dd2080e7          	jalr	-558(ra) # 800030ca <dirlookup>
    80003300:	e93d                	bnez	a0,80003376 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003302:	04c92483          	lw	s1,76(s2)
    80003306:	c49d                	beqz	s1,80003334 <dirlink+0x54>
    80003308:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000330a:	4741                	li	a4,16
    8000330c:	86a6                	mv	a3,s1
    8000330e:	fc040613          	addi	a2,s0,-64
    80003312:	4581                	li	a1,0
    80003314:	854a                	mv	a0,s2
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	b84080e7          	jalr	-1148(ra) # 80002e9a <readi>
    8000331e:	47c1                	li	a5,16
    80003320:	06f51163          	bne	a0,a5,80003382 <dirlink+0xa2>
    if(de.inum == 0)
    80003324:	fc045783          	lhu	a5,-64(s0)
    80003328:	c791                	beqz	a5,80003334 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000332a:	24c1                	addiw	s1,s1,16
    8000332c:	04c92783          	lw	a5,76(s2)
    80003330:	fcf4ede3          	bltu	s1,a5,8000330a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003334:	4639                	li	a2,14
    80003336:	85d2                	mv	a1,s4
    80003338:	fc240513          	addi	a0,s0,-62
    8000333c:	ffffd097          	auipc	ra,0xffffd
    80003340:	f94080e7          	jalr	-108(ra) # 800002d0 <strncpy>
  de.inum = inum;
    80003344:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003348:	4741                	li	a4,16
    8000334a:	86a6                	mv	a3,s1
    8000334c:	fc040613          	addi	a2,s0,-64
    80003350:	4581                	li	a1,0
    80003352:	854a                	mv	a0,s2
    80003354:	00000097          	auipc	ra,0x0
    80003358:	c3e080e7          	jalr	-962(ra) # 80002f92 <writei>
    8000335c:	872a                	mv	a4,a0
    8000335e:	47c1                	li	a5,16
  return 0;
    80003360:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003362:	02f71863          	bne	a4,a5,80003392 <dirlink+0xb2>
}
    80003366:	70e2                	ld	ra,56(sp)
    80003368:	7442                	ld	s0,48(sp)
    8000336a:	74a2                	ld	s1,40(sp)
    8000336c:	7902                	ld	s2,32(sp)
    8000336e:	69e2                	ld	s3,24(sp)
    80003370:	6a42                	ld	s4,16(sp)
    80003372:	6121                	addi	sp,sp,64
    80003374:	8082                	ret
    iput(ip);
    80003376:	00000097          	auipc	ra,0x0
    8000337a:	a2a080e7          	jalr	-1494(ra) # 80002da0 <iput>
    return -1;
    8000337e:	557d                	li	a0,-1
    80003380:	b7dd                	j	80003366 <dirlink+0x86>
      panic("dirlink read");
    80003382:	00005517          	auipc	a0,0x5
    80003386:	2de50513          	addi	a0,a0,734 # 80008660 <syscalls+0x1d8>
    8000338a:	00003097          	auipc	ra,0x3
    8000338e:	8d6080e7          	jalr	-1834(ra) # 80005c60 <panic>
    panic("dirlink");
    80003392:	00005517          	auipc	a0,0x5
    80003396:	3d650513          	addi	a0,a0,982 # 80008768 <syscalls+0x2e0>
    8000339a:	00003097          	auipc	ra,0x3
    8000339e:	8c6080e7          	jalr	-1850(ra) # 80005c60 <panic>

00000000800033a2 <namei>:

struct inode*
namei(char *path)
{
    800033a2:	1101                	addi	sp,sp,-32
    800033a4:	ec06                	sd	ra,24(sp)
    800033a6:	e822                	sd	s0,16(sp)
    800033a8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033aa:	fe040613          	addi	a2,s0,-32
    800033ae:	4581                	li	a1,0
    800033b0:	00000097          	auipc	ra,0x0
    800033b4:	dca080e7          	jalr	-566(ra) # 8000317a <namex>
}
    800033b8:	60e2                	ld	ra,24(sp)
    800033ba:	6442                	ld	s0,16(sp)
    800033bc:	6105                	addi	sp,sp,32
    800033be:	8082                	ret

00000000800033c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033c0:	1141                	addi	sp,sp,-16
    800033c2:	e406                	sd	ra,8(sp)
    800033c4:	e022                	sd	s0,0(sp)
    800033c6:	0800                	addi	s0,sp,16
    800033c8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033ca:	4585                	li	a1,1
    800033cc:	00000097          	auipc	ra,0x0
    800033d0:	dae080e7          	jalr	-594(ra) # 8000317a <namex>
}
    800033d4:	60a2                	ld	ra,8(sp)
    800033d6:	6402                	ld	s0,0(sp)
    800033d8:	0141                	addi	sp,sp,16
    800033da:	8082                	ret

00000000800033dc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033dc:	1101                	addi	sp,sp,-32
    800033de:	ec06                	sd	ra,24(sp)
    800033e0:	e822                	sd	s0,16(sp)
    800033e2:	e426                	sd	s1,8(sp)
    800033e4:	e04a                	sd	s2,0(sp)
    800033e6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033e8:	00016917          	auipc	s2,0x16
    800033ec:	e3890913          	addi	s2,s2,-456 # 80019220 <log>
    800033f0:	01892583          	lw	a1,24(s2)
    800033f4:	02892503          	lw	a0,40(s2)
    800033f8:	fffff097          	auipc	ra,0xfffff
    800033fc:	fec080e7          	jalr	-20(ra) # 800023e4 <bread>
    80003400:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003402:	02c92683          	lw	a3,44(s2)
    80003406:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003408:	02d05863          	blez	a3,80003438 <write_head+0x5c>
    8000340c:	00016797          	auipc	a5,0x16
    80003410:	e4478793          	addi	a5,a5,-444 # 80019250 <log+0x30>
    80003414:	05c50713          	addi	a4,a0,92
    80003418:	36fd                	addiw	a3,a3,-1
    8000341a:	02069613          	slli	a2,a3,0x20
    8000341e:	01e65693          	srli	a3,a2,0x1e
    80003422:	00016617          	auipc	a2,0x16
    80003426:	e3260613          	addi	a2,a2,-462 # 80019254 <log+0x34>
    8000342a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000342c:	4390                	lw	a2,0(a5)
    8000342e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003430:	0791                	addi	a5,a5,4
    80003432:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003434:	fed79ce3          	bne	a5,a3,8000342c <write_head+0x50>
  }
  bwrite(buf);
    80003438:	8526                	mv	a0,s1
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	09c080e7          	jalr	156(ra) # 800024d6 <bwrite>
  brelse(buf);
    80003442:	8526                	mv	a0,s1
    80003444:	fffff097          	auipc	ra,0xfffff
    80003448:	0d0080e7          	jalr	208(ra) # 80002514 <brelse>
}
    8000344c:	60e2                	ld	ra,24(sp)
    8000344e:	6442                	ld	s0,16(sp)
    80003450:	64a2                	ld	s1,8(sp)
    80003452:	6902                	ld	s2,0(sp)
    80003454:	6105                	addi	sp,sp,32
    80003456:	8082                	ret

0000000080003458 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003458:	00016797          	auipc	a5,0x16
    8000345c:	df47a783          	lw	a5,-524(a5) # 8001924c <log+0x2c>
    80003460:	0af05d63          	blez	a5,8000351a <install_trans+0xc2>
{
    80003464:	7139                	addi	sp,sp,-64
    80003466:	fc06                	sd	ra,56(sp)
    80003468:	f822                	sd	s0,48(sp)
    8000346a:	f426                	sd	s1,40(sp)
    8000346c:	f04a                	sd	s2,32(sp)
    8000346e:	ec4e                	sd	s3,24(sp)
    80003470:	e852                	sd	s4,16(sp)
    80003472:	e456                	sd	s5,8(sp)
    80003474:	e05a                	sd	s6,0(sp)
    80003476:	0080                	addi	s0,sp,64
    80003478:	8b2a                	mv	s6,a0
    8000347a:	00016a97          	auipc	s5,0x16
    8000347e:	dd6a8a93          	addi	s5,s5,-554 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003482:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003484:	00016997          	auipc	s3,0x16
    80003488:	d9c98993          	addi	s3,s3,-612 # 80019220 <log>
    8000348c:	a00d                	j	800034ae <install_trans+0x56>
    brelse(lbuf);
    8000348e:	854a                	mv	a0,s2
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	084080e7          	jalr	132(ra) # 80002514 <brelse>
    brelse(dbuf);
    80003498:	8526                	mv	a0,s1
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	07a080e7          	jalr	122(ra) # 80002514 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a2:	2a05                	addiw	s4,s4,1
    800034a4:	0a91                	addi	s5,s5,4
    800034a6:	02c9a783          	lw	a5,44(s3)
    800034aa:	04fa5e63          	bge	s4,a5,80003506 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ae:	0189a583          	lw	a1,24(s3)
    800034b2:	014585bb          	addw	a1,a1,s4
    800034b6:	2585                	addiw	a1,a1,1
    800034b8:	0289a503          	lw	a0,40(s3)
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	f28080e7          	jalr	-216(ra) # 800023e4 <bread>
    800034c4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034c6:	000aa583          	lw	a1,0(s5)
    800034ca:	0289a503          	lw	a0,40(s3)
    800034ce:	fffff097          	auipc	ra,0xfffff
    800034d2:	f16080e7          	jalr	-234(ra) # 800023e4 <bread>
    800034d6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034d8:	40000613          	li	a2,1024
    800034dc:	05890593          	addi	a1,s2,88
    800034e0:	05850513          	addi	a0,a0,88
    800034e4:	ffffd097          	auipc	ra,0xffffd
    800034e8:	d3c080e7          	jalr	-708(ra) # 80000220 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034ec:	8526                	mv	a0,s1
    800034ee:	fffff097          	auipc	ra,0xfffff
    800034f2:	fe8080e7          	jalr	-24(ra) # 800024d6 <bwrite>
    if(recovering == 0)
    800034f6:	f80b1ce3          	bnez	s6,8000348e <install_trans+0x36>
      bunpin(dbuf);
    800034fa:	8526                	mv	a0,s1
    800034fc:	fffff097          	auipc	ra,0xfffff
    80003500:	0f2080e7          	jalr	242(ra) # 800025ee <bunpin>
    80003504:	b769                	j	8000348e <install_trans+0x36>
}
    80003506:	70e2                	ld	ra,56(sp)
    80003508:	7442                	ld	s0,48(sp)
    8000350a:	74a2                	ld	s1,40(sp)
    8000350c:	7902                	ld	s2,32(sp)
    8000350e:	69e2                	ld	s3,24(sp)
    80003510:	6a42                	ld	s4,16(sp)
    80003512:	6aa2                	ld	s5,8(sp)
    80003514:	6b02                	ld	s6,0(sp)
    80003516:	6121                	addi	sp,sp,64
    80003518:	8082                	ret
    8000351a:	8082                	ret

000000008000351c <initlog>:
{
    8000351c:	7179                	addi	sp,sp,-48
    8000351e:	f406                	sd	ra,40(sp)
    80003520:	f022                	sd	s0,32(sp)
    80003522:	ec26                	sd	s1,24(sp)
    80003524:	e84a                	sd	s2,16(sp)
    80003526:	e44e                	sd	s3,8(sp)
    80003528:	1800                	addi	s0,sp,48
    8000352a:	892a                	mv	s2,a0
    8000352c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000352e:	00016497          	auipc	s1,0x16
    80003532:	cf248493          	addi	s1,s1,-782 # 80019220 <log>
    80003536:	00005597          	auipc	a1,0x5
    8000353a:	13a58593          	addi	a1,a1,314 # 80008670 <syscalls+0x1e8>
    8000353e:	8526                	mv	a0,s1
    80003540:	00003097          	auipc	ra,0x3
    80003544:	bc8080e7          	jalr	-1080(ra) # 80006108 <initlock>
  log.start = sb->logstart;
    80003548:	0149a583          	lw	a1,20(s3)
    8000354c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000354e:	0109a783          	lw	a5,16(s3)
    80003552:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003554:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003558:	854a                	mv	a0,s2
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	e8a080e7          	jalr	-374(ra) # 800023e4 <bread>
  log.lh.n = lh->n;
    80003562:	4d34                	lw	a3,88(a0)
    80003564:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003566:	02d05663          	blez	a3,80003592 <initlog+0x76>
    8000356a:	05c50793          	addi	a5,a0,92
    8000356e:	00016717          	auipc	a4,0x16
    80003572:	ce270713          	addi	a4,a4,-798 # 80019250 <log+0x30>
    80003576:	36fd                	addiw	a3,a3,-1
    80003578:	02069613          	slli	a2,a3,0x20
    8000357c:	01e65693          	srli	a3,a2,0x1e
    80003580:	06050613          	addi	a2,a0,96
    80003584:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003586:	4390                	lw	a2,0(a5)
    80003588:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000358a:	0791                	addi	a5,a5,4
    8000358c:	0711                	addi	a4,a4,4
    8000358e:	fed79ce3          	bne	a5,a3,80003586 <initlog+0x6a>
  brelse(buf);
    80003592:	fffff097          	auipc	ra,0xfffff
    80003596:	f82080e7          	jalr	-126(ra) # 80002514 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000359a:	4505                	li	a0,1
    8000359c:	00000097          	auipc	ra,0x0
    800035a0:	ebc080e7          	jalr	-324(ra) # 80003458 <install_trans>
  log.lh.n = 0;
    800035a4:	00016797          	auipc	a5,0x16
    800035a8:	ca07a423          	sw	zero,-856(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800035ac:	00000097          	auipc	ra,0x0
    800035b0:	e30080e7          	jalr	-464(ra) # 800033dc <write_head>
}
    800035b4:	70a2                	ld	ra,40(sp)
    800035b6:	7402                	ld	s0,32(sp)
    800035b8:	64e2                	ld	s1,24(sp)
    800035ba:	6942                	ld	s2,16(sp)
    800035bc:	69a2                	ld	s3,8(sp)
    800035be:	6145                	addi	sp,sp,48
    800035c0:	8082                	ret

00000000800035c2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035c2:	1101                	addi	sp,sp,-32
    800035c4:	ec06                	sd	ra,24(sp)
    800035c6:	e822                	sd	s0,16(sp)
    800035c8:	e426                	sd	s1,8(sp)
    800035ca:	e04a                	sd	s2,0(sp)
    800035cc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035ce:	00016517          	auipc	a0,0x16
    800035d2:	c5250513          	addi	a0,a0,-942 # 80019220 <log>
    800035d6:	00003097          	auipc	ra,0x3
    800035da:	bc2080e7          	jalr	-1086(ra) # 80006198 <acquire>
  while(1){
    if(log.committing){
    800035de:	00016497          	auipc	s1,0x16
    800035e2:	c4248493          	addi	s1,s1,-958 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035e6:	4979                	li	s2,30
    800035e8:	a039                	j	800035f6 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035ea:	85a6                	mv	a1,s1
    800035ec:	8526                	mv	a0,s1
    800035ee:	ffffe097          	auipc	ra,0xffffe
    800035f2:	f6c080e7          	jalr	-148(ra) # 8000155a <sleep>
    if(log.committing){
    800035f6:	50dc                	lw	a5,36(s1)
    800035f8:	fbed                	bnez	a5,800035ea <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035fa:	5098                	lw	a4,32(s1)
    800035fc:	2705                	addiw	a4,a4,1
    800035fe:	0007069b          	sext.w	a3,a4
    80003602:	0027179b          	slliw	a5,a4,0x2
    80003606:	9fb9                	addw	a5,a5,a4
    80003608:	0017979b          	slliw	a5,a5,0x1
    8000360c:	54d8                	lw	a4,44(s1)
    8000360e:	9fb9                	addw	a5,a5,a4
    80003610:	00f95963          	bge	s2,a5,80003622 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003614:	85a6                	mv	a1,s1
    80003616:	8526                	mv	a0,s1
    80003618:	ffffe097          	auipc	ra,0xffffe
    8000361c:	f42080e7          	jalr	-190(ra) # 8000155a <sleep>
    80003620:	bfd9                	j	800035f6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003622:	00016517          	auipc	a0,0x16
    80003626:	bfe50513          	addi	a0,a0,-1026 # 80019220 <log>
    8000362a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000362c:	00003097          	auipc	ra,0x3
    80003630:	c20080e7          	jalr	-992(ra) # 8000624c <release>
      break;
    }
  }
}
    80003634:	60e2                	ld	ra,24(sp)
    80003636:	6442                	ld	s0,16(sp)
    80003638:	64a2                	ld	s1,8(sp)
    8000363a:	6902                	ld	s2,0(sp)
    8000363c:	6105                	addi	sp,sp,32
    8000363e:	8082                	ret

0000000080003640 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003640:	7139                	addi	sp,sp,-64
    80003642:	fc06                	sd	ra,56(sp)
    80003644:	f822                	sd	s0,48(sp)
    80003646:	f426                	sd	s1,40(sp)
    80003648:	f04a                	sd	s2,32(sp)
    8000364a:	ec4e                	sd	s3,24(sp)
    8000364c:	e852                	sd	s4,16(sp)
    8000364e:	e456                	sd	s5,8(sp)
    80003650:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003652:	00016497          	auipc	s1,0x16
    80003656:	bce48493          	addi	s1,s1,-1074 # 80019220 <log>
    8000365a:	8526                	mv	a0,s1
    8000365c:	00003097          	auipc	ra,0x3
    80003660:	b3c080e7          	jalr	-1220(ra) # 80006198 <acquire>
  log.outstanding -= 1;
    80003664:	509c                	lw	a5,32(s1)
    80003666:	37fd                	addiw	a5,a5,-1
    80003668:	0007891b          	sext.w	s2,a5
    8000366c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000366e:	50dc                	lw	a5,36(s1)
    80003670:	e7b9                	bnez	a5,800036be <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003672:	04091e63          	bnez	s2,800036ce <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003676:	00016497          	auipc	s1,0x16
    8000367a:	baa48493          	addi	s1,s1,-1110 # 80019220 <log>
    8000367e:	4785                	li	a5,1
    80003680:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003682:	8526                	mv	a0,s1
    80003684:	00003097          	auipc	ra,0x3
    80003688:	bc8080e7          	jalr	-1080(ra) # 8000624c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000368c:	54dc                	lw	a5,44(s1)
    8000368e:	06f04763          	bgtz	a5,800036fc <end_op+0xbc>
    acquire(&log.lock);
    80003692:	00016497          	auipc	s1,0x16
    80003696:	b8e48493          	addi	s1,s1,-1138 # 80019220 <log>
    8000369a:	8526                	mv	a0,s1
    8000369c:	00003097          	auipc	ra,0x3
    800036a0:	afc080e7          	jalr	-1284(ra) # 80006198 <acquire>
    log.committing = 0;
    800036a4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036a8:	8526                	mv	a0,s1
    800036aa:	ffffe097          	auipc	ra,0xffffe
    800036ae:	03c080e7          	jalr	60(ra) # 800016e6 <wakeup>
    release(&log.lock);
    800036b2:	8526                	mv	a0,s1
    800036b4:	00003097          	auipc	ra,0x3
    800036b8:	b98080e7          	jalr	-1128(ra) # 8000624c <release>
}
    800036bc:	a03d                	j	800036ea <end_op+0xaa>
    panic("log.committing");
    800036be:	00005517          	auipc	a0,0x5
    800036c2:	fba50513          	addi	a0,a0,-70 # 80008678 <syscalls+0x1f0>
    800036c6:	00002097          	auipc	ra,0x2
    800036ca:	59a080e7          	jalr	1434(ra) # 80005c60 <panic>
    wakeup(&log);
    800036ce:	00016497          	auipc	s1,0x16
    800036d2:	b5248493          	addi	s1,s1,-1198 # 80019220 <log>
    800036d6:	8526                	mv	a0,s1
    800036d8:	ffffe097          	auipc	ra,0xffffe
    800036dc:	00e080e7          	jalr	14(ra) # 800016e6 <wakeup>
  release(&log.lock);
    800036e0:	8526                	mv	a0,s1
    800036e2:	00003097          	auipc	ra,0x3
    800036e6:	b6a080e7          	jalr	-1174(ra) # 8000624c <release>
}
    800036ea:	70e2                	ld	ra,56(sp)
    800036ec:	7442                	ld	s0,48(sp)
    800036ee:	74a2                	ld	s1,40(sp)
    800036f0:	7902                	ld	s2,32(sp)
    800036f2:	69e2                	ld	s3,24(sp)
    800036f4:	6a42                	ld	s4,16(sp)
    800036f6:	6aa2                	ld	s5,8(sp)
    800036f8:	6121                	addi	sp,sp,64
    800036fa:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036fc:	00016a97          	auipc	s5,0x16
    80003700:	b54a8a93          	addi	s5,s5,-1196 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003704:	00016a17          	auipc	s4,0x16
    80003708:	b1ca0a13          	addi	s4,s4,-1252 # 80019220 <log>
    8000370c:	018a2583          	lw	a1,24(s4)
    80003710:	012585bb          	addw	a1,a1,s2
    80003714:	2585                	addiw	a1,a1,1
    80003716:	028a2503          	lw	a0,40(s4)
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	cca080e7          	jalr	-822(ra) # 800023e4 <bread>
    80003722:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003724:	000aa583          	lw	a1,0(s5)
    80003728:	028a2503          	lw	a0,40(s4)
    8000372c:	fffff097          	auipc	ra,0xfffff
    80003730:	cb8080e7          	jalr	-840(ra) # 800023e4 <bread>
    80003734:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003736:	40000613          	li	a2,1024
    8000373a:	05850593          	addi	a1,a0,88
    8000373e:	05848513          	addi	a0,s1,88
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	ade080e7          	jalr	-1314(ra) # 80000220 <memmove>
    bwrite(to);  // write the log
    8000374a:	8526                	mv	a0,s1
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	d8a080e7          	jalr	-630(ra) # 800024d6 <bwrite>
    brelse(from);
    80003754:	854e                	mv	a0,s3
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	dbe080e7          	jalr	-578(ra) # 80002514 <brelse>
    brelse(to);
    8000375e:	8526                	mv	a0,s1
    80003760:	fffff097          	auipc	ra,0xfffff
    80003764:	db4080e7          	jalr	-588(ra) # 80002514 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003768:	2905                	addiw	s2,s2,1
    8000376a:	0a91                	addi	s5,s5,4
    8000376c:	02ca2783          	lw	a5,44(s4)
    80003770:	f8f94ee3          	blt	s2,a5,8000370c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003774:	00000097          	auipc	ra,0x0
    80003778:	c68080e7          	jalr	-920(ra) # 800033dc <write_head>
    install_trans(0); // Now install writes to home locations
    8000377c:	4501                	li	a0,0
    8000377e:	00000097          	auipc	ra,0x0
    80003782:	cda080e7          	jalr	-806(ra) # 80003458 <install_trans>
    log.lh.n = 0;
    80003786:	00016797          	auipc	a5,0x16
    8000378a:	ac07a323          	sw	zero,-1338(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000378e:	00000097          	auipc	ra,0x0
    80003792:	c4e080e7          	jalr	-946(ra) # 800033dc <write_head>
    80003796:	bdf5                	j	80003692 <end_op+0x52>

0000000080003798 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003798:	1101                	addi	sp,sp,-32
    8000379a:	ec06                	sd	ra,24(sp)
    8000379c:	e822                	sd	s0,16(sp)
    8000379e:	e426                	sd	s1,8(sp)
    800037a0:	e04a                	sd	s2,0(sp)
    800037a2:	1000                	addi	s0,sp,32
    800037a4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037a6:	00016917          	auipc	s2,0x16
    800037aa:	a7a90913          	addi	s2,s2,-1414 # 80019220 <log>
    800037ae:	854a                	mv	a0,s2
    800037b0:	00003097          	auipc	ra,0x3
    800037b4:	9e8080e7          	jalr	-1560(ra) # 80006198 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037b8:	02c92603          	lw	a2,44(s2)
    800037bc:	47f5                	li	a5,29
    800037be:	06c7c563          	blt	a5,a2,80003828 <log_write+0x90>
    800037c2:	00016797          	auipc	a5,0x16
    800037c6:	a7a7a783          	lw	a5,-1414(a5) # 8001923c <log+0x1c>
    800037ca:	37fd                	addiw	a5,a5,-1
    800037cc:	04f65e63          	bge	a2,a5,80003828 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037d0:	00016797          	auipc	a5,0x16
    800037d4:	a707a783          	lw	a5,-1424(a5) # 80019240 <log+0x20>
    800037d8:	06f05063          	blez	a5,80003838 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037dc:	4781                	li	a5,0
    800037de:	06c05563          	blez	a2,80003848 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e2:	44cc                	lw	a1,12(s1)
    800037e4:	00016717          	auipc	a4,0x16
    800037e8:	a6c70713          	addi	a4,a4,-1428 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037ec:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ee:	4314                	lw	a3,0(a4)
    800037f0:	04b68c63          	beq	a3,a1,80003848 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037f4:	2785                	addiw	a5,a5,1
    800037f6:	0711                	addi	a4,a4,4
    800037f8:	fef61be3          	bne	a2,a5,800037ee <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037fc:	0621                	addi	a2,a2,8
    800037fe:	060a                	slli	a2,a2,0x2
    80003800:	00016797          	auipc	a5,0x16
    80003804:	a2078793          	addi	a5,a5,-1504 # 80019220 <log>
    80003808:	97b2                	add	a5,a5,a2
    8000380a:	44d8                	lw	a4,12(s1)
    8000380c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000380e:	8526                	mv	a0,s1
    80003810:	fffff097          	auipc	ra,0xfffff
    80003814:	da2080e7          	jalr	-606(ra) # 800025b2 <bpin>
    log.lh.n++;
    80003818:	00016717          	auipc	a4,0x16
    8000381c:	a0870713          	addi	a4,a4,-1528 # 80019220 <log>
    80003820:	575c                	lw	a5,44(a4)
    80003822:	2785                	addiw	a5,a5,1
    80003824:	d75c                	sw	a5,44(a4)
    80003826:	a82d                	j	80003860 <log_write+0xc8>
    panic("too big a transaction");
    80003828:	00005517          	auipc	a0,0x5
    8000382c:	e6050513          	addi	a0,a0,-416 # 80008688 <syscalls+0x200>
    80003830:	00002097          	auipc	ra,0x2
    80003834:	430080e7          	jalr	1072(ra) # 80005c60 <panic>
    panic("log_write outside of trans");
    80003838:	00005517          	auipc	a0,0x5
    8000383c:	e6850513          	addi	a0,a0,-408 # 800086a0 <syscalls+0x218>
    80003840:	00002097          	auipc	ra,0x2
    80003844:	420080e7          	jalr	1056(ra) # 80005c60 <panic>
  log.lh.block[i] = b->blockno;
    80003848:	00878693          	addi	a3,a5,8
    8000384c:	068a                	slli	a3,a3,0x2
    8000384e:	00016717          	auipc	a4,0x16
    80003852:	9d270713          	addi	a4,a4,-1582 # 80019220 <log>
    80003856:	9736                	add	a4,a4,a3
    80003858:	44d4                	lw	a3,12(s1)
    8000385a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000385c:	faf609e3          	beq	a2,a5,8000380e <log_write+0x76>
  }
  release(&log.lock);
    80003860:	00016517          	auipc	a0,0x16
    80003864:	9c050513          	addi	a0,a0,-1600 # 80019220 <log>
    80003868:	00003097          	auipc	ra,0x3
    8000386c:	9e4080e7          	jalr	-1564(ra) # 8000624c <release>
}
    80003870:	60e2                	ld	ra,24(sp)
    80003872:	6442                	ld	s0,16(sp)
    80003874:	64a2                	ld	s1,8(sp)
    80003876:	6902                	ld	s2,0(sp)
    80003878:	6105                	addi	sp,sp,32
    8000387a:	8082                	ret

000000008000387c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000387c:	1101                	addi	sp,sp,-32
    8000387e:	ec06                	sd	ra,24(sp)
    80003880:	e822                	sd	s0,16(sp)
    80003882:	e426                	sd	s1,8(sp)
    80003884:	e04a                	sd	s2,0(sp)
    80003886:	1000                	addi	s0,sp,32
    80003888:	84aa                	mv	s1,a0
    8000388a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000388c:	00005597          	auipc	a1,0x5
    80003890:	e3458593          	addi	a1,a1,-460 # 800086c0 <syscalls+0x238>
    80003894:	0521                	addi	a0,a0,8
    80003896:	00003097          	auipc	ra,0x3
    8000389a:	872080e7          	jalr	-1934(ra) # 80006108 <initlock>
  lk->name = name;
    8000389e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038a2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038a6:	0204a423          	sw	zero,40(s1)
}
    800038aa:	60e2                	ld	ra,24(sp)
    800038ac:	6442                	ld	s0,16(sp)
    800038ae:	64a2                	ld	s1,8(sp)
    800038b0:	6902                	ld	s2,0(sp)
    800038b2:	6105                	addi	sp,sp,32
    800038b4:	8082                	ret

00000000800038b6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038b6:	1101                	addi	sp,sp,-32
    800038b8:	ec06                	sd	ra,24(sp)
    800038ba:	e822                	sd	s0,16(sp)
    800038bc:	e426                	sd	s1,8(sp)
    800038be:	e04a                	sd	s2,0(sp)
    800038c0:	1000                	addi	s0,sp,32
    800038c2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038c4:	00850913          	addi	s2,a0,8
    800038c8:	854a                	mv	a0,s2
    800038ca:	00003097          	auipc	ra,0x3
    800038ce:	8ce080e7          	jalr	-1842(ra) # 80006198 <acquire>
  while (lk->locked) {
    800038d2:	409c                	lw	a5,0(s1)
    800038d4:	cb89                	beqz	a5,800038e6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038d6:	85ca                	mv	a1,s2
    800038d8:	8526                	mv	a0,s1
    800038da:	ffffe097          	auipc	ra,0xffffe
    800038de:	c80080e7          	jalr	-896(ra) # 8000155a <sleep>
  while (lk->locked) {
    800038e2:	409c                	lw	a5,0(s1)
    800038e4:	fbed                	bnez	a5,800038d6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038e6:	4785                	li	a5,1
    800038e8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038ea:	ffffd097          	auipc	ra,0xffffd
    800038ee:	5a4080e7          	jalr	1444(ra) # 80000e8e <myproc>
    800038f2:	591c                	lw	a5,48(a0)
    800038f4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038f6:	854a                	mv	a0,s2
    800038f8:	00003097          	auipc	ra,0x3
    800038fc:	954080e7          	jalr	-1708(ra) # 8000624c <release>
}
    80003900:	60e2                	ld	ra,24(sp)
    80003902:	6442                	ld	s0,16(sp)
    80003904:	64a2                	ld	s1,8(sp)
    80003906:	6902                	ld	s2,0(sp)
    80003908:	6105                	addi	sp,sp,32
    8000390a:	8082                	ret

000000008000390c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000390c:	1101                	addi	sp,sp,-32
    8000390e:	ec06                	sd	ra,24(sp)
    80003910:	e822                	sd	s0,16(sp)
    80003912:	e426                	sd	s1,8(sp)
    80003914:	e04a                	sd	s2,0(sp)
    80003916:	1000                	addi	s0,sp,32
    80003918:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000391a:	00850913          	addi	s2,a0,8
    8000391e:	854a                	mv	a0,s2
    80003920:	00003097          	auipc	ra,0x3
    80003924:	878080e7          	jalr	-1928(ra) # 80006198 <acquire>
  lk->locked = 0;
    80003928:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000392c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003930:	8526                	mv	a0,s1
    80003932:	ffffe097          	auipc	ra,0xffffe
    80003936:	db4080e7          	jalr	-588(ra) # 800016e6 <wakeup>
  release(&lk->lk);
    8000393a:	854a                	mv	a0,s2
    8000393c:	00003097          	auipc	ra,0x3
    80003940:	910080e7          	jalr	-1776(ra) # 8000624c <release>
}
    80003944:	60e2                	ld	ra,24(sp)
    80003946:	6442                	ld	s0,16(sp)
    80003948:	64a2                	ld	s1,8(sp)
    8000394a:	6902                	ld	s2,0(sp)
    8000394c:	6105                	addi	sp,sp,32
    8000394e:	8082                	ret

0000000080003950 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003950:	7179                	addi	sp,sp,-48
    80003952:	f406                	sd	ra,40(sp)
    80003954:	f022                	sd	s0,32(sp)
    80003956:	ec26                	sd	s1,24(sp)
    80003958:	e84a                	sd	s2,16(sp)
    8000395a:	e44e                	sd	s3,8(sp)
    8000395c:	1800                	addi	s0,sp,48
    8000395e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003960:	00850913          	addi	s2,a0,8
    80003964:	854a                	mv	a0,s2
    80003966:	00003097          	auipc	ra,0x3
    8000396a:	832080e7          	jalr	-1998(ra) # 80006198 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000396e:	409c                	lw	a5,0(s1)
    80003970:	ef99                	bnez	a5,8000398e <holdingsleep+0x3e>
    80003972:	4481                	li	s1,0
  release(&lk->lk);
    80003974:	854a                	mv	a0,s2
    80003976:	00003097          	auipc	ra,0x3
    8000397a:	8d6080e7          	jalr	-1834(ra) # 8000624c <release>
  return r;
}
    8000397e:	8526                	mv	a0,s1
    80003980:	70a2                	ld	ra,40(sp)
    80003982:	7402                	ld	s0,32(sp)
    80003984:	64e2                	ld	s1,24(sp)
    80003986:	6942                	ld	s2,16(sp)
    80003988:	69a2                	ld	s3,8(sp)
    8000398a:	6145                	addi	sp,sp,48
    8000398c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000398e:	0284a983          	lw	s3,40(s1)
    80003992:	ffffd097          	auipc	ra,0xffffd
    80003996:	4fc080e7          	jalr	1276(ra) # 80000e8e <myproc>
    8000399a:	5904                	lw	s1,48(a0)
    8000399c:	413484b3          	sub	s1,s1,s3
    800039a0:	0014b493          	seqz	s1,s1
    800039a4:	bfc1                	j	80003974 <holdingsleep+0x24>

00000000800039a6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039a6:	1141                	addi	sp,sp,-16
    800039a8:	e406                	sd	ra,8(sp)
    800039aa:	e022                	sd	s0,0(sp)
    800039ac:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039ae:	00005597          	auipc	a1,0x5
    800039b2:	d2258593          	addi	a1,a1,-734 # 800086d0 <syscalls+0x248>
    800039b6:	00016517          	auipc	a0,0x16
    800039ba:	9b250513          	addi	a0,a0,-1614 # 80019368 <ftable>
    800039be:	00002097          	auipc	ra,0x2
    800039c2:	74a080e7          	jalr	1866(ra) # 80006108 <initlock>
}
    800039c6:	60a2                	ld	ra,8(sp)
    800039c8:	6402                	ld	s0,0(sp)
    800039ca:	0141                	addi	sp,sp,16
    800039cc:	8082                	ret

00000000800039ce <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039ce:	1101                	addi	sp,sp,-32
    800039d0:	ec06                	sd	ra,24(sp)
    800039d2:	e822                	sd	s0,16(sp)
    800039d4:	e426                	sd	s1,8(sp)
    800039d6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039d8:	00016517          	auipc	a0,0x16
    800039dc:	99050513          	addi	a0,a0,-1648 # 80019368 <ftable>
    800039e0:	00002097          	auipc	ra,0x2
    800039e4:	7b8080e7          	jalr	1976(ra) # 80006198 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039e8:	00016497          	auipc	s1,0x16
    800039ec:	99848493          	addi	s1,s1,-1640 # 80019380 <ftable+0x18>
    800039f0:	00017717          	auipc	a4,0x17
    800039f4:	93070713          	addi	a4,a4,-1744 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    800039f8:	40dc                	lw	a5,4(s1)
    800039fa:	cf99                	beqz	a5,80003a18 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039fc:	02848493          	addi	s1,s1,40
    80003a00:	fee49ce3          	bne	s1,a4,800039f8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a04:	00016517          	auipc	a0,0x16
    80003a08:	96450513          	addi	a0,a0,-1692 # 80019368 <ftable>
    80003a0c:	00003097          	auipc	ra,0x3
    80003a10:	840080e7          	jalr	-1984(ra) # 8000624c <release>
  return 0;
    80003a14:	4481                	li	s1,0
    80003a16:	a819                	j	80003a2c <filealloc+0x5e>
      f->ref = 1;
    80003a18:	4785                	li	a5,1
    80003a1a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a1c:	00016517          	auipc	a0,0x16
    80003a20:	94c50513          	addi	a0,a0,-1716 # 80019368 <ftable>
    80003a24:	00003097          	auipc	ra,0x3
    80003a28:	828080e7          	jalr	-2008(ra) # 8000624c <release>
}
    80003a2c:	8526                	mv	a0,s1
    80003a2e:	60e2                	ld	ra,24(sp)
    80003a30:	6442                	ld	s0,16(sp)
    80003a32:	64a2                	ld	s1,8(sp)
    80003a34:	6105                	addi	sp,sp,32
    80003a36:	8082                	ret

0000000080003a38 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a38:	1101                	addi	sp,sp,-32
    80003a3a:	ec06                	sd	ra,24(sp)
    80003a3c:	e822                	sd	s0,16(sp)
    80003a3e:	e426                	sd	s1,8(sp)
    80003a40:	1000                	addi	s0,sp,32
    80003a42:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a44:	00016517          	auipc	a0,0x16
    80003a48:	92450513          	addi	a0,a0,-1756 # 80019368 <ftable>
    80003a4c:	00002097          	auipc	ra,0x2
    80003a50:	74c080e7          	jalr	1868(ra) # 80006198 <acquire>
  if(f->ref < 1)
    80003a54:	40dc                	lw	a5,4(s1)
    80003a56:	02f05263          	blez	a5,80003a7a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a5a:	2785                	addiw	a5,a5,1
    80003a5c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a5e:	00016517          	auipc	a0,0x16
    80003a62:	90a50513          	addi	a0,a0,-1782 # 80019368 <ftable>
    80003a66:	00002097          	auipc	ra,0x2
    80003a6a:	7e6080e7          	jalr	2022(ra) # 8000624c <release>
  return f;
}
    80003a6e:	8526                	mv	a0,s1
    80003a70:	60e2                	ld	ra,24(sp)
    80003a72:	6442                	ld	s0,16(sp)
    80003a74:	64a2                	ld	s1,8(sp)
    80003a76:	6105                	addi	sp,sp,32
    80003a78:	8082                	ret
    panic("filedup");
    80003a7a:	00005517          	auipc	a0,0x5
    80003a7e:	c5e50513          	addi	a0,a0,-930 # 800086d8 <syscalls+0x250>
    80003a82:	00002097          	auipc	ra,0x2
    80003a86:	1de080e7          	jalr	478(ra) # 80005c60 <panic>

0000000080003a8a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a8a:	7139                	addi	sp,sp,-64
    80003a8c:	fc06                	sd	ra,56(sp)
    80003a8e:	f822                	sd	s0,48(sp)
    80003a90:	f426                	sd	s1,40(sp)
    80003a92:	f04a                	sd	s2,32(sp)
    80003a94:	ec4e                	sd	s3,24(sp)
    80003a96:	e852                	sd	s4,16(sp)
    80003a98:	e456                	sd	s5,8(sp)
    80003a9a:	0080                	addi	s0,sp,64
    80003a9c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a9e:	00016517          	auipc	a0,0x16
    80003aa2:	8ca50513          	addi	a0,a0,-1846 # 80019368 <ftable>
    80003aa6:	00002097          	auipc	ra,0x2
    80003aaa:	6f2080e7          	jalr	1778(ra) # 80006198 <acquire>
  if(f->ref < 1)
    80003aae:	40dc                	lw	a5,4(s1)
    80003ab0:	06f05163          	blez	a5,80003b12 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ab4:	37fd                	addiw	a5,a5,-1
    80003ab6:	0007871b          	sext.w	a4,a5
    80003aba:	c0dc                	sw	a5,4(s1)
    80003abc:	06e04363          	bgtz	a4,80003b22 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ac0:	0004a903          	lw	s2,0(s1)
    80003ac4:	0094ca83          	lbu	s5,9(s1)
    80003ac8:	0104ba03          	ld	s4,16(s1)
    80003acc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ad0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ad4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ad8:	00016517          	auipc	a0,0x16
    80003adc:	89050513          	addi	a0,a0,-1904 # 80019368 <ftable>
    80003ae0:	00002097          	auipc	ra,0x2
    80003ae4:	76c080e7          	jalr	1900(ra) # 8000624c <release>

  if(ff.type == FD_PIPE){
    80003ae8:	4785                	li	a5,1
    80003aea:	04f90d63          	beq	s2,a5,80003b44 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003aee:	3979                	addiw	s2,s2,-2
    80003af0:	4785                	li	a5,1
    80003af2:	0527e063          	bltu	a5,s2,80003b32 <fileclose+0xa8>
    begin_op();
    80003af6:	00000097          	auipc	ra,0x0
    80003afa:	acc080e7          	jalr	-1332(ra) # 800035c2 <begin_op>
    iput(ff.ip);
    80003afe:	854e                	mv	a0,s3
    80003b00:	fffff097          	auipc	ra,0xfffff
    80003b04:	2a0080e7          	jalr	672(ra) # 80002da0 <iput>
    end_op();
    80003b08:	00000097          	auipc	ra,0x0
    80003b0c:	b38080e7          	jalr	-1224(ra) # 80003640 <end_op>
    80003b10:	a00d                	j	80003b32 <fileclose+0xa8>
    panic("fileclose");
    80003b12:	00005517          	auipc	a0,0x5
    80003b16:	bce50513          	addi	a0,a0,-1074 # 800086e0 <syscalls+0x258>
    80003b1a:	00002097          	auipc	ra,0x2
    80003b1e:	146080e7          	jalr	326(ra) # 80005c60 <panic>
    release(&ftable.lock);
    80003b22:	00016517          	auipc	a0,0x16
    80003b26:	84650513          	addi	a0,a0,-1978 # 80019368 <ftable>
    80003b2a:	00002097          	auipc	ra,0x2
    80003b2e:	722080e7          	jalr	1826(ra) # 8000624c <release>
  }
}
    80003b32:	70e2                	ld	ra,56(sp)
    80003b34:	7442                	ld	s0,48(sp)
    80003b36:	74a2                	ld	s1,40(sp)
    80003b38:	7902                	ld	s2,32(sp)
    80003b3a:	69e2                	ld	s3,24(sp)
    80003b3c:	6a42                	ld	s4,16(sp)
    80003b3e:	6aa2                	ld	s5,8(sp)
    80003b40:	6121                	addi	sp,sp,64
    80003b42:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b44:	85d6                	mv	a1,s5
    80003b46:	8552                	mv	a0,s4
    80003b48:	00000097          	auipc	ra,0x0
    80003b4c:	34c080e7          	jalr	844(ra) # 80003e94 <pipeclose>
    80003b50:	b7cd                	j	80003b32 <fileclose+0xa8>

0000000080003b52 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b52:	715d                	addi	sp,sp,-80
    80003b54:	e486                	sd	ra,72(sp)
    80003b56:	e0a2                	sd	s0,64(sp)
    80003b58:	fc26                	sd	s1,56(sp)
    80003b5a:	f84a                	sd	s2,48(sp)
    80003b5c:	f44e                	sd	s3,40(sp)
    80003b5e:	0880                	addi	s0,sp,80
    80003b60:	84aa                	mv	s1,a0
    80003b62:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b64:	ffffd097          	auipc	ra,0xffffd
    80003b68:	32a080e7          	jalr	810(ra) # 80000e8e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b6c:	409c                	lw	a5,0(s1)
    80003b6e:	37f9                	addiw	a5,a5,-2
    80003b70:	4705                	li	a4,1
    80003b72:	04f76763          	bltu	a4,a5,80003bc0 <filestat+0x6e>
    80003b76:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b78:	6c88                	ld	a0,24(s1)
    80003b7a:	fffff097          	auipc	ra,0xfffff
    80003b7e:	06c080e7          	jalr	108(ra) # 80002be6 <ilock>
    stati(f->ip, &st);
    80003b82:	fb840593          	addi	a1,s0,-72
    80003b86:	6c88                	ld	a0,24(s1)
    80003b88:	fffff097          	auipc	ra,0xfffff
    80003b8c:	2e8080e7          	jalr	744(ra) # 80002e70 <stati>
    iunlock(f->ip);
    80003b90:	6c88                	ld	a0,24(s1)
    80003b92:	fffff097          	auipc	ra,0xfffff
    80003b96:	116080e7          	jalr	278(ra) # 80002ca8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b9a:	46e1                	li	a3,24
    80003b9c:	fb840613          	addi	a2,s0,-72
    80003ba0:	85ce                	mv	a1,s3
    80003ba2:	05093503          	ld	a0,80(s2)
    80003ba6:	ffffd097          	auipc	ra,0xffffd
    80003baa:	fac080e7          	jalr	-84(ra) # 80000b52 <copyout>
    80003bae:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bb2:	60a6                	ld	ra,72(sp)
    80003bb4:	6406                	ld	s0,64(sp)
    80003bb6:	74e2                	ld	s1,56(sp)
    80003bb8:	7942                	ld	s2,48(sp)
    80003bba:	79a2                	ld	s3,40(sp)
    80003bbc:	6161                	addi	sp,sp,80
    80003bbe:	8082                	ret
  return -1;
    80003bc0:	557d                	li	a0,-1
    80003bc2:	bfc5                	j	80003bb2 <filestat+0x60>

0000000080003bc4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bc4:	7179                	addi	sp,sp,-48
    80003bc6:	f406                	sd	ra,40(sp)
    80003bc8:	f022                	sd	s0,32(sp)
    80003bca:	ec26                	sd	s1,24(sp)
    80003bcc:	e84a                	sd	s2,16(sp)
    80003bce:	e44e                	sd	s3,8(sp)
    80003bd0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bd2:	00854783          	lbu	a5,8(a0)
    80003bd6:	c3d5                	beqz	a5,80003c7a <fileread+0xb6>
    80003bd8:	84aa                	mv	s1,a0
    80003bda:	89ae                	mv	s3,a1
    80003bdc:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bde:	411c                	lw	a5,0(a0)
    80003be0:	4705                	li	a4,1
    80003be2:	04e78963          	beq	a5,a4,80003c34 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003be6:	470d                	li	a4,3
    80003be8:	04e78d63          	beq	a5,a4,80003c42 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bec:	4709                	li	a4,2
    80003bee:	06e79e63          	bne	a5,a4,80003c6a <fileread+0xa6>
    ilock(f->ip);
    80003bf2:	6d08                	ld	a0,24(a0)
    80003bf4:	fffff097          	auipc	ra,0xfffff
    80003bf8:	ff2080e7          	jalr	-14(ra) # 80002be6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bfc:	874a                	mv	a4,s2
    80003bfe:	5094                	lw	a3,32(s1)
    80003c00:	864e                	mv	a2,s3
    80003c02:	4585                	li	a1,1
    80003c04:	6c88                	ld	a0,24(s1)
    80003c06:	fffff097          	auipc	ra,0xfffff
    80003c0a:	294080e7          	jalr	660(ra) # 80002e9a <readi>
    80003c0e:	892a                	mv	s2,a0
    80003c10:	00a05563          	blez	a0,80003c1a <fileread+0x56>
      f->off += r;
    80003c14:	509c                	lw	a5,32(s1)
    80003c16:	9fa9                	addw	a5,a5,a0
    80003c18:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c1a:	6c88                	ld	a0,24(s1)
    80003c1c:	fffff097          	auipc	ra,0xfffff
    80003c20:	08c080e7          	jalr	140(ra) # 80002ca8 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c24:	854a                	mv	a0,s2
    80003c26:	70a2                	ld	ra,40(sp)
    80003c28:	7402                	ld	s0,32(sp)
    80003c2a:	64e2                	ld	s1,24(sp)
    80003c2c:	6942                	ld	s2,16(sp)
    80003c2e:	69a2                	ld	s3,8(sp)
    80003c30:	6145                	addi	sp,sp,48
    80003c32:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c34:	6908                	ld	a0,16(a0)
    80003c36:	00000097          	auipc	ra,0x0
    80003c3a:	3c0080e7          	jalr	960(ra) # 80003ff6 <piperead>
    80003c3e:	892a                	mv	s2,a0
    80003c40:	b7d5                	j	80003c24 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c42:	02451783          	lh	a5,36(a0)
    80003c46:	03079693          	slli	a3,a5,0x30
    80003c4a:	92c1                	srli	a3,a3,0x30
    80003c4c:	4725                	li	a4,9
    80003c4e:	02d76863          	bltu	a4,a3,80003c7e <fileread+0xba>
    80003c52:	0792                	slli	a5,a5,0x4
    80003c54:	00015717          	auipc	a4,0x15
    80003c58:	67470713          	addi	a4,a4,1652 # 800192c8 <devsw>
    80003c5c:	97ba                	add	a5,a5,a4
    80003c5e:	639c                	ld	a5,0(a5)
    80003c60:	c38d                	beqz	a5,80003c82 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c62:	4505                	li	a0,1
    80003c64:	9782                	jalr	a5
    80003c66:	892a                	mv	s2,a0
    80003c68:	bf75                	j	80003c24 <fileread+0x60>
    panic("fileread");
    80003c6a:	00005517          	auipc	a0,0x5
    80003c6e:	a8650513          	addi	a0,a0,-1402 # 800086f0 <syscalls+0x268>
    80003c72:	00002097          	auipc	ra,0x2
    80003c76:	fee080e7          	jalr	-18(ra) # 80005c60 <panic>
    return -1;
    80003c7a:	597d                	li	s2,-1
    80003c7c:	b765                	j	80003c24 <fileread+0x60>
      return -1;
    80003c7e:	597d                	li	s2,-1
    80003c80:	b755                	j	80003c24 <fileread+0x60>
    80003c82:	597d                	li	s2,-1
    80003c84:	b745                	j	80003c24 <fileread+0x60>

0000000080003c86 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c86:	715d                	addi	sp,sp,-80
    80003c88:	e486                	sd	ra,72(sp)
    80003c8a:	e0a2                	sd	s0,64(sp)
    80003c8c:	fc26                	sd	s1,56(sp)
    80003c8e:	f84a                	sd	s2,48(sp)
    80003c90:	f44e                	sd	s3,40(sp)
    80003c92:	f052                	sd	s4,32(sp)
    80003c94:	ec56                	sd	s5,24(sp)
    80003c96:	e85a                	sd	s6,16(sp)
    80003c98:	e45e                	sd	s7,8(sp)
    80003c9a:	e062                	sd	s8,0(sp)
    80003c9c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c9e:	00954783          	lbu	a5,9(a0)
    80003ca2:	10078663          	beqz	a5,80003dae <filewrite+0x128>
    80003ca6:	892a                	mv	s2,a0
    80003ca8:	8b2e                	mv	s6,a1
    80003caa:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cac:	411c                	lw	a5,0(a0)
    80003cae:	4705                	li	a4,1
    80003cb0:	02e78263          	beq	a5,a4,80003cd4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cb4:	470d                	li	a4,3
    80003cb6:	02e78663          	beq	a5,a4,80003ce2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cba:	4709                	li	a4,2
    80003cbc:	0ee79163          	bne	a5,a4,80003d9e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cc0:	0ac05d63          	blez	a2,80003d7a <filewrite+0xf4>
    int i = 0;
    80003cc4:	4981                	li	s3,0
    80003cc6:	6b85                	lui	s7,0x1
    80003cc8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ccc:	6c05                	lui	s8,0x1
    80003cce:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cd2:	a861                	j	80003d6a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cd4:	6908                	ld	a0,16(a0)
    80003cd6:	00000097          	auipc	ra,0x0
    80003cda:	22e080e7          	jalr	558(ra) # 80003f04 <pipewrite>
    80003cde:	8a2a                	mv	s4,a0
    80003ce0:	a045                	j	80003d80 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ce2:	02451783          	lh	a5,36(a0)
    80003ce6:	03079693          	slli	a3,a5,0x30
    80003cea:	92c1                	srli	a3,a3,0x30
    80003cec:	4725                	li	a4,9
    80003cee:	0cd76263          	bltu	a4,a3,80003db2 <filewrite+0x12c>
    80003cf2:	0792                	slli	a5,a5,0x4
    80003cf4:	00015717          	auipc	a4,0x15
    80003cf8:	5d470713          	addi	a4,a4,1492 # 800192c8 <devsw>
    80003cfc:	97ba                	add	a5,a5,a4
    80003cfe:	679c                	ld	a5,8(a5)
    80003d00:	cbdd                	beqz	a5,80003db6 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d02:	4505                	li	a0,1
    80003d04:	9782                	jalr	a5
    80003d06:	8a2a                	mv	s4,a0
    80003d08:	a8a5                	j	80003d80 <filewrite+0xfa>
    80003d0a:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d0e:	00000097          	auipc	ra,0x0
    80003d12:	8b4080e7          	jalr	-1868(ra) # 800035c2 <begin_op>
      ilock(f->ip);
    80003d16:	01893503          	ld	a0,24(s2)
    80003d1a:	fffff097          	auipc	ra,0xfffff
    80003d1e:	ecc080e7          	jalr	-308(ra) # 80002be6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d22:	8756                	mv	a4,s5
    80003d24:	02092683          	lw	a3,32(s2)
    80003d28:	01698633          	add	a2,s3,s6
    80003d2c:	4585                	li	a1,1
    80003d2e:	01893503          	ld	a0,24(s2)
    80003d32:	fffff097          	auipc	ra,0xfffff
    80003d36:	260080e7          	jalr	608(ra) # 80002f92 <writei>
    80003d3a:	84aa                	mv	s1,a0
    80003d3c:	00a05763          	blez	a0,80003d4a <filewrite+0xc4>
        f->off += r;
    80003d40:	02092783          	lw	a5,32(s2)
    80003d44:	9fa9                	addw	a5,a5,a0
    80003d46:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d4a:	01893503          	ld	a0,24(s2)
    80003d4e:	fffff097          	auipc	ra,0xfffff
    80003d52:	f5a080e7          	jalr	-166(ra) # 80002ca8 <iunlock>
      end_op();
    80003d56:	00000097          	auipc	ra,0x0
    80003d5a:	8ea080e7          	jalr	-1814(ra) # 80003640 <end_op>

      if(r != n1){
    80003d5e:	009a9f63          	bne	s5,s1,80003d7c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d62:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d66:	0149db63          	bge	s3,s4,80003d7c <filewrite+0xf6>
      int n1 = n - i;
    80003d6a:	413a04bb          	subw	s1,s4,s3
    80003d6e:	0004879b          	sext.w	a5,s1
    80003d72:	f8fbdce3          	bge	s7,a5,80003d0a <filewrite+0x84>
    80003d76:	84e2                	mv	s1,s8
    80003d78:	bf49                	j	80003d0a <filewrite+0x84>
    int i = 0;
    80003d7a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d7c:	013a1f63          	bne	s4,s3,80003d9a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d80:	8552                	mv	a0,s4
    80003d82:	60a6                	ld	ra,72(sp)
    80003d84:	6406                	ld	s0,64(sp)
    80003d86:	74e2                	ld	s1,56(sp)
    80003d88:	7942                	ld	s2,48(sp)
    80003d8a:	79a2                	ld	s3,40(sp)
    80003d8c:	7a02                	ld	s4,32(sp)
    80003d8e:	6ae2                	ld	s5,24(sp)
    80003d90:	6b42                	ld	s6,16(sp)
    80003d92:	6ba2                	ld	s7,8(sp)
    80003d94:	6c02                	ld	s8,0(sp)
    80003d96:	6161                	addi	sp,sp,80
    80003d98:	8082                	ret
    ret = (i == n ? n : -1);
    80003d9a:	5a7d                	li	s4,-1
    80003d9c:	b7d5                	j	80003d80 <filewrite+0xfa>
    panic("filewrite");
    80003d9e:	00005517          	auipc	a0,0x5
    80003da2:	96250513          	addi	a0,a0,-1694 # 80008700 <syscalls+0x278>
    80003da6:	00002097          	auipc	ra,0x2
    80003daa:	eba080e7          	jalr	-326(ra) # 80005c60 <panic>
    return -1;
    80003dae:	5a7d                	li	s4,-1
    80003db0:	bfc1                	j	80003d80 <filewrite+0xfa>
      return -1;
    80003db2:	5a7d                	li	s4,-1
    80003db4:	b7f1                	j	80003d80 <filewrite+0xfa>
    80003db6:	5a7d                	li	s4,-1
    80003db8:	b7e1                	j	80003d80 <filewrite+0xfa>

0000000080003dba <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dba:	7179                	addi	sp,sp,-48
    80003dbc:	f406                	sd	ra,40(sp)
    80003dbe:	f022                	sd	s0,32(sp)
    80003dc0:	ec26                	sd	s1,24(sp)
    80003dc2:	e84a                	sd	s2,16(sp)
    80003dc4:	e44e                	sd	s3,8(sp)
    80003dc6:	e052                	sd	s4,0(sp)
    80003dc8:	1800                	addi	s0,sp,48
    80003dca:	84aa                	mv	s1,a0
    80003dcc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dce:	0005b023          	sd	zero,0(a1)
    80003dd2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	bf8080e7          	jalr	-1032(ra) # 800039ce <filealloc>
    80003dde:	e088                	sd	a0,0(s1)
    80003de0:	c551                	beqz	a0,80003e6c <pipealloc+0xb2>
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	bec080e7          	jalr	-1044(ra) # 800039ce <filealloc>
    80003dea:	00aa3023          	sd	a0,0(s4)
    80003dee:	c92d                	beqz	a0,80003e60 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003df0:	ffffc097          	auipc	ra,0xffffc
    80003df4:	32a080e7          	jalr	810(ra) # 8000011a <kalloc>
    80003df8:	892a                	mv	s2,a0
    80003dfa:	c125                	beqz	a0,80003e5a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dfc:	4985                	li	s3,1
    80003dfe:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e02:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e06:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e0a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e0e:	00004597          	auipc	a1,0x4
    80003e12:	5d258593          	addi	a1,a1,1490 # 800083e0 <states.0+0x1a0>
    80003e16:	00002097          	auipc	ra,0x2
    80003e1a:	2f2080e7          	jalr	754(ra) # 80006108 <initlock>
  (*f0)->type = FD_PIPE;
    80003e1e:	609c                	ld	a5,0(s1)
    80003e20:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e24:	609c                	ld	a5,0(s1)
    80003e26:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e2a:	609c                	ld	a5,0(s1)
    80003e2c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e30:	609c                	ld	a5,0(s1)
    80003e32:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e36:	000a3783          	ld	a5,0(s4)
    80003e3a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e3e:	000a3783          	ld	a5,0(s4)
    80003e42:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e46:	000a3783          	ld	a5,0(s4)
    80003e4a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e4e:	000a3783          	ld	a5,0(s4)
    80003e52:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e56:	4501                	li	a0,0
    80003e58:	a025                	j	80003e80 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e5a:	6088                	ld	a0,0(s1)
    80003e5c:	e501                	bnez	a0,80003e64 <pipealloc+0xaa>
    80003e5e:	a039                	j	80003e6c <pipealloc+0xb2>
    80003e60:	6088                	ld	a0,0(s1)
    80003e62:	c51d                	beqz	a0,80003e90 <pipealloc+0xd6>
    fileclose(*f0);
    80003e64:	00000097          	auipc	ra,0x0
    80003e68:	c26080e7          	jalr	-986(ra) # 80003a8a <fileclose>
  if(*f1)
    80003e6c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e70:	557d                	li	a0,-1
  if(*f1)
    80003e72:	c799                	beqz	a5,80003e80 <pipealloc+0xc6>
    fileclose(*f1);
    80003e74:	853e                	mv	a0,a5
    80003e76:	00000097          	auipc	ra,0x0
    80003e7a:	c14080e7          	jalr	-1004(ra) # 80003a8a <fileclose>
  return -1;
    80003e7e:	557d                	li	a0,-1
}
    80003e80:	70a2                	ld	ra,40(sp)
    80003e82:	7402                	ld	s0,32(sp)
    80003e84:	64e2                	ld	s1,24(sp)
    80003e86:	6942                	ld	s2,16(sp)
    80003e88:	69a2                	ld	s3,8(sp)
    80003e8a:	6a02                	ld	s4,0(sp)
    80003e8c:	6145                	addi	sp,sp,48
    80003e8e:	8082                	ret
  return -1;
    80003e90:	557d                	li	a0,-1
    80003e92:	b7fd                	j	80003e80 <pipealloc+0xc6>

0000000080003e94 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e94:	1101                	addi	sp,sp,-32
    80003e96:	ec06                	sd	ra,24(sp)
    80003e98:	e822                	sd	s0,16(sp)
    80003e9a:	e426                	sd	s1,8(sp)
    80003e9c:	e04a                	sd	s2,0(sp)
    80003e9e:	1000                	addi	s0,sp,32
    80003ea0:	84aa                	mv	s1,a0
    80003ea2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ea4:	00002097          	auipc	ra,0x2
    80003ea8:	2f4080e7          	jalr	756(ra) # 80006198 <acquire>
  if(writable){
    80003eac:	02090d63          	beqz	s2,80003ee6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003eb0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eb4:	21848513          	addi	a0,s1,536
    80003eb8:	ffffe097          	auipc	ra,0xffffe
    80003ebc:	82e080e7          	jalr	-2002(ra) # 800016e6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ec0:	2204b783          	ld	a5,544(s1)
    80003ec4:	eb95                	bnez	a5,80003ef8 <pipeclose+0x64>
    release(&pi->lock);
    80003ec6:	8526                	mv	a0,s1
    80003ec8:	00002097          	auipc	ra,0x2
    80003ecc:	384080e7          	jalr	900(ra) # 8000624c <release>
    kfree((char*)pi);
    80003ed0:	8526                	mv	a0,s1
    80003ed2:	ffffc097          	auipc	ra,0xffffc
    80003ed6:	14a080e7          	jalr	330(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eda:	60e2                	ld	ra,24(sp)
    80003edc:	6442                	ld	s0,16(sp)
    80003ede:	64a2                	ld	s1,8(sp)
    80003ee0:	6902                	ld	s2,0(sp)
    80003ee2:	6105                	addi	sp,sp,32
    80003ee4:	8082                	ret
    pi->readopen = 0;
    80003ee6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003eea:	21c48513          	addi	a0,s1,540
    80003eee:	ffffd097          	auipc	ra,0xffffd
    80003ef2:	7f8080e7          	jalr	2040(ra) # 800016e6 <wakeup>
    80003ef6:	b7e9                	j	80003ec0 <pipeclose+0x2c>
    release(&pi->lock);
    80003ef8:	8526                	mv	a0,s1
    80003efa:	00002097          	auipc	ra,0x2
    80003efe:	352080e7          	jalr	850(ra) # 8000624c <release>
}
    80003f02:	bfe1                	j	80003eda <pipeclose+0x46>

0000000080003f04 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f04:	711d                	addi	sp,sp,-96
    80003f06:	ec86                	sd	ra,88(sp)
    80003f08:	e8a2                	sd	s0,80(sp)
    80003f0a:	e4a6                	sd	s1,72(sp)
    80003f0c:	e0ca                	sd	s2,64(sp)
    80003f0e:	fc4e                	sd	s3,56(sp)
    80003f10:	f852                	sd	s4,48(sp)
    80003f12:	f456                	sd	s5,40(sp)
    80003f14:	f05a                	sd	s6,32(sp)
    80003f16:	ec5e                	sd	s7,24(sp)
    80003f18:	e862                	sd	s8,16(sp)
    80003f1a:	1080                	addi	s0,sp,96
    80003f1c:	84aa                	mv	s1,a0
    80003f1e:	8aae                	mv	s5,a1
    80003f20:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f22:	ffffd097          	auipc	ra,0xffffd
    80003f26:	f6c080e7          	jalr	-148(ra) # 80000e8e <myproc>
    80003f2a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f2c:	8526                	mv	a0,s1
    80003f2e:	00002097          	auipc	ra,0x2
    80003f32:	26a080e7          	jalr	618(ra) # 80006198 <acquire>
  while(i < n){
    80003f36:	0b405363          	blez	s4,80003fdc <pipewrite+0xd8>
  int i = 0;
    80003f3a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f3c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f3e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f42:	21c48b93          	addi	s7,s1,540
    80003f46:	a089                	j	80003f88 <pipewrite+0x84>
      release(&pi->lock);
    80003f48:	8526                	mv	a0,s1
    80003f4a:	00002097          	auipc	ra,0x2
    80003f4e:	302080e7          	jalr	770(ra) # 8000624c <release>
      return -1;
    80003f52:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f54:	854a                	mv	a0,s2
    80003f56:	60e6                	ld	ra,88(sp)
    80003f58:	6446                	ld	s0,80(sp)
    80003f5a:	64a6                	ld	s1,72(sp)
    80003f5c:	6906                	ld	s2,64(sp)
    80003f5e:	79e2                	ld	s3,56(sp)
    80003f60:	7a42                	ld	s4,48(sp)
    80003f62:	7aa2                	ld	s5,40(sp)
    80003f64:	7b02                	ld	s6,32(sp)
    80003f66:	6be2                	ld	s7,24(sp)
    80003f68:	6c42                	ld	s8,16(sp)
    80003f6a:	6125                	addi	sp,sp,96
    80003f6c:	8082                	ret
      wakeup(&pi->nread);
    80003f6e:	8562                	mv	a0,s8
    80003f70:	ffffd097          	auipc	ra,0xffffd
    80003f74:	776080e7          	jalr	1910(ra) # 800016e6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f78:	85a6                	mv	a1,s1
    80003f7a:	855e                	mv	a0,s7
    80003f7c:	ffffd097          	auipc	ra,0xffffd
    80003f80:	5de080e7          	jalr	1502(ra) # 8000155a <sleep>
  while(i < n){
    80003f84:	05495d63          	bge	s2,s4,80003fde <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f88:	2204a783          	lw	a5,544(s1)
    80003f8c:	dfd5                	beqz	a5,80003f48 <pipewrite+0x44>
    80003f8e:	0289a783          	lw	a5,40(s3)
    80003f92:	fbdd                	bnez	a5,80003f48 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f94:	2184a783          	lw	a5,536(s1)
    80003f98:	21c4a703          	lw	a4,540(s1)
    80003f9c:	2007879b          	addiw	a5,a5,512
    80003fa0:	fcf707e3          	beq	a4,a5,80003f6e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fa4:	4685                	li	a3,1
    80003fa6:	01590633          	add	a2,s2,s5
    80003faa:	faf40593          	addi	a1,s0,-81
    80003fae:	0509b503          	ld	a0,80(s3)
    80003fb2:	ffffd097          	auipc	ra,0xffffd
    80003fb6:	c2c080e7          	jalr	-980(ra) # 80000bde <copyin>
    80003fba:	03650263          	beq	a0,s6,80003fde <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fbe:	21c4a783          	lw	a5,540(s1)
    80003fc2:	0017871b          	addiw	a4,a5,1
    80003fc6:	20e4ae23          	sw	a4,540(s1)
    80003fca:	1ff7f793          	andi	a5,a5,511
    80003fce:	97a6                	add	a5,a5,s1
    80003fd0:	faf44703          	lbu	a4,-81(s0)
    80003fd4:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fd8:	2905                	addiw	s2,s2,1
    80003fda:	b76d                	j	80003f84 <pipewrite+0x80>
  int i = 0;
    80003fdc:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fde:	21848513          	addi	a0,s1,536
    80003fe2:	ffffd097          	auipc	ra,0xffffd
    80003fe6:	704080e7          	jalr	1796(ra) # 800016e6 <wakeup>
  release(&pi->lock);
    80003fea:	8526                	mv	a0,s1
    80003fec:	00002097          	auipc	ra,0x2
    80003ff0:	260080e7          	jalr	608(ra) # 8000624c <release>
  return i;
    80003ff4:	b785                	j	80003f54 <pipewrite+0x50>

0000000080003ff6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ff6:	715d                	addi	sp,sp,-80
    80003ff8:	e486                	sd	ra,72(sp)
    80003ffa:	e0a2                	sd	s0,64(sp)
    80003ffc:	fc26                	sd	s1,56(sp)
    80003ffe:	f84a                	sd	s2,48(sp)
    80004000:	f44e                	sd	s3,40(sp)
    80004002:	f052                	sd	s4,32(sp)
    80004004:	ec56                	sd	s5,24(sp)
    80004006:	e85a                	sd	s6,16(sp)
    80004008:	0880                	addi	s0,sp,80
    8000400a:	84aa                	mv	s1,a0
    8000400c:	892e                	mv	s2,a1
    8000400e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004010:	ffffd097          	auipc	ra,0xffffd
    80004014:	e7e080e7          	jalr	-386(ra) # 80000e8e <myproc>
    80004018:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000401a:	8526                	mv	a0,s1
    8000401c:	00002097          	auipc	ra,0x2
    80004020:	17c080e7          	jalr	380(ra) # 80006198 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004024:	2184a703          	lw	a4,536(s1)
    80004028:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000402c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004030:	02f71463          	bne	a4,a5,80004058 <piperead+0x62>
    80004034:	2244a783          	lw	a5,548(s1)
    80004038:	c385                	beqz	a5,80004058 <piperead+0x62>
    if(pr->killed){
    8000403a:	028a2783          	lw	a5,40(s4)
    8000403e:	ebc9                	bnez	a5,800040d0 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004040:	85a6                	mv	a1,s1
    80004042:	854e                	mv	a0,s3
    80004044:	ffffd097          	auipc	ra,0xffffd
    80004048:	516080e7          	jalr	1302(ra) # 8000155a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000404c:	2184a703          	lw	a4,536(s1)
    80004050:	21c4a783          	lw	a5,540(s1)
    80004054:	fef700e3          	beq	a4,a5,80004034 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004058:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000405a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000405c:	05505463          	blez	s5,800040a4 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004060:	2184a783          	lw	a5,536(s1)
    80004064:	21c4a703          	lw	a4,540(s1)
    80004068:	02f70e63          	beq	a4,a5,800040a4 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000406c:	0017871b          	addiw	a4,a5,1
    80004070:	20e4ac23          	sw	a4,536(s1)
    80004074:	1ff7f793          	andi	a5,a5,511
    80004078:	97a6                	add	a5,a5,s1
    8000407a:	0187c783          	lbu	a5,24(a5)
    8000407e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004082:	4685                	li	a3,1
    80004084:	fbf40613          	addi	a2,s0,-65
    80004088:	85ca                	mv	a1,s2
    8000408a:	050a3503          	ld	a0,80(s4)
    8000408e:	ffffd097          	auipc	ra,0xffffd
    80004092:	ac4080e7          	jalr	-1340(ra) # 80000b52 <copyout>
    80004096:	01650763          	beq	a0,s6,800040a4 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000409a:	2985                	addiw	s3,s3,1
    8000409c:	0905                	addi	s2,s2,1
    8000409e:	fd3a91e3          	bne	s5,s3,80004060 <piperead+0x6a>
    800040a2:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040a4:	21c48513          	addi	a0,s1,540
    800040a8:	ffffd097          	auipc	ra,0xffffd
    800040ac:	63e080e7          	jalr	1598(ra) # 800016e6 <wakeup>
  release(&pi->lock);
    800040b0:	8526                	mv	a0,s1
    800040b2:	00002097          	auipc	ra,0x2
    800040b6:	19a080e7          	jalr	410(ra) # 8000624c <release>
  return i;
}
    800040ba:	854e                	mv	a0,s3
    800040bc:	60a6                	ld	ra,72(sp)
    800040be:	6406                	ld	s0,64(sp)
    800040c0:	74e2                	ld	s1,56(sp)
    800040c2:	7942                	ld	s2,48(sp)
    800040c4:	79a2                	ld	s3,40(sp)
    800040c6:	7a02                	ld	s4,32(sp)
    800040c8:	6ae2                	ld	s5,24(sp)
    800040ca:	6b42                	ld	s6,16(sp)
    800040cc:	6161                	addi	sp,sp,80
    800040ce:	8082                	ret
      release(&pi->lock);
    800040d0:	8526                	mv	a0,s1
    800040d2:	00002097          	auipc	ra,0x2
    800040d6:	17a080e7          	jalr	378(ra) # 8000624c <release>
      return -1;
    800040da:	59fd                	li	s3,-1
    800040dc:	bff9                	j	800040ba <piperead+0xc4>

00000000800040de <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040de:	de010113          	addi	sp,sp,-544
    800040e2:	20113c23          	sd	ra,536(sp)
    800040e6:	20813823          	sd	s0,528(sp)
    800040ea:	20913423          	sd	s1,520(sp)
    800040ee:	21213023          	sd	s2,512(sp)
    800040f2:	ffce                	sd	s3,504(sp)
    800040f4:	fbd2                	sd	s4,496(sp)
    800040f6:	f7d6                	sd	s5,488(sp)
    800040f8:	f3da                	sd	s6,480(sp)
    800040fa:	efde                	sd	s7,472(sp)
    800040fc:	ebe2                	sd	s8,464(sp)
    800040fe:	e7e6                	sd	s9,456(sp)
    80004100:	e3ea                	sd	s10,448(sp)
    80004102:	ff6e                	sd	s11,440(sp)
    80004104:	1400                	addi	s0,sp,544
    80004106:	892a                	mv	s2,a0
    80004108:	dea43423          	sd	a0,-536(s0)
    8000410c:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	d7e080e7          	jalr	-642(ra) # 80000e8e <myproc>
    80004118:	84aa                	mv	s1,a0

  begin_op();
    8000411a:	fffff097          	auipc	ra,0xfffff
    8000411e:	4a8080e7          	jalr	1192(ra) # 800035c2 <begin_op>

  if((ip = namei(path)) == 0){
    80004122:	854a                	mv	a0,s2
    80004124:	fffff097          	auipc	ra,0xfffff
    80004128:	27e080e7          	jalr	638(ra) # 800033a2 <namei>
    8000412c:	c93d                	beqz	a0,800041a2 <exec+0xc4>
    8000412e:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004130:	fffff097          	auipc	ra,0xfffff
    80004134:	ab6080e7          	jalr	-1354(ra) # 80002be6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004138:	04000713          	li	a4,64
    8000413c:	4681                	li	a3,0
    8000413e:	e5040613          	addi	a2,s0,-432
    80004142:	4581                	li	a1,0
    80004144:	8556                	mv	a0,s5
    80004146:	fffff097          	auipc	ra,0xfffff
    8000414a:	d54080e7          	jalr	-684(ra) # 80002e9a <readi>
    8000414e:	04000793          	li	a5,64
    80004152:	00f51a63          	bne	a0,a5,80004166 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004156:	e5042703          	lw	a4,-432(s0)
    8000415a:	464c47b7          	lui	a5,0x464c4
    8000415e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004162:	04f70663          	beq	a4,a5,800041ae <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004166:	8556                	mv	a0,s5
    80004168:	fffff097          	auipc	ra,0xfffff
    8000416c:	ce0080e7          	jalr	-800(ra) # 80002e48 <iunlockput>
    end_op();
    80004170:	fffff097          	auipc	ra,0xfffff
    80004174:	4d0080e7          	jalr	1232(ra) # 80003640 <end_op>
  }
  return -1;
    80004178:	557d                	li	a0,-1
}
    8000417a:	21813083          	ld	ra,536(sp)
    8000417e:	21013403          	ld	s0,528(sp)
    80004182:	20813483          	ld	s1,520(sp)
    80004186:	20013903          	ld	s2,512(sp)
    8000418a:	79fe                	ld	s3,504(sp)
    8000418c:	7a5e                	ld	s4,496(sp)
    8000418e:	7abe                	ld	s5,488(sp)
    80004190:	7b1e                	ld	s6,480(sp)
    80004192:	6bfe                	ld	s7,472(sp)
    80004194:	6c5e                	ld	s8,464(sp)
    80004196:	6cbe                	ld	s9,456(sp)
    80004198:	6d1e                	ld	s10,448(sp)
    8000419a:	7dfa                	ld	s11,440(sp)
    8000419c:	22010113          	addi	sp,sp,544
    800041a0:	8082                	ret
    end_op();
    800041a2:	fffff097          	auipc	ra,0xfffff
    800041a6:	49e080e7          	jalr	1182(ra) # 80003640 <end_op>
    return -1;
    800041aa:	557d                	li	a0,-1
    800041ac:	b7f9                	j	8000417a <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800041ae:	8526                	mv	a0,s1
    800041b0:	ffffd097          	auipc	ra,0xffffd
    800041b4:	da2080e7          	jalr	-606(ra) # 80000f52 <proc_pagetable>
    800041b8:	8b2a                	mv	s6,a0
    800041ba:	d555                	beqz	a0,80004166 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041bc:	e7042783          	lw	a5,-400(s0)
    800041c0:	e8845703          	lhu	a4,-376(s0)
    800041c4:	c735                	beqz	a4,80004230 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041c6:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041c8:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800041cc:	6a05                	lui	s4,0x1
    800041ce:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041d2:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041d6:	6d85                	lui	s11,0x1
    800041d8:	7d7d                	lui	s10,0xfffff
    800041da:	ac1d                	j	80004410 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041dc:	00004517          	auipc	a0,0x4
    800041e0:	53450513          	addi	a0,a0,1332 # 80008710 <syscalls+0x288>
    800041e4:	00002097          	auipc	ra,0x2
    800041e8:	a7c080e7          	jalr	-1412(ra) # 80005c60 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041ec:	874a                	mv	a4,s2
    800041ee:	009c86bb          	addw	a3,s9,s1
    800041f2:	4581                	li	a1,0
    800041f4:	8556                	mv	a0,s5
    800041f6:	fffff097          	auipc	ra,0xfffff
    800041fa:	ca4080e7          	jalr	-860(ra) # 80002e9a <readi>
    800041fe:	2501                	sext.w	a0,a0
    80004200:	1aa91863          	bne	s2,a0,800043b0 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004204:	009d84bb          	addw	s1,s11,s1
    80004208:	013d09bb          	addw	s3,s10,s3
    8000420c:	1f74f263          	bgeu	s1,s7,800043f0 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004210:	02049593          	slli	a1,s1,0x20
    80004214:	9181                	srli	a1,a1,0x20
    80004216:	95e2                	add	a1,a1,s8
    80004218:	855a                	mv	a0,s6
    8000421a:	ffffc097          	auipc	ra,0xffffc
    8000421e:	330080e7          	jalr	816(ra) # 8000054a <walkaddr>
    80004222:	862a                	mv	a2,a0
    if(pa == 0)
    80004224:	dd45                	beqz	a0,800041dc <exec+0xfe>
      n = PGSIZE;
    80004226:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004228:	fd49f2e3          	bgeu	s3,s4,800041ec <exec+0x10e>
      n = sz - i;
    8000422c:	894e                	mv	s2,s3
    8000422e:	bf7d                	j	800041ec <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004230:	4481                	li	s1,0
  iunlockput(ip);
    80004232:	8556                	mv	a0,s5
    80004234:	fffff097          	auipc	ra,0xfffff
    80004238:	c14080e7          	jalr	-1004(ra) # 80002e48 <iunlockput>
  end_op();
    8000423c:	fffff097          	auipc	ra,0xfffff
    80004240:	404080e7          	jalr	1028(ra) # 80003640 <end_op>
  p = myproc();
    80004244:	ffffd097          	auipc	ra,0xffffd
    80004248:	c4a080e7          	jalr	-950(ra) # 80000e8e <myproc>
    8000424c:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000424e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004252:	6785                	lui	a5,0x1
    80004254:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004256:	97a6                	add	a5,a5,s1
    80004258:	777d                	lui	a4,0xfffff
    8000425a:	8ff9                	and	a5,a5,a4
    8000425c:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004260:	6609                	lui	a2,0x2
    80004262:	963e                	add	a2,a2,a5
    80004264:	85be                	mv	a1,a5
    80004266:	855a                	mv	a0,s6
    80004268:	ffffc097          	auipc	ra,0xffffc
    8000426c:	696080e7          	jalr	1686(ra) # 800008fe <uvmalloc>
    80004270:	8c2a                	mv	s8,a0
  ip = 0;
    80004272:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004274:	12050e63          	beqz	a0,800043b0 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004278:	75f9                	lui	a1,0xffffe
    8000427a:	95aa                	add	a1,a1,a0
    8000427c:	855a                	mv	a0,s6
    8000427e:	ffffd097          	auipc	ra,0xffffd
    80004282:	8a2080e7          	jalr	-1886(ra) # 80000b20 <uvmclear>
  stackbase = sp - PGSIZE;
    80004286:	7afd                	lui	s5,0xfffff
    80004288:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000428a:	df043783          	ld	a5,-528(s0)
    8000428e:	6388                	ld	a0,0(a5)
    80004290:	c925                	beqz	a0,80004300 <exec+0x222>
    80004292:	e9040993          	addi	s3,s0,-368
    80004296:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000429a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000429c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000429e:	ffffc097          	auipc	ra,0xffffc
    800042a2:	0a2080e7          	jalr	162(ra) # 80000340 <strlen>
    800042a6:	0015079b          	addiw	a5,a0,1
    800042aa:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042ae:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800042b2:	13596363          	bltu	s2,s5,800043d8 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042b6:	df043d83          	ld	s11,-528(s0)
    800042ba:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800042be:	8552                	mv	a0,s4
    800042c0:	ffffc097          	auipc	ra,0xffffc
    800042c4:	080080e7          	jalr	128(ra) # 80000340 <strlen>
    800042c8:	0015069b          	addiw	a3,a0,1
    800042cc:	8652                	mv	a2,s4
    800042ce:	85ca                	mv	a1,s2
    800042d0:	855a                	mv	a0,s6
    800042d2:	ffffd097          	auipc	ra,0xffffd
    800042d6:	880080e7          	jalr	-1920(ra) # 80000b52 <copyout>
    800042da:	10054363          	bltz	a0,800043e0 <exec+0x302>
    ustack[argc] = sp;
    800042de:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042e2:	0485                	addi	s1,s1,1
    800042e4:	008d8793          	addi	a5,s11,8
    800042e8:	def43823          	sd	a5,-528(s0)
    800042ec:	008db503          	ld	a0,8(s11)
    800042f0:	c911                	beqz	a0,80004304 <exec+0x226>
    if(argc >= MAXARG)
    800042f2:	09a1                	addi	s3,s3,8
    800042f4:	fb3c95e3          	bne	s9,s3,8000429e <exec+0x1c0>
  sz = sz1;
    800042f8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042fc:	4a81                	li	s5,0
    800042fe:	a84d                	j	800043b0 <exec+0x2d2>
  sp = sz;
    80004300:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004302:	4481                	li	s1,0
  ustack[argc] = 0;
    80004304:	00349793          	slli	a5,s1,0x3
    80004308:	f9078793          	addi	a5,a5,-112
    8000430c:	97a2                	add	a5,a5,s0
    8000430e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004312:	00148693          	addi	a3,s1,1
    80004316:	068e                	slli	a3,a3,0x3
    80004318:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000431c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004320:	01597663          	bgeu	s2,s5,8000432c <exec+0x24e>
  sz = sz1;
    80004324:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004328:	4a81                	li	s5,0
    8000432a:	a059                	j	800043b0 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000432c:	e9040613          	addi	a2,s0,-368
    80004330:	85ca                	mv	a1,s2
    80004332:	855a                	mv	a0,s6
    80004334:	ffffd097          	auipc	ra,0xffffd
    80004338:	81e080e7          	jalr	-2018(ra) # 80000b52 <copyout>
    8000433c:	0a054663          	bltz	a0,800043e8 <exec+0x30a>
  p->trapframe->a1 = sp;
    80004340:	058bb783          	ld	a5,88(s7)
    80004344:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004348:	de843783          	ld	a5,-536(s0)
    8000434c:	0007c703          	lbu	a4,0(a5)
    80004350:	cf11                	beqz	a4,8000436c <exec+0x28e>
    80004352:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004354:	02f00693          	li	a3,47
    80004358:	a039                	j	80004366 <exec+0x288>
      last = s+1;
    8000435a:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000435e:	0785                	addi	a5,a5,1
    80004360:	fff7c703          	lbu	a4,-1(a5)
    80004364:	c701                	beqz	a4,8000436c <exec+0x28e>
    if(*s == '/')
    80004366:	fed71ce3          	bne	a4,a3,8000435e <exec+0x280>
    8000436a:	bfc5                	j	8000435a <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    8000436c:	4641                	li	a2,16
    8000436e:	de843583          	ld	a1,-536(s0)
    80004372:	158b8513          	addi	a0,s7,344
    80004376:	ffffc097          	auipc	ra,0xffffc
    8000437a:	f98080e7          	jalr	-104(ra) # 8000030e <safestrcpy>
  oldpagetable = p->pagetable;
    8000437e:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004382:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004386:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000438a:	058bb783          	ld	a5,88(s7)
    8000438e:	e6843703          	ld	a4,-408(s0)
    80004392:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004394:	058bb783          	ld	a5,88(s7)
    80004398:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000439c:	85ea                	mv	a1,s10
    8000439e:	ffffd097          	auipc	ra,0xffffd
    800043a2:	c50080e7          	jalr	-944(ra) # 80000fee <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043a6:	0004851b          	sext.w	a0,s1
    800043aa:	bbc1                	j	8000417a <exec+0x9c>
    800043ac:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800043b0:	df843583          	ld	a1,-520(s0)
    800043b4:	855a                	mv	a0,s6
    800043b6:	ffffd097          	auipc	ra,0xffffd
    800043ba:	c38080e7          	jalr	-968(ra) # 80000fee <proc_freepagetable>
  if(ip){
    800043be:	da0a94e3          	bnez	s5,80004166 <exec+0x88>
  return -1;
    800043c2:	557d                	li	a0,-1
    800043c4:	bb5d                	j	8000417a <exec+0x9c>
    800043c6:	de943c23          	sd	s1,-520(s0)
    800043ca:	b7dd                	j	800043b0 <exec+0x2d2>
    800043cc:	de943c23          	sd	s1,-520(s0)
    800043d0:	b7c5                	j	800043b0 <exec+0x2d2>
    800043d2:	de943c23          	sd	s1,-520(s0)
    800043d6:	bfe9                	j	800043b0 <exec+0x2d2>
  sz = sz1;
    800043d8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043dc:	4a81                	li	s5,0
    800043de:	bfc9                	j	800043b0 <exec+0x2d2>
  sz = sz1;
    800043e0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043e4:	4a81                	li	s5,0
    800043e6:	b7e9                	j	800043b0 <exec+0x2d2>
  sz = sz1;
    800043e8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043ec:	4a81                	li	s5,0
    800043ee:	b7c9                	j	800043b0 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043f0:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043f4:	e0843783          	ld	a5,-504(s0)
    800043f8:	0017869b          	addiw	a3,a5,1
    800043fc:	e0d43423          	sd	a3,-504(s0)
    80004400:	e0043783          	ld	a5,-512(s0)
    80004404:	0387879b          	addiw	a5,a5,56
    80004408:	e8845703          	lhu	a4,-376(s0)
    8000440c:	e2e6d3e3          	bge	a3,a4,80004232 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004410:	2781                	sext.w	a5,a5
    80004412:	e0f43023          	sd	a5,-512(s0)
    80004416:	03800713          	li	a4,56
    8000441a:	86be                	mv	a3,a5
    8000441c:	e1840613          	addi	a2,s0,-488
    80004420:	4581                	li	a1,0
    80004422:	8556                	mv	a0,s5
    80004424:	fffff097          	auipc	ra,0xfffff
    80004428:	a76080e7          	jalr	-1418(ra) # 80002e9a <readi>
    8000442c:	03800793          	li	a5,56
    80004430:	f6f51ee3          	bne	a0,a5,800043ac <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004434:	e1842783          	lw	a5,-488(s0)
    80004438:	4705                	li	a4,1
    8000443a:	fae79de3          	bne	a5,a4,800043f4 <exec+0x316>
    if(ph.memsz < ph.filesz)
    8000443e:	e4043603          	ld	a2,-448(s0)
    80004442:	e3843783          	ld	a5,-456(s0)
    80004446:	f8f660e3          	bltu	a2,a5,800043c6 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000444a:	e2843783          	ld	a5,-472(s0)
    8000444e:	963e                	add	a2,a2,a5
    80004450:	f6f66ee3          	bltu	a2,a5,800043cc <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004454:	85a6                	mv	a1,s1
    80004456:	855a                	mv	a0,s6
    80004458:	ffffc097          	auipc	ra,0xffffc
    8000445c:	4a6080e7          	jalr	1190(ra) # 800008fe <uvmalloc>
    80004460:	dea43c23          	sd	a0,-520(s0)
    80004464:	d53d                	beqz	a0,800043d2 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    80004466:	e2843c03          	ld	s8,-472(s0)
    8000446a:	de043783          	ld	a5,-544(s0)
    8000446e:	00fc77b3          	and	a5,s8,a5
    80004472:	ff9d                	bnez	a5,800043b0 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004474:	e2042c83          	lw	s9,-480(s0)
    80004478:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000447c:	f60b8ae3          	beqz	s7,800043f0 <exec+0x312>
    80004480:	89de                	mv	s3,s7
    80004482:	4481                	li	s1,0
    80004484:	b371                	j	80004210 <exec+0x132>

0000000080004486 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004486:	7179                	addi	sp,sp,-48
    80004488:	f406                	sd	ra,40(sp)
    8000448a:	f022                	sd	s0,32(sp)
    8000448c:	ec26                	sd	s1,24(sp)
    8000448e:	e84a                	sd	s2,16(sp)
    80004490:	1800                	addi	s0,sp,48
    80004492:	892e                	mv	s2,a1
    80004494:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004496:	fdc40593          	addi	a1,s0,-36
    8000449a:	ffffe097          	auipc	ra,0xffffe
    8000449e:	ae0080e7          	jalr	-1312(ra) # 80001f7a <argint>
    800044a2:	04054063          	bltz	a0,800044e2 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044a6:	fdc42703          	lw	a4,-36(s0)
    800044aa:	47bd                	li	a5,15
    800044ac:	02e7ed63          	bltu	a5,a4,800044e6 <argfd+0x60>
    800044b0:	ffffd097          	auipc	ra,0xffffd
    800044b4:	9de080e7          	jalr	-1570(ra) # 80000e8e <myproc>
    800044b8:	fdc42703          	lw	a4,-36(s0)
    800044bc:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    800044c0:	078e                	slli	a5,a5,0x3
    800044c2:	953e                	add	a0,a0,a5
    800044c4:	611c                	ld	a5,0(a0)
    800044c6:	c395                	beqz	a5,800044ea <argfd+0x64>
    return -1;
  if(pfd)
    800044c8:	00090463          	beqz	s2,800044d0 <argfd+0x4a>
    *pfd = fd;
    800044cc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044d0:	4501                	li	a0,0
  if(pf)
    800044d2:	c091                	beqz	s1,800044d6 <argfd+0x50>
    *pf = f;
    800044d4:	e09c                	sd	a5,0(s1)
}
    800044d6:	70a2                	ld	ra,40(sp)
    800044d8:	7402                	ld	s0,32(sp)
    800044da:	64e2                	ld	s1,24(sp)
    800044dc:	6942                	ld	s2,16(sp)
    800044de:	6145                	addi	sp,sp,48
    800044e0:	8082                	ret
    return -1;
    800044e2:	557d                	li	a0,-1
    800044e4:	bfcd                	j	800044d6 <argfd+0x50>
    return -1;
    800044e6:	557d                	li	a0,-1
    800044e8:	b7fd                	j	800044d6 <argfd+0x50>
    800044ea:	557d                	li	a0,-1
    800044ec:	b7ed                	j	800044d6 <argfd+0x50>

00000000800044ee <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044ee:	1101                	addi	sp,sp,-32
    800044f0:	ec06                	sd	ra,24(sp)
    800044f2:	e822                	sd	s0,16(sp)
    800044f4:	e426                	sd	s1,8(sp)
    800044f6:	1000                	addi	s0,sp,32
    800044f8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044fa:	ffffd097          	auipc	ra,0xffffd
    800044fe:	994080e7          	jalr	-1644(ra) # 80000e8e <myproc>
    80004502:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004504:	0d050793          	addi	a5,a0,208
    80004508:	4501                	li	a0,0
    8000450a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000450c:	6398                	ld	a4,0(a5)
    8000450e:	cb19                	beqz	a4,80004524 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004510:	2505                	addiw	a0,a0,1
    80004512:	07a1                	addi	a5,a5,8
    80004514:	fed51ce3          	bne	a0,a3,8000450c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004518:	557d                	li	a0,-1
}
    8000451a:	60e2                	ld	ra,24(sp)
    8000451c:	6442                	ld	s0,16(sp)
    8000451e:	64a2                	ld	s1,8(sp)
    80004520:	6105                	addi	sp,sp,32
    80004522:	8082                	ret
      p->ofile[fd] = f;
    80004524:	01a50793          	addi	a5,a0,26
    80004528:	078e                	slli	a5,a5,0x3
    8000452a:	963e                	add	a2,a2,a5
    8000452c:	e204                	sd	s1,0(a2)
      return fd;
    8000452e:	b7f5                	j	8000451a <fdalloc+0x2c>

0000000080004530 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004530:	715d                	addi	sp,sp,-80
    80004532:	e486                	sd	ra,72(sp)
    80004534:	e0a2                	sd	s0,64(sp)
    80004536:	fc26                	sd	s1,56(sp)
    80004538:	f84a                	sd	s2,48(sp)
    8000453a:	f44e                	sd	s3,40(sp)
    8000453c:	f052                	sd	s4,32(sp)
    8000453e:	ec56                	sd	s5,24(sp)
    80004540:	0880                	addi	s0,sp,80
    80004542:	89ae                	mv	s3,a1
    80004544:	8ab2                	mv	s5,a2
    80004546:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004548:	fb040593          	addi	a1,s0,-80
    8000454c:	fffff097          	auipc	ra,0xfffff
    80004550:	e74080e7          	jalr	-396(ra) # 800033c0 <nameiparent>
    80004554:	892a                	mv	s2,a0
    80004556:	12050e63          	beqz	a0,80004692 <create+0x162>
    return 0;

  ilock(dp);
    8000455a:	ffffe097          	auipc	ra,0xffffe
    8000455e:	68c080e7          	jalr	1676(ra) # 80002be6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004562:	4601                	li	a2,0
    80004564:	fb040593          	addi	a1,s0,-80
    80004568:	854a                	mv	a0,s2
    8000456a:	fffff097          	auipc	ra,0xfffff
    8000456e:	b60080e7          	jalr	-1184(ra) # 800030ca <dirlookup>
    80004572:	84aa                	mv	s1,a0
    80004574:	c921                	beqz	a0,800045c4 <create+0x94>
    iunlockput(dp);
    80004576:	854a                	mv	a0,s2
    80004578:	fffff097          	auipc	ra,0xfffff
    8000457c:	8d0080e7          	jalr	-1840(ra) # 80002e48 <iunlockput>
    ilock(ip);
    80004580:	8526                	mv	a0,s1
    80004582:	ffffe097          	auipc	ra,0xffffe
    80004586:	664080e7          	jalr	1636(ra) # 80002be6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000458a:	2981                	sext.w	s3,s3
    8000458c:	4789                	li	a5,2
    8000458e:	02f99463          	bne	s3,a5,800045b6 <create+0x86>
    80004592:	0444d783          	lhu	a5,68(s1)
    80004596:	37f9                	addiw	a5,a5,-2
    80004598:	17c2                	slli	a5,a5,0x30
    8000459a:	93c1                	srli	a5,a5,0x30
    8000459c:	4705                	li	a4,1
    8000459e:	00f76c63          	bltu	a4,a5,800045b6 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800045a2:	8526                	mv	a0,s1
    800045a4:	60a6                	ld	ra,72(sp)
    800045a6:	6406                	ld	s0,64(sp)
    800045a8:	74e2                	ld	s1,56(sp)
    800045aa:	7942                	ld	s2,48(sp)
    800045ac:	79a2                	ld	s3,40(sp)
    800045ae:	7a02                	ld	s4,32(sp)
    800045b0:	6ae2                	ld	s5,24(sp)
    800045b2:	6161                	addi	sp,sp,80
    800045b4:	8082                	ret
    iunlockput(ip);
    800045b6:	8526                	mv	a0,s1
    800045b8:	fffff097          	auipc	ra,0xfffff
    800045bc:	890080e7          	jalr	-1904(ra) # 80002e48 <iunlockput>
    return 0;
    800045c0:	4481                	li	s1,0
    800045c2:	b7c5                	j	800045a2 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045c4:	85ce                	mv	a1,s3
    800045c6:	00092503          	lw	a0,0(s2)
    800045ca:	ffffe097          	auipc	ra,0xffffe
    800045ce:	482080e7          	jalr	1154(ra) # 80002a4c <ialloc>
    800045d2:	84aa                	mv	s1,a0
    800045d4:	c521                	beqz	a0,8000461c <create+0xec>
  ilock(ip);
    800045d6:	ffffe097          	auipc	ra,0xffffe
    800045da:	610080e7          	jalr	1552(ra) # 80002be6 <ilock>
  ip->major = major;
    800045de:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045e2:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045e6:	4a05                	li	s4,1
    800045e8:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800045ec:	8526                	mv	a0,s1
    800045ee:	ffffe097          	auipc	ra,0xffffe
    800045f2:	52c080e7          	jalr	1324(ra) # 80002b1a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045f6:	2981                	sext.w	s3,s3
    800045f8:	03498a63          	beq	s3,s4,8000462c <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045fc:	40d0                	lw	a2,4(s1)
    800045fe:	fb040593          	addi	a1,s0,-80
    80004602:	854a                	mv	a0,s2
    80004604:	fffff097          	auipc	ra,0xfffff
    80004608:	cdc080e7          	jalr	-804(ra) # 800032e0 <dirlink>
    8000460c:	06054b63          	bltz	a0,80004682 <create+0x152>
  iunlockput(dp);
    80004610:	854a                	mv	a0,s2
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	836080e7          	jalr	-1994(ra) # 80002e48 <iunlockput>
  return ip;
    8000461a:	b761                	j	800045a2 <create+0x72>
    panic("create: ialloc");
    8000461c:	00004517          	auipc	a0,0x4
    80004620:	11450513          	addi	a0,a0,276 # 80008730 <syscalls+0x2a8>
    80004624:	00001097          	auipc	ra,0x1
    80004628:	63c080e7          	jalr	1596(ra) # 80005c60 <panic>
    dp->nlink++;  // for ".."
    8000462c:	04a95783          	lhu	a5,74(s2)
    80004630:	2785                	addiw	a5,a5,1
    80004632:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004636:	854a                	mv	a0,s2
    80004638:	ffffe097          	auipc	ra,0xffffe
    8000463c:	4e2080e7          	jalr	1250(ra) # 80002b1a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004640:	40d0                	lw	a2,4(s1)
    80004642:	00004597          	auipc	a1,0x4
    80004646:	0fe58593          	addi	a1,a1,254 # 80008740 <syscalls+0x2b8>
    8000464a:	8526                	mv	a0,s1
    8000464c:	fffff097          	auipc	ra,0xfffff
    80004650:	c94080e7          	jalr	-876(ra) # 800032e0 <dirlink>
    80004654:	00054f63          	bltz	a0,80004672 <create+0x142>
    80004658:	00492603          	lw	a2,4(s2)
    8000465c:	00004597          	auipc	a1,0x4
    80004660:	0ec58593          	addi	a1,a1,236 # 80008748 <syscalls+0x2c0>
    80004664:	8526                	mv	a0,s1
    80004666:	fffff097          	auipc	ra,0xfffff
    8000466a:	c7a080e7          	jalr	-902(ra) # 800032e0 <dirlink>
    8000466e:	f80557e3          	bgez	a0,800045fc <create+0xcc>
      panic("create dots");
    80004672:	00004517          	auipc	a0,0x4
    80004676:	0de50513          	addi	a0,a0,222 # 80008750 <syscalls+0x2c8>
    8000467a:	00001097          	auipc	ra,0x1
    8000467e:	5e6080e7          	jalr	1510(ra) # 80005c60 <panic>
    panic("create: dirlink");
    80004682:	00004517          	auipc	a0,0x4
    80004686:	0de50513          	addi	a0,a0,222 # 80008760 <syscalls+0x2d8>
    8000468a:	00001097          	auipc	ra,0x1
    8000468e:	5d6080e7          	jalr	1494(ra) # 80005c60 <panic>
    return 0;
    80004692:	84aa                	mv	s1,a0
    80004694:	b739                	j	800045a2 <create+0x72>

0000000080004696 <sys_dup>:
{
    80004696:	7179                	addi	sp,sp,-48
    80004698:	f406                	sd	ra,40(sp)
    8000469a:	f022                	sd	s0,32(sp)
    8000469c:	ec26                	sd	s1,24(sp)
    8000469e:	e84a                	sd	s2,16(sp)
    800046a0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046a2:	fd840613          	addi	a2,s0,-40
    800046a6:	4581                	li	a1,0
    800046a8:	4501                	li	a0,0
    800046aa:	00000097          	auipc	ra,0x0
    800046ae:	ddc080e7          	jalr	-548(ra) # 80004486 <argfd>
    return -1;
    800046b2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046b4:	02054363          	bltz	a0,800046da <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800046b8:	fd843903          	ld	s2,-40(s0)
    800046bc:	854a                	mv	a0,s2
    800046be:	00000097          	auipc	ra,0x0
    800046c2:	e30080e7          	jalr	-464(ra) # 800044ee <fdalloc>
    800046c6:	84aa                	mv	s1,a0
    return -1;
    800046c8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046ca:	00054863          	bltz	a0,800046da <sys_dup+0x44>
  filedup(f);
    800046ce:	854a                	mv	a0,s2
    800046d0:	fffff097          	auipc	ra,0xfffff
    800046d4:	368080e7          	jalr	872(ra) # 80003a38 <filedup>
  return fd;
    800046d8:	87a6                	mv	a5,s1
}
    800046da:	853e                	mv	a0,a5
    800046dc:	70a2                	ld	ra,40(sp)
    800046de:	7402                	ld	s0,32(sp)
    800046e0:	64e2                	ld	s1,24(sp)
    800046e2:	6942                	ld	s2,16(sp)
    800046e4:	6145                	addi	sp,sp,48
    800046e6:	8082                	ret

00000000800046e8 <sys_read>:
{
    800046e8:	7179                	addi	sp,sp,-48
    800046ea:	f406                	sd	ra,40(sp)
    800046ec:	f022                	sd	s0,32(sp)
    800046ee:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f0:	fe840613          	addi	a2,s0,-24
    800046f4:	4581                	li	a1,0
    800046f6:	4501                	li	a0,0
    800046f8:	00000097          	auipc	ra,0x0
    800046fc:	d8e080e7          	jalr	-626(ra) # 80004486 <argfd>
    return -1;
    80004700:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004702:	04054163          	bltz	a0,80004744 <sys_read+0x5c>
    80004706:	fe440593          	addi	a1,s0,-28
    8000470a:	4509                	li	a0,2
    8000470c:	ffffe097          	auipc	ra,0xffffe
    80004710:	86e080e7          	jalr	-1938(ra) # 80001f7a <argint>
    return -1;
    80004714:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004716:	02054763          	bltz	a0,80004744 <sys_read+0x5c>
    8000471a:	fd840593          	addi	a1,s0,-40
    8000471e:	4505                	li	a0,1
    80004720:	ffffe097          	auipc	ra,0xffffe
    80004724:	87c080e7          	jalr	-1924(ra) # 80001f9c <argaddr>
    return -1;
    80004728:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000472a:	00054d63          	bltz	a0,80004744 <sys_read+0x5c>
  return fileread(f, p, n);
    8000472e:	fe442603          	lw	a2,-28(s0)
    80004732:	fd843583          	ld	a1,-40(s0)
    80004736:	fe843503          	ld	a0,-24(s0)
    8000473a:	fffff097          	auipc	ra,0xfffff
    8000473e:	48a080e7          	jalr	1162(ra) # 80003bc4 <fileread>
    80004742:	87aa                	mv	a5,a0
}
    80004744:	853e                	mv	a0,a5
    80004746:	70a2                	ld	ra,40(sp)
    80004748:	7402                	ld	s0,32(sp)
    8000474a:	6145                	addi	sp,sp,48
    8000474c:	8082                	ret

000000008000474e <sys_write>:
{
    8000474e:	7179                	addi	sp,sp,-48
    80004750:	f406                	sd	ra,40(sp)
    80004752:	f022                	sd	s0,32(sp)
    80004754:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004756:	fe840613          	addi	a2,s0,-24
    8000475a:	4581                	li	a1,0
    8000475c:	4501                	li	a0,0
    8000475e:	00000097          	auipc	ra,0x0
    80004762:	d28080e7          	jalr	-728(ra) # 80004486 <argfd>
    return -1;
    80004766:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004768:	04054163          	bltz	a0,800047aa <sys_write+0x5c>
    8000476c:	fe440593          	addi	a1,s0,-28
    80004770:	4509                	li	a0,2
    80004772:	ffffe097          	auipc	ra,0xffffe
    80004776:	808080e7          	jalr	-2040(ra) # 80001f7a <argint>
    return -1;
    8000477a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000477c:	02054763          	bltz	a0,800047aa <sys_write+0x5c>
    80004780:	fd840593          	addi	a1,s0,-40
    80004784:	4505                	li	a0,1
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	816080e7          	jalr	-2026(ra) # 80001f9c <argaddr>
    return -1;
    8000478e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004790:	00054d63          	bltz	a0,800047aa <sys_write+0x5c>
  return filewrite(f, p, n);
    80004794:	fe442603          	lw	a2,-28(s0)
    80004798:	fd843583          	ld	a1,-40(s0)
    8000479c:	fe843503          	ld	a0,-24(s0)
    800047a0:	fffff097          	auipc	ra,0xfffff
    800047a4:	4e6080e7          	jalr	1254(ra) # 80003c86 <filewrite>
    800047a8:	87aa                	mv	a5,a0
}
    800047aa:	853e                	mv	a0,a5
    800047ac:	70a2                	ld	ra,40(sp)
    800047ae:	7402                	ld	s0,32(sp)
    800047b0:	6145                	addi	sp,sp,48
    800047b2:	8082                	ret

00000000800047b4 <sys_close>:
{
    800047b4:	1101                	addi	sp,sp,-32
    800047b6:	ec06                	sd	ra,24(sp)
    800047b8:	e822                	sd	s0,16(sp)
    800047ba:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047bc:	fe040613          	addi	a2,s0,-32
    800047c0:	fec40593          	addi	a1,s0,-20
    800047c4:	4501                	li	a0,0
    800047c6:	00000097          	auipc	ra,0x0
    800047ca:	cc0080e7          	jalr	-832(ra) # 80004486 <argfd>
    return -1;
    800047ce:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047d0:	02054463          	bltz	a0,800047f8 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047d4:	ffffc097          	auipc	ra,0xffffc
    800047d8:	6ba080e7          	jalr	1722(ra) # 80000e8e <myproc>
    800047dc:	fec42783          	lw	a5,-20(s0)
    800047e0:	07e9                	addi	a5,a5,26
    800047e2:	078e                	slli	a5,a5,0x3
    800047e4:	953e                	add	a0,a0,a5
    800047e6:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047ea:	fe043503          	ld	a0,-32(s0)
    800047ee:	fffff097          	auipc	ra,0xfffff
    800047f2:	29c080e7          	jalr	668(ra) # 80003a8a <fileclose>
  return 0;
    800047f6:	4781                	li	a5,0
}
    800047f8:	853e                	mv	a0,a5
    800047fa:	60e2                	ld	ra,24(sp)
    800047fc:	6442                	ld	s0,16(sp)
    800047fe:	6105                	addi	sp,sp,32
    80004800:	8082                	ret

0000000080004802 <sys_fstat>:
{
    80004802:	1101                	addi	sp,sp,-32
    80004804:	ec06                	sd	ra,24(sp)
    80004806:	e822                	sd	s0,16(sp)
    80004808:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000480a:	fe840613          	addi	a2,s0,-24
    8000480e:	4581                	li	a1,0
    80004810:	4501                	li	a0,0
    80004812:	00000097          	auipc	ra,0x0
    80004816:	c74080e7          	jalr	-908(ra) # 80004486 <argfd>
    return -1;
    8000481a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000481c:	02054563          	bltz	a0,80004846 <sys_fstat+0x44>
    80004820:	fe040593          	addi	a1,s0,-32
    80004824:	4505                	li	a0,1
    80004826:	ffffd097          	auipc	ra,0xffffd
    8000482a:	776080e7          	jalr	1910(ra) # 80001f9c <argaddr>
    return -1;
    8000482e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004830:	00054b63          	bltz	a0,80004846 <sys_fstat+0x44>
  return filestat(f, st);
    80004834:	fe043583          	ld	a1,-32(s0)
    80004838:	fe843503          	ld	a0,-24(s0)
    8000483c:	fffff097          	auipc	ra,0xfffff
    80004840:	316080e7          	jalr	790(ra) # 80003b52 <filestat>
    80004844:	87aa                	mv	a5,a0
}
    80004846:	853e                	mv	a0,a5
    80004848:	60e2                	ld	ra,24(sp)
    8000484a:	6442                	ld	s0,16(sp)
    8000484c:	6105                	addi	sp,sp,32
    8000484e:	8082                	ret

0000000080004850 <sys_link>:
{
    80004850:	7169                	addi	sp,sp,-304
    80004852:	f606                	sd	ra,296(sp)
    80004854:	f222                	sd	s0,288(sp)
    80004856:	ee26                	sd	s1,280(sp)
    80004858:	ea4a                	sd	s2,272(sp)
    8000485a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000485c:	08000613          	li	a2,128
    80004860:	ed040593          	addi	a1,s0,-304
    80004864:	4501                	li	a0,0
    80004866:	ffffd097          	auipc	ra,0xffffd
    8000486a:	758080e7          	jalr	1880(ra) # 80001fbe <argstr>
    return -1;
    8000486e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004870:	10054e63          	bltz	a0,8000498c <sys_link+0x13c>
    80004874:	08000613          	li	a2,128
    80004878:	f5040593          	addi	a1,s0,-176
    8000487c:	4505                	li	a0,1
    8000487e:	ffffd097          	auipc	ra,0xffffd
    80004882:	740080e7          	jalr	1856(ra) # 80001fbe <argstr>
    return -1;
    80004886:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004888:	10054263          	bltz	a0,8000498c <sys_link+0x13c>
  begin_op();
    8000488c:	fffff097          	auipc	ra,0xfffff
    80004890:	d36080e7          	jalr	-714(ra) # 800035c2 <begin_op>
  if((ip = namei(old)) == 0){
    80004894:	ed040513          	addi	a0,s0,-304
    80004898:	fffff097          	auipc	ra,0xfffff
    8000489c:	b0a080e7          	jalr	-1270(ra) # 800033a2 <namei>
    800048a0:	84aa                	mv	s1,a0
    800048a2:	c551                	beqz	a0,8000492e <sys_link+0xde>
  ilock(ip);
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	342080e7          	jalr	834(ra) # 80002be6 <ilock>
  if(ip->type == T_DIR){
    800048ac:	04449703          	lh	a4,68(s1)
    800048b0:	4785                	li	a5,1
    800048b2:	08f70463          	beq	a4,a5,8000493a <sys_link+0xea>
  ip->nlink++;
    800048b6:	04a4d783          	lhu	a5,74(s1)
    800048ba:	2785                	addiw	a5,a5,1
    800048bc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048c0:	8526                	mv	a0,s1
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	258080e7          	jalr	600(ra) # 80002b1a <iupdate>
  iunlock(ip);
    800048ca:	8526                	mv	a0,s1
    800048cc:	ffffe097          	auipc	ra,0xffffe
    800048d0:	3dc080e7          	jalr	988(ra) # 80002ca8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048d4:	fd040593          	addi	a1,s0,-48
    800048d8:	f5040513          	addi	a0,s0,-176
    800048dc:	fffff097          	auipc	ra,0xfffff
    800048e0:	ae4080e7          	jalr	-1308(ra) # 800033c0 <nameiparent>
    800048e4:	892a                	mv	s2,a0
    800048e6:	c935                	beqz	a0,8000495a <sys_link+0x10a>
  ilock(dp);
    800048e8:	ffffe097          	auipc	ra,0xffffe
    800048ec:	2fe080e7          	jalr	766(ra) # 80002be6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048f0:	00092703          	lw	a4,0(s2)
    800048f4:	409c                	lw	a5,0(s1)
    800048f6:	04f71d63          	bne	a4,a5,80004950 <sys_link+0x100>
    800048fa:	40d0                	lw	a2,4(s1)
    800048fc:	fd040593          	addi	a1,s0,-48
    80004900:	854a                	mv	a0,s2
    80004902:	fffff097          	auipc	ra,0xfffff
    80004906:	9de080e7          	jalr	-1570(ra) # 800032e0 <dirlink>
    8000490a:	04054363          	bltz	a0,80004950 <sys_link+0x100>
  iunlockput(dp);
    8000490e:	854a                	mv	a0,s2
    80004910:	ffffe097          	auipc	ra,0xffffe
    80004914:	538080e7          	jalr	1336(ra) # 80002e48 <iunlockput>
  iput(ip);
    80004918:	8526                	mv	a0,s1
    8000491a:	ffffe097          	auipc	ra,0xffffe
    8000491e:	486080e7          	jalr	1158(ra) # 80002da0 <iput>
  end_op();
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	d1e080e7          	jalr	-738(ra) # 80003640 <end_op>
  return 0;
    8000492a:	4781                	li	a5,0
    8000492c:	a085                	j	8000498c <sys_link+0x13c>
    end_op();
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	d12080e7          	jalr	-750(ra) # 80003640 <end_op>
    return -1;
    80004936:	57fd                	li	a5,-1
    80004938:	a891                	j	8000498c <sys_link+0x13c>
    iunlockput(ip);
    8000493a:	8526                	mv	a0,s1
    8000493c:	ffffe097          	auipc	ra,0xffffe
    80004940:	50c080e7          	jalr	1292(ra) # 80002e48 <iunlockput>
    end_op();
    80004944:	fffff097          	auipc	ra,0xfffff
    80004948:	cfc080e7          	jalr	-772(ra) # 80003640 <end_op>
    return -1;
    8000494c:	57fd                	li	a5,-1
    8000494e:	a83d                	j	8000498c <sys_link+0x13c>
    iunlockput(dp);
    80004950:	854a                	mv	a0,s2
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	4f6080e7          	jalr	1270(ra) # 80002e48 <iunlockput>
  ilock(ip);
    8000495a:	8526                	mv	a0,s1
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	28a080e7          	jalr	650(ra) # 80002be6 <ilock>
  ip->nlink--;
    80004964:	04a4d783          	lhu	a5,74(s1)
    80004968:	37fd                	addiw	a5,a5,-1
    8000496a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000496e:	8526                	mv	a0,s1
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	1aa080e7          	jalr	426(ra) # 80002b1a <iupdate>
  iunlockput(ip);
    80004978:	8526                	mv	a0,s1
    8000497a:	ffffe097          	auipc	ra,0xffffe
    8000497e:	4ce080e7          	jalr	1230(ra) # 80002e48 <iunlockput>
  end_op();
    80004982:	fffff097          	auipc	ra,0xfffff
    80004986:	cbe080e7          	jalr	-834(ra) # 80003640 <end_op>
  return -1;
    8000498a:	57fd                	li	a5,-1
}
    8000498c:	853e                	mv	a0,a5
    8000498e:	70b2                	ld	ra,296(sp)
    80004990:	7412                	ld	s0,288(sp)
    80004992:	64f2                	ld	s1,280(sp)
    80004994:	6952                	ld	s2,272(sp)
    80004996:	6155                	addi	sp,sp,304
    80004998:	8082                	ret

000000008000499a <sys_unlink>:
{
    8000499a:	7151                	addi	sp,sp,-240
    8000499c:	f586                	sd	ra,232(sp)
    8000499e:	f1a2                	sd	s0,224(sp)
    800049a0:	eda6                	sd	s1,216(sp)
    800049a2:	e9ca                	sd	s2,208(sp)
    800049a4:	e5ce                	sd	s3,200(sp)
    800049a6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049a8:	08000613          	li	a2,128
    800049ac:	f3040593          	addi	a1,s0,-208
    800049b0:	4501                	li	a0,0
    800049b2:	ffffd097          	auipc	ra,0xffffd
    800049b6:	60c080e7          	jalr	1548(ra) # 80001fbe <argstr>
    800049ba:	18054163          	bltz	a0,80004b3c <sys_unlink+0x1a2>
  begin_op();
    800049be:	fffff097          	auipc	ra,0xfffff
    800049c2:	c04080e7          	jalr	-1020(ra) # 800035c2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049c6:	fb040593          	addi	a1,s0,-80
    800049ca:	f3040513          	addi	a0,s0,-208
    800049ce:	fffff097          	auipc	ra,0xfffff
    800049d2:	9f2080e7          	jalr	-1550(ra) # 800033c0 <nameiparent>
    800049d6:	84aa                	mv	s1,a0
    800049d8:	c979                	beqz	a0,80004aae <sys_unlink+0x114>
  ilock(dp);
    800049da:	ffffe097          	auipc	ra,0xffffe
    800049de:	20c080e7          	jalr	524(ra) # 80002be6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049e2:	00004597          	auipc	a1,0x4
    800049e6:	d5e58593          	addi	a1,a1,-674 # 80008740 <syscalls+0x2b8>
    800049ea:	fb040513          	addi	a0,s0,-80
    800049ee:	ffffe097          	auipc	ra,0xffffe
    800049f2:	6c2080e7          	jalr	1730(ra) # 800030b0 <namecmp>
    800049f6:	14050a63          	beqz	a0,80004b4a <sys_unlink+0x1b0>
    800049fa:	00004597          	auipc	a1,0x4
    800049fe:	d4e58593          	addi	a1,a1,-690 # 80008748 <syscalls+0x2c0>
    80004a02:	fb040513          	addi	a0,s0,-80
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	6aa080e7          	jalr	1706(ra) # 800030b0 <namecmp>
    80004a0e:	12050e63          	beqz	a0,80004b4a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a12:	f2c40613          	addi	a2,s0,-212
    80004a16:	fb040593          	addi	a1,s0,-80
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	6ae080e7          	jalr	1710(ra) # 800030ca <dirlookup>
    80004a24:	892a                	mv	s2,a0
    80004a26:	12050263          	beqz	a0,80004b4a <sys_unlink+0x1b0>
  ilock(ip);
    80004a2a:	ffffe097          	auipc	ra,0xffffe
    80004a2e:	1bc080e7          	jalr	444(ra) # 80002be6 <ilock>
  if(ip->nlink < 1)
    80004a32:	04a91783          	lh	a5,74(s2)
    80004a36:	08f05263          	blez	a5,80004aba <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a3a:	04491703          	lh	a4,68(s2)
    80004a3e:	4785                	li	a5,1
    80004a40:	08f70563          	beq	a4,a5,80004aca <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a44:	4641                	li	a2,16
    80004a46:	4581                	li	a1,0
    80004a48:	fc040513          	addi	a0,s0,-64
    80004a4c:	ffffb097          	auipc	ra,0xffffb
    80004a50:	778080e7          	jalr	1912(ra) # 800001c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a54:	4741                	li	a4,16
    80004a56:	f2c42683          	lw	a3,-212(s0)
    80004a5a:	fc040613          	addi	a2,s0,-64
    80004a5e:	4581                	li	a1,0
    80004a60:	8526                	mv	a0,s1
    80004a62:	ffffe097          	auipc	ra,0xffffe
    80004a66:	530080e7          	jalr	1328(ra) # 80002f92 <writei>
    80004a6a:	47c1                	li	a5,16
    80004a6c:	0af51563          	bne	a0,a5,80004b16 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a70:	04491703          	lh	a4,68(s2)
    80004a74:	4785                	li	a5,1
    80004a76:	0af70863          	beq	a4,a5,80004b26 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	3cc080e7          	jalr	972(ra) # 80002e48 <iunlockput>
  ip->nlink--;
    80004a84:	04a95783          	lhu	a5,74(s2)
    80004a88:	37fd                	addiw	a5,a5,-1
    80004a8a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a8e:	854a                	mv	a0,s2
    80004a90:	ffffe097          	auipc	ra,0xffffe
    80004a94:	08a080e7          	jalr	138(ra) # 80002b1a <iupdate>
  iunlockput(ip);
    80004a98:	854a                	mv	a0,s2
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	3ae080e7          	jalr	942(ra) # 80002e48 <iunlockput>
  end_op();
    80004aa2:	fffff097          	auipc	ra,0xfffff
    80004aa6:	b9e080e7          	jalr	-1122(ra) # 80003640 <end_op>
  return 0;
    80004aaa:	4501                	li	a0,0
    80004aac:	a84d                	j	80004b5e <sys_unlink+0x1c4>
    end_op();
    80004aae:	fffff097          	auipc	ra,0xfffff
    80004ab2:	b92080e7          	jalr	-1134(ra) # 80003640 <end_op>
    return -1;
    80004ab6:	557d                	li	a0,-1
    80004ab8:	a05d                	j	80004b5e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004aba:	00004517          	auipc	a0,0x4
    80004abe:	cb650513          	addi	a0,a0,-842 # 80008770 <syscalls+0x2e8>
    80004ac2:	00001097          	auipc	ra,0x1
    80004ac6:	19e080e7          	jalr	414(ra) # 80005c60 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aca:	04c92703          	lw	a4,76(s2)
    80004ace:	02000793          	li	a5,32
    80004ad2:	f6e7f9e3          	bgeu	a5,a4,80004a44 <sys_unlink+0xaa>
    80004ad6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ada:	4741                	li	a4,16
    80004adc:	86ce                	mv	a3,s3
    80004ade:	f1840613          	addi	a2,s0,-232
    80004ae2:	4581                	li	a1,0
    80004ae4:	854a                	mv	a0,s2
    80004ae6:	ffffe097          	auipc	ra,0xffffe
    80004aea:	3b4080e7          	jalr	948(ra) # 80002e9a <readi>
    80004aee:	47c1                	li	a5,16
    80004af0:	00f51b63          	bne	a0,a5,80004b06 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004af4:	f1845783          	lhu	a5,-232(s0)
    80004af8:	e7a1                	bnez	a5,80004b40 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004afa:	29c1                	addiw	s3,s3,16
    80004afc:	04c92783          	lw	a5,76(s2)
    80004b00:	fcf9ede3          	bltu	s3,a5,80004ada <sys_unlink+0x140>
    80004b04:	b781                	j	80004a44 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b06:	00004517          	auipc	a0,0x4
    80004b0a:	c8250513          	addi	a0,a0,-894 # 80008788 <syscalls+0x300>
    80004b0e:	00001097          	auipc	ra,0x1
    80004b12:	152080e7          	jalr	338(ra) # 80005c60 <panic>
    panic("unlink: writei");
    80004b16:	00004517          	auipc	a0,0x4
    80004b1a:	c8a50513          	addi	a0,a0,-886 # 800087a0 <syscalls+0x318>
    80004b1e:	00001097          	auipc	ra,0x1
    80004b22:	142080e7          	jalr	322(ra) # 80005c60 <panic>
    dp->nlink--;
    80004b26:	04a4d783          	lhu	a5,74(s1)
    80004b2a:	37fd                	addiw	a5,a5,-1
    80004b2c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b30:	8526                	mv	a0,s1
    80004b32:	ffffe097          	auipc	ra,0xffffe
    80004b36:	fe8080e7          	jalr	-24(ra) # 80002b1a <iupdate>
    80004b3a:	b781                	j	80004a7a <sys_unlink+0xe0>
    return -1;
    80004b3c:	557d                	li	a0,-1
    80004b3e:	a005                	j	80004b5e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b40:	854a                	mv	a0,s2
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	306080e7          	jalr	774(ra) # 80002e48 <iunlockput>
  iunlockput(dp);
    80004b4a:	8526                	mv	a0,s1
    80004b4c:	ffffe097          	auipc	ra,0xffffe
    80004b50:	2fc080e7          	jalr	764(ra) # 80002e48 <iunlockput>
  end_op();
    80004b54:	fffff097          	auipc	ra,0xfffff
    80004b58:	aec080e7          	jalr	-1300(ra) # 80003640 <end_op>
  return -1;
    80004b5c:	557d                	li	a0,-1
}
    80004b5e:	70ae                	ld	ra,232(sp)
    80004b60:	740e                	ld	s0,224(sp)
    80004b62:	64ee                	ld	s1,216(sp)
    80004b64:	694e                	ld	s2,208(sp)
    80004b66:	69ae                	ld	s3,200(sp)
    80004b68:	616d                	addi	sp,sp,240
    80004b6a:	8082                	ret

0000000080004b6c <sys_open>:

uint64
sys_open(void)
{
    80004b6c:	7131                	addi	sp,sp,-192
    80004b6e:	fd06                	sd	ra,184(sp)
    80004b70:	f922                	sd	s0,176(sp)
    80004b72:	f526                	sd	s1,168(sp)
    80004b74:	f14a                	sd	s2,160(sp)
    80004b76:	ed4e                	sd	s3,152(sp)
    80004b78:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b7a:	08000613          	li	a2,128
    80004b7e:	f5040593          	addi	a1,s0,-176
    80004b82:	4501                	li	a0,0
    80004b84:	ffffd097          	auipc	ra,0xffffd
    80004b88:	43a080e7          	jalr	1082(ra) # 80001fbe <argstr>
    return -1;
    80004b8c:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b8e:	0c054163          	bltz	a0,80004c50 <sys_open+0xe4>
    80004b92:	f4c40593          	addi	a1,s0,-180
    80004b96:	4505                	li	a0,1
    80004b98:	ffffd097          	auipc	ra,0xffffd
    80004b9c:	3e2080e7          	jalr	994(ra) # 80001f7a <argint>
    80004ba0:	0a054863          	bltz	a0,80004c50 <sys_open+0xe4>

  begin_op();
    80004ba4:	fffff097          	auipc	ra,0xfffff
    80004ba8:	a1e080e7          	jalr	-1506(ra) # 800035c2 <begin_op>

  if(omode & O_CREATE){
    80004bac:	f4c42783          	lw	a5,-180(s0)
    80004bb0:	2007f793          	andi	a5,a5,512
    80004bb4:	cbdd                	beqz	a5,80004c6a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004bb6:	4681                	li	a3,0
    80004bb8:	4601                	li	a2,0
    80004bba:	4589                	li	a1,2
    80004bbc:	f5040513          	addi	a0,s0,-176
    80004bc0:	00000097          	auipc	ra,0x0
    80004bc4:	970080e7          	jalr	-1680(ra) # 80004530 <create>
    80004bc8:	892a                	mv	s2,a0
    if(ip == 0){
    80004bca:	c959                	beqz	a0,80004c60 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bcc:	04491703          	lh	a4,68(s2)
    80004bd0:	478d                	li	a5,3
    80004bd2:	00f71763          	bne	a4,a5,80004be0 <sys_open+0x74>
    80004bd6:	04695703          	lhu	a4,70(s2)
    80004bda:	47a5                	li	a5,9
    80004bdc:	0ce7ec63          	bltu	a5,a4,80004cb4 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004be0:	fffff097          	auipc	ra,0xfffff
    80004be4:	dee080e7          	jalr	-530(ra) # 800039ce <filealloc>
    80004be8:	89aa                	mv	s3,a0
    80004bea:	10050263          	beqz	a0,80004cee <sys_open+0x182>
    80004bee:	00000097          	auipc	ra,0x0
    80004bf2:	900080e7          	jalr	-1792(ra) # 800044ee <fdalloc>
    80004bf6:	84aa                	mv	s1,a0
    80004bf8:	0e054663          	bltz	a0,80004ce4 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bfc:	04491703          	lh	a4,68(s2)
    80004c00:	478d                	li	a5,3
    80004c02:	0cf70463          	beq	a4,a5,80004cca <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c06:	4789                	li	a5,2
    80004c08:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c0c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c10:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c14:	f4c42783          	lw	a5,-180(s0)
    80004c18:	0017c713          	xori	a4,a5,1
    80004c1c:	8b05                	andi	a4,a4,1
    80004c1e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c22:	0037f713          	andi	a4,a5,3
    80004c26:	00e03733          	snez	a4,a4
    80004c2a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c2e:	4007f793          	andi	a5,a5,1024
    80004c32:	c791                	beqz	a5,80004c3e <sys_open+0xd2>
    80004c34:	04491703          	lh	a4,68(s2)
    80004c38:	4789                	li	a5,2
    80004c3a:	08f70f63          	beq	a4,a5,80004cd8 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c3e:	854a                	mv	a0,s2
    80004c40:	ffffe097          	auipc	ra,0xffffe
    80004c44:	068080e7          	jalr	104(ra) # 80002ca8 <iunlock>
  end_op();
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	9f8080e7          	jalr	-1544(ra) # 80003640 <end_op>

  return fd;
}
    80004c50:	8526                	mv	a0,s1
    80004c52:	70ea                	ld	ra,184(sp)
    80004c54:	744a                	ld	s0,176(sp)
    80004c56:	74aa                	ld	s1,168(sp)
    80004c58:	790a                	ld	s2,160(sp)
    80004c5a:	69ea                	ld	s3,152(sp)
    80004c5c:	6129                	addi	sp,sp,192
    80004c5e:	8082                	ret
      end_op();
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	9e0080e7          	jalr	-1568(ra) # 80003640 <end_op>
      return -1;
    80004c68:	b7e5                	j	80004c50 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c6a:	f5040513          	addi	a0,s0,-176
    80004c6e:	ffffe097          	auipc	ra,0xffffe
    80004c72:	734080e7          	jalr	1844(ra) # 800033a2 <namei>
    80004c76:	892a                	mv	s2,a0
    80004c78:	c905                	beqz	a0,80004ca8 <sys_open+0x13c>
    ilock(ip);
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	f6c080e7          	jalr	-148(ra) # 80002be6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c82:	04491703          	lh	a4,68(s2)
    80004c86:	4785                	li	a5,1
    80004c88:	f4f712e3          	bne	a4,a5,80004bcc <sys_open+0x60>
    80004c8c:	f4c42783          	lw	a5,-180(s0)
    80004c90:	dba1                	beqz	a5,80004be0 <sys_open+0x74>
      iunlockput(ip);
    80004c92:	854a                	mv	a0,s2
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	1b4080e7          	jalr	436(ra) # 80002e48 <iunlockput>
      end_op();
    80004c9c:	fffff097          	auipc	ra,0xfffff
    80004ca0:	9a4080e7          	jalr	-1628(ra) # 80003640 <end_op>
      return -1;
    80004ca4:	54fd                	li	s1,-1
    80004ca6:	b76d                	j	80004c50 <sys_open+0xe4>
      end_op();
    80004ca8:	fffff097          	auipc	ra,0xfffff
    80004cac:	998080e7          	jalr	-1640(ra) # 80003640 <end_op>
      return -1;
    80004cb0:	54fd                	li	s1,-1
    80004cb2:	bf79                	j	80004c50 <sys_open+0xe4>
    iunlockput(ip);
    80004cb4:	854a                	mv	a0,s2
    80004cb6:	ffffe097          	auipc	ra,0xffffe
    80004cba:	192080e7          	jalr	402(ra) # 80002e48 <iunlockput>
    end_op();
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	982080e7          	jalr	-1662(ra) # 80003640 <end_op>
    return -1;
    80004cc6:	54fd                	li	s1,-1
    80004cc8:	b761                	j	80004c50 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cca:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cce:	04691783          	lh	a5,70(s2)
    80004cd2:	02f99223          	sh	a5,36(s3)
    80004cd6:	bf2d                	j	80004c10 <sys_open+0xa4>
    itrunc(ip);
    80004cd8:	854a                	mv	a0,s2
    80004cda:	ffffe097          	auipc	ra,0xffffe
    80004cde:	01a080e7          	jalr	26(ra) # 80002cf4 <itrunc>
    80004ce2:	bfb1                	j	80004c3e <sys_open+0xd2>
      fileclose(f);
    80004ce4:	854e                	mv	a0,s3
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	da4080e7          	jalr	-604(ra) # 80003a8a <fileclose>
    iunlockput(ip);
    80004cee:	854a                	mv	a0,s2
    80004cf0:	ffffe097          	auipc	ra,0xffffe
    80004cf4:	158080e7          	jalr	344(ra) # 80002e48 <iunlockput>
    end_op();
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	948080e7          	jalr	-1720(ra) # 80003640 <end_op>
    return -1;
    80004d00:	54fd                	li	s1,-1
    80004d02:	b7b9                	j	80004c50 <sys_open+0xe4>

0000000080004d04 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d04:	7175                	addi	sp,sp,-144
    80004d06:	e506                	sd	ra,136(sp)
    80004d08:	e122                	sd	s0,128(sp)
    80004d0a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d0c:	fffff097          	auipc	ra,0xfffff
    80004d10:	8b6080e7          	jalr	-1866(ra) # 800035c2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d14:	08000613          	li	a2,128
    80004d18:	f7040593          	addi	a1,s0,-144
    80004d1c:	4501                	li	a0,0
    80004d1e:	ffffd097          	auipc	ra,0xffffd
    80004d22:	2a0080e7          	jalr	672(ra) # 80001fbe <argstr>
    80004d26:	02054963          	bltz	a0,80004d58 <sys_mkdir+0x54>
    80004d2a:	4681                	li	a3,0
    80004d2c:	4601                	li	a2,0
    80004d2e:	4585                	li	a1,1
    80004d30:	f7040513          	addi	a0,s0,-144
    80004d34:	fffff097          	auipc	ra,0xfffff
    80004d38:	7fc080e7          	jalr	2044(ra) # 80004530 <create>
    80004d3c:	cd11                	beqz	a0,80004d58 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d3e:	ffffe097          	auipc	ra,0xffffe
    80004d42:	10a080e7          	jalr	266(ra) # 80002e48 <iunlockput>
  end_op();
    80004d46:	fffff097          	auipc	ra,0xfffff
    80004d4a:	8fa080e7          	jalr	-1798(ra) # 80003640 <end_op>
  return 0;
    80004d4e:	4501                	li	a0,0
}
    80004d50:	60aa                	ld	ra,136(sp)
    80004d52:	640a                	ld	s0,128(sp)
    80004d54:	6149                	addi	sp,sp,144
    80004d56:	8082                	ret
    end_op();
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	8e8080e7          	jalr	-1816(ra) # 80003640 <end_op>
    return -1;
    80004d60:	557d                	li	a0,-1
    80004d62:	b7fd                	j	80004d50 <sys_mkdir+0x4c>

0000000080004d64 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d64:	7135                	addi	sp,sp,-160
    80004d66:	ed06                	sd	ra,152(sp)
    80004d68:	e922                	sd	s0,144(sp)
    80004d6a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	856080e7          	jalr	-1962(ra) # 800035c2 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d74:	08000613          	li	a2,128
    80004d78:	f7040593          	addi	a1,s0,-144
    80004d7c:	4501                	li	a0,0
    80004d7e:	ffffd097          	auipc	ra,0xffffd
    80004d82:	240080e7          	jalr	576(ra) # 80001fbe <argstr>
    80004d86:	04054a63          	bltz	a0,80004dda <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d8a:	f6c40593          	addi	a1,s0,-148
    80004d8e:	4505                	li	a0,1
    80004d90:	ffffd097          	auipc	ra,0xffffd
    80004d94:	1ea080e7          	jalr	490(ra) # 80001f7a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d98:	04054163          	bltz	a0,80004dda <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d9c:	f6840593          	addi	a1,s0,-152
    80004da0:	4509                	li	a0,2
    80004da2:	ffffd097          	auipc	ra,0xffffd
    80004da6:	1d8080e7          	jalr	472(ra) # 80001f7a <argint>
     argint(1, &major) < 0 ||
    80004daa:	02054863          	bltz	a0,80004dda <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004dae:	f6841683          	lh	a3,-152(s0)
    80004db2:	f6c41603          	lh	a2,-148(s0)
    80004db6:	458d                	li	a1,3
    80004db8:	f7040513          	addi	a0,s0,-144
    80004dbc:	fffff097          	auipc	ra,0xfffff
    80004dc0:	774080e7          	jalr	1908(ra) # 80004530 <create>
     argint(2, &minor) < 0 ||
    80004dc4:	c919                	beqz	a0,80004dda <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dc6:	ffffe097          	auipc	ra,0xffffe
    80004dca:	082080e7          	jalr	130(ra) # 80002e48 <iunlockput>
  end_op();
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	872080e7          	jalr	-1934(ra) # 80003640 <end_op>
  return 0;
    80004dd6:	4501                	li	a0,0
    80004dd8:	a031                	j	80004de4 <sys_mknod+0x80>
    end_op();
    80004dda:	fffff097          	auipc	ra,0xfffff
    80004dde:	866080e7          	jalr	-1946(ra) # 80003640 <end_op>
    return -1;
    80004de2:	557d                	li	a0,-1
}
    80004de4:	60ea                	ld	ra,152(sp)
    80004de6:	644a                	ld	s0,144(sp)
    80004de8:	610d                	addi	sp,sp,160
    80004dea:	8082                	ret

0000000080004dec <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dec:	7135                	addi	sp,sp,-160
    80004dee:	ed06                	sd	ra,152(sp)
    80004df0:	e922                	sd	s0,144(sp)
    80004df2:	e526                	sd	s1,136(sp)
    80004df4:	e14a                	sd	s2,128(sp)
    80004df6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004df8:	ffffc097          	auipc	ra,0xffffc
    80004dfc:	096080e7          	jalr	150(ra) # 80000e8e <myproc>
    80004e00:	892a                	mv	s2,a0
  
  begin_op();
    80004e02:	ffffe097          	auipc	ra,0xffffe
    80004e06:	7c0080e7          	jalr	1984(ra) # 800035c2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e0a:	08000613          	li	a2,128
    80004e0e:	f6040593          	addi	a1,s0,-160
    80004e12:	4501                	li	a0,0
    80004e14:	ffffd097          	auipc	ra,0xffffd
    80004e18:	1aa080e7          	jalr	426(ra) # 80001fbe <argstr>
    80004e1c:	04054b63          	bltz	a0,80004e72 <sys_chdir+0x86>
    80004e20:	f6040513          	addi	a0,s0,-160
    80004e24:	ffffe097          	auipc	ra,0xffffe
    80004e28:	57e080e7          	jalr	1406(ra) # 800033a2 <namei>
    80004e2c:	84aa                	mv	s1,a0
    80004e2e:	c131                	beqz	a0,80004e72 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e30:	ffffe097          	auipc	ra,0xffffe
    80004e34:	db6080e7          	jalr	-586(ra) # 80002be6 <ilock>
  if(ip->type != T_DIR){
    80004e38:	04449703          	lh	a4,68(s1)
    80004e3c:	4785                	li	a5,1
    80004e3e:	04f71063          	bne	a4,a5,80004e7e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e42:	8526                	mv	a0,s1
    80004e44:	ffffe097          	auipc	ra,0xffffe
    80004e48:	e64080e7          	jalr	-412(ra) # 80002ca8 <iunlock>
  iput(p->cwd);
    80004e4c:	15093503          	ld	a0,336(s2)
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	f50080e7          	jalr	-176(ra) # 80002da0 <iput>
  end_op();
    80004e58:	ffffe097          	auipc	ra,0xffffe
    80004e5c:	7e8080e7          	jalr	2024(ra) # 80003640 <end_op>
  p->cwd = ip;
    80004e60:	14993823          	sd	s1,336(s2)
  return 0;
    80004e64:	4501                	li	a0,0
}
    80004e66:	60ea                	ld	ra,152(sp)
    80004e68:	644a                	ld	s0,144(sp)
    80004e6a:	64aa                	ld	s1,136(sp)
    80004e6c:	690a                	ld	s2,128(sp)
    80004e6e:	610d                	addi	sp,sp,160
    80004e70:	8082                	ret
    end_op();
    80004e72:	ffffe097          	auipc	ra,0xffffe
    80004e76:	7ce080e7          	jalr	1998(ra) # 80003640 <end_op>
    return -1;
    80004e7a:	557d                	li	a0,-1
    80004e7c:	b7ed                	j	80004e66 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e7e:	8526                	mv	a0,s1
    80004e80:	ffffe097          	auipc	ra,0xffffe
    80004e84:	fc8080e7          	jalr	-56(ra) # 80002e48 <iunlockput>
    end_op();
    80004e88:	ffffe097          	auipc	ra,0xffffe
    80004e8c:	7b8080e7          	jalr	1976(ra) # 80003640 <end_op>
    return -1;
    80004e90:	557d                	li	a0,-1
    80004e92:	bfd1                	j	80004e66 <sys_chdir+0x7a>

0000000080004e94 <sys_exec>:

uint64
sys_exec(void)
{
    80004e94:	7145                	addi	sp,sp,-464
    80004e96:	e786                	sd	ra,456(sp)
    80004e98:	e3a2                	sd	s0,448(sp)
    80004e9a:	ff26                	sd	s1,440(sp)
    80004e9c:	fb4a                	sd	s2,432(sp)
    80004e9e:	f74e                	sd	s3,424(sp)
    80004ea0:	f352                	sd	s4,416(sp)
    80004ea2:	ef56                	sd	s5,408(sp)
    80004ea4:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ea6:	08000613          	li	a2,128
    80004eaa:	f4040593          	addi	a1,s0,-192
    80004eae:	4501                	li	a0,0
    80004eb0:	ffffd097          	auipc	ra,0xffffd
    80004eb4:	10e080e7          	jalr	270(ra) # 80001fbe <argstr>
    return -1;
    80004eb8:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004eba:	0c054b63          	bltz	a0,80004f90 <sys_exec+0xfc>
    80004ebe:	e3840593          	addi	a1,s0,-456
    80004ec2:	4505                	li	a0,1
    80004ec4:	ffffd097          	auipc	ra,0xffffd
    80004ec8:	0d8080e7          	jalr	216(ra) # 80001f9c <argaddr>
    80004ecc:	0c054263          	bltz	a0,80004f90 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004ed0:	10000613          	li	a2,256
    80004ed4:	4581                	li	a1,0
    80004ed6:	e4040513          	addi	a0,s0,-448
    80004eda:	ffffb097          	auipc	ra,0xffffb
    80004ede:	2ea080e7          	jalr	746(ra) # 800001c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ee2:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ee6:	89a6                	mv	s3,s1
    80004ee8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004eea:	02000a13          	li	s4,32
    80004eee:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ef2:	00391513          	slli	a0,s2,0x3
    80004ef6:	e3040593          	addi	a1,s0,-464
    80004efa:	e3843783          	ld	a5,-456(s0)
    80004efe:	953e                	add	a0,a0,a5
    80004f00:	ffffd097          	auipc	ra,0xffffd
    80004f04:	fe0080e7          	jalr	-32(ra) # 80001ee0 <fetchaddr>
    80004f08:	02054a63          	bltz	a0,80004f3c <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004f0c:	e3043783          	ld	a5,-464(s0)
    80004f10:	c3b9                	beqz	a5,80004f56 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f12:	ffffb097          	auipc	ra,0xffffb
    80004f16:	208080e7          	jalr	520(ra) # 8000011a <kalloc>
    80004f1a:	85aa                	mv	a1,a0
    80004f1c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f20:	cd11                	beqz	a0,80004f3c <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f22:	6605                	lui	a2,0x1
    80004f24:	e3043503          	ld	a0,-464(s0)
    80004f28:	ffffd097          	auipc	ra,0xffffd
    80004f2c:	00a080e7          	jalr	10(ra) # 80001f32 <fetchstr>
    80004f30:	00054663          	bltz	a0,80004f3c <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f34:	0905                	addi	s2,s2,1
    80004f36:	09a1                	addi	s3,s3,8
    80004f38:	fb491be3          	bne	s2,s4,80004eee <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f3c:	f4040913          	addi	s2,s0,-192
    80004f40:	6088                	ld	a0,0(s1)
    80004f42:	c531                	beqz	a0,80004f8e <sys_exec+0xfa>
    kfree(argv[i]);
    80004f44:	ffffb097          	auipc	ra,0xffffb
    80004f48:	0d8080e7          	jalr	216(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f4c:	04a1                	addi	s1,s1,8
    80004f4e:	ff2499e3          	bne	s1,s2,80004f40 <sys_exec+0xac>
  return -1;
    80004f52:	597d                	li	s2,-1
    80004f54:	a835                	j	80004f90 <sys_exec+0xfc>
      argv[i] = 0;
    80004f56:	0a8e                	slli	s5,s5,0x3
    80004f58:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    80004f5c:	00878ab3          	add	s5,a5,s0
    80004f60:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f64:	e4040593          	addi	a1,s0,-448
    80004f68:	f4040513          	addi	a0,s0,-192
    80004f6c:	fffff097          	auipc	ra,0xfffff
    80004f70:	172080e7          	jalr	370(ra) # 800040de <exec>
    80004f74:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f76:	f4040993          	addi	s3,s0,-192
    80004f7a:	6088                	ld	a0,0(s1)
    80004f7c:	c911                	beqz	a0,80004f90 <sys_exec+0xfc>
    kfree(argv[i]);
    80004f7e:	ffffb097          	auipc	ra,0xffffb
    80004f82:	09e080e7          	jalr	158(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f86:	04a1                	addi	s1,s1,8
    80004f88:	ff3499e3          	bne	s1,s3,80004f7a <sys_exec+0xe6>
    80004f8c:	a011                	j	80004f90 <sys_exec+0xfc>
  return -1;
    80004f8e:	597d                	li	s2,-1
}
    80004f90:	854a                	mv	a0,s2
    80004f92:	60be                	ld	ra,456(sp)
    80004f94:	641e                	ld	s0,448(sp)
    80004f96:	74fa                	ld	s1,440(sp)
    80004f98:	795a                	ld	s2,432(sp)
    80004f9a:	79ba                	ld	s3,424(sp)
    80004f9c:	7a1a                	ld	s4,416(sp)
    80004f9e:	6afa                	ld	s5,408(sp)
    80004fa0:	6179                	addi	sp,sp,464
    80004fa2:	8082                	ret

0000000080004fa4 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fa4:	7139                	addi	sp,sp,-64
    80004fa6:	fc06                	sd	ra,56(sp)
    80004fa8:	f822                	sd	s0,48(sp)
    80004faa:	f426                	sd	s1,40(sp)
    80004fac:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fae:	ffffc097          	auipc	ra,0xffffc
    80004fb2:	ee0080e7          	jalr	-288(ra) # 80000e8e <myproc>
    80004fb6:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004fb8:	fd840593          	addi	a1,s0,-40
    80004fbc:	4501                	li	a0,0
    80004fbe:	ffffd097          	auipc	ra,0xffffd
    80004fc2:	fde080e7          	jalr	-34(ra) # 80001f9c <argaddr>
    return -1;
    80004fc6:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fc8:	0e054063          	bltz	a0,800050a8 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fcc:	fc840593          	addi	a1,s0,-56
    80004fd0:	fd040513          	addi	a0,s0,-48
    80004fd4:	fffff097          	auipc	ra,0xfffff
    80004fd8:	de6080e7          	jalr	-538(ra) # 80003dba <pipealloc>
    return -1;
    80004fdc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fde:	0c054563          	bltz	a0,800050a8 <sys_pipe+0x104>
  fd0 = -1;
    80004fe2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fe6:	fd043503          	ld	a0,-48(s0)
    80004fea:	fffff097          	auipc	ra,0xfffff
    80004fee:	504080e7          	jalr	1284(ra) # 800044ee <fdalloc>
    80004ff2:	fca42223          	sw	a0,-60(s0)
    80004ff6:	08054c63          	bltz	a0,8000508e <sys_pipe+0xea>
    80004ffa:	fc843503          	ld	a0,-56(s0)
    80004ffe:	fffff097          	auipc	ra,0xfffff
    80005002:	4f0080e7          	jalr	1264(ra) # 800044ee <fdalloc>
    80005006:	fca42023          	sw	a0,-64(s0)
    8000500a:	06054963          	bltz	a0,8000507c <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000500e:	4691                	li	a3,4
    80005010:	fc440613          	addi	a2,s0,-60
    80005014:	fd843583          	ld	a1,-40(s0)
    80005018:	68a8                	ld	a0,80(s1)
    8000501a:	ffffc097          	auipc	ra,0xffffc
    8000501e:	b38080e7          	jalr	-1224(ra) # 80000b52 <copyout>
    80005022:	02054063          	bltz	a0,80005042 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005026:	4691                	li	a3,4
    80005028:	fc040613          	addi	a2,s0,-64
    8000502c:	fd843583          	ld	a1,-40(s0)
    80005030:	0591                	addi	a1,a1,4
    80005032:	68a8                	ld	a0,80(s1)
    80005034:	ffffc097          	auipc	ra,0xffffc
    80005038:	b1e080e7          	jalr	-1250(ra) # 80000b52 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000503c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000503e:	06055563          	bgez	a0,800050a8 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005042:	fc442783          	lw	a5,-60(s0)
    80005046:	07e9                	addi	a5,a5,26
    80005048:	078e                	slli	a5,a5,0x3
    8000504a:	97a6                	add	a5,a5,s1
    8000504c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005050:	fc042783          	lw	a5,-64(s0)
    80005054:	07e9                	addi	a5,a5,26
    80005056:	078e                	slli	a5,a5,0x3
    80005058:	00f48533          	add	a0,s1,a5
    8000505c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005060:	fd043503          	ld	a0,-48(s0)
    80005064:	fffff097          	auipc	ra,0xfffff
    80005068:	a26080e7          	jalr	-1498(ra) # 80003a8a <fileclose>
    fileclose(wf);
    8000506c:	fc843503          	ld	a0,-56(s0)
    80005070:	fffff097          	auipc	ra,0xfffff
    80005074:	a1a080e7          	jalr	-1510(ra) # 80003a8a <fileclose>
    return -1;
    80005078:	57fd                	li	a5,-1
    8000507a:	a03d                	j	800050a8 <sys_pipe+0x104>
    if(fd0 >= 0)
    8000507c:	fc442783          	lw	a5,-60(s0)
    80005080:	0007c763          	bltz	a5,8000508e <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005084:	07e9                	addi	a5,a5,26
    80005086:	078e                	slli	a5,a5,0x3
    80005088:	97a6                	add	a5,a5,s1
    8000508a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000508e:	fd043503          	ld	a0,-48(s0)
    80005092:	fffff097          	auipc	ra,0xfffff
    80005096:	9f8080e7          	jalr	-1544(ra) # 80003a8a <fileclose>
    fileclose(wf);
    8000509a:	fc843503          	ld	a0,-56(s0)
    8000509e:	fffff097          	auipc	ra,0xfffff
    800050a2:	9ec080e7          	jalr	-1556(ra) # 80003a8a <fileclose>
    return -1;
    800050a6:	57fd                	li	a5,-1
}
    800050a8:	853e                	mv	a0,a5
    800050aa:	70e2                	ld	ra,56(sp)
    800050ac:	7442                	ld	s0,48(sp)
    800050ae:	74a2                	ld	s1,40(sp)
    800050b0:	6121                	addi	sp,sp,64
    800050b2:	8082                	ret
	...

00000000800050c0 <kernelvec>:
    800050c0:	7111                	addi	sp,sp,-256
    800050c2:	e006                	sd	ra,0(sp)
    800050c4:	e40a                	sd	sp,8(sp)
    800050c6:	e80e                	sd	gp,16(sp)
    800050c8:	ec12                	sd	tp,24(sp)
    800050ca:	f016                	sd	t0,32(sp)
    800050cc:	f41a                	sd	t1,40(sp)
    800050ce:	f81e                	sd	t2,48(sp)
    800050d0:	fc22                	sd	s0,56(sp)
    800050d2:	e0a6                	sd	s1,64(sp)
    800050d4:	e4aa                	sd	a0,72(sp)
    800050d6:	e8ae                	sd	a1,80(sp)
    800050d8:	ecb2                	sd	a2,88(sp)
    800050da:	f0b6                	sd	a3,96(sp)
    800050dc:	f4ba                	sd	a4,104(sp)
    800050de:	f8be                	sd	a5,112(sp)
    800050e0:	fcc2                	sd	a6,120(sp)
    800050e2:	e146                	sd	a7,128(sp)
    800050e4:	e54a                	sd	s2,136(sp)
    800050e6:	e94e                	sd	s3,144(sp)
    800050e8:	ed52                	sd	s4,152(sp)
    800050ea:	f156                	sd	s5,160(sp)
    800050ec:	f55a                	sd	s6,168(sp)
    800050ee:	f95e                	sd	s7,176(sp)
    800050f0:	fd62                	sd	s8,184(sp)
    800050f2:	e1e6                	sd	s9,192(sp)
    800050f4:	e5ea                	sd	s10,200(sp)
    800050f6:	e9ee                	sd	s11,208(sp)
    800050f8:	edf2                	sd	t3,216(sp)
    800050fa:	f1f6                	sd	t4,224(sp)
    800050fc:	f5fa                	sd	t5,232(sp)
    800050fe:	f9fe                	sd	t6,240(sp)
    80005100:	cadfc0ef          	jal	ra,80001dac <kerneltrap>
    80005104:	6082                	ld	ra,0(sp)
    80005106:	6122                	ld	sp,8(sp)
    80005108:	61c2                	ld	gp,16(sp)
    8000510a:	7282                	ld	t0,32(sp)
    8000510c:	7322                	ld	t1,40(sp)
    8000510e:	73c2                	ld	t2,48(sp)
    80005110:	7462                	ld	s0,56(sp)
    80005112:	6486                	ld	s1,64(sp)
    80005114:	6526                	ld	a0,72(sp)
    80005116:	65c6                	ld	a1,80(sp)
    80005118:	6666                	ld	a2,88(sp)
    8000511a:	7686                	ld	a3,96(sp)
    8000511c:	7726                	ld	a4,104(sp)
    8000511e:	77c6                	ld	a5,112(sp)
    80005120:	7866                	ld	a6,120(sp)
    80005122:	688a                	ld	a7,128(sp)
    80005124:	692a                	ld	s2,136(sp)
    80005126:	69ca                	ld	s3,144(sp)
    80005128:	6a6a                	ld	s4,152(sp)
    8000512a:	7a8a                	ld	s5,160(sp)
    8000512c:	7b2a                	ld	s6,168(sp)
    8000512e:	7bca                	ld	s7,176(sp)
    80005130:	7c6a                	ld	s8,184(sp)
    80005132:	6c8e                	ld	s9,192(sp)
    80005134:	6d2e                	ld	s10,200(sp)
    80005136:	6dce                	ld	s11,208(sp)
    80005138:	6e6e                	ld	t3,216(sp)
    8000513a:	7e8e                	ld	t4,224(sp)
    8000513c:	7f2e                	ld	t5,232(sp)
    8000513e:	7fce                	ld	t6,240(sp)
    80005140:	6111                	addi	sp,sp,256
    80005142:	10200073          	sret
    80005146:	00000013          	nop
    8000514a:	00000013          	nop
    8000514e:	0001                	nop

0000000080005150 <timervec>:
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	e10c                	sd	a1,0(a0)
    80005156:	e510                	sd	a2,8(a0)
    80005158:	e914                	sd	a3,16(a0)
    8000515a:	6d0c                	ld	a1,24(a0)
    8000515c:	7110                	ld	a2,32(a0)
    8000515e:	6194                	ld	a3,0(a1)
    80005160:	96b2                	add	a3,a3,a2
    80005162:	e194                	sd	a3,0(a1)
    80005164:	4589                	li	a1,2
    80005166:	14459073          	csrw	sip,a1
    8000516a:	6914                	ld	a3,16(a0)
    8000516c:	6510                	ld	a2,8(a0)
    8000516e:	610c                	ld	a1,0(a0)
    80005170:	34051573          	csrrw	a0,mscratch,a0
    80005174:	30200073          	mret
	...

000000008000517a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000517a:	1141                	addi	sp,sp,-16
    8000517c:	e422                	sd	s0,8(sp)
    8000517e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005180:	0c0007b7          	lui	a5,0xc000
    80005184:	4705                	li	a4,1
    80005186:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005188:	c3d8                	sw	a4,4(a5)
}
    8000518a:	6422                	ld	s0,8(sp)
    8000518c:	0141                	addi	sp,sp,16
    8000518e:	8082                	ret

0000000080005190 <plicinithart>:

void
plicinithart(void)
{
    80005190:	1141                	addi	sp,sp,-16
    80005192:	e406                	sd	ra,8(sp)
    80005194:	e022                	sd	s0,0(sp)
    80005196:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	cca080e7          	jalr	-822(ra) # 80000e62 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051a0:	0085171b          	slliw	a4,a0,0x8
    800051a4:	0c0027b7          	lui	a5,0xc002
    800051a8:	97ba                	add	a5,a5,a4
    800051aa:	40200713          	li	a4,1026
    800051ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051b2:	00d5151b          	slliw	a0,a0,0xd
    800051b6:	0c2017b7          	lui	a5,0xc201
    800051ba:	97aa                	add	a5,a5,a0
    800051bc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051c0:	60a2                	ld	ra,8(sp)
    800051c2:	6402                	ld	s0,0(sp)
    800051c4:	0141                	addi	sp,sp,16
    800051c6:	8082                	ret

00000000800051c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051c8:	1141                	addi	sp,sp,-16
    800051ca:	e406                	sd	ra,8(sp)
    800051cc:	e022                	sd	s0,0(sp)
    800051ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051d0:	ffffc097          	auipc	ra,0xffffc
    800051d4:	c92080e7          	jalr	-878(ra) # 80000e62 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051d8:	00d5151b          	slliw	a0,a0,0xd
    800051dc:	0c2017b7          	lui	a5,0xc201
    800051e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800051e2:	43c8                	lw	a0,4(a5)
    800051e4:	60a2                	ld	ra,8(sp)
    800051e6:	6402                	ld	s0,0(sp)
    800051e8:	0141                	addi	sp,sp,16
    800051ea:	8082                	ret

00000000800051ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051ec:	1101                	addi	sp,sp,-32
    800051ee:	ec06                	sd	ra,24(sp)
    800051f0:	e822                	sd	s0,16(sp)
    800051f2:	e426                	sd	s1,8(sp)
    800051f4:	1000                	addi	s0,sp,32
    800051f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051f8:	ffffc097          	auipc	ra,0xffffc
    800051fc:	c6a080e7          	jalr	-918(ra) # 80000e62 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005200:	00d5151b          	slliw	a0,a0,0xd
    80005204:	0c2017b7          	lui	a5,0xc201
    80005208:	97aa                	add	a5,a5,a0
    8000520a:	c3c4                	sw	s1,4(a5)
}
    8000520c:	60e2                	ld	ra,24(sp)
    8000520e:	6442                	ld	s0,16(sp)
    80005210:	64a2                	ld	s1,8(sp)
    80005212:	6105                	addi	sp,sp,32
    80005214:	8082                	ret

0000000080005216 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005216:	1141                	addi	sp,sp,-16
    80005218:	e406                	sd	ra,8(sp)
    8000521a:	e022                	sd	s0,0(sp)
    8000521c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000521e:	479d                	li	a5,7
    80005220:	06a7c863          	blt	a5,a0,80005290 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005224:	00016717          	auipc	a4,0x16
    80005228:	ddc70713          	addi	a4,a4,-548 # 8001b000 <disk>
    8000522c:	972a                	add	a4,a4,a0
    8000522e:	6789                	lui	a5,0x2
    80005230:	97ba                	add	a5,a5,a4
    80005232:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005236:	e7ad                	bnez	a5,800052a0 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005238:	00451793          	slli	a5,a0,0x4
    8000523c:	00018717          	auipc	a4,0x18
    80005240:	dc470713          	addi	a4,a4,-572 # 8001d000 <disk+0x2000>
    80005244:	6314                	ld	a3,0(a4)
    80005246:	96be                	add	a3,a3,a5
    80005248:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000524c:	6314                	ld	a3,0(a4)
    8000524e:	96be                	add	a3,a3,a5
    80005250:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005254:	6314                	ld	a3,0(a4)
    80005256:	96be                	add	a3,a3,a5
    80005258:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000525c:	6318                	ld	a4,0(a4)
    8000525e:	97ba                	add	a5,a5,a4
    80005260:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005264:	00016717          	auipc	a4,0x16
    80005268:	d9c70713          	addi	a4,a4,-612 # 8001b000 <disk>
    8000526c:	972a                	add	a4,a4,a0
    8000526e:	6789                	lui	a5,0x2
    80005270:	97ba                	add	a5,a5,a4
    80005272:	4705                	li	a4,1
    80005274:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005278:	00018517          	auipc	a0,0x18
    8000527c:	da050513          	addi	a0,a0,-608 # 8001d018 <disk+0x2018>
    80005280:	ffffc097          	auipc	ra,0xffffc
    80005284:	466080e7          	jalr	1126(ra) # 800016e6 <wakeup>
}
    80005288:	60a2                	ld	ra,8(sp)
    8000528a:	6402                	ld	s0,0(sp)
    8000528c:	0141                	addi	sp,sp,16
    8000528e:	8082                	ret
    panic("free_desc 1");
    80005290:	00003517          	auipc	a0,0x3
    80005294:	52050513          	addi	a0,a0,1312 # 800087b0 <syscalls+0x328>
    80005298:	00001097          	auipc	ra,0x1
    8000529c:	9c8080e7          	jalr	-1592(ra) # 80005c60 <panic>
    panic("free_desc 2");
    800052a0:	00003517          	auipc	a0,0x3
    800052a4:	52050513          	addi	a0,a0,1312 # 800087c0 <syscalls+0x338>
    800052a8:	00001097          	auipc	ra,0x1
    800052ac:	9b8080e7          	jalr	-1608(ra) # 80005c60 <panic>

00000000800052b0 <virtio_disk_init>:
{
    800052b0:	1101                	addi	sp,sp,-32
    800052b2:	ec06                	sd	ra,24(sp)
    800052b4:	e822                	sd	s0,16(sp)
    800052b6:	e426                	sd	s1,8(sp)
    800052b8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052ba:	00003597          	auipc	a1,0x3
    800052be:	51658593          	addi	a1,a1,1302 # 800087d0 <syscalls+0x348>
    800052c2:	00018517          	auipc	a0,0x18
    800052c6:	e6650513          	addi	a0,a0,-410 # 8001d128 <disk+0x2128>
    800052ca:	00001097          	auipc	ra,0x1
    800052ce:	e3e080e7          	jalr	-450(ra) # 80006108 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d2:	100017b7          	lui	a5,0x10001
    800052d6:	4398                	lw	a4,0(a5)
    800052d8:	2701                	sext.w	a4,a4
    800052da:	747277b7          	lui	a5,0x74727
    800052de:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052e2:	0ef71063          	bne	a4,a5,800053c2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052e6:	100017b7          	lui	a5,0x10001
    800052ea:	43dc                	lw	a5,4(a5)
    800052ec:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052ee:	4705                	li	a4,1
    800052f0:	0ce79963          	bne	a5,a4,800053c2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052f4:	100017b7          	lui	a5,0x10001
    800052f8:	479c                	lw	a5,8(a5)
    800052fa:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052fc:	4709                	li	a4,2
    800052fe:	0ce79263          	bne	a5,a4,800053c2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005302:	100017b7          	lui	a5,0x10001
    80005306:	47d8                	lw	a4,12(a5)
    80005308:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000530a:	554d47b7          	lui	a5,0x554d4
    8000530e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005312:	0af71863          	bne	a4,a5,800053c2 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005316:	100017b7          	lui	a5,0x10001
    8000531a:	4705                	li	a4,1
    8000531c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531e:	470d                	li	a4,3
    80005320:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005322:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005324:	c7ffe6b7          	lui	a3,0xc7ffe
    80005328:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000532c:	8f75                	and	a4,a4,a3
    8000532e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005330:	472d                	li	a4,11
    80005332:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005334:	473d                	li	a4,15
    80005336:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005338:	6705                	lui	a4,0x1
    8000533a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000533c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005340:	5bdc                	lw	a5,52(a5)
    80005342:	2781                	sext.w	a5,a5
  if(max == 0)
    80005344:	c7d9                	beqz	a5,800053d2 <virtio_disk_init+0x122>
  if(max < NUM)
    80005346:	471d                	li	a4,7
    80005348:	08f77d63          	bgeu	a4,a5,800053e2 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000534c:	100014b7          	lui	s1,0x10001
    80005350:	47a1                	li	a5,8
    80005352:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005354:	6609                	lui	a2,0x2
    80005356:	4581                	li	a1,0
    80005358:	00016517          	auipc	a0,0x16
    8000535c:	ca850513          	addi	a0,a0,-856 # 8001b000 <disk>
    80005360:	ffffb097          	auipc	ra,0xffffb
    80005364:	e64080e7          	jalr	-412(ra) # 800001c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005368:	00016717          	auipc	a4,0x16
    8000536c:	c9870713          	addi	a4,a4,-872 # 8001b000 <disk>
    80005370:	00c75793          	srli	a5,a4,0xc
    80005374:	2781                	sext.w	a5,a5
    80005376:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005378:	00018797          	auipc	a5,0x18
    8000537c:	c8878793          	addi	a5,a5,-888 # 8001d000 <disk+0x2000>
    80005380:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005382:	00016717          	auipc	a4,0x16
    80005386:	cfe70713          	addi	a4,a4,-770 # 8001b080 <disk+0x80>
    8000538a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000538c:	00017717          	auipc	a4,0x17
    80005390:	c7470713          	addi	a4,a4,-908 # 8001c000 <disk+0x1000>
    80005394:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005396:	4705                	li	a4,1
    80005398:	00e78c23          	sb	a4,24(a5)
    8000539c:	00e78ca3          	sb	a4,25(a5)
    800053a0:	00e78d23          	sb	a4,26(a5)
    800053a4:	00e78da3          	sb	a4,27(a5)
    800053a8:	00e78e23          	sb	a4,28(a5)
    800053ac:	00e78ea3          	sb	a4,29(a5)
    800053b0:	00e78f23          	sb	a4,30(a5)
    800053b4:	00e78fa3          	sb	a4,31(a5)
}
    800053b8:	60e2                	ld	ra,24(sp)
    800053ba:	6442                	ld	s0,16(sp)
    800053bc:	64a2                	ld	s1,8(sp)
    800053be:	6105                	addi	sp,sp,32
    800053c0:	8082                	ret
    panic("could not find virtio disk");
    800053c2:	00003517          	auipc	a0,0x3
    800053c6:	41e50513          	addi	a0,a0,1054 # 800087e0 <syscalls+0x358>
    800053ca:	00001097          	auipc	ra,0x1
    800053ce:	896080e7          	jalr	-1898(ra) # 80005c60 <panic>
    panic("virtio disk has no queue 0");
    800053d2:	00003517          	auipc	a0,0x3
    800053d6:	42e50513          	addi	a0,a0,1070 # 80008800 <syscalls+0x378>
    800053da:	00001097          	auipc	ra,0x1
    800053de:	886080e7          	jalr	-1914(ra) # 80005c60 <panic>
    panic("virtio disk max queue too short");
    800053e2:	00003517          	auipc	a0,0x3
    800053e6:	43e50513          	addi	a0,a0,1086 # 80008820 <syscalls+0x398>
    800053ea:	00001097          	auipc	ra,0x1
    800053ee:	876080e7          	jalr	-1930(ra) # 80005c60 <panic>

00000000800053f2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053f2:	7119                	addi	sp,sp,-128
    800053f4:	fc86                	sd	ra,120(sp)
    800053f6:	f8a2                	sd	s0,112(sp)
    800053f8:	f4a6                	sd	s1,104(sp)
    800053fa:	f0ca                	sd	s2,96(sp)
    800053fc:	ecce                	sd	s3,88(sp)
    800053fe:	e8d2                	sd	s4,80(sp)
    80005400:	e4d6                	sd	s5,72(sp)
    80005402:	e0da                	sd	s6,64(sp)
    80005404:	fc5e                	sd	s7,56(sp)
    80005406:	f862                	sd	s8,48(sp)
    80005408:	f466                	sd	s9,40(sp)
    8000540a:	f06a                	sd	s10,32(sp)
    8000540c:	ec6e                	sd	s11,24(sp)
    8000540e:	0100                	addi	s0,sp,128
    80005410:	8aaa                	mv	s5,a0
    80005412:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005414:	00c52c83          	lw	s9,12(a0)
    80005418:	001c9c9b          	slliw	s9,s9,0x1
    8000541c:	1c82                	slli	s9,s9,0x20
    8000541e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005422:	00018517          	auipc	a0,0x18
    80005426:	d0650513          	addi	a0,a0,-762 # 8001d128 <disk+0x2128>
    8000542a:	00001097          	auipc	ra,0x1
    8000542e:	d6e080e7          	jalr	-658(ra) # 80006198 <acquire>
  for(int i = 0; i < 3; i++){
    80005432:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005434:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005436:	00016c17          	auipc	s8,0x16
    8000543a:	bcac0c13          	addi	s8,s8,-1078 # 8001b000 <disk>
    8000543e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005440:	4b0d                	li	s6,3
    80005442:	a0ad                	j	800054ac <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005444:	00fc0733          	add	a4,s8,a5
    80005448:	975e                	add	a4,a4,s7
    8000544a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000544e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005450:	0207c563          	bltz	a5,8000547a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005454:	2905                	addiw	s2,s2,1
    80005456:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005458:	19690c63          	beq	s2,s6,800055f0 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000545c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000545e:	00018717          	auipc	a4,0x18
    80005462:	bba70713          	addi	a4,a4,-1094 # 8001d018 <disk+0x2018>
    80005466:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005468:	00074683          	lbu	a3,0(a4)
    8000546c:	fee1                	bnez	a3,80005444 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000546e:	2785                	addiw	a5,a5,1
    80005470:	0705                	addi	a4,a4,1
    80005472:	fe979be3          	bne	a5,s1,80005468 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005476:	57fd                	li	a5,-1
    80005478:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000547a:	01205d63          	blez	s2,80005494 <virtio_disk_rw+0xa2>
    8000547e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005480:	000a2503          	lw	a0,0(s4)
    80005484:	00000097          	auipc	ra,0x0
    80005488:	d92080e7          	jalr	-622(ra) # 80005216 <free_desc>
      for(int j = 0; j < i; j++)
    8000548c:	2d85                	addiw	s11,s11,1
    8000548e:	0a11                	addi	s4,s4,4
    80005490:	ff2d98e3          	bne	s11,s2,80005480 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005494:	00018597          	auipc	a1,0x18
    80005498:	c9458593          	addi	a1,a1,-876 # 8001d128 <disk+0x2128>
    8000549c:	00018517          	auipc	a0,0x18
    800054a0:	b7c50513          	addi	a0,a0,-1156 # 8001d018 <disk+0x2018>
    800054a4:	ffffc097          	auipc	ra,0xffffc
    800054a8:	0b6080e7          	jalr	182(ra) # 8000155a <sleep>
  for(int i = 0; i < 3; i++){
    800054ac:	f8040a13          	addi	s4,s0,-128
{
    800054b0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800054b2:	894e                	mv	s2,s3
    800054b4:	b765                	j	8000545c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054b6:	00018697          	auipc	a3,0x18
    800054ba:	b4a6b683          	ld	a3,-1206(a3) # 8001d000 <disk+0x2000>
    800054be:	96ba                	add	a3,a3,a4
    800054c0:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054c4:	00016817          	auipc	a6,0x16
    800054c8:	b3c80813          	addi	a6,a6,-1220 # 8001b000 <disk>
    800054cc:	00018697          	auipc	a3,0x18
    800054d0:	b3468693          	addi	a3,a3,-1228 # 8001d000 <disk+0x2000>
    800054d4:	6290                	ld	a2,0(a3)
    800054d6:	963a                	add	a2,a2,a4
    800054d8:	00c65583          	lhu	a1,12(a2)
    800054dc:	0015e593          	ori	a1,a1,1
    800054e0:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800054e4:	f8842603          	lw	a2,-120(s0)
    800054e8:	628c                	ld	a1,0(a3)
    800054ea:	972e                	add	a4,a4,a1
    800054ec:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054f0:	20050593          	addi	a1,a0,512
    800054f4:	0592                	slli	a1,a1,0x4
    800054f6:	95c2                	add	a1,a1,a6
    800054f8:	577d                	li	a4,-1
    800054fa:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054fe:	00461713          	slli	a4,a2,0x4
    80005502:	6290                	ld	a2,0(a3)
    80005504:	963a                	add	a2,a2,a4
    80005506:	03078793          	addi	a5,a5,48
    8000550a:	97c2                	add	a5,a5,a6
    8000550c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000550e:	629c                	ld	a5,0(a3)
    80005510:	97ba                	add	a5,a5,a4
    80005512:	4605                	li	a2,1
    80005514:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005516:	629c                	ld	a5,0(a3)
    80005518:	97ba                	add	a5,a5,a4
    8000551a:	4809                	li	a6,2
    8000551c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005520:	629c                	ld	a5,0(a3)
    80005522:	97ba                	add	a5,a5,a4
    80005524:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005528:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000552c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005530:	6698                	ld	a4,8(a3)
    80005532:	00275783          	lhu	a5,2(a4)
    80005536:	8b9d                	andi	a5,a5,7
    80005538:	0786                	slli	a5,a5,0x1
    8000553a:	973e                	add	a4,a4,a5
    8000553c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005540:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005544:	6698                	ld	a4,8(a3)
    80005546:	00275783          	lhu	a5,2(a4)
    8000554a:	2785                	addiw	a5,a5,1
    8000554c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005550:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005554:	100017b7          	lui	a5,0x10001
    80005558:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000555c:	004aa783          	lw	a5,4(s5)
    80005560:	02c79163          	bne	a5,a2,80005582 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005564:	00018917          	auipc	s2,0x18
    80005568:	bc490913          	addi	s2,s2,-1084 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    8000556c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000556e:	85ca                	mv	a1,s2
    80005570:	8556                	mv	a0,s5
    80005572:	ffffc097          	auipc	ra,0xffffc
    80005576:	fe8080e7          	jalr	-24(ra) # 8000155a <sleep>
  while(b->disk == 1) {
    8000557a:	004aa783          	lw	a5,4(s5)
    8000557e:	fe9788e3          	beq	a5,s1,8000556e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005582:	f8042903          	lw	s2,-128(s0)
    80005586:	20090713          	addi	a4,s2,512
    8000558a:	0712                	slli	a4,a4,0x4
    8000558c:	00016797          	auipc	a5,0x16
    80005590:	a7478793          	addi	a5,a5,-1420 # 8001b000 <disk>
    80005594:	97ba                	add	a5,a5,a4
    80005596:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000559a:	00018997          	auipc	s3,0x18
    8000559e:	a6698993          	addi	s3,s3,-1434 # 8001d000 <disk+0x2000>
    800055a2:	00491713          	slli	a4,s2,0x4
    800055a6:	0009b783          	ld	a5,0(s3)
    800055aa:	97ba                	add	a5,a5,a4
    800055ac:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055b0:	854a                	mv	a0,s2
    800055b2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055b6:	00000097          	auipc	ra,0x0
    800055ba:	c60080e7          	jalr	-928(ra) # 80005216 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055be:	8885                	andi	s1,s1,1
    800055c0:	f0ed                	bnez	s1,800055a2 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055c2:	00018517          	auipc	a0,0x18
    800055c6:	b6650513          	addi	a0,a0,-1178 # 8001d128 <disk+0x2128>
    800055ca:	00001097          	auipc	ra,0x1
    800055ce:	c82080e7          	jalr	-894(ra) # 8000624c <release>
}
    800055d2:	70e6                	ld	ra,120(sp)
    800055d4:	7446                	ld	s0,112(sp)
    800055d6:	74a6                	ld	s1,104(sp)
    800055d8:	7906                	ld	s2,96(sp)
    800055da:	69e6                	ld	s3,88(sp)
    800055dc:	6a46                	ld	s4,80(sp)
    800055de:	6aa6                	ld	s5,72(sp)
    800055e0:	6b06                	ld	s6,64(sp)
    800055e2:	7be2                	ld	s7,56(sp)
    800055e4:	7c42                	ld	s8,48(sp)
    800055e6:	7ca2                	ld	s9,40(sp)
    800055e8:	7d02                	ld	s10,32(sp)
    800055ea:	6de2                	ld	s11,24(sp)
    800055ec:	6109                	addi	sp,sp,128
    800055ee:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055f0:	f8042503          	lw	a0,-128(s0)
    800055f4:	20050793          	addi	a5,a0,512
    800055f8:	0792                	slli	a5,a5,0x4
  if(write)
    800055fa:	00016817          	auipc	a6,0x16
    800055fe:	a0680813          	addi	a6,a6,-1530 # 8001b000 <disk>
    80005602:	00f80733          	add	a4,a6,a5
    80005606:	01a036b3          	snez	a3,s10
    8000560a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000560e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005612:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005616:	7679                	lui	a2,0xffffe
    80005618:	963e                	add	a2,a2,a5
    8000561a:	00018697          	auipc	a3,0x18
    8000561e:	9e668693          	addi	a3,a3,-1562 # 8001d000 <disk+0x2000>
    80005622:	6298                	ld	a4,0(a3)
    80005624:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005626:	0a878593          	addi	a1,a5,168
    8000562a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000562c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000562e:	6298                	ld	a4,0(a3)
    80005630:	9732                	add	a4,a4,a2
    80005632:	45c1                	li	a1,16
    80005634:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005636:	6298                	ld	a4,0(a3)
    80005638:	9732                	add	a4,a4,a2
    8000563a:	4585                	li	a1,1
    8000563c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005640:	f8442703          	lw	a4,-124(s0)
    80005644:	628c                	ld	a1,0(a3)
    80005646:	962e                	add	a2,a2,a1
    80005648:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000564c:	0712                	slli	a4,a4,0x4
    8000564e:	6290                	ld	a2,0(a3)
    80005650:	963a                	add	a2,a2,a4
    80005652:	058a8593          	addi	a1,s5,88
    80005656:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005658:	6294                	ld	a3,0(a3)
    8000565a:	96ba                	add	a3,a3,a4
    8000565c:	40000613          	li	a2,1024
    80005660:	c690                	sw	a2,8(a3)
  if(write)
    80005662:	e40d1ae3          	bnez	s10,800054b6 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005666:	00018697          	auipc	a3,0x18
    8000566a:	99a6b683          	ld	a3,-1638(a3) # 8001d000 <disk+0x2000>
    8000566e:	96ba                	add	a3,a3,a4
    80005670:	4609                	li	a2,2
    80005672:	00c69623          	sh	a2,12(a3)
    80005676:	b5b9                	j	800054c4 <virtio_disk_rw+0xd2>

0000000080005678 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005678:	1101                	addi	sp,sp,-32
    8000567a:	ec06                	sd	ra,24(sp)
    8000567c:	e822                	sd	s0,16(sp)
    8000567e:	e426                	sd	s1,8(sp)
    80005680:	e04a                	sd	s2,0(sp)
    80005682:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005684:	00018517          	auipc	a0,0x18
    80005688:	aa450513          	addi	a0,a0,-1372 # 8001d128 <disk+0x2128>
    8000568c:	00001097          	auipc	ra,0x1
    80005690:	b0c080e7          	jalr	-1268(ra) # 80006198 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005694:	10001737          	lui	a4,0x10001
    80005698:	533c                	lw	a5,96(a4)
    8000569a:	8b8d                	andi	a5,a5,3
    8000569c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000569e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056a2:	00018797          	auipc	a5,0x18
    800056a6:	95e78793          	addi	a5,a5,-1698 # 8001d000 <disk+0x2000>
    800056aa:	6b94                	ld	a3,16(a5)
    800056ac:	0207d703          	lhu	a4,32(a5)
    800056b0:	0026d783          	lhu	a5,2(a3)
    800056b4:	06f70163          	beq	a4,a5,80005716 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056b8:	00016917          	auipc	s2,0x16
    800056bc:	94890913          	addi	s2,s2,-1720 # 8001b000 <disk>
    800056c0:	00018497          	auipc	s1,0x18
    800056c4:	94048493          	addi	s1,s1,-1728 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056c8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056cc:	6898                	ld	a4,16(s1)
    800056ce:	0204d783          	lhu	a5,32(s1)
    800056d2:	8b9d                	andi	a5,a5,7
    800056d4:	078e                	slli	a5,a5,0x3
    800056d6:	97ba                	add	a5,a5,a4
    800056d8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056da:	20078713          	addi	a4,a5,512
    800056de:	0712                	slli	a4,a4,0x4
    800056e0:	974a                	add	a4,a4,s2
    800056e2:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056e6:	e731                	bnez	a4,80005732 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056e8:	20078793          	addi	a5,a5,512
    800056ec:	0792                	slli	a5,a5,0x4
    800056ee:	97ca                	add	a5,a5,s2
    800056f0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056f2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056f6:	ffffc097          	auipc	ra,0xffffc
    800056fa:	ff0080e7          	jalr	-16(ra) # 800016e6 <wakeup>

    disk.used_idx += 1;
    800056fe:	0204d783          	lhu	a5,32(s1)
    80005702:	2785                	addiw	a5,a5,1
    80005704:	17c2                	slli	a5,a5,0x30
    80005706:	93c1                	srli	a5,a5,0x30
    80005708:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000570c:	6898                	ld	a4,16(s1)
    8000570e:	00275703          	lhu	a4,2(a4)
    80005712:	faf71be3          	bne	a4,a5,800056c8 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005716:	00018517          	auipc	a0,0x18
    8000571a:	a1250513          	addi	a0,a0,-1518 # 8001d128 <disk+0x2128>
    8000571e:	00001097          	auipc	ra,0x1
    80005722:	b2e080e7          	jalr	-1234(ra) # 8000624c <release>
}
    80005726:	60e2                	ld	ra,24(sp)
    80005728:	6442                	ld	s0,16(sp)
    8000572a:	64a2                	ld	s1,8(sp)
    8000572c:	6902                	ld	s2,0(sp)
    8000572e:	6105                	addi	sp,sp,32
    80005730:	8082                	ret
      panic("virtio_disk_intr status");
    80005732:	00003517          	auipc	a0,0x3
    80005736:	10e50513          	addi	a0,a0,270 # 80008840 <syscalls+0x3b8>
    8000573a:	00000097          	auipc	ra,0x0
    8000573e:	526080e7          	jalr	1318(ra) # 80005c60 <panic>

0000000080005742 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005742:	1141                	addi	sp,sp,-16
    80005744:	e422                	sd	s0,8(sp)
    80005746:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005748:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000574c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005750:	0037979b          	slliw	a5,a5,0x3
    80005754:	02004737          	lui	a4,0x2004
    80005758:	97ba                	add	a5,a5,a4
    8000575a:	0200c737          	lui	a4,0x200c
    8000575e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005762:	000f4637          	lui	a2,0xf4
    80005766:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000576a:	9732                	add	a4,a4,a2
    8000576c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000576e:	00259693          	slli	a3,a1,0x2
    80005772:	96ae                	add	a3,a3,a1
    80005774:	068e                	slli	a3,a3,0x3
    80005776:	00019717          	auipc	a4,0x19
    8000577a:	88a70713          	addi	a4,a4,-1910 # 8001e000 <timer_scratch>
    8000577e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005780:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005782:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005784:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005788:	00000797          	auipc	a5,0x0
    8000578c:	9c878793          	addi	a5,a5,-1592 # 80005150 <timervec>
    80005790:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005794:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005798:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000579c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057a0:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057a4:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057a8:	30479073          	csrw	mie,a5
}
    800057ac:	6422                	ld	s0,8(sp)
    800057ae:	0141                	addi	sp,sp,16
    800057b0:	8082                	ret

00000000800057b2 <start>:
{
    800057b2:	1141                	addi	sp,sp,-16
    800057b4:	e406                	sd	ra,8(sp)
    800057b6:	e022                	sd	s0,0(sp)
    800057b8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057ba:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057be:	7779                	lui	a4,0xffffe
    800057c0:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057c4:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057c6:	6705                	lui	a4,0x1
    800057c8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057cc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057ce:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057d2:	ffffb797          	auipc	a5,0xffffb
    800057d6:	b9878793          	addi	a5,a5,-1128 # 8000036a <main>
    800057da:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057de:	4781                	li	a5,0
    800057e0:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057e4:	67c1                	lui	a5,0x10
    800057e6:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800057e8:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057ec:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057f0:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057f4:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057f8:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057fc:	57fd                	li	a5,-1
    800057fe:	83a9                	srli	a5,a5,0xa
    80005800:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005804:	47bd                	li	a5,15
    80005806:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000580a:	00000097          	auipc	ra,0x0
    8000580e:	f38080e7          	jalr	-200(ra) # 80005742 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005812:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005816:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005818:	823e                	mv	tp,a5
  asm volatile("mret");
    8000581a:	30200073          	mret
}
    8000581e:	60a2                	ld	ra,8(sp)
    80005820:	6402                	ld	s0,0(sp)
    80005822:	0141                	addi	sp,sp,16
    80005824:	8082                	ret

0000000080005826 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005826:	715d                	addi	sp,sp,-80
    80005828:	e486                	sd	ra,72(sp)
    8000582a:	e0a2                	sd	s0,64(sp)
    8000582c:	fc26                	sd	s1,56(sp)
    8000582e:	f84a                	sd	s2,48(sp)
    80005830:	f44e                	sd	s3,40(sp)
    80005832:	f052                	sd	s4,32(sp)
    80005834:	ec56                	sd	s5,24(sp)
    80005836:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005838:	04c05763          	blez	a2,80005886 <consolewrite+0x60>
    8000583c:	8a2a                	mv	s4,a0
    8000583e:	84ae                	mv	s1,a1
    80005840:	89b2                	mv	s3,a2
    80005842:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005844:	5afd                	li	s5,-1
    80005846:	4685                	li	a3,1
    80005848:	8626                	mv	a2,s1
    8000584a:	85d2                	mv	a1,s4
    8000584c:	fbf40513          	addi	a0,s0,-65
    80005850:	ffffc097          	auipc	ra,0xffffc
    80005854:	104080e7          	jalr	260(ra) # 80001954 <either_copyin>
    80005858:	01550d63          	beq	a0,s5,80005872 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000585c:	fbf44503          	lbu	a0,-65(s0)
    80005860:	00000097          	auipc	ra,0x0
    80005864:	77e080e7          	jalr	1918(ra) # 80005fde <uartputc>
  for(i = 0; i < n; i++){
    80005868:	2905                	addiw	s2,s2,1
    8000586a:	0485                	addi	s1,s1,1
    8000586c:	fd299de3          	bne	s3,s2,80005846 <consolewrite+0x20>
    80005870:	894e                	mv	s2,s3
  }

  return i;
}
    80005872:	854a                	mv	a0,s2
    80005874:	60a6                	ld	ra,72(sp)
    80005876:	6406                	ld	s0,64(sp)
    80005878:	74e2                	ld	s1,56(sp)
    8000587a:	7942                	ld	s2,48(sp)
    8000587c:	79a2                	ld	s3,40(sp)
    8000587e:	7a02                	ld	s4,32(sp)
    80005880:	6ae2                	ld	s5,24(sp)
    80005882:	6161                	addi	sp,sp,80
    80005884:	8082                	ret
  for(i = 0; i < n; i++){
    80005886:	4901                	li	s2,0
    80005888:	b7ed                	j	80005872 <consolewrite+0x4c>

000000008000588a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000588a:	7159                	addi	sp,sp,-112
    8000588c:	f486                	sd	ra,104(sp)
    8000588e:	f0a2                	sd	s0,96(sp)
    80005890:	eca6                	sd	s1,88(sp)
    80005892:	e8ca                	sd	s2,80(sp)
    80005894:	e4ce                	sd	s3,72(sp)
    80005896:	e0d2                	sd	s4,64(sp)
    80005898:	fc56                	sd	s5,56(sp)
    8000589a:	f85a                	sd	s6,48(sp)
    8000589c:	f45e                	sd	s7,40(sp)
    8000589e:	f062                	sd	s8,32(sp)
    800058a0:	ec66                	sd	s9,24(sp)
    800058a2:	e86a                	sd	s10,16(sp)
    800058a4:	1880                	addi	s0,sp,112
    800058a6:	8aaa                	mv	s5,a0
    800058a8:	8a2e                	mv	s4,a1
    800058aa:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058ac:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800058b0:	00021517          	auipc	a0,0x21
    800058b4:	89050513          	addi	a0,a0,-1904 # 80026140 <cons>
    800058b8:	00001097          	auipc	ra,0x1
    800058bc:	8e0080e7          	jalr	-1824(ra) # 80006198 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058c0:	00021497          	auipc	s1,0x21
    800058c4:	88048493          	addi	s1,s1,-1920 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058c8:	00021917          	auipc	s2,0x21
    800058cc:	91090913          	addi	s2,s2,-1776 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058d0:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058d2:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058d4:	4ca9                	li	s9,10
  while(n > 0){
    800058d6:	07305863          	blez	s3,80005946 <consoleread+0xbc>
    while(cons.r == cons.w){
    800058da:	0984a783          	lw	a5,152(s1)
    800058de:	09c4a703          	lw	a4,156(s1)
    800058e2:	02f71463          	bne	a4,a5,8000590a <consoleread+0x80>
      if(myproc()->killed){
    800058e6:	ffffb097          	auipc	ra,0xffffb
    800058ea:	5a8080e7          	jalr	1448(ra) # 80000e8e <myproc>
    800058ee:	551c                	lw	a5,40(a0)
    800058f0:	e7b5                	bnez	a5,8000595c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800058f2:	85a6                	mv	a1,s1
    800058f4:	854a                	mv	a0,s2
    800058f6:	ffffc097          	auipc	ra,0xffffc
    800058fa:	c64080e7          	jalr	-924(ra) # 8000155a <sleep>
    while(cons.r == cons.w){
    800058fe:	0984a783          	lw	a5,152(s1)
    80005902:	09c4a703          	lw	a4,156(s1)
    80005906:	fef700e3          	beq	a4,a5,800058e6 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    8000590a:	0017871b          	addiw	a4,a5,1
    8000590e:	08e4ac23          	sw	a4,152(s1)
    80005912:	07f7f713          	andi	a4,a5,127
    80005916:	9726                	add	a4,a4,s1
    80005918:	01874703          	lbu	a4,24(a4)
    8000591c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005920:	077d0563          	beq	s10,s7,8000598a <consoleread+0x100>
    cbuf = c;
    80005924:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005928:	4685                	li	a3,1
    8000592a:	f9f40613          	addi	a2,s0,-97
    8000592e:	85d2                	mv	a1,s4
    80005930:	8556                	mv	a0,s5
    80005932:	ffffc097          	auipc	ra,0xffffc
    80005936:	fcc080e7          	jalr	-52(ra) # 800018fe <either_copyout>
    8000593a:	01850663          	beq	a0,s8,80005946 <consoleread+0xbc>
    dst++;
    8000593e:	0a05                	addi	s4,s4,1
    --n;
    80005940:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005942:	f99d1ae3          	bne	s10,s9,800058d6 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005946:	00020517          	auipc	a0,0x20
    8000594a:	7fa50513          	addi	a0,a0,2042 # 80026140 <cons>
    8000594e:	00001097          	auipc	ra,0x1
    80005952:	8fe080e7          	jalr	-1794(ra) # 8000624c <release>

  return target - n;
    80005956:	413b053b          	subw	a0,s6,s3
    8000595a:	a811                	j	8000596e <consoleread+0xe4>
        release(&cons.lock);
    8000595c:	00020517          	auipc	a0,0x20
    80005960:	7e450513          	addi	a0,a0,2020 # 80026140 <cons>
    80005964:	00001097          	auipc	ra,0x1
    80005968:	8e8080e7          	jalr	-1816(ra) # 8000624c <release>
        return -1;
    8000596c:	557d                	li	a0,-1
}
    8000596e:	70a6                	ld	ra,104(sp)
    80005970:	7406                	ld	s0,96(sp)
    80005972:	64e6                	ld	s1,88(sp)
    80005974:	6946                	ld	s2,80(sp)
    80005976:	69a6                	ld	s3,72(sp)
    80005978:	6a06                	ld	s4,64(sp)
    8000597a:	7ae2                	ld	s5,56(sp)
    8000597c:	7b42                	ld	s6,48(sp)
    8000597e:	7ba2                	ld	s7,40(sp)
    80005980:	7c02                	ld	s8,32(sp)
    80005982:	6ce2                	ld	s9,24(sp)
    80005984:	6d42                	ld	s10,16(sp)
    80005986:	6165                	addi	sp,sp,112
    80005988:	8082                	ret
      if(n < target){
    8000598a:	0009871b          	sext.w	a4,s3
    8000598e:	fb677ce3          	bgeu	a4,s6,80005946 <consoleread+0xbc>
        cons.r--;
    80005992:	00021717          	auipc	a4,0x21
    80005996:	84f72323          	sw	a5,-1978(a4) # 800261d8 <cons+0x98>
    8000599a:	b775                	j	80005946 <consoleread+0xbc>

000000008000599c <consputc>:
{
    8000599c:	1141                	addi	sp,sp,-16
    8000599e:	e406                	sd	ra,8(sp)
    800059a0:	e022                	sd	s0,0(sp)
    800059a2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059a4:	10000793          	li	a5,256
    800059a8:	00f50a63          	beq	a0,a5,800059bc <consputc+0x20>
    uartputc_sync(c);
    800059ac:	00000097          	auipc	ra,0x0
    800059b0:	560080e7          	jalr	1376(ra) # 80005f0c <uartputc_sync>
}
    800059b4:	60a2                	ld	ra,8(sp)
    800059b6:	6402                	ld	s0,0(sp)
    800059b8:	0141                	addi	sp,sp,16
    800059ba:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059bc:	4521                	li	a0,8
    800059be:	00000097          	auipc	ra,0x0
    800059c2:	54e080e7          	jalr	1358(ra) # 80005f0c <uartputc_sync>
    800059c6:	02000513          	li	a0,32
    800059ca:	00000097          	auipc	ra,0x0
    800059ce:	542080e7          	jalr	1346(ra) # 80005f0c <uartputc_sync>
    800059d2:	4521                	li	a0,8
    800059d4:	00000097          	auipc	ra,0x0
    800059d8:	538080e7          	jalr	1336(ra) # 80005f0c <uartputc_sync>
    800059dc:	bfe1                	j	800059b4 <consputc+0x18>

00000000800059de <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059de:	1101                	addi	sp,sp,-32
    800059e0:	ec06                	sd	ra,24(sp)
    800059e2:	e822                	sd	s0,16(sp)
    800059e4:	e426                	sd	s1,8(sp)
    800059e6:	e04a                	sd	s2,0(sp)
    800059e8:	1000                	addi	s0,sp,32
    800059ea:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059ec:	00020517          	auipc	a0,0x20
    800059f0:	75450513          	addi	a0,a0,1876 # 80026140 <cons>
    800059f4:	00000097          	auipc	ra,0x0
    800059f8:	7a4080e7          	jalr	1956(ra) # 80006198 <acquire>

  switch(c){
    800059fc:	47d5                	li	a5,21
    800059fe:	0af48663          	beq	s1,a5,80005aaa <consoleintr+0xcc>
    80005a02:	0297ca63          	blt	a5,s1,80005a36 <consoleintr+0x58>
    80005a06:	47a1                	li	a5,8
    80005a08:	0ef48763          	beq	s1,a5,80005af6 <consoleintr+0x118>
    80005a0c:	47c1                	li	a5,16
    80005a0e:	10f49a63          	bne	s1,a5,80005b22 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a12:	ffffc097          	auipc	ra,0xffffc
    80005a16:	f98080e7          	jalr	-104(ra) # 800019aa <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a1a:	00020517          	auipc	a0,0x20
    80005a1e:	72650513          	addi	a0,a0,1830 # 80026140 <cons>
    80005a22:	00001097          	auipc	ra,0x1
    80005a26:	82a080e7          	jalr	-2006(ra) # 8000624c <release>
}
    80005a2a:	60e2                	ld	ra,24(sp)
    80005a2c:	6442                	ld	s0,16(sp)
    80005a2e:	64a2                	ld	s1,8(sp)
    80005a30:	6902                	ld	s2,0(sp)
    80005a32:	6105                	addi	sp,sp,32
    80005a34:	8082                	ret
  switch(c){
    80005a36:	07f00793          	li	a5,127
    80005a3a:	0af48e63          	beq	s1,a5,80005af6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a3e:	00020717          	auipc	a4,0x20
    80005a42:	70270713          	addi	a4,a4,1794 # 80026140 <cons>
    80005a46:	0a072783          	lw	a5,160(a4)
    80005a4a:	09872703          	lw	a4,152(a4)
    80005a4e:	9f99                	subw	a5,a5,a4
    80005a50:	07f00713          	li	a4,127
    80005a54:	fcf763e3          	bltu	a4,a5,80005a1a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a58:	47b5                	li	a5,13
    80005a5a:	0cf48763          	beq	s1,a5,80005b28 <consoleintr+0x14a>
      consputc(c);
    80005a5e:	8526                	mv	a0,s1
    80005a60:	00000097          	auipc	ra,0x0
    80005a64:	f3c080e7          	jalr	-196(ra) # 8000599c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a68:	00020797          	auipc	a5,0x20
    80005a6c:	6d878793          	addi	a5,a5,1752 # 80026140 <cons>
    80005a70:	0a07a703          	lw	a4,160(a5)
    80005a74:	0017069b          	addiw	a3,a4,1
    80005a78:	0006861b          	sext.w	a2,a3
    80005a7c:	0ad7a023          	sw	a3,160(a5)
    80005a80:	07f77713          	andi	a4,a4,127
    80005a84:	97ba                	add	a5,a5,a4
    80005a86:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a8a:	47a9                	li	a5,10
    80005a8c:	0cf48563          	beq	s1,a5,80005b56 <consoleintr+0x178>
    80005a90:	4791                	li	a5,4
    80005a92:	0cf48263          	beq	s1,a5,80005b56 <consoleintr+0x178>
    80005a96:	00020797          	auipc	a5,0x20
    80005a9a:	7427a783          	lw	a5,1858(a5) # 800261d8 <cons+0x98>
    80005a9e:	0807879b          	addiw	a5,a5,128
    80005aa2:	f6f61ce3          	bne	a2,a5,80005a1a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005aa6:	863e                	mv	a2,a5
    80005aa8:	a07d                	j	80005b56 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005aaa:	00020717          	auipc	a4,0x20
    80005aae:	69670713          	addi	a4,a4,1686 # 80026140 <cons>
    80005ab2:	0a072783          	lw	a5,160(a4)
    80005ab6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005aba:	00020497          	auipc	s1,0x20
    80005abe:	68648493          	addi	s1,s1,1670 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005ac2:	4929                	li	s2,10
    80005ac4:	f4f70be3          	beq	a4,a5,80005a1a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ac8:	37fd                	addiw	a5,a5,-1
    80005aca:	07f7f713          	andi	a4,a5,127
    80005ace:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ad0:	01874703          	lbu	a4,24(a4)
    80005ad4:	f52703e3          	beq	a4,s2,80005a1a <consoleintr+0x3c>
      cons.e--;
    80005ad8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005adc:	10000513          	li	a0,256
    80005ae0:	00000097          	auipc	ra,0x0
    80005ae4:	ebc080e7          	jalr	-324(ra) # 8000599c <consputc>
    while(cons.e != cons.w &&
    80005ae8:	0a04a783          	lw	a5,160(s1)
    80005aec:	09c4a703          	lw	a4,156(s1)
    80005af0:	fcf71ce3          	bne	a4,a5,80005ac8 <consoleintr+0xea>
    80005af4:	b71d                	j	80005a1a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005af6:	00020717          	auipc	a4,0x20
    80005afa:	64a70713          	addi	a4,a4,1610 # 80026140 <cons>
    80005afe:	0a072783          	lw	a5,160(a4)
    80005b02:	09c72703          	lw	a4,156(a4)
    80005b06:	f0f70ae3          	beq	a4,a5,80005a1a <consoleintr+0x3c>
      cons.e--;
    80005b0a:	37fd                	addiw	a5,a5,-1
    80005b0c:	00020717          	auipc	a4,0x20
    80005b10:	6cf72a23          	sw	a5,1748(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b14:	10000513          	li	a0,256
    80005b18:	00000097          	auipc	ra,0x0
    80005b1c:	e84080e7          	jalr	-380(ra) # 8000599c <consputc>
    80005b20:	bded                	j	80005a1a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b22:	ee048ce3          	beqz	s1,80005a1a <consoleintr+0x3c>
    80005b26:	bf21                	j	80005a3e <consoleintr+0x60>
      consputc(c);
    80005b28:	4529                	li	a0,10
    80005b2a:	00000097          	auipc	ra,0x0
    80005b2e:	e72080e7          	jalr	-398(ra) # 8000599c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b32:	00020797          	auipc	a5,0x20
    80005b36:	60e78793          	addi	a5,a5,1550 # 80026140 <cons>
    80005b3a:	0a07a703          	lw	a4,160(a5)
    80005b3e:	0017069b          	addiw	a3,a4,1
    80005b42:	0006861b          	sext.w	a2,a3
    80005b46:	0ad7a023          	sw	a3,160(a5)
    80005b4a:	07f77713          	andi	a4,a4,127
    80005b4e:	97ba                	add	a5,a5,a4
    80005b50:	4729                	li	a4,10
    80005b52:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b56:	00020797          	auipc	a5,0x20
    80005b5a:	68c7a323          	sw	a2,1670(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b5e:	00020517          	auipc	a0,0x20
    80005b62:	67a50513          	addi	a0,a0,1658 # 800261d8 <cons+0x98>
    80005b66:	ffffc097          	auipc	ra,0xffffc
    80005b6a:	b80080e7          	jalr	-1152(ra) # 800016e6 <wakeup>
    80005b6e:	b575                	j	80005a1a <consoleintr+0x3c>

0000000080005b70 <consoleinit>:

void
consoleinit(void)
{
    80005b70:	1141                	addi	sp,sp,-16
    80005b72:	e406                	sd	ra,8(sp)
    80005b74:	e022                	sd	s0,0(sp)
    80005b76:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b78:	00003597          	auipc	a1,0x3
    80005b7c:	ce058593          	addi	a1,a1,-800 # 80008858 <syscalls+0x3d0>
    80005b80:	00020517          	auipc	a0,0x20
    80005b84:	5c050513          	addi	a0,a0,1472 # 80026140 <cons>
    80005b88:	00000097          	auipc	ra,0x0
    80005b8c:	580080e7          	jalr	1408(ra) # 80006108 <initlock>

  uartinit();
    80005b90:	00000097          	auipc	ra,0x0
    80005b94:	32c080e7          	jalr	812(ra) # 80005ebc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b98:	00013797          	auipc	a5,0x13
    80005b9c:	73078793          	addi	a5,a5,1840 # 800192c8 <devsw>
    80005ba0:	00000717          	auipc	a4,0x0
    80005ba4:	cea70713          	addi	a4,a4,-790 # 8000588a <consoleread>
    80005ba8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005baa:	00000717          	auipc	a4,0x0
    80005bae:	c7c70713          	addi	a4,a4,-900 # 80005826 <consolewrite>
    80005bb2:	ef98                	sd	a4,24(a5)
}
    80005bb4:	60a2                	ld	ra,8(sp)
    80005bb6:	6402                	ld	s0,0(sp)
    80005bb8:	0141                	addi	sp,sp,16
    80005bba:	8082                	ret

0000000080005bbc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bbc:	7179                	addi	sp,sp,-48
    80005bbe:	f406                	sd	ra,40(sp)
    80005bc0:	f022                	sd	s0,32(sp)
    80005bc2:	ec26                	sd	s1,24(sp)
    80005bc4:	e84a                	sd	s2,16(sp)
    80005bc6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bc8:	c219                	beqz	a2,80005bce <printint+0x12>
    80005bca:	08054763          	bltz	a0,80005c58 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005bce:	2501                	sext.w	a0,a0
    80005bd0:	4881                	li	a7,0
    80005bd2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bd6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bd8:	2581                	sext.w	a1,a1
    80005bda:	00003617          	auipc	a2,0x3
    80005bde:	cae60613          	addi	a2,a2,-850 # 80008888 <digits>
    80005be2:	883a                	mv	a6,a4
    80005be4:	2705                	addiw	a4,a4,1
    80005be6:	02b577bb          	remuw	a5,a0,a1
    80005bea:	1782                	slli	a5,a5,0x20
    80005bec:	9381                	srli	a5,a5,0x20
    80005bee:	97b2                	add	a5,a5,a2
    80005bf0:	0007c783          	lbu	a5,0(a5)
    80005bf4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bf8:	0005079b          	sext.w	a5,a0
    80005bfc:	02b5553b          	divuw	a0,a0,a1
    80005c00:	0685                	addi	a3,a3,1
    80005c02:	feb7f0e3          	bgeu	a5,a1,80005be2 <printint+0x26>

  if(sign)
    80005c06:	00088c63          	beqz	a7,80005c1e <printint+0x62>
    buf[i++] = '-';
    80005c0a:	fe070793          	addi	a5,a4,-32
    80005c0e:	00878733          	add	a4,a5,s0
    80005c12:	02d00793          	li	a5,45
    80005c16:	fef70823          	sb	a5,-16(a4)
    80005c1a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c1e:	02e05763          	blez	a4,80005c4c <printint+0x90>
    80005c22:	fd040793          	addi	a5,s0,-48
    80005c26:	00e784b3          	add	s1,a5,a4
    80005c2a:	fff78913          	addi	s2,a5,-1
    80005c2e:	993a                	add	s2,s2,a4
    80005c30:	377d                	addiw	a4,a4,-1
    80005c32:	1702                	slli	a4,a4,0x20
    80005c34:	9301                	srli	a4,a4,0x20
    80005c36:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c3a:	fff4c503          	lbu	a0,-1(s1)
    80005c3e:	00000097          	auipc	ra,0x0
    80005c42:	d5e080e7          	jalr	-674(ra) # 8000599c <consputc>
  while(--i >= 0)
    80005c46:	14fd                	addi	s1,s1,-1
    80005c48:	ff2499e3          	bne	s1,s2,80005c3a <printint+0x7e>
}
    80005c4c:	70a2                	ld	ra,40(sp)
    80005c4e:	7402                	ld	s0,32(sp)
    80005c50:	64e2                	ld	s1,24(sp)
    80005c52:	6942                	ld	s2,16(sp)
    80005c54:	6145                	addi	sp,sp,48
    80005c56:	8082                	ret
    x = -xx;
    80005c58:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c5c:	4885                	li	a7,1
    x = -xx;
    80005c5e:	bf95                	j	80005bd2 <printint+0x16>

0000000080005c60 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c60:	1101                	addi	sp,sp,-32
    80005c62:	ec06                	sd	ra,24(sp)
    80005c64:	e822                	sd	s0,16(sp)
    80005c66:	e426                	sd	s1,8(sp)
    80005c68:	1000                	addi	s0,sp,32
    80005c6a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c6c:	00020797          	auipc	a5,0x20
    80005c70:	5807aa23          	sw	zero,1428(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c74:	00003517          	auipc	a0,0x3
    80005c78:	bec50513          	addi	a0,a0,-1044 # 80008860 <syscalls+0x3d8>
    80005c7c:	00000097          	auipc	ra,0x0
    80005c80:	02e080e7          	jalr	46(ra) # 80005caa <printf>
  printf(s);
    80005c84:	8526                	mv	a0,s1
    80005c86:	00000097          	auipc	ra,0x0
    80005c8a:	024080e7          	jalr	36(ra) # 80005caa <printf>
  printf("\n");
    80005c8e:	00002517          	auipc	a0,0x2
    80005c92:	3ba50513          	addi	a0,a0,954 # 80008048 <etext+0x48>
    80005c96:	00000097          	auipc	ra,0x0
    80005c9a:	014080e7          	jalr	20(ra) # 80005caa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c9e:	4785                	li	a5,1
    80005ca0:	00003717          	auipc	a4,0x3
    80005ca4:	36f72e23          	sw	a5,892(a4) # 8000901c <panicked>
  for(;;)
    80005ca8:	a001                	j	80005ca8 <panic+0x48>

0000000080005caa <printf>:
{
    80005caa:	7131                	addi	sp,sp,-192
    80005cac:	fc86                	sd	ra,120(sp)
    80005cae:	f8a2                	sd	s0,112(sp)
    80005cb0:	f4a6                	sd	s1,104(sp)
    80005cb2:	f0ca                	sd	s2,96(sp)
    80005cb4:	ecce                	sd	s3,88(sp)
    80005cb6:	e8d2                	sd	s4,80(sp)
    80005cb8:	e4d6                	sd	s5,72(sp)
    80005cba:	e0da                	sd	s6,64(sp)
    80005cbc:	fc5e                	sd	s7,56(sp)
    80005cbe:	f862                	sd	s8,48(sp)
    80005cc0:	f466                	sd	s9,40(sp)
    80005cc2:	f06a                	sd	s10,32(sp)
    80005cc4:	ec6e                	sd	s11,24(sp)
    80005cc6:	0100                	addi	s0,sp,128
    80005cc8:	8a2a                	mv	s4,a0
    80005cca:	e40c                	sd	a1,8(s0)
    80005ccc:	e810                	sd	a2,16(s0)
    80005cce:	ec14                	sd	a3,24(s0)
    80005cd0:	f018                	sd	a4,32(s0)
    80005cd2:	f41c                	sd	a5,40(s0)
    80005cd4:	03043823          	sd	a6,48(s0)
    80005cd8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cdc:	00020d97          	auipc	s11,0x20
    80005ce0:	524dad83          	lw	s11,1316(s11) # 80026200 <pr+0x18>
  if(locking)
    80005ce4:	020d9b63          	bnez	s11,80005d1a <printf+0x70>
  if (fmt == 0)
    80005ce8:	040a0263          	beqz	s4,80005d2c <printf+0x82>
  va_start(ap, fmt);
    80005cec:	00840793          	addi	a5,s0,8
    80005cf0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cf4:	000a4503          	lbu	a0,0(s4)
    80005cf8:	14050f63          	beqz	a0,80005e56 <printf+0x1ac>
    80005cfc:	4981                	li	s3,0
    if(c != '%'){
    80005cfe:	02500a93          	li	s5,37
    switch(c){
    80005d02:	07000b93          	li	s7,112
  consputc('x');
    80005d06:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d08:	00003b17          	auipc	s6,0x3
    80005d0c:	b80b0b13          	addi	s6,s6,-1152 # 80008888 <digits>
    switch(c){
    80005d10:	07300c93          	li	s9,115
    80005d14:	06400c13          	li	s8,100
    80005d18:	a82d                	j	80005d52 <printf+0xa8>
    acquire(&pr.lock);
    80005d1a:	00020517          	auipc	a0,0x20
    80005d1e:	4ce50513          	addi	a0,a0,1230 # 800261e8 <pr>
    80005d22:	00000097          	auipc	ra,0x0
    80005d26:	476080e7          	jalr	1142(ra) # 80006198 <acquire>
    80005d2a:	bf7d                	j	80005ce8 <printf+0x3e>
    panic("null fmt");
    80005d2c:	00003517          	auipc	a0,0x3
    80005d30:	b4450513          	addi	a0,a0,-1212 # 80008870 <syscalls+0x3e8>
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	f2c080e7          	jalr	-212(ra) # 80005c60 <panic>
      consputc(c);
    80005d3c:	00000097          	auipc	ra,0x0
    80005d40:	c60080e7          	jalr	-928(ra) # 8000599c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d44:	2985                	addiw	s3,s3,1
    80005d46:	013a07b3          	add	a5,s4,s3
    80005d4a:	0007c503          	lbu	a0,0(a5)
    80005d4e:	10050463          	beqz	a0,80005e56 <printf+0x1ac>
    if(c != '%'){
    80005d52:	ff5515e3          	bne	a0,s5,80005d3c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d56:	2985                	addiw	s3,s3,1
    80005d58:	013a07b3          	add	a5,s4,s3
    80005d5c:	0007c783          	lbu	a5,0(a5)
    80005d60:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d64:	cbed                	beqz	a5,80005e56 <printf+0x1ac>
    switch(c){
    80005d66:	05778a63          	beq	a5,s7,80005dba <printf+0x110>
    80005d6a:	02fbf663          	bgeu	s7,a5,80005d96 <printf+0xec>
    80005d6e:	09978863          	beq	a5,s9,80005dfe <printf+0x154>
    80005d72:	07800713          	li	a4,120
    80005d76:	0ce79563          	bne	a5,a4,80005e40 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d7a:	f8843783          	ld	a5,-120(s0)
    80005d7e:	00878713          	addi	a4,a5,8
    80005d82:	f8e43423          	sd	a4,-120(s0)
    80005d86:	4605                	li	a2,1
    80005d88:	85ea                	mv	a1,s10
    80005d8a:	4388                	lw	a0,0(a5)
    80005d8c:	00000097          	auipc	ra,0x0
    80005d90:	e30080e7          	jalr	-464(ra) # 80005bbc <printint>
      break;
    80005d94:	bf45                	j	80005d44 <printf+0x9a>
    switch(c){
    80005d96:	09578f63          	beq	a5,s5,80005e34 <printf+0x18a>
    80005d9a:	0b879363          	bne	a5,s8,80005e40 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d9e:	f8843783          	ld	a5,-120(s0)
    80005da2:	00878713          	addi	a4,a5,8
    80005da6:	f8e43423          	sd	a4,-120(s0)
    80005daa:	4605                	li	a2,1
    80005dac:	45a9                	li	a1,10
    80005dae:	4388                	lw	a0,0(a5)
    80005db0:	00000097          	auipc	ra,0x0
    80005db4:	e0c080e7          	jalr	-500(ra) # 80005bbc <printint>
      break;
    80005db8:	b771                	j	80005d44 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005dba:	f8843783          	ld	a5,-120(s0)
    80005dbe:	00878713          	addi	a4,a5,8
    80005dc2:	f8e43423          	sd	a4,-120(s0)
    80005dc6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005dca:	03000513          	li	a0,48
    80005dce:	00000097          	auipc	ra,0x0
    80005dd2:	bce080e7          	jalr	-1074(ra) # 8000599c <consputc>
  consputc('x');
    80005dd6:	07800513          	li	a0,120
    80005dda:	00000097          	auipc	ra,0x0
    80005dde:	bc2080e7          	jalr	-1086(ra) # 8000599c <consputc>
    80005de2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005de4:	03c95793          	srli	a5,s2,0x3c
    80005de8:	97da                	add	a5,a5,s6
    80005dea:	0007c503          	lbu	a0,0(a5)
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	bae080e7          	jalr	-1106(ra) # 8000599c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005df6:	0912                	slli	s2,s2,0x4
    80005df8:	34fd                	addiw	s1,s1,-1
    80005dfa:	f4ed                	bnez	s1,80005de4 <printf+0x13a>
    80005dfc:	b7a1                	j	80005d44 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005dfe:	f8843783          	ld	a5,-120(s0)
    80005e02:	00878713          	addi	a4,a5,8
    80005e06:	f8e43423          	sd	a4,-120(s0)
    80005e0a:	6384                	ld	s1,0(a5)
    80005e0c:	cc89                	beqz	s1,80005e26 <printf+0x17c>
      for(; *s; s++)
    80005e0e:	0004c503          	lbu	a0,0(s1)
    80005e12:	d90d                	beqz	a0,80005d44 <printf+0x9a>
        consputc(*s);
    80005e14:	00000097          	auipc	ra,0x0
    80005e18:	b88080e7          	jalr	-1144(ra) # 8000599c <consputc>
      for(; *s; s++)
    80005e1c:	0485                	addi	s1,s1,1
    80005e1e:	0004c503          	lbu	a0,0(s1)
    80005e22:	f96d                	bnez	a0,80005e14 <printf+0x16a>
    80005e24:	b705                	j	80005d44 <printf+0x9a>
        s = "(null)";
    80005e26:	00003497          	auipc	s1,0x3
    80005e2a:	a4248493          	addi	s1,s1,-1470 # 80008868 <syscalls+0x3e0>
      for(; *s; s++)
    80005e2e:	02800513          	li	a0,40
    80005e32:	b7cd                	j	80005e14 <printf+0x16a>
      consputc('%');
    80005e34:	8556                	mv	a0,s5
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	b66080e7          	jalr	-1178(ra) # 8000599c <consputc>
      break;
    80005e3e:	b719                	j	80005d44 <printf+0x9a>
      consputc('%');
    80005e40:	8556                	mv	a0,s5
    80005e42:	00000097          	auipc	ra,0x0
    80005e46:	b5a080e7          	jalr	-1190(ra) # 8000599c <consputc>
      consputc(c);
    80005e4a:	8526                	mv	a0,s1
    80005e4c:	00000097          	auipc	ra,0x0
    80005e50:	b50080e7          	jalr	-1200(ra) # 8000599c <consputc>
      break;
    80005e54:	bdc5                	j	80005d44 <printf+0x9a>
  if(locking)
    80005e56:	020d9163          	bnez	s11,80005e78 <printf+0x1ce>
}
    80005e5a:	70e6                	ld	ra,120(sp)
    80005e5c:	7446                	ld	s0,112(sp)
    80005e5e:	74a6                	ld	s1,104(sp)
    80005e60:	7906                	ld	s2,96(sp)
    80005e62:	69e6                	ld	s3,88(sp)
    80005e64:	6a46                	ld	s4,80(sp)
    80005e66:	6aa6                	ld	s5,72(sp)
    80005e68:	6b06                	ld	s6,64(sp)
    80005e6a:	7be2                	ld	s7,56(sp)
    80005e6c:	7c42                	ld	s8,48(sp)
    80005e6e:	7ca2                	ld	s9,40(sp)
    80005e70:	7d02                	ld	s10,32(sp)
    80005e72:	6de2                	ld	s11,24(sp)
    80005e74:	6129                	addi	sp,sp,192
    80005e76:	8082                	ret
    release(&pr.lock);
    80005e78:	00020517          	auipc	a0,0x20
    80005e7c:	37050513          	addi	a0,a0,880 # 800261e8 <pr>
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	3cc080e7          	jalr	972(ra) # 8000624c <release>
}
    80005e88:	bfc9                	j	80005e5a <printf+0x1b0>

0000000080005e8a <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e8a:	1101                	addi	sp,sp,-32
    80005e8c:	ec06                	sd	ra,24(sp)
    80005e8e:	e822                	sd	s0,16(sp)
    80005e90:	e426                	sd	s1,8(sp)
    80005e92:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e94:	00020497          	auipc	s1,0x20
    80005e98:	35448493          	addi	s1,s1,852 # 800261e8 <pr>
    80005e9c:	00003597          	auipc	a1,0x3
    80005ea0:	9e458593          	addi	a1,a1,-1564 # 80008880 <syscalls+0x3f8>
    80005ea4:	8526                	mv	a0,s1
    80005ea6:	00000097          	auipc	ra,0x0
    80005eaa:	262080e7          	jalr	610(ra) # 80006108 <initlock>
  pr.locking = 1;
    80005eae:	4785                	li	a5,1
    80005eb0:	cc9c                	sw	a5,24(s1)
}
    80005eb2:	60e2                	ld	ra,24(sp)
    80005eb4:	6442                	ld	s0,16(sp)
    80005eb6:	64a2                	ld	s1,8(sp)
    80005eb8:	6105                	addi	sp,sp,32
    80005eba:	8082                	ret

0000000080005ebc <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ebc:	1141                	addi	sp,sp,-16
    80005ebe:	e406                	sd	ra,8(sp)
    80005ec0:	e022                	sd	s0,0(sp)
    80005ec2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ec4:	100007b7          	lui	a5,0x10000
    80005ec8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ecc:	f8000713          	li	a4,-128
    80005ed0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ed4:	470d                	li	a4,3
    80005ed6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005eda:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ede:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ee2:	469d                	li	a3,7
    80005ee4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ee8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005eec:	00003597          	auipc	a1,0x3
    80005ef0:	9b458593          	addi	a1,a1,-1612 # 800088a0 <digits+0x18>
    80005ef4:	00020517          	auipc	a0,0x20
    80005ef8:	31450513          	addi	a0,a0,788 # 80026208 <uart_tx_lock>
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	20c080e7          	jalr	524(ra) # 80006108 <initlock>
}
    80005f04:	60a2                	ld	ra,8(sp)
    80005f06:	6402                	ld	s0,0(sp)
    80005f08:	0141                	addi	sp,sp,16
    80005f0a:	8082                	ret

0000000080005f0c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f0c:	1101                	addi	sp,sp,-32
    80005f0e:	ec06                	sd	ra,24(sp)
    80005f10:	e822                	sd	s0,16(sp)
    80005f12:	e426                	sd	s1,8(sp)
    80005f14:	1000                	addi	s0,sp,32
    80005f16:	84aa                	mv	s1,a0
  push_off();
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	234080e7          	jalr	564(ra) # 8000614c <push_off>

  if(panicked){
    80005f20:	00003797          	auipc	a5,0x3
    80005f24:	0fc7a783          	lw	a5,252(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f28:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f2c:	c391                	beqz	a5,80005f30 <uartputc_sync+0x24>
    for(;;)
    80005f2e:	a001                	j	80005f2e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f30:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f34:	0207f793          	andi	a5,a5,32
    80005f38:	dfe5                	beqz	a5,80005f30 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f3a:	0ff4f513          	zext.b	a0,s1
    80005f3e:	100007b7          	lui	a5,0x10000
    80005f42:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f46:	00000097          	auipc	ra,0x0
    80005f4a:	2a6080e7          	jalr	678(ra) # 800061ec <pop_off>
}
    80005f4e:	60e2                	ld	ra,24(sp)
    80005f50:	6442                	ld	s0,16(sp)
    80005f52:	64a2                	ld	s1,8(sp)
    80005f54:	6105                	addi	sp,sp,32
    80005f56:	8082                	ret

0000000080005f58 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f58:	00003797          	auipc	a5,0x3
    80005f5c:	0c87b783          	ld	a5,200(a5) # 80009020 <uart_tx_r>
    80005f60:	00003717          	auipc	a4,0x3
    80005f64:	0c873703          	ld	a4,200(a4) # 80009028 <uart_tx_w>
    80005f68:	06f70a63          	beq	a4,a5,80005fdc <uartstart+0x84>
{
    80005f6c:	7139                	addi	sp,sp,-64
    80005f6e:	fc06                	sd	ra,56(sp)
    80005f70:	f822                	sd	s0,48(sp)
    80005f72:	f426                	sd	s1,40(sp)
    80005f74:	f04a                	sd	s2,32(sp)
    80005f76:	ec4e                	sd	s3,24(sp)
    80005f78:	e852                	sd	s4,16(sp)
    80005f7a:	e456                	sd	s5,8(sp)
    80005f7c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f7e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f82:	00020a17          	auipc	s4,0x20
    80005f86:	286a0a13          	addi	s4,s4,646 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f8a:	00003497          	auipc	s1,0x3
    80005f8e:	09648493          	addi	s1,s1,150 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f92:	00003997          	auipc	s3,0x3
    80005f96:	09698993          	addi	s3,s3,150 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f9a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f9e:	02077713          	andi	a4,a4,32
    80005fa2:	c705                	beqz	a4,80005fca <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fa4:	01f7f713          	andi	a4,a5,31
    80005fa8:	9752                	add	a4,a4,s4
    80005faa:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005fae:	0785                	addi	a5,a5,1
    80005fb0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fb2:	8526                	mv	a0,s1
    80005fb4:	ffffb097          	auipc	ra,0xffffb
    80005fb8:	732080e7          	jalr	1842(ra) # 800016e6 <wakeup>
    
    WriteReg(THR, c);
    80005fbc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fc0:	609c                	ld	a5,0(s1)
    80005fc2:	0009b703          	ld	a4,0(s3)
    80005fc6:	fcf71ae3          	bne	a4,a5,80005f9a <uartstart+0x42>
  }
}
    80005fca:	70e2                	ld	ra,56(sp)
    80005fcc:	7442                	ld	s0,48(sp)
    80005fce:	74a2                	ld	s1,40(sp)
    80005fd0:	7902                	ld	s2,32(sp)
    80005fd2:	69e2                	ld	s3,24(sp)
    80005fd4:	6a42                	ld	s4,16(sp)
    80005fd6:	6aa2                	ld	s5,8(sp)
    80005fd8:	6121                	addi	sp,sp,64
    80005fda:	8082                	ret
    80005fdc:	8082                	ret

0000000080005fde <uartputc>:
{
    80005fde:	7179                	addi	sp,sp,-48
    80005fe0:	f406                	sd	ra,40(sp)
    80005fe2:	f022                	sd	s0,32(sp)
    80005fe4:	ec26                	sd	s1,24(sp)
    80005fe6:	e84a                	sd	s2,16(sp)
    80005fe8:	e44e                	sd	s3,8(sp)
    80005fea:	e052                	sd	s4,0(sp)
    80005fec:	1800                	addi	s0,sp,48
    80005fee:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005ff0:	00020517          	auipc	a0,0x20
    80005ff4:	21850513          	addi	a0,a0,536 # 80026208 <uart_tx_lock>
    80005ff8:	00000097          	auipc	ra,0x0
    80005ffc:	1a0080e7          	jalr	416(ra) # 80006198 <acquire>
  if(panicked){
    80006000:	00003797          	auipc	a5,0x3
    80006004:	01c7a783          	lw	a5,28(a5) # 8000901c <panicked>
    80006008:	c391                	beqz	a5,8000600c <uartputc+0x2e>
    for(;;)
    8000600a:	a001                	j	8000600a <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000600c:	00003717          	auipc	a4,0x3
    80006010:	01c73703          	ld	a4,28(a4) # 80009028 <uart_tx_w>
    80006014:	00003797          	auipc	a5,0x3
    80006018:	00c7b783          	ld	a5,12(a5) # 80009020 <uart_tx_r>
    8000601c:	02078793          	addi	a5,a5,32
    80006020:	02e79b63          	bne	a5,a4,80006056 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006024:	00020997          	auipc	s3,0x20
    80006028:	1e498993          	addi	s3,s3,484 # 80026208 <uart_tx_lock>
    8000602c:	00003497          	auipc	s1,0x3
    80006030:	ff448493          	addi	s1,s1,-12 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006034:	00003917          	auipc	s2,0x3
    80006038:	ff490913          	addi	s2,s2,-12 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000603c:	85ce                	mv	a1,s3
    8000603e:	8526                	mv	a0,s1
    80006040:	ffffb097          	auipc	ra,0xffffb
    80006044:	51a080e7          	jalr	1306(ra) # 8000155a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006048:	00093703          	ld	a4,0(s2)
    8000604c:	609c                	ld	a5,0(s1)
    8000604e:	02078793          	addi	a5,a5,32
    80006052:	fee785e3          	beq	a5,a4,8000603c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006056:	00020497          	auipc	s1,0x20
    8000605a:	1b248493          	addi	s1,s1,434 # 80026208 <uart_tx_lock>
    8000605e:	01f77793          	andi	a5,a4,31
    80006062:	97a6                	add	a5,a5,s1
    80006064:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006068:	0705                	addi	a4,a4,1
    8000606a:	00003797          	auipc	a5,0x3
    8000606e:	fae7bf23          	sd	a4,-66(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006072:	00000097          	auipc	ra,0x0
    80006076:	ee6080e7          	jalr	-282(ra) # 80005f58 <uartstart>
      release(&uart_tx_lock);
    8000607a:	8526                	mv	a0,s1
    8000607c:	00000097          	auipc	ra,0x0
    80006080:	1d0080e7          	jalr	464(ra) # 8000624c <release>
}
    80006084:	70a2                	ld	ra,40(sp)
    80006086:	7402                	ld	s0,32(sp)
    80006088:	64e2                	ld	s1,24(sp)
    8000608a:	6942                	ld	s2,16(sp)
    8000608c:	69a2                	ld	s3,8(sp)
    8000608e:	6a02                	ld	s4,0(sp)
    80006090:	6145                	addi	sp,sp,48
    80006092:	8082                	ret

0000000080006094 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006094:	1141                	addi	sp,sp,-16
    80006096:	e422                	sd	s0,8(sp)
    80006098:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000609a:	100007b7          	lui	a5,0x10000
    8000609e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060a2:	8b85                	andi	a5,a5,1
    800060a4:	cb81                	beqz	a5,800060b4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800060a6:	100007b7          	lui	a5,0x10000
    800060aa:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800060ae:	6422                	ld	s0,8(sp)
    800060b0:	0141                	addi	sp,sp,16
    800060b2:	8082                	ret
    return -1;
    800060b4:	557d                	li	a0,-1
    800060b6:	bfe5                	j	800060ae <uartgetc+0x1a>

00000000800060b8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060b8:	1101                	addi	sp,sp,-32
    800060ba:	ec06                	sd	ra,24(sp)
    800060bc:	e822                	sd	s0,16(sp)
    800060be:	e426                	sd	s1,8(sp)
    800060c0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060c2:	54fd                	li	s1,-1
    800060c4:	a029                	j	800060ce <uartintr+0x16>
      break;
    consoleintr(c);
    800060c6:	00000097          	auipc	ra,0x0
    800060ca:	918080e7          	jalr	-1768(ra) # 800059de <consoleintr>
    int c = uartgetc();
    800060ce:	00000097          	auipc	ra,0x0
    800060d2:	fc6080e7          	jalr	-58(ra) # 80006094 <uartgetc>
    if(c == -1)
    800060d6:	fe9518e3          	bne	a0,s1,800060c6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060da:	00020497          	auipc	s1,0x20
    800060de:	12e48493          	addi	s1,s1,302 # 80026208 <uart_tx_lock>
    800060e2:	8526                	mv	a0,s1
    800060e4:	00000097          	auipc	ra,0x0
    800060e8:	0b4080e7          	jalr	180(ra) # 80006198 <acquire>
  uartstart();
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	e6c080e7          	jalr	-404(ra) # 80005f58 <uartstart>
  release(&uart_tx_lock);
    800060f4:	8526                	mv	a0,s1
    800060f6:	00000097          	auipc	ra,0x0
    800060fa:	156080e7          	jalr	342(ra) # 8000624c <release>
}
    800060fe:	60e2                	ld	ra,24(sp)
    80006100:	6442                	ld	s0,16(sp)
    80006102:	64a2                	ld	s1,8(sp)
    80006104:	6105                	addi	sp,sp,32
    80006106:	8082                	ret

0000000080006108 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006108:	1141                	addi	sp,sp,-16
    8000610a:	e422                	sd	s0,8(sp)
    8000610c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000610e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006110:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006114:	00053823          	sd	zero,16(a0)
}
    80006118:	6422                	ld	s0,8(sp)
    8000611a:	0141                	addi	sp,sp,16
    8000611c:	8082                	ret

000000008000611e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000611e:	411c                	lw	a5,0(a0)
    80006120:	e399                	bnez	a5,80006126 <holding+0x8>
    80006122:	4501                	li	a0,0
  return r;
}
    80006124:	8082                	ret
{
    80006126:	1101                	addi	sp,sp,-32
    80006128:	ec06                	sd	ra,24(sp)
    8000612a:	e822                	sd	s0,16(sp)
    8000612c:	e426                	sd	s1,8(sp)
    8000612e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006130:	6904                	ld	s1,16(a0)
    80006132:	ffffb097          	auipc	ra,0xffffb
    80006136:	d40080e7          	jalr	-704(ra) # 80000e72 <mycpu>
    8000613a:	40a48533          	sub	a0,s1,a0
    8000613e:	00153513          	seqz	a0,a0
}
    80006142:	60e2                	ld	ra,24(sp)
    80006144:	6442                	ld	s0,16(sp)
    80006146:	64a2                	ld	s1,8(sp)
    80006148:	6105                	addi	sp,sp,32
    8000614a:	8082                	ret

000000008000614c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000614c:	1101                	addi	sp,sp,-32
    8000614e:	ec06                	sd	ra,24(sp)
    80006150:	e822                	sd	s0,16(sp)
    80006152:	e426                	sd	s1,8(sp)
    80006154:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006156:	100024f3          	csrr	s1,sstatus
    8000615a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000615e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006160:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006164:	ffffb097          	auipc	ra,0xffffb
    80006168:	d0e080e7          	jalr	-754(ra) # 80000e72 <mycpu>
    8000616c:	5d3c                	lw	a5,120(a0)
    8000616e:	cf89                	beqz	a5,80006188 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006170:	ffffb097          	auipc	ra,0xffffb
    80006174:	d02080e7          	jalr	-766(ra) # 80000e72 <mycpu>
    80006178:	5d3c                	lw	a5,120(a0)
    8000617a:	2785                	addiw	a5,a5,1
    8000617c:	dd3c                	sw	a5,120(a0)
}
    8000617e:	60e2                	ld	ra,24(sp)
    80006180:	6442                	ld	s0,16(sp)
    80006182:	64a2                	ld	s1,8(sp)
    80006184:	6105                	addi	sp,sp,32
    80006186:	8082                	ret
    mycpu()->intena = old;
    80006188:	ffffb097          	auipc	ra,0xffffb
    8000618c:	cea080e7          	jalr	-790(ra) # 80000e72 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006190:	8085                	srli	s1,s1,0x1
    80006192:	8885                	andi	s1,s1,1
    80006194:	dd64                	sw	s1,124(a0)
    80006196:	bfe9                	j	80006170 <push_off+0x24>

0000000080006198 <acquire>:
{
    80006198:	1101                	addi	sp,sp,-32
    8000619a:	ec06                	sd	ra,24(sp)
    8000619c:	e822                	sd	s0,16(sp)
    8000619e:	e426                	sd	s1,8(sp)
    800061a0:	1000                	addi	s0,sp,32
    800061a2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061a4:	00000097          	auipc	ra,0x0
    800061a8:	fa8080e7          	jalr	-88(ra) # 8000614c <push_off>
  if(holding(lk))
    800061ac:	8526                	mv	a0,s1
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	f70080e7          	jalr	-144(ra) # 8000611e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061b6:	4705                	li	a4,1
  if(holding(lk))
    800061b8:	e115                	bnez	a0,800061dc <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061ba:	87ba                	mv	a5,a4
    800061bc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061c0:	2781                	sext.w	a5,a5
    800061c2:	ffe5                	bnez	a5,800061ba <acquire+0x22>
  __sync_synchronize();
    800061c4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061c8:	ffffb097          	auipc	ra,0xffffb
    800061cc:	caa080e7          	jalr	-854(ra) # 80000e72 <mycpu>
    800061d0:	e888                	sd	a0,16(s1)
}
    800061d2:	60e2                	ld	ra,24(sp)
    800061d4:	6442                	ld	s0,16(sp)
    800061d6:	64a2                	ld	s1,8(sp)
    800061d8:	6105                	addi	sp,sp,32
    800061da:	8082                	ret
    panic("acquire");
    800061dc:	00002517          	auipc	a0,0x2
    800061e0:	6cc50513          	addi	a0,a0,1740 # 800088a8 <digits+0x20>
    800061e4:	00000097          	auipc	ra,0x0
    800061e8:	a7c080e7          	jalr	-1412(ra) # 80005c60 <panic>

00000000800061ec <pop_off>:

void
pop_off(void)
{
    800061ec:	1141                	addi	sp,sp,-16
    800061ee:	e406                	sd	ra,8(sp)
    800061f0:	e022                	sd	s0,0(sp)
    800061f2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061f4:	ffffb097          	auipc	ra,0xffffb
    800061f8:	c7e080e7          	jalr	-898(ra) # 80000e72 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061fc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006200:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006202:	e78d                	bnez	a5,8000622c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006204:	5d3c                	lw	a5,120(a0)
    80006206:	02f05b63          	blez	a5,8000623c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000620a:	37fd                	addiw	a5,a5,-1
    8000620c:	0007871b          	sext.w	a4,a5
    80006210:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006212:	eb09                	bnez	a4,80006224 <pop_off+0x38>
    80006214:	5d7c                	lw	a5,124(a0)
    80006216:	c799                	beqz	a5,80006224 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006218:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000621c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006220:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006224:	60a2                	ld	ra,8(sp)
    80006226:	6402                	ld	s0,0(sp)
    80006228:	0141                	addi	sp,sp,16
    8000622a:	8082                	ret
    panic("pop_off - interruptible");
    8000622c:	00002517          	auipc	a0,0x2
    80006230:	68450513          	addi	a0,a0,1668 # 800088b0 <digits+0x28>
    80006234:	00000097          	auipc	ra,0x0
    80006238:	a2c080e7          	jalr	-1492(ra) # 80005c60 <panic>
    panic("pop_off");
    8000623c:	00002517          	auipc	a0,0x2
    80006240:	68c50513          	addi	a0,a0,1676 # 800088c8 <digits+0x40>
    80006244:	00000097          	auipc	ra,0x0
    80006248:	a1c080e7          	jalr	-1508(ra) # 80005c60 <panic>

000000008000624c <release>:
{
    8000624c:	1101                	addi	sp,sp,-32
    8000624e:	ec06                	sd	ra,24(sp)
    80006250:	e822                	sd	s0,16(sp)
    80006252:	e426                	sd	s1,8(sp)
    80006254:	1000                	addi	s0,sp,32
    80006256:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006258:	00000097          	auipc	ra,0x0
    8000625c:	ec6080e7          	jalr	-314(ra) # 8000611e <holding>
    80006260:	c115                	beqz	a0,80006284 <release+0x38>
  lk->cpu = 0;
    80006262:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006266:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000626a:	0f50000f          	fence	iorw,ow
    8000626e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006272:	00000097          	auipc	ra,0x0
    80006276:	f7a080e7          	jalr	-134(ra) # 800061ec <pop_off>
}
    8000627a:	60e2                	ld	ra,24(sp)
    8000627c:	6442                	ld	s0,16(sp)
    8000627e:	64a2                	ld	s1,8(sp)
    80006280:	6105                	addi	sp,sp,32
    80006282:	8082                	ret
    panic("release");
    80006284:	00002517          	auipc	a0,0x2
    80006288:	64c50513          	addi	a0,a0,1612 # 800088d0 <digits+0x48>
    8000628c:	00000097          	auipc	ra,0x0
    80006290:	9d4080e7          	jalr	-1580(ra) # 80005c60 <panic>
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
