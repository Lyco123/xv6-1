
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00021117          	auipc	sp,0x21
    80000004:	b7010113          	addi	sp,sp,-1168 # 80020b70 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	418050ef          	jal	8000542e <start>

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
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00029797          	auipc	a5,0x29
    80000034:	c4078793          	addi	a5,a5,-960 # 80028c70 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	00008917          	auipc	s2,0x8
    80000050:	8f490913          	addi	s2,s2,-1804 # 80007940 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	63b050ef          	jal	80005e90 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	6c3050ef          	jal	80005f28 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	2e5050ef          	jal	80005b62 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	00008517          	auipc	a0,0x8
    800000de:	86650513          	addi	a0,a0,-1946 # 80007940 <kmem>
    800000e2:	52f050ef          	jal	80005e10 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00029517          	auipc	a0,0x29
    800000ee:	b8650513          	addi	a0,a0,-1146 # 80028c70 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	00008497          	auipc	s1,0x8
    8000010c:	83848493          	addi	s1,s1,-1992 # 80007940 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	57f050ef          	jal	80005e90 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	00008517          	auipc	a0,0x8
    80000120:	82450513          	addi	a0,a0,-2012 # 80007940 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	603050ef          	jal	80005f28 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	00008517          	auipc	a0,0x8
    80000144:	80050513          	addi	a0,a0,-2048 # 80007940 <kmem>
    80000148:	5e1050ef          	jal	80005f28 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000154:	ca19                	beqz	a2,8000016a <memset+0x1c>
    80000156:	87aa                	mv	a5,a0
    80000158:	1602                	slli	a2,a2,0x20
    8000015a:	9201                	srli	a2,a2,0x20
    8000015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000164:	0785                	addi	a5,a5,1
    80000166:	fee79de3          	bne	a5,a4,80000160 <memset+0x12>
  }
  return dst;
}
    8000016a:	6422                	ld	s0,8(sp)
    8000016c:	0141                	addi	sp,sp,16
    8000016e:	8082                	ret

0000000080000170 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000170:	1141                	addi	sp,sp,-16
    80000172:	e422                	sd	s0,8(sp)
    80000174:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000176:	ca05                	beqz	a2,800001a6 <memcmp+0x36>
    80000178:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000017c:	1682                	slli	a3,a3,0x20
    8000017e:	9281                	srli	a3,a3,0x20
    80000180:	0685                	addi	a3,a3,1
    80000182:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000184:	00054783          	lbu	a5,0(a0)
    80000188:	0005c703          	lbu	a4,0(a1)
    8000018c:	00e79863          	bne	a5,a4,8000019c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000190:	0505                	addi	a0,a0,1
    80000192:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000194:	fed518e3          	bne	a0,a3,80000184 <memcmp+0x14>
  }

  return 0;
    80000198:	4501                	li	a0,0
    8000019a:	a019                	j	800001a0 <memcmp+0x30>
      return *s1 - *s2;
    8000019c:	40e7853b          	subw	a0,a5,a4
}
    800001a0:	6422                	ld	s0,8(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret
  return 0;
    800001a6:	4501                	li	a0,0
    800001a8:	bfe5                	j	800001a0 <memcmp+0x30>

00000000800001aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001aa:	1141                	addi	sp,sp,-16
    800001ac:	e422                	sd	s0,8(sp)
    800001ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b0:	c205                	beqz	a2,800001d0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b2:	02a5e263          	bltu	a1,a0,800001d6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b6:	1602                	slli	a2,a2,0x20
    800001b8:	9201                	srli	a2,a2,0x20
    800001ba:	00c587b3          	add	a5,a1,a2
{
    800001be:	872a                	mv	a4,a0
      *d++ = *s++;
    800001c0:	0585                	addi	a1,a1,1
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd6391>
    800001c4:	fff5c683          	lbu	a3,-1(a1)
    800001c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001cc:	feb79ae3          	bne	a5,a1,800001c0 <memmove+0x16>

  return dst;
}
    800001d0:	6422                	ld	s0,8(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  if(s < d && s + n > d){
    800001d6:	02061693          	slli	a3,a2,0x20
    800001da:	9281                	srli	a3,a3,0x20
    800001dc:	00d58733          	add	a4,a1,a3
    800001e0:	fce57be3          	bgeu	a0,a4,800001b6 <memmove+0xc>
    d += n;
    800001e4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e6:	fff6079b          	addiw	a5,a2,-1
    800001ea:	1782                	slli	a5,a5,0x20
    800001ec:	9381                	srli	a5,a5,0x20
    800001ee:	fff7c793          	not	a5,a5
    800001f2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f4:	177d                	addi	a4,a4,-1
    800001f6:	16fd                	addi	a3,a3,-1
    800001f8:	00074603          	lbu	a2,0(a4)
    800001fc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000200:	fef71ae3          	bne	a4,a5,800001f4 <memmove+0x4a>
    80000204:	b7f1                	j	800001d0 <memmove+0x26>

0000000080000206 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020e:	f9dff0ef          	jal	800001aa <memmove>
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000220:	ce11                	beqz	a2,8000023c <strncmp+0x22>
    80000222:	00054783          	lbu	a5,0(a0)
    80000226:	cf89                	beqz	a5,80000240 <strncmp+0x26>
    80000228:	0005c703          	lbu	a4,0(a1)
    8000022c:	00f71a63          	bne	a4,a5,80000240 <strncmp+0x26>
    n--, p++, q++;
    80000230:	367d                	addiw	a2,a2,-1
    80000232:	0505                	addi	a0,a0,1
    80000234:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000236:	f675                	bnez	a2,80000222 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000238:	4501                	li	a0,0
    8000023a:	a801                	j	8000024a <strncmp+0x30>
    8000023c:	4501                	li	a0,0
    8000023e:	a031                	j	8000024a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000240:	00054503          	lbu	a0,0(a0)
    80000244:	0005c783          	lbu	a5,0(a1)
    80000248:	9d1d                	subw	a0,a0,a5
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000256:	87aa                	mv	a5,a0
    80000258:	86b2                	mv	a3,a2
    8000025a:	367d                	addiw	a2,a2,-1
    8000025c:	02d05563          	blez	a3,80000286 <strncpy+0x36>
    80000260:	0785                	addi	a5,a5,1
    80000262:	0005c703          	lbu	a4,0(a1)
    80000266:	fee78fa3          	sb	a4,-1(a5)
    8000026a:	0585                	addi	a1,a1,1
    8000026c:	f775                	bnez	a4,80000258 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000026e:	873e                	mv	a4,a5
    80000270:	9fb5                	addw	a5,a5,a3
    80000272:	37fd                	addiw	a5,a5,-1
    80000274:	00c05963          	blez	a2,80000286 <strncpy+0x36>
    *s++ = 0;
    80000278:	0705                	addi	a4,a4,1
    8000027a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000027e:	40e786bb          	subw	a3,a5,a4
    80000282:	fed04be3          	bgtz	a3,80000278 <strncpy+0x28>
  return os;
}
    80000286:	6422                	ld	s0,8(sp)
    80000288:	0141                	addi	sp,sp,16
    8000028a:	8082                	ret

000000008000028c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000292:	02c05363          	blez	a2,800002b8 <safestrcpy+0x2c>
    80000296:	fff6069b          	addiw	a3,a2,-1
    8000029a:	1682                	slli	a3,a3,0x20
    8000029c:	9281                	srli	a3,a3,0x20
    8000029e:	96ae                	add	a3,a3,a1
    800002a0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002a2:	00d58963          	beq	a1,a3,800002b4 <safestrcpy+0x28>
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	0785                	addi	a5,a5,1
    800002aa:	fff5c703          	lbu	a4,-1(a1)
    800002ae:	fee78fa3          	sb	a4,-1(a5)
    800002b2:	fb65                	bnez	a4,800002a2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002b4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <strlen>:

int
strlen(const char *s)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002c4:	00054783          	lbu	a5,0(a0)
    800002c8:	cf91                	beqz	a5,800002e4 <strlen+0x26>
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	87aa                	mv	a5,a0
    800002ce:	86be                	mv	a3,a5
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff7c703          	lbu	a4,-1(a5)
    800002d6:	ff65                	bnez	a4,800002ce <strlen+0x10>
    800002d8:	40a6853b          	subw	a0,a3,a0
    800002dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002de:	6422                	ld	s0,8(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret
  for(n = 0; s[n]; n++)
    800002e4:	4501                	li	a0,0
    800002e6:	bfe5                	j	800002de <strlen+0x20>

00000000800002e8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f0:	2b9000ef          	jal	80000da8 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002f4:	00007717          	auipc	a4,0x7
    800002f8:	61c70713          	addi	a4,a4,1564 # 80007910 <started>
  if(cpuid() == 0){
    800002fc:	c51d                	beqz	a0,8000032a <main+0x42>
    while(started == 0)
    800002fe:	431c                	lw	a5,0(a4)
    80000300:	2781                	sext.w	a5,a5
    80000302:	dff5                	beqz	a5,800002fe <main+0x16>
      ;
    __sync_synchronize();
    80000304:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000308:	2a1000ef          	jal	80000da8 <cpuid>
    8000030c:	85aa                	mv	a1,a0
    8000030e:	00007517          	auipc	a0,0x7
    80000312:	d2a50513          	addi	a0,a0,-726 # 80007038 <etext+0x38>
    80000316:	57a050ef          	jal	80005890 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	778010ef          	jal	80001a96 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	327040ef          	jal	80004e48 <plicinithart>
  }

  scheduler();        
    80000326:	759000ef          	jal	8000127e <scheduler>
    consoleinit();
    8000032a:	490050ef          	jal	800057ba <consoleinit>
    printfinit();
    8000032e:	06f050ef          	jal	80005b9c <printfinit>
    printf("\n");
    80000332:	00007517          	auipc	a0,0x7
    80000336:	ce650513          	addi	a0,a0,-794 # 80007018 <etext+0x18>
    8000033a:	556050ef          	jal	80005890 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	ce250513          	addi	a0,a0,-798 # 80007020 <etext+0x20>
    80000346:	54a050ef          	jal	80005890 <printf>
    printf("\n");
    8000034a:	00007517          	auipc	a0,0x7
    8000034e:	cce50513          	addi	a0,a0,-818 # 80007018 <etext+0x18>
    80000352:	53e050ef          	jal	80005890 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2ca000ef          	jal	80000624 <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	191000ef          	jal	80000cf2 <procinit>
    trapinit();      // trap vectors
    80000366:	70c010ef          	jal	80001a72 <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	72c010ef          	jal	80001a96 <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	2c1040ef          	jal	80004e2e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	2d7040ef          	jal	80004e48 <plicinithart>
    binit();         // buffer cache
    80000376:	68d010ef          	jal	80002202 <binit>
    iinit();         // inode table
    8000037a:	47e020ef          	jal	800027f8 <iinit>
    fileinit();      // file table
    8000037e:	22a030ef          	jal	800035a8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	3b7040ef          	jal	80004f38 <virtio_disk_init>
    userinit();      // first user process
    80000386:	4b3000ef          	jal	80001038 <userinit>
    __sync_synchronize();
    8000038a:	0ff0000f          	fence
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	00007717          	auipc	a4,0x7
    80000394:	58f72023          	sw	a5,1408(a4) # 80007910 <started>
    80000398:	b779                	j	80000326 <main+0x3e>

000000008000039a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e422                	sd	s0,8(sp)
    8000039e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003a0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003a4:	00007797          	auipc	a5,0x7
    800003a8:	5747b783          	ld	a5,1396(a5) # 80007918 <kernel_pagetable>
    800003ac:	83b1                	srli	a5,a5,0xc
    800003ae:	577d                	li	a4,-1
    800003b0:	177e                	slli	a4,a4,0x3f
    800003b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003b4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003b8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003bc:	6422                	ld	s0,8(sp)
    800003be:	0141                	addi	sp,sp,16
    800003c0:	8082                	ret

00000000800003c2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003c2:	7139                	addi	sp,sp,-64
    800003c4:	fc06                	sd	ra,56(sp)
    800003c6:	f822                	sd	s0,48(sp)
    800003c8:	f426                	sd	s1,40(sp)
    800003ca:	f04a                	sd	s2,32(sp)
    800003cc:	ec4e                	sd	s3,24(sp)
    800003ce:	e852                	sd	s4,16(sp)
    800003d0:	e456                	sd	s5,8(sp)
    800003d2:	e05a                	sd	s6,0(sp)
    800003d4:	0080                	addi	s0,sp,64
    800003d6:	84aa                	mv	s1,a0
    800003d8:	89ae                	mv	s3,a1
    800003da:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003dc:	57fd                	li	a5,-1
    800003de:	83e9                	srli	a5,a5,0x1a
    800003e0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003e2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003e4:	02b7fc63          	bgeu	a5,a1,8000041c <walk+0x5a>
    panic("walk");
    800003e8:	00007517          	auipc	a0,0x7
    800003ec:	c6850513          	addi	a0,a0,-920 # 80007050 <etext+0x50>
    800003f0:	772050ef          	jal	80005b62 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003f4:	060a8263          	beqz	s5,80000458 <walk+0x96>
    800003f8:	d07ff0ef          	jal	800000fe <kalloc>
    800003fc:	84aa                	mv	s1,a0
    800003fe:	c139                	beqz	a0,80000444 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000400:	6605                	lui	a2,0x1
    80000402:	4581                	li	a1,0
    80000404:	d4bff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000408:	00c4d793          	srli	a5,s1,0xc
    8000040c:	07aa                	slli	a5,a5,0xa
    8000040e:	0017e793          	ori	a5,a5,1
    80000412:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd6387>
    80000418:	036a0063          	beq	s4,s6,80000438 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000041c:	0149d933          	srl	s2,s3,s4
    80000420:	1ff97913          	andi	s2,s2,511
    80000424:	090e                	slli	s2,s2,0x3
    80000426:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000428:	00093483          	ld	s1,0(s2)
    8000042c:	0014f793          	andi	a5,s1,1
    80000430:	d3f1                	beqz	a5,800003f4 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000432:	80a9                	srli	s1,s1,0xa
    80000434:	04b2                	slli	s1,s1,0xc
    80000436:	b7c5                	j	80000416 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000438:	00c9d513          	srli	a0,s3,0xc
    8000043c:	1ff57513          	andi	a0,a0,511
    80000440:	050e                	slli	a0,a0,0x3
    80000442:	9526                	add	a0,a0,s1
}
    80000444:	70e2                	ld	ra,56(sp)
    80000446:	7442                	ld	s0,48(sp)
    80000448:	74a2                	ld	s1,40(sp)
    8000044a:	7902                	ld	s2,32(sp)
    8000044c:	69e2                	ld	s3,24(sp)
    8000044e:	6a42                	ld	s4,16(sp)
    80000450:	6aa2                	ld	s5,8(sp)
    80000452:	6b02                	ld	s6,0(sp)
    80000454:	6121                	addi	sp,sp,64
    80000456:	8082                	ret
        return 0;
    80000458:	4501                	li	a0,0
    8000045a:	b7ed                	j	80000444 <walk+0x82>

000000008000045c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000045c:	57fd                	li	a5,-1
    8000045e:	83e9                	srli	a5,a5,0x1a
    80000460:	00b7f463          	bgeu	a5,a1,80000468 <walkaddr+0xc>
    return 0;
    80000464:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000466:	8082                	ret
{
    80000468:	1141                	addi	sp,sp,-16
    8000046a:	e406                	sd	ra,8(sp)
    8000046c:	e022                	sd	s0,0(sp)
    8000046e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000470:	4601                	li	a2,0
    80000472:	f51ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000476:	c105                	beqz	a0,80000496 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000478:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000047a:	0117f693          	andi	a3,a5,17
    8000047e:	4745                	li	a4,17
    return 0;
    80000480:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000482:	00e68663          	beq	a3,a4,8000048e <walkaddr+0x32>
}
    80000486:	60a2                	ld	ra,8(sp)
    80000488:	6402                	ld	s0,0(sp)
    8000048a:	0141                	addi	sp,sp,16
    8000048c:	8082                	ret
  pa = PTE2PA(*pte);
    8000048e:	83a9                	srli	a5,a5,0xa
    80000490:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000494:	bfcd                	j	80000486 <walkaddr+0x2a>
    return 0;
    80000496:	4501                	li	a0,0
    80000498:	b7fd                	j	80000486 <walkaddr+0x2a>

000000008000049a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000049a:	715d                	addi	sp,sp,-80
    8000049c:	e486                	sd	ra,72(sp)
    8000049e:	e0a2                	sd	s0,64(sp)
    800004a0:	fc26                	sd	s1,56(sp)
    800004a2:	f84a                	sd	s2,48(sp)
    800004a4:	f44e                	sd	s3,40(sp)
    800004a6:	f052                	sd	s4,32(sp)
    800004a8:	ec56                	sd	s5,24(sp)
    800004aa:	e85a                	sd	s6,16(sp)
    800004ac:	e45e                	sd	s7,8(sp)
    800004ae:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004b0:	03459793          	slli	a5,a1,0x34
    800004b4:	e7a9                	bnez	a5,800004fe <mappages+0x64>
    800004b6:	8aaa                	mv	s5,a0
    800004b8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004ba:	03461793          	slli	a5,a2,0x34
    800004be:	e7b1                	bnez	a5,8000050a <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004c0:	ca39                	beqz	a2,80000516 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004c2:	77fd                	lui	a5,0xfffff
    800004c4:	963e                	add	a2,a2,a5
    800004c6:	00b609b3          	add	s3,a2,a1
  a = va;
    800004ca:	892e                	mv	s2,a1
    800004cc:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004d0:	6b85                	lui	s7,0x1
    800004d2:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004d6:	4605                	li	a2,1
    800004d8:	85ca                	mv	a1,s2
    800004da:	8556                	mv	a0,s5
    800004dc:	ee7ff0ef          	jal	800003c2 <walk>
    800004e0:	c539                	beqz	a0,8000052e <mappages+0x94>
    if(*pte & PTE_V)
    800004e2:	611c                	ld	a5,0(a0)
    800004e4:	8b85                	andi	a5,a5,1
    800004e6:	ef95                	bnez	a5,80000522 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004e8:	80b1                	srli	s1,s1,0xc
    800004ea:	04aa                	slli	s1,s1,0xa
    800004ec:	0164e4b3          	or	s1,s1,s6
    800004f0:	0014e493          	ori	s1,s1,1
    800004f4:	e104                	sd	s1,0(a0)
    if(a == last)
    800004f6:	05390863          	beq	s2,s3,80000546 <mappages+0xac>
    a += PGSIZE;
    800004fa:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fc:	bfd9                	j	800004d2 <mappages+0x38>
    panic("mappages: va not aligned");
    800004fe:	00007517          	auipc	a0,0x7
    80000502:	b5a50513          	addi	a0,a0,-1190 # 80007058 <etext+0x58>
    80000506:	65c050ef          	jal	80005b62 <panic>
    panic("mappages: size not aligned");
    8000050a:	00007517          	auipc	a0,0x7
    8000050e:	b6e50513          	addi	a0,a0,-1170 # 80007078 <etext+0x78>
    80000512:	650050ef          	jal	80005b62 <panic>
    panic("mappages: size");
    80000516:	00007517          	auipc	a0,0x7
    8000051a:	b8250513          	addi	a0,a0,-1150 # 80007098 <etext+0x98>
    8000051e:	644050ef          	jal	80005b62 <panic>
      panic("mappages: remap");
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b8650513          	addi	a0,a0,-1146 # 800070a8 <etext+0xa8>
    8000052a:	638050ef          	jal	80005b62 <panic>
      return -1;
    8000052e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000530:	60a6                	ld	ra,72(sp)
    80000532:	6406                	ld	s0,64(sp)
    80000534:	74e2                	ld	s1,56(sp)
    80000536:	7942                	ld	s2,48(sp)
    80000538:	79a2                	ld	s3,40(sp)
    8000053a:	7a02                	ld	s4,32(sp)
    8000053c:	6ae2                	ld	s5,24(sp)
    8000053e:	6b42                	ld	s6,16(sp)
    80000540:	6ba2                	ld	s7,8(sp)
    80000542:	6161                	addi	sp,sp,80
    80000544:	8082                	ret
  return 0;
    80000546:	4501                	li	a0,0
    80000548:	b7e5                	j	80000530 <mappages+0x96>

000000008000054a <kvmmap>:
{
    8000054a:	1141                	addi	sp,sp,-16
    8000054c:	e406                	sd	ra,8(sp)
    8000054e:	e022                	sd	s0,0(sp)
    80000550:	0800                	addi	s0,sp,16
    80000552:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000554:	86b2                	mv	a3,a2
    80000556:	863e                	mv	a2,a5
    80000558:	f43ff0ef          	jal	8000049a <mappages>
    8000055c:	e509                	bnez	a0,80000566 <kvmmap+0x1c>
}
    8000055e:	60a2                	ld	ra,8(sp)
    80000560:	6402                	ld	s0,0(sp)
    80000562:	0141                	addi	sp,sp,16
    80000564:	8082                	ret
    panic("kvmmap");
    80000566:	00007517          	auipc	a0,0x7
    8000056a:	b5250513          	addi	a0,a0,-1198 # 800070b8 <etext+0xb8>
    8000056e:	5f4050ef          	jal	80005b62 <panic>

0000000080000572 <kvmmake>:
{
    80000572:	1101                	addi	sp,sp,-32
    80000574:	ec06                	sd	ra,24(sp)
    80000576:	e822                	sd	s0,16(sp)
    80000578:	e426                	sd	s1,8(sp)
    8000057a:	e04a                	sd	s2,0(sp)
    8000057c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000057e:	b81ff0ef          	jal	800000fe <kalloc>
    80000582:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000584:	6605                	lui	a2,0x1
    80000586:	4581                	li	a1,0
    80000588:	bc7ff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000058c:	4719                	li	a4,6
    8000058e:	6685                	lui	a3,0x1
    80000590:	10000637          	lui	a2,0x10000
    80000594:	100005b7          	lui	a1,0x10000
    80000598:	8526                	mv	a0,s1
    8000059a:	fb1ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000059e:	4719                	li	a4,6
    800005a0:	6685                	lui	a3,0x1
    800005a2:	10001637          	lui	a2,0x10001
    800005a6:	100015b7          	lui	a1,0x10001
    800005aa:	8526                	mv	a0,s1
    800005ac:	f9fff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005b0:	4719                	li	a4,6
    800005b2:	040006b7          	lui	a3,0x4000
    800005b6:	0c000637          	lui	a2,0xc000
    800005ba:	0c0005b7          	lui	a1,0xc000
    800005be:	8526                	mv	a0,s1
    800005c0:	f8bff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005c4:	00007917          	auipc	s2,0x7
    800005c8:	a3c90913          	addi	s2,s2,-1476 # 80007000 <etext>
    800005cc:	4729                	li	a4,10
    800005ce:	80007697          	auipc	a3,0x80007
    800005d2:	a3268693          	addi	a3,a3,-1486 # 7000 <_entry-0x7fff9000>
    800005d6:	4605                	li	a2,1
    800005d8:	067e                	slli	a2,a2,0x1f
    800005da:	85b2                	mv	a1,a2
    800005dc:	8526                	mv	a0,s1
    800005de:	f6dff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005e2:	46c5                	li	a3,17
    800005e4:	06ee                	slli	a3,a3,0x1b
    800005e6:	4719                	li	a4,6
    800005e8:	412686b3          	sub	a3,a3,s2
    800005ec:	864a                	mv	a2,s2
    800005ee:	85ca                	mv	a1,s2
    800005f0:	8526                	mv	a0,s1
    800005f2:	f59ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005f6:	4729                	li	a4,10
    800005f8:	6685                	lui	a3,0x1
    800005fa:	00006617          	auipc	a2,0x6
    800005fe:	a0660613          	addi	a2,a2,-1530 # 80006000 <_trampoline>
    80000602:	040005b7          	lui	a1,0x4000
    80000606:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000608:	05b2                	slli	a1,a1,0xc
    8000060a:	8526                	mv	a0,s1
    8000060c:	f3fff0ef          	jal	8000054a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000610:	8526                	mv	a0,s1
    80000612:	648000ef          	jal	80000c5a <proc_mapstacks>
}
    80000616:	8526                	mv	a0,s1
    80000618:	60e2                	ld	ra,24(sp)
    8000061a:	6442                	ld	s0,16(sp)
    8000061c:	64a2                	ld	s1,8(sp)
    8000061e:	6902                	ld	s2,0(sp)
    80000620:	6105                	addi	sp,sp,32
    80000622:	8082                	ret

0000000080000624 <kvminit>:
{
    80000624:	1141                	addi	sp,sp,-16
    80000626:	e406                	sd	ra,8(sp)
    80000628:	e022                	sd	s0,0(sp)
    8000062a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000062c:	f47ff0ef          	jal	80000572 <kvmmake>
    80000630:	00007797          	auipc	a5,0x7
    80000634:	2ea7b423          	sd	a0,744(a5) # 80007918 <kernel_pagetable>
}
    80000638:	60a2                	ld	ra,8(sp)
    8000063a:	6402                	ld	s0,0(sp)
    8000063c:	0141                	addi	sp,sp,16
    8000063e:	8082                	ret

0000000080000640 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000640:	715d                	addi	sp,sp,-80
    80000642:	e486                	sd	ra,72(sp)
    80000644:	e0a2                	sd	s0,64(sp)
    80000646:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000648:	03459793          	slli	a5,a1,0x34
    8000064c:	e39d                	bnez	a5,80000672 <uvmunmap+0x32>
    8000064e:	f84a                	sd	s2,48(sp)
    80000650:	f44e                	sd	s3,40(sp)
    80000652:	f052                	sd	s4,32(sp)
    80000654:	ec56                	sd	s5,24(sp)
    80000656:	e85a                	sd	s6,16(sp)
    80000658:	e45e                	sd	s7,8(sp)
    8000065a:	8a2a                	mv	s4,a0
    8000065c:	892e                	mv	s2,a1
    8000065e:	8bb6                	mv	s7,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000660:	0632                	slli	a2,a2,0xc
    80000662:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      continue;
    if(PTE_FLAGS(*pte) == PTE_V)
    80000666:	4b05                	li	s6,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000668:	6a85                	lui	s5,0x1
    8000066a:	0735f463          	bgeu	a1,s3,800006d2 <uvmunmap+0x92>
    8000066e:	fc26                	sd	s1,56(sp)
    80000670:	a80d                	j	800006a2 <uvmunmap+0x62>
    80000672:	fc26                	sd	s1,56(sp)
    80000674:	f84a                	sd	s2,48(sp)
    80000676:	f44e                	sd	s3,40(sp)
    80000678:	f052                	sd	s4,32(sp)
    8000067a:	ec56                	sd	s5,24(sp)
    8000067c:	e85a                	sd	s6,16(sp)
    8000067e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a4050513          	addi	a0,a0,-1472 # 800070c0 <etext+0xc0>
    80000688:	4da050ef          	jal	80005b62 <panic>
      panic("uvmunmap: walk");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a4c50513          	addi	a0,a0,-1460 # 800070d8 <etext+0xd8>
    80000694:	4ce050ef          	jal	80005b62 <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000698:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000069c:	9956                	add	s2,s2,s5
    8000069e:	03397963          	bgeu	s2,s3,800006d0 <uvmunmap+0x90>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006a2:	4601                	li	a2,0
    800006a4:	85ca                	mv	a1,s2
    800006a6:	8552                	mv	a0,s4
    800006a8:	d1bff0ef          	jal	800003c2 <walk>
    800006ac:	84aa                	mv	s1,a0
    800006ae:	dd79                	beqz	a0,8000068c <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    800006b0:	611c                	ld	a5,0(a0)
    800006b2:	0017f713          	andi	a4,a5,1
    800006b6:	d37d                	beqz	a4,8000069c <uvmunmap+0x5c>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006b8:	3ff7f713          	andi	a4,a5,1023
    800006bc:	ff6700e3          	beq	a4,s6,8000069c <uvmunmap+0x5c>
    if(do_free){
    800006c0:	fc0b8ce3          	beqz	s7,80000698 <uvmunmap+0x58>
      uint64 pa = PTE2PA(*pte);
    800006c4:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800006c6:	00c79513          	slli	a0,a5,0xc
    800006ca:	953ff0ef          	jal	8000001c <kfree>
    800006ce:	b7e9                	j	80000698 <uvmunmap+0x58>
    800006d0:	74e2                	ld	s1,56(sp)
    800006d2:	7942                	ld	s2,48(sp)
    800006d4:	79a2                	ld	s3,40(sp)
    800006d6:	7a02                	ld	s4,32(sp)
    800006d8:	6ae2                	ld	s5,24(sp)
    800006da:	6b42                	ld	s6,16(sp)
    800006dc:	6ba2                	ld	s7,8(sp)
  }
}
    800006de:	60a6                	ld	ra,72(sp)
    800006e0:	6406                	ld	s0,64(sp)
    800006e2:	6161                	addi	sp,sp,80
    800006e4:	8082                	ret

00000000800006e6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800006e6:	1101                	addi	sp,sp,-32
    800006e8:	ec06                	sd	ra,24(sp)
    800006ea:	e822                	sd	s0,16(sp)
    800006ec:	e426                	sd	s1,8(sp)
    800006ee:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800006f0:	a0fff0ef          	jal	800000fe <kalloc>
    800006f4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800006f6:	c509                	beqz	a0,80000700 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800006f8:	6605                	lui	a2,0x1
    800006fa:	4581                	li	a1,0
    800006fc:	a53ff0ef          	jal	8000014e <memset>
  return pagetable;
}
    80000700:	8526                	mv	a0,s1
    80000702:	60e2                	ld	ra,24(sp)
    80000704:	6442                	ld	s0,16(sp)
    80000706:	64a2                	ld	s1,8(sp)
    80000708:	6105                	addi	sp,sp,32
    8000070a:	8082                	ret

000000008000070c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000070c:	7179                	addi	sp,sp,-48
    8000070e:	f406                	sd	ra,40(sp)
    80000710:	f022                	sd	s0,32(sp)
    80000712:	ec26                	sd	s1,24(sp)
    80000714:	e84a                	sd	s2,16(sp)
    80000716:	e44e                	sd	s3,8(sp)
    80000718:	e052                	sd	s4,0(sp)
    8000071a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000071c:	6785                	lui	a5,0x1
    8000071e:	04f67063          	bgeu	a2,a5,8000075e <uvmfirst+0x52>
    80000722:	8a2a                	mv	s4,a0
    80000724:	89ae                	mv	s3,a1
    80000726:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000728:	9d7ff0ef          	jal	800000fe <kalloc>
    8000072c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000072e:	6605                	lui	a2,0x1
    80000730:	4581                	li	a1,0
    80000732:	a1dff0ef          	jal	8000014e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000736:	4779                	li	a4,30
    80000738:	86ca                	mv	a3,s2
    8000073a:	6605                	lui	a2,0x1
    8000073c:	4581                	li	a1,0
    8000073e:	8552                	mv	a0,s4
    80000740:	d5bff0ef          	jal	8000049a <mappages>
  memmove(mem, src, sz);
    80000744:	8626                	mv	a2,s1
    80000746:	85ce                	mv	a1,s3
    80000748:	854a                	mv	a0,s2
    8000074a:	a61ff0ef          	jal	800001aa <memmove>
}
    8000074e:	70a2                	ld	ra,40(sp)
    80000750:	7402                	ld	s0,32(sp)
    80000752:	64e2                	ld	s1,24(sp)
    80000754:	6942                	ld	s2,16(sp)
    80000756:	69a2                	ld	s3,8(sp)
    80000758:	6a02                	ld	s4,0(sp)
    8000075a:	6145                	addi	sp,sp,48
    8000075c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000075e:	00007517          	auipc	a0,0x7
    80000762:	98a50513          	addi	a0,a0,-1654 # 800070e8 <etext+0xe8>
    80000766:	3fc050ef          	jal	80005b62 <panic>

000000008000076a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000076a:	1101                	addi	sp,sp,-32
    8000076c:	ec06                	sd	ra,24(sp)
    8000076e:	e822                	sd	s0,16(sp)
    80000770:	e426                	sd	s1,8(sp)
    80000772:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000774:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000776:	00b67d63          	bgeu	a2,a1,80000790 <uvmdealloc+0x26>
    8000077a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000077c:	6785                	lui	a5,0x1
    8000077e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000780:	00f60733          	add	a4,a2,a5
    80000784:	76fd                	lui	a3,0xfffff
    80000786:	8f75                	and	a4,a4,a3
    80000788:	97ae                	add	a5,a5,a1
    8000078a:	8ff5                	and	a5,a5,a3
    8000078c:	00f76863          	bltu	a4,a5,8000079c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000790:	8526                	mv	a0,s1
    80000792:	60e2                	ld	ra,24(sp)
    80000794:	6442                	ld	s0,16(sp)
    80000796:	64a2                	ld	s1,8(sp)
    80000798:	6105                	addi	sp,sp,32
    8000079a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000079c:	8f99                	sub	a5,a5,a4
    8000079e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007a0:	4685                	li	a3,1
    800007a2:	0007861b          	sext.w	a2,a5
    800007a6:	85ba                	mv	a1,a4
    800007a8:	e99ff0ef          	jal	80000640 <uvmunmap>
    800007ac:	b7d5                	j	80000790 <uvmdealloc+0x26>

00000000800007ae <uvmalloc>:
  if(newsz < oldsz)
    800007ae:	08b66f63          	bltu	a2,a1,8000084c <uvmalloc+0x9e>
{
    800007b2:	7139                	addi	sp,sp,-64
    800007b4:	fc06                	sd	ra,56(sp)
    800007b6:	f822                	sd	s0,48(sp)
    800007b8:	ec4e                	sd	s3,24(sp)
    800007ba:	e852                	sd	s4,16(sp)
    800007bc:	e456                	sd	s5,8(sp)
    800007be:	0080                	addi	s0,sp,64
    800007c0:	8aaa                	mv	s5,a0
    800007c2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007c4:	6785                	lui	a5,0x1
    800007c6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007c8:	95be                	add	a1,a1,a5
    800007ca:	77fd                	lui	a5,0xfffff
    800007cc:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800007d0:	08c9f063          	bgeu	s3,a2,80000850 <uvmalloc+0xa2>
    800007d4:	f426                	sd	s1,40(sp)
    800007d6:	f04a                	sd	s2,32(sp)
    800007d8:	e05a                	sd	s6,0(sp)
    800007da:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007dc:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007e0:	91fff0ef          	jal	800000fe <kalloc>
    800007e4:	84aa                	mv	s1,a0
    if(mem == 0){
    800007e6:	c515                	beqz	a0,80000812 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	963ff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007f0:	875a                	mv	a4,s6
    800007f2:	86a6                	mv	a3,s1
    800007f4:	6605                	lui	a2,0x1
    800007f6:	85ca                	mv	a1,s2
    800007f8:	8556                	mv	a0,s5
    800007fa:	ca1ff0ef          	jal	8000049a <mappages>
    800007fe:	e915                	bnez	a0,80000832 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000800:	6785                	lui	a5,0x1
    80000802:	993e                	add	s2,s2,a5
    80000804:	fd496ee3          	bltu	s2,s4,800007e0 <uvmalloc+0x32>
  return newsz;
    80000808:	8552                	mv	a0,s4
    8000080a:	74a2                	ld	s1,40(sp)
    8000080c:	7902                	ld	s2,32(sp)
    8000080e:	6b02                	ld	s6,0(sp)
    80000810:	a811                	j	80000824 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80000812:	864e                	mv	a2,s3
    80000814:	85ca                	mv	a1,s2
    80000816:	8556                	mv	a0,s5
    80000818:	f53ff0ef          	jal	8000076a <uvmdealloc>
      return 0;
    8000081c:	4501                	li	a0,0
    8000081e:	74a2                	ld	s1,40(sp)
    80000820:	7902                	ld	s2,32(sp)
    80000822:	6b02                	ld	s6,0(sp)
}
    80000824:	70e2                	ld	ra,56(sp)
    80000826:	7442                	ld	s0,48(sp)
    80000828:	69e2                	ld	s3,24(sp)
    8000082a:	6a42                	ld	s4,16(sp)
    8000082c:	6aa2                	ld	s5,8(sp)
    8000082e:	6121                	addi	sp,sp,64
    80000830:	8082                	ret
      kfree(mem);
    80000832:	8526                	mv	a0,s1
    80000834:	fe8ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000838:	864e                	mv	a2,s3
    8000083a:	85ca                	mv	a1,s2
    8000083c:	8556                	mv	a0,s5
    8000083e:	f2dff0ef          	jal	8000076a <uvmdealloc>
      return 0;
    80000842:	4501                	li	a0,0
    80000844:	74a2                	ld	s1,40(sp)
    80000846:	7902                	ld	s2,32(sp)
    80000848:	6b02                	ld	s6,0(sp)
    8000084a:	bfe9                	j	80000824 <uvmalloc+0x76>
    return oldsz;
    8000084c:	852e                	mv	a0,a1
}
    8000084e:	8082                	ret
  return newsz;
    80000850:	8532                	mv	a0,a2
    80000852:	bfc9                	j	80000824 <uvmalloc+0x76>

0000000080000854 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000854:	7179                	addi	sp,sp,-48
    80000856:	f406                	sd	ra,40(sp)
    80000858:	f022                	sd	s0,32(sp)
    8000085a:	ec26                	sd	s1,24(sp)
    8000085c:	e84a                	sd	s2,16(sp)
    8000085e:	e44e                	sd	s3,8(sp)
    80000860:	e052                	sd	s4,0(sp)
    80000862:	1800                	addi	s0,sp,48
    80000864:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000866:	84aa                	mv	s1,a0
    80000868:	6905                	lui	s2,0x1
    8000086a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000086c:	4985                	li	s3,1
    8000086e:	a819                	j	80000884 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000870:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000872:	00c79513          	slli	a0,a5,0xc
    80000876:	fdfff0ef          	jal	80000854 <freewalk>
      pagetable[i] = 0;
    8000087a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000087e:	04a1                	addi	s1,s1,8
    80000880:	01248f63          	beq	s1,s2,8000089e <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80000884:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000886:	00f7f713          	andi	a4,a5,15
    8000088a:	ff3703e3          	beq	a4,s3,80000870 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000088e:	8b85                	andi	a5,a5,1
    80000890:	d7fd                	beqz	a5,8000087e <freewalk+0x2a>
      panic("freewalk: leaf");
    80000892:	00007517          	auipc	a0,0x7
    80000896:	87650513          	addi	a0,a0,-1930 # 80007108 <etext+0x108>
    8000089a:	2c8050ef          	jal	80005b62 <panic>
    }
  }
  kfree((void*)pagetable);
    8000089e:	8552                	mv	a0,s4
    800008a0:	f7cff0ef          	jal	8000001c <kfree>
}
    800008a4:	70a2                	ld	ra,40(sp)
    800008a6:	7402                	ld	s0,32(sp)
    800008a8:	64e2                	ld	s1,24(sp)
    800008aa:	6942                	ld	s2,16(sp)
    800008ac:	69a2                	ld	s3,8(sp)
    800008ae:	6a02                	ld	s4,0(sp)
    800008b0:	6145                	addi	sp,sp,48
    800008b2:	8082                	ret

00000000800008b4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008b4:	1101                	addi	sp,sp,-32
    800008b6:	ec06                	sd	ra,24(sp)
    800008b8:	e822                	sd	s0,16(sp)
    800008ba:	e426                	sd	s1,8(sp)
    800008bc:	1000                	addi	s0,sp,32
    800008be:	84aa                	mv	s1,a0
  if(sz > 0)
    800008c0:	e989                	bnez	a1,800008d2 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008c2:	8526                	mv	a0,s1
    800008c4:	f91ff0ef          	jal	80000854 <freewalk>
}
    800008c8:	60e2                	ld	ra,24(sp)
    800008ca:	6442                	ld	s0,16(sp)
    800008cc:	64a2                	ld	s1,8(sp)
    800008ce:	6105                	addi	sp,sp,32
    800008d0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	4685                	li	a3,1
    800008da:	00c5d613          	srli	a2,a1,0xc
    800008de:	4581                	li	a1,0
    800008e0:	d61ff0ef          	jal	80000640 <uvmunmap>
    800008e4:	bff9                	j	800008c2 <uvmfree+0xe>

00000000800008e6 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800008e6:	c65d                	beqz	a2,80000994 <uvmcopy+0xae>
{
    800008e8:	715d                	addi	sp,sp,-80
    800008ea:	e486                	sd	ra,72(sp)
    800008ec:	e0a2                	sd	s0,64(sp)
    800008ee:	fc26                	sd	s1,56(sp)
    800008f0:	f84a                	sd	s2,48(sp)
    800008f2:	f44e                	sd	s3,40(sp)
    800008f4:	f052                	sd	s4,32(sp)
    800008f6:	ec56                	sd	s5,24(sp)
    800008f8:	e85a                	sd	s6,16(sp)
    800008fa:	e45e                	sd	s7,8(sp)
    800008fc:	0880                	addi	s0,sp,80
    800008fe:	8b2a                	mv	s6,a0
    80000900:	8aae                	mv	s5,a1
    80000902:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000904:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000906:	4601                	li	a2,0
    80000908:	85ce                	mv	a1,s3
    8000090a:	855a                	mv	a0,s6
    8000090c:	ab7ff0ef          	jal	800003c2 <walk>
    80000910:	c121                	beqz	a0,80000950 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000912:	6118                	ld	a4,0(a0)
    80000914:	00177793          	andi	a5,a4,1
    80000918:	c3b1                	beqz	a5,8000095c <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000091a:	00a75593          	srli	a1,a4,0xa
    8000091e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000922:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000926:	fd8ff0ef          	jal	800000fe <kalloc>
    8000092a:	892a                	mv	s2,a0
    8000092c:	c129                	beqz	a0,8000096e <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000092e:	6605                	lui	a2,0x1
    80000930:	85de                	mv	a1,s7
    80000932:	879ff0ef          	jal	800001aa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000936:	8726                	mv	a4,s1
    80000938:	86ca                	mv	a3,s2
    8000093a:	6605                	lui	a2,0x1
    8000093c:	85ce                	mv	a1,s3
    8000093e:	8556                	mv	a0,s5
    80000940:	b5bff0ef          	jal	8000049a <mappages>
    80000944:	e115                	bnez	a0,80000968 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    80000946:	6785                	lui	a5,0x1
    80000948:	99be                	add	s3,s3,a5
    8000094a:	fb49eee3          	bltu	s3,s4,80000906 <uvmcopy+0x20>
    8000094e:	a805                	j	8000097e <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000950:	00006517          	auipc	a0,0x6
    80000954:	7c850513          	addi	a0,a0,1992 # 80007118 <etext+0x118>
    80000958:	20a050ef          	jal	80005b62 <panic>
      panic("uvmcopy: page not present");
    8000095c:	00006517          	auipc	a0,0x6
    80000960:	7dc50513          	addi	a0,a0,2012 # 80007138 <etext+0x138>
    80000964:	1fe050ef          	jal	80005b62 <panic>
      kfree(mem);
    80000968:	854a                	mv	a0,s2
    8000096a:	eb2ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000096e:	4685                	li	a3,1
    80000970:	00c9d613          	srli	a2,s3,0xc
    80000974:	4581                	li	a1,0
    80000976:	8556                	mv	a0,s5
    80000978:	cc9ff0ef          	jal	80000640 <uvmunmap>
  return -1;
    8000097c:	557d                	li	a0,-1
}
    8000097e:	60a6                	ld	ra,72(sp)
    80000980:	6406                	ld	s0,64(sp)
    80000982:	74e2                	ld	s1,56(sp)
    80000984:	7942                	ld	s2,48(sp)
    80000986:	79a2                	ld	s3,40(sp)
    80000988:	7a02                	ld	s4,32(sp)
    8000098a:	6ae2                	ld	s5,24(sp)
    8000098c:	6b42                	ld	s6,16(sp)
    8000098e:	6ba2                	ld	s7,8(sp)
    80000990:	6161                	addi	sp,sp,80
    80000992:	8082                	ret
  return 0;
    80000994:	4501                	li	a0,0
}
    80000996:	8082                	ret

0000000080000998 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000998:	1141                	addi	sp,sp,-16
    8000099a:	e406                	sd	ra,8(sp)
    8000099c:	e022                	sd	s0,0(sp)
    8000099e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009a0:	4601                	li	a2,0
    800009a2:	a21ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    800009a6:	c901                	beqz	a0,800009b6 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009a8:	611c                	ld	a5,0(a0)
    800009aa:	9bbd                	andi	a5,a5,-17
    800009ac:	e11c                	sd	a5,0(a0)
}
    800009ae:	60a2                	ld	ra,8(sp)
    800009b0:	6402                	ld	s0,0(sp)
    800009b2:	0141                	addi	sp,sp,16
    800009b4:	8082                	ret
    panic("uvmclear");
    800009b6:	00006517          	auipc	a0,0x6
    800009ba:	7a250513          	addi	a0,a0,1954 # 80007158 <etext+0x158>
    800009be:	1a4050ef          	jal	80005b62 <panic>

00000000800009c2 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800009c2:	cad1                	beqz	a3,80000a56 <copyout+0x94>
{
    800009c4:	711d                	addi	sp,sp,-96
    800009c6:	ec86                	sd	ra,88(sp)
    800009c8:	e8a2                	sd	s0,80(sp)
    800009ca:	e4a6                	sd	s1,72(sp)
    800009cc:	fc4e                	sd	s3,56(sp)
    800009ce:	f456                	sd	s5,40(sp)
    800009d0:	f05a                	sd	s6,32(sp)
    800009d2:	ec5e                	sd	s7,24(sp)
    800009d4:	1080                	addi	s0,sp,96
    800009d6:	8baa                	mv	s7,a0
    800009d8:	8aae                	mv	s5,a1
    800009da:	8b32                	mv	s6,a2
    800009dc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800009de:	74fd                	lui	s1,0xfffff
    800009e0:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    800009e2:	57fd                	li	a5,-1
    800009e4:	83e9                	srli	a5,a5,0x1a
    800009e6:	0697ea63          	bltu	a5,s1,80000a5a <copyout+0x98>
    800009ea:	e0ca                	sd	s2,64(sp)
    800009ec:	f852                	sd	s4,48(sp)
    800009ee:	e862                	sd	s8,16(sp)
    800009f0:	e466                	sd	s9,8(sp)
    800009f2:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800009f4:	4cd5                	li	s9,21
    800009f6:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    800009f8:	8c3e                	mv	s8,a5
    800009fa:	a025                	j	80000a22 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    800009fc:	83a9                	srli	a5,a5,0xa
    800009fe:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a00:	409a8533          	sub	a0,s5,s1
    80000a04:	0009061b          	sext.w	a2,s2
    80000a08:	85da                	mv	a1,s6
    80000a0a:	953e                	add	a0,a0,a5
    80000a0c:	f9eff0ef          	jal	800001aa <memmove>

    len -= n;
    80000a10:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a14:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000a16:	02098963          	beqz	s3,80000a48 <copyout+0x86>
    if(va0 >= MAXVA)
    80000a1a:	054c6263          	bltu	s8,s4,80000a5e <copyout+0x9c>
    80000a1e:	84d2                	mv	s1,s4
    80000a20:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000a22:	4601                	li	a2,0
    80000a24:	85a6                	mv	a1,s1
    80000a26:	855e                	mv	a0,s7
    80000a28:	99bff0ef          	jal	800003c2 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a2c:	c121                	beqz	a0,80000a6c <copyout+0xaa>
    80000a2e:	611c                	ld	a5,0(a0)
    80000a30:	0157f713          	andi	a4,a5,21
    80000a34:	05971b63          	bne	a4,s9,80000a8a <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    80000a38:	01a48a33          	add	s4,s1,s10
    80000a3c:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000a40:	fb29fee3          	bgeu	s3,s2,800009fc <copyout+0x3a>
    80000a44:	894e                	mv	s2,s3
    80000a46:	bf5d                	j	800009fc <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000a48:	4501                	li	a0,0
    80000a4a:	6906                	ld	s2,64(sp)
    80000a4c:	7a42                	ld	s4,48(sp)
    80000a4e:	6c42                	ld	s8,16(sp)
    80000a50:	6ca2                	ld	s9,8(sp)
    80000a52:	6d02                	ld	s10,0(sp)
    80000a54:	a015                	j	80000a78 <copyout+0xb6>
    80000a56:	4501                	li	a0,0
}
    80000a58:	8082                	ret
      return -1;
    80000a5a:	557d                	li	a0,-1
    80000a5c:	a831                	j	80000a78 <copyout+0xb6>
    80000a5e:	557d                	li	a0,-1
    80000a60:	6906                	ld	s2,64(sp)
    80000a62:	7a42                	ld	s4,48(sp)
    80000a64:	6c42                	ld	s8,16(sp)
    80000a66:	6ca2                	ld	s9,8(sp)
    80000a68:	6d02                	ld	s10,0(sp)
    80000a6a:	a039                	j	80000a78 <copyout+0xb6>
      return -1;
    80000a6c:	557d                	li	a0,-1
    80000a6e:	6906                	ld	s2,64(sp)
    80000a70:	7a42                	ld	s4,48(sp)
    80000a72:	6c42                	ld	s8,16(sp)
    80000a74:	6ca2                	ld	s9,8(sp)
    80000a76:	6d02                	ld	s10,0(sp)
}
    80000a78:	60e6                	ld	ra,88(sp)
    80000a7a:	6446                	ld	s0,80(sp)
    80000a7c:	64a6                	ld	s1,72(sp)
    80000a7e:	79e2                	ld	s3,56(sp)
    80000a80:	7aa2                	ld	s5,40(sp)
    80000a82:	7b02                	ld	s6,32(sp)
    80000a84:	6be2                	ld	s7,24(sp)
    80000a86:	6125                	addi	sp,sp,96
    80000a88:	8082                	ret
      return -1;
    80000a8a:	557d                	li	a0,-1
    80000a8c:	6906                	ld	s2,64(sp)
    80000a8e:	7a42                	ld	s4,48(sp)
    80000a90:	6c42                	ld	s8,16(sp)
    80000a92:	6ca2                	ld	s9,8(sp)
    80000a94:	6d02                	ld	s10,0(sp)
    80000a96:	b7cd                	j	80000a78 <copyout+0xb6>

0000000080000a98 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000a98:	c6a5                	beqz	a3,80000b00 <copyin+0x68>
{
    80000a9a:	715d                	addi	sp,sp,-80
    80000a9c:	e486                	sd	ra,72(sp)
    80000a9e:	e0a2                	sd	s0,64(sp)
    80000aa0:	fc26                	sd	s1,56(sp)
    80000aa2:	f84a                	sd	s2,48(sp)
    80000aa4:	f44e                	sd	s3,40(sp)
    80000aa6:	f052                	sd	s4,32(sp)
    80000aa8:	ec56                	sd	s5,24(sp)
    80000aaa:	e85a                	sd	s6,16(sp)
    80000aac:	e45e                	sd	s7,8(sp)
    80000aae:	e062                	sd	s8,0(sp)
    80000ab0:	0880                	addi	s0,sp,80
    80000ab2:	8b2a                	mv	s6,a0
    80000ab4:	8a2e                	mv	s4,a1
    80000ab6:	8c32                	mv	s8,a2
    80000ab8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000aba:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000abc:	6a85                	lui	s5,0x1
    80000abe:	a00d                	j	80000ae0 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ac0:	018505b3          	add	a1,a0,s8
    80000ac4:	0004861b          	sext.w	a2,s1
    80000ac8:	412585b3          	sub	a1,a1,s2
    80000acc:	8552                	mv	a0,s4
    80000ace:	edcff0ef          	jal	800001aa <memmove>

    len -= n;
    80000ad2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000ad6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000ad8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000adc:	02098063          	beqz	s3,80000afc <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000ae0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ae4:	85ca                	mv	a1,s2
    80000ae6:	855a                	mv	a0,s6
    80000ae8:	975ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    80000aec:	cd01                	beqz	a0,80000b04 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000aee:	418904b3          	sub	s1,s2,s8
    80000af2:	94d6                	add	s1,s1,s5
    if(n > len)
    80000af4:	fc99f6e3          	bgeu	s3,s1,80000ac0 <copyin+0x28>
    80000af8:	84ce                	mv	s1,s3
    80000afa:	b7d9                	j	80000ac0 <copyin+0x28>
  }
  return 0;
    80000afc:	4501                	li	a0,0
    80000afe:	a021                	j	80000b06 <copyin+0x6e>
    80000b00:	4501                	li	a0,0
}
    80000b02:	8082                	ret
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
    80000b18:	6c02                	ld	s8,0(sp)
    80000b1a:	6161                	addi	sp,sp,80
    80000b1c:	8082                	ret

0000000080000b1e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b1e:	c6dd                	beqz	a3,80000bcc <copyinstr+0xae>
{
    80000b20:	715d                	addi	sp,sp,-80
    80000b22:	e486                	sd	ra,72(sp)
    80000b24:	e0a2                	sd	s0,64(sp)
    80000b26:	fc26                	sd	s1,56(sp)
    80000b28:	f84a                	sd	s2,48(sp)
    80000b2a:	f44e                	sd	s3,40(sp)
    80000b2c:	f052                	sd	s4,32(sp)
    80000b2e:	ec56                	sd	s5,24(sp)
    80000b30:	e85a                	sd	s6,16(sp)
    80000b32:	e45e                	sd	s7,8(sp)
    80000b34:	0880                	addi	s0,sp,80
    80000b36:	8a2a                	mv	s4,a0
    80000b38:	8b2e                	mv	s6,a1
    80000b3a:	8bb2                	mv	s7,a2
    80000b3c:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b3e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b40:	6985                	lui	s3,0x1
    80000b42:	a825                	j	80000b7a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b44:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b48:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b4a:	37fd                	addiw	a5,a5,-1
    80000b4c:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b50:	60a6                	ld	ra,72(sp)
    80000b52:	6406                	ld	s0,64(sp)
    80000b54:	74e2                	ld	s1,56(sp)
    80000b56:	7942                	ld	s2,48(sp)
    80000b58:	79a2                	ld	s3,40(sp)
    80000b5a:	7a02                	ld	s4,32(sp)
    80000b5c:	6ae2                	ld	s5,24(sp)
    80000b5e:	6b42                	ld	s6,16(sp)
    80000b60:	6ba2                	ld	s7,8(sp)
    80000b62:	6161                	addi	sp,sp,80
    80000b64:	8082                	ret
    80000b66:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000b6a:	9742                	add	a4,a4,a6
      --max;
    80000b6c:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000b70:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000b74:	04e58463          	beq	a1,a4,80000bbc <copyinstr+0x9e>
{
    80000b78:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000b7a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000b7e:	85a6                	mv	a1,s1
    80000b80:	8552                	mv	a0,s4
    80000b82:	8dbff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    80000b86:	cd0d                	beqz	a0,80000bc0 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000b88:	417486b3          	sub	a3,s1,s7
    80000b8c:	96ce                	add	a3,a3,s3
    if(n > max)
    80000b8e:	00d97363          	bgeu	s2,a3,80000b94 <copyinstr+0x76>
    80000b92:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000b94:	955e                	add	a0,a0,s7
    80000b96:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000b98:	c695                	beqz	a3,80000bc4 <copyinstr+0xa6>
    80000b9a:	87da                	mv	a5,s6
    80000b9c:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000b9e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ba2:	96da                	add	a3,a3,s6
    80000ba4:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000ba6:	00f60733          	add	a4,a2,a5
    80000baa:	00074703          	lbu	a4,0(a4)
    80000bae:	db59                	beqz	a4,80000b44 <copyinstr+0x26>
        *dst = *p;
    80000bb0:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bb4:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bb6:	fed797e3          	bne	a5,a3,80000ba4 <copyinstr+0x86>
    80000bba:	b775                	j	80000b66 <copyinstr+0x48>
    80000bbc:	4781                	li	a5,0
    80000bbe:	b771                	j	80000b4a <copyinstr+0x2c>
      return -1;
    80000bc0:	557d                	li	a0,-1
    80000bc2:	b779                	j	80000b50 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000bc4:	6b85                	lui	s7,0x1
    80000bc6:	9ba6                	add	s7,s7,s1
    80000bc8:	87da                	mv	a5,s6
    80000bca:	b77d                	j	80000b78 <copyinstr+0x5a>
  int got_null = 0;
    80000bcc:	4781                	li	a5,0
  if(got_null){
    80000bce:	37fd                	addiw	a5,a5,-1
    80000bd0:	0007851b          	sext.w	a0,a5
}
    80000bd4:	8082                	ret

0000000080000bd6 <uvmgetdirty>:

// get the dirty flag of the va's PTE - lab10
int uvmgetdirty(pagetable_t pagetable, uint64 va) {
    80000bd6:	1141                	addi	sp,sp,-16
    80000bd8:	e406                	sd	ra,8(sp)
    80000bda:	e022                	sd	s0,0(sp)
    80000bdc:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000bde:	4601                	li	a2,0
    80000be0:	fe2ff0ef          	jal	800003c2 <walk>
  if(pte == 0) {
    80000be4:	c901                	beqz	a0,80000bf4 <uvmgetdirty+0x1e>
    return 0;
  }
  return (*pte & PTE_D);
    80000be6:	6108                	ld	a0,0(a0)
    80000be8:	08057513          	andi	a0,a0,128
}
    80000bec:	60a2                	ld	ra,8(sp)
    80000bee:	6402                	ld	s0,0(sp)
    80000bf0:	0141                	addi	sp,sp,16
    80000bf2:	8082                	ret
    return 0;
    80000bf4:	4501                	li	a0,0
    80000bf6:	bfdd                	j	80000bec <uvmgetdirty+0x16>

0000000080000bf8 <uvmsetdirtywrite>:

// set the dirty flag and write flag of the va's PTE - lab10
int uvmsetdirtywrite(pagetable_t pagetable, uint64 va) {
    80000bf8:	1141                	addi	sp,sp,-16
    80000bfa:	e406                	sd	ra,8(sp)
    80000bfc:	e022                	sd	s0,0(sp)
    80000bfe:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000c00:	4601                	li	a2,0
    80000c02:	fc0ff0ef          	jal	800003c2 <walk>
  if(pte == 0) {
    80000c06:	c911                	beqz	a0,80000c1a <uvmsetdirtywrite+0x22>
    return -1;
  }
  *pte |= PTE_D | PTE_W;
    80000c08:	611c                	ld	a5,0(a0)
    80000c0a:	0847e793          	ori	a5,a5,132
    80000c0e:	e11c                	sd	a5,0(a0)
  return 0;
    80000c10:	4501                	li	a0,0
    80000c12:	60a2                	ld	ra,8(sp)
    80000c14:	6402                	ld	s0,0(sp)
    80000c16:	0141                	addi	sp,sp,16
    80000c18:	8082                	ret
    return -1;
    80000c1a:	557d                	li	a0,-1
    80000c1c:	bfdd                	j	80000c12 <uvmsetdirtywrite+0x1a>

0000000080000c1e <wakeup1>:
  }
}

static void
wakeup1(struct proc *p)
{
    80000c1e:	1101                	addi	sp,sp,-32
    80000c20:	ec06                	sd	ra,24(sp)
    80000c22:	e822                	sd	s0,16(sp)
    80000c24:	e426                	sd	s1,8(sp)
    80000c26:	1000                	addi	s0,sp,32
    80000c28:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80000c2a:	1fc050ef          	jal	80005e26 <holding>
    80000c2e:	c909                	beqz	a0,80000c40 <wakeup1+0x22>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80000c30:	709c                	ld	a5,32(s1)
    80000c32:	00978d63          	beq	a5,s1,80000c4c <wakeup1+0x2e>
    p->state = RUNNABLE;
  }
}
    80000c36:	60e2                	ld	ra,24(sp)
    80000c38:	6442                	ld	s0,16(sp)
    80000c3a:	64a2                	ld	s1,8(sp)
    80000c3c:	6105                	addi	sp,sp,32
    80000c3e:	8082                	ret
    panic("wakeup1");
    80000c40:	00006517          	auipc	a0,0x6
    80000c44:	52850513          	addi	a0,a0,1320 # 80007168 <etext+0x168>
    80000c48:	71b040ef          	jal	80005b62 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80000c4c:	4c98                	lw	a4,24(s1)
    80000c4e:	4789                	li	a5,2
    80000c50:	fef713e3          	bne	a4,a5,80000c36 <wakeup1+0x18>
    p->state = RUNNABLE;
    80000c54:	478d                	li	a5,3
    80000c56:	cc9c                	sw	a5,24(s1)
}
    80000c58:	bff9                	j	80000c36 <wakeup1+0x18>

0000000080000c5a <proc_mapstacks>:
{
    80000c5a:	7139                	addi	sp,sp,-64
    80000c5c:	fc06                	sd	ra,56(sp)
    80000c5e:	f822                	sd	s0,48(sp)
    80000c60:	f426                	sd	s1,40(sp)
    80000c62:	f04a                	sd	s2,32(sp)
    80000c64:	ec4e                	sd	s3,24(sp)
    80000c66:	e852                	sd	s4,16(sp)
    80000c68:	e456                	sd	s5,8(sp)
    80000c6a:	e05a                	sd	s6,0(sp)
    80000c6c:	0080                	addi	s0,sp,64
    80000c6e:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c70:	00007497          	auipc	s1,0x7
    80000c74:	12048493          	addi	s1,s1,288 # 80007d90 <proc>
    uint64 va = KSTACK((int) (p - proc));
    80000c78:	8b26                	mv	s6,s1
    80000c7a:	fe9b0937          	lui	s2,0xfe9b0
    80000c7e:	25990913          	addi	s2,s2,601 # fffffffffe9b0259 <end+0xffffffff7e9875e9>
    80000c82:	0936                	slli	s2,s2,0xd
    80000c84:	7ed90913          	addi	s2,s2,2029
    80000c88:	0936                	slli	s2,s2,0xd
    80000c8a:	6c190913          	addi	s2,s2,1729
    80000c8e:	0932                	slli	s2,s2,0xc
    80000c90:	96590913          	addi	s2,s2,-1691
    80000c94:	040009b7          	lui	s3,0x4000
    80000c98:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c9a:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c9c:	00015a97          	auipc	s5,0x15
    80000ca0:	af4a8a93          	addi	s5,s5,-1292 # 80015790 <tickslock>
    char *pa = kalloc();
    80000ca4:	c5aff0ef          	jal	800000fe <kalloc>
    80000ca8:	862a                	mv	a2,a0
    if(pa == 0)
    80000caa:	cd15                	beqz	a0,80000ce6 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000cac:	416485b3          	sub	a1,s1,s6
    80000cb0:	858d                	srai	a1,a1,0x3
    80000cb2:	032585b3          	mul	a1,a1,s2
    80000cb6:	2585                	addiw	a1,a1,1
    80000cb8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000cbc:	4719                	li	a4,6
    80000cbe:	6685                	lui	a3,0x1
    80000cc0:	40b985b3          	sub	a1,s3,a1
    80000cc4:	8552                	mv	a0,s4
    80000cc6:	885ff0ef          	jal	8000054a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cca:	36848493          	addi	s1,s1,872
    80000cce:	fd549be3          	bne	s1,s5,80000ca4 <proc_mapstacks+0x4a>
}
    80000cd2:	70e2                	ld	ra,56(sp)
    80000cd4:	7442                	ld	s0,48(sp)
    80000cd6:	74a2                	ld	s1,40(sp)
    80000cd8:	7902                	ld	s2,32(sp)
    80000cda:	69e2                	ld	s3,24(sp)
    80000cdc:	6a42                	ld	s4,16(sp)
    80000cde:	6aa2                	ld	s5,8(sp)
    80000ce0:	6b02                	ld	s6,0(sp)
    80000ce2:	6121                	addi	sp,sp,64
    80000ce4:	8082                	ret
      panic("kalloc");
    80000ce6:	00006517          	auipc	a0,0x6
    80000cea:	48a50513          	addi	a0,a0,1162 # 80007170 <etext+0x170>
    80000cee:	675040ef          	jal	80005b62 <panic>

0000000080000cf2 <procinit>:
{
    80000cf2:	7139                	addi	sp,sp,-64
    80000cf4:	fc06                	sd	ra,56(sp)
    80000cf6:	f822                	sd	s0,48(sp)
    80000cf8:	f426                	sd	s1,40(sp)
    80000cfa:	f04a                	sd	s2,32(sp)
    80000cfc:	ec4e                	sd	s3,24(sp)
    80000cfe:	e852                	sd	s4,16(sp)
    80000d00:	e456                	sd	s5,8(sp)
    80000d02:	e05a                	sd	s6,0(sp)
    80000d04:	0080                	addi	s0,sp,64
  initlock(&pid_lock, "nextpid");
    80000d06:	00006597          	auipc	a1,0x6
    80000d0a:	47258593          	addi	a1,a1,1138 # 80007178 <etext+0x178>
    80000d0e:	00007517          	auipc	a0,0x7
    80000d12:	c5250513          	addi	a0,a0,-942 # 80007960 <pid_lock>
    80000d16:	0fa050ef          	jal	80005e10 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d1a:	00006597          	auipc	a1,0x6
    80000d1e:	46658593          	addi	a1,a1,1126 # 80007180 <etext+0x180>
    80000d22:	00007517          	auipc	a0,0x7
    80000d26:	c5650513          	addi	a0,a0,-938 # 80007978 <wait_lock>
    80000d2a:	0e6050ef          	jal	80005e10 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d2e:	00007497          	auipc	s1,0x7
    80000d32:	06248493          	addi	s1,s1,98 # 80007d90 <proc>
      initlock(&p->lock, "proc");
    80000d36:	00006b17          	auipc	s6,0x6
    80000d3a:	45ab0b13          	addi	s6,s6,1114 # 80007190 <etext+0x190>
      p->kstack = KSTACK((int) (p - proc));
    80000d3e:	8aa6                	mv	s5,s1
    80000d40:	fe9b0937          	lui	s2,0xfe9b0
    80000d44:	25990913          	addi	s2,s2,601 # fffffffffe9b0259 <end+0xffffffff7e9875e9>
    80000d48:	0936                	slli	s2,s2,0xd
    80000d4a:	7ed90913          	addi	s2,s2,2029
    80000d4e:	0936                	slli	s2,s2,0xd
    80000d50:	6c190913          	addi	s2,s2,1729
    80000d54:	0932                	slli	s2,s2,0xc
    80000d56:	96590913          	addi	s2,s2,-1691
    80000d5a:	040009b7          	lui	s3,0x4000
    80000d5e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d60:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d62:	00015a17          	auipc	s4,0x15
    80000d66:	a2ea0a13          	addi	s4,s4,-1490 # 80015790 <tickslock>
      initlock(&p->lock, "proc");
    80000d6a:	85da                	mv	a1,s6
    80000d6c:	8526                	mv	a0,s1
    80000d6e:	0a2050ef          	jal	80005e10 <initlock>
      p->state = UNUSED;
    80000d72:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d76:	415487b3          	sub	a5,s1,s5
    80000d7a:	878d                	srai	a5,a5,0x3
    80000d7c:	032787b3          	mul	a5,a5,s2
    80000d80:	2785                	addiw	a5,a5,1
    80000d82:	00d7979b          	slliw	a5,a5,0xd
    80000d86:	40f987b3          	sub	a5,s3,a5
    80000d8a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8c:	36848493          	addi	s1,s1,872
    80000d90:	fd449de3          	bne	s1,s4,80000d6a <procinit+0x78>
}
    80000d94:	70e2                	ld	ra,56(sp)
    80000d96:	7442                	ld	s0,48(sp)
    80000d98:	74a2                	ld	s1,40(sp)
    80000d9a:	7902                	ld	s2,32(sp)
    80000d9c:	69e2                	ld	s3,24(sp)
    80000d9e:	6a42                	ld	s4,16(sp)
    80000da0:	6aa2                	ld	s5,8(sp)
    80000da2:	6b02                	ld	s6,0(sp)
    80000da4:	6121                	addi	sp,sp,64
    80000da6:	8082                	ret

0000000080000da8 <cpuid>:
{
    80000da8:	1141                	addi	sp,sp,-16
    80000daa:	e422                	sd	s0,8(sp)
    80000dac:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000dae:	8512                	mv	a0,tp
}
    80000db0:	2501                	sext.w	a0,a0
    80000db2:	6422                	ld	s0,8(sp)
    80000db4:	0141                	addi	sp,sp,16
    80000db6:	8082                	ret

0000000080000db8 <mycpu>:
{
    80000db8:	1141                	addi	sp,sp,-16
    80000dba:	e422                	sd	s0,8(sp)
    80000dbc:	0800                	addi	s0,sp,16
    80000dbe:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80000dc0:	2781                	sext.w	a5,a5
    80000dc2:	079e                	slli	a5,a5,0x7
}
    80000dc4:	00007517          	auipc	a0,0x7
    80000dc8:	bcc50513          	addi	a0,a0,-1076 # 80007990 <cpus>
    80000dcc:	953e                	add	a0,a0,a5
    80000dce:	6422                	ld	s0,8(sp)
    80000dd0:	0141                	addi	sp,sp,16
    80000dd2:	8082                	ret

0000000080000dd4 <myproc>:
{
    80000dd4:	1101                	addi	sp,sp,-32
    80000dd6:	ec06                	sd	ra,24(sp)
    80000dd8:	e822                	sd	s0,16(sp)
    80000dda:	e426                	sd	s1,8(sp)
    80000ddc:	1000                	addi	s0,sp,32
  push_off();
    80000dde:	072050ef          	jal	80005e50 <push_off>
    80000de2:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80000de4:	2781                	sext.w	a5,a5
    80000de6:	079e                	slli	a5,a5,0x7
    80000de8:	00007717          	auipc	a4,0x7
    80000dec:	b7870713          	addi	a4,a4,-1160 # 80007960 <pid_lock>
    80000df0:	97ba                	add	a5,a5,a4
    80000df2:	7b84                	ld	s1,48(a5)
  pop_off();
    80000df4:	0e0050ef          	jal	80005ed4 <pop_off>
}
    80000df8:	8526                	mv	a0,s1
    80000dfa:	60e2                	ld	ra,24(sp)
    80000dfc:	6442                	ld	s0,16(sp)
    80000dfe:	64a2                	ld	s1,8(sp)
    80000e00:	6105                	addi	sp,sp,32
    80000e02:	8082                	ret

0000000080000e04 <forkret>:
{
    80000e04:	1141                	addi	sp,sp,-16
    80000e06:	e406                	sd	ra,8(sp)
    80000e08:	e022                	sd	s0,0(sp)
    80000e0a:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80000e0c:	fc9ff0ef          	jal	80000dd4 <myproc>
    80000e10:	118050ef          	jal	80005f28 <release>
  if (first) {
    80000e14:	00007797          	auipc	a5,0x7
    80000e18:	aac7a783          	lw	a5,-1364(a5) # 800078c0 <first.1>
    80000e1c:	e799                	bnez	a5,80000e2a <forkret+0x26>
  usertrapret();
    80000e1e:	491000ef          	jal	80001aae <usertrapret>
}
    80000e22:	60a2                	ld	ra,8(sp)
    80000e24:	6402                	ld	s0,0(sp)
    80000e26:	0141                	addi	sp,sp,16
    80000e28:	8082                	ret
    fsinit(ROOTDEV);
    80000e2a:	4505                	li	a0,1
    80000e2c:	161010ef          	jal	8000278c <fsinit>
    first = 0;
    80000e30:	00007797          	auipc	a5,0x7
    80000e34:	a807a823          	sw	zero,-1392(a5) # 800078c0 <first.1>
    __sync_synchronize();
    80000e38:	0ff0000f          	fence
    80000e3c:	b7cd                	j	80000e1e <forkret+0x1a>

0000000080000e3e <allocpid>:
{
    80000e3e:	1101                	addi	sp,sp,-32
    80000e40:	ec06                	sd	ra,24(sp)
    80000e42:	e822                	sd	s0,16(sp)
    80000e44:	e426                	sd	s1,8(sp)
    80000e46:	e04a                	sd	s2,0(sp)
    80000e48:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e4a:	00007917          	auipc	s2,0x7
    80000e4e:	b1690913          	addi	s2,s2,-1258 # 80007960 <pid_lock>
    80000e52:	854a                	mv	a0,s2
    80000e54:	03c050ef          	jal	80005e90 <acquire>
  pid = nextpid;
    80000e58:	00007797          	auipc	a5,0x7
    80000e5c:	a6c78793          	addi	a5,a5,-1428 # 800078c4 <nextpid>
    80000e60:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e62:	0014871b          	addiw	a4,s1,1
    80000e66:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e68:	854a                	mv	a0,s2
    80000e6a:	0be050ef          	jal	80005f28 <release>
}
    80000e6e:	8526                	mv	a0,s1
    80000e70:	60e2                	ld	ra,24(sp)
    80000e72:	6442                	ld	s0,16(sp)
    80000e74:	64a2                	ld	s1,8(sp)
    80000e76:	6902                	ld	s2,0(sp)
    80000e78:	6105                	addi	sp,sp,32
    80000e7a:	8082                	ret

0000000080000e7c <proc_pagetable>:
{
    80000e7c:	1101                	addi	sp,sp,-32
    80000e7e:	ec06                	sd	ra,24(sp)
    80000e80:	e822                	sd	s0,16(sp)
    80000e82:	e426                	sd	s1,8(sp)
    80000e84:	e04a                	sd	s2,0(sp)
    80000e86:	1000                	addi	s0,sp,32
    80000e88:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e8a:	85dff0ef          	jal	800006e6 <uvmcreate>
    80000e8e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e90:	cd05                	beqz	a0,80000ec8 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e92:	4729                	li	a4,10
    80000e94:	00005697          	auipc	a3,0x5
    80000e98:	16c68693          	addi	a3,a3,364 # 80006000 <_trampoline>
    80000e9c:	6605                	lui	a2,0x1
    80000e9e:	040005b7          	lui	a1,0x4000
    80000ea2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ea4:	05b2                	slli	a1,a1,0xc
    80000ea6:	df4ff0ef          	jal	8000049a <mappages>
    80000eaa:	02054663          	bltz	a0,80000ed6 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000eae:	4719                	li	a4,6
    80000eb0:	05893683          	ld	a3,88(s2)
    80000eb4:	6605                	lui	a2,0x1
    80000eb6:	020005b7          	lui	a1,0x2000
    80000eba:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ebc:	05b6                	slli	a1,a1,0xd
    80000ebe:	8526                	mv	a0,s1
    80000ec0:	ddaff0ef          	jal	8000049a <mappages>
    80000ec4:	00054f63          	bltz	a0,80000ee2 <proc_pagetable+0x66>
}
    80000ec8:	8526                	mv	a0,s1
    80000eca:	60e2                	ld	ra,24(sp)
    80000ecc:	6442                	ld	s0,16(sp)
    80000ece:	64a2                	ld	s1,8(sp)
    80000ed0:	6902                	ld	s2,0(sp)
    80000ed2:	6105                	addi	sp,sp,32
    80000ed4:	8082                	ret
    uvmfree(pagetable, 0);
    80000ed6:	4581                	li	a1,0
    80000ed8:	8526                	mv	a0,s1
    80000eda:	9dbff0ef          	jal	800008b4 <uvmfree>
    return 0;
    80000ede:	4481                	li	s1,0
    80000ee0:	b7e5                	j	80000ec8 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ee2:	4681                	li	a3,0
    80000ee4:	4605                	li	a2,1
    80000ee6:	040005b7          	lui	a1,0x4000
    80000eea:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eec:	05b2                	slli	a1,a1,0xc
    80000eee:	8526                	mv	a0,s1
    80000ef0:	f50ff0ef          	jal	80000640 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ef4:	4581                	li	a1,0
    80000ef6:	8526                	mv	a0,s1
    80000ef8:	9bdff0ef          	jal	800008b4 <uvmfree>
    return 0;
    80000efc:	4481                	li	s1,0
    80000efe:	b7e9                	j	80000ec8 <proc_pagetable+0x4c>

0000000080000f00 <proc_freepagetable>:
{
    80000f00:	1101                	addi	sp,sp,-32
    80000f02:	ec06                	sd	ra,24(sp)
    80000f04:	e822                	sd	s0,16(sp)
    80000f06:	e426                	sd	s1,8(sp)
    80000f08:	e04a                	sd	s2,0(sp)
    80000f0a:	1000                	addi	s0,sp,32
    80000f0c:	84aa                	mv	s1,a0
    80000f0e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f10:	4681                	li	a3,0
    80000f12:	4605                	li	a2,1
    80000f14:	040005b7          	lui	a1,0x4000
    80000f18:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f1a:	05b2                	slli	a1,a1,0xc
    80000f1c:	f24ff0ef          	jal	80000640 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f20:	4681                	li	a3,0
    80000f22:	4605                	li	a2,1
    80000f24:	020005b7          	lui	a1,0x2000
    80000f28:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f2a:	05b6                	slli	a1,a1,0xd
    80000f2c:	8526                	mv	a0,s1
    80000f2e:	f12ff0ef          	jal	80000640 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f32:	85ca                	mv	a1,s2
    80000f34:	8526                	mv	a0,s1
    80000f36:	97fff0ef          	jal	800008b4 <uvmfree>
}
    80000f3a:	60e2                	ld	ra,24(sp)
    80000f3c:	6442                	ld	s0,16(sp)
    80000f3e:	64a2                	ld	s1,8(sp)
    80000f40:	6902                	ld	s2,0(sp)
    80000f42:	6105                	addi	sp,sp,32
    80000f44:	8082                	ret

0000000080000f46 <freeproc>:
{
    80000f46:	1101                	addi	sp,sp,-32
    80000f48:	ec06                	sd	ra,24(sp)
    80000f4a:	e822                	sd	s0,16(sp)
    80000f4c:	e426                	sd	s1,8(sp)
    80000f4e:	1000                	addi	s0,sp,32
    80000f50:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f52:	6d28                	ld	a0,88(a0)
    80000f54:	c119                	beqz	a0,80000f5a <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f56:	8c6ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f5a:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f5e:	68a8                	ld	a0,80(s1)
    80000f60:	c501                	beqz	a0,80000f68 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f62:	64ac                	ld	a1,72(s1)
    80000f64:	f9dff0ef          	jal	80000f00 <proc_freepagetable>
  p->pagetable = 0;
    80000f68:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f6c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f70:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f74:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f78:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f7c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f80:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f84:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f88:	0004ac23          	sw	zero,24(s1)
}
    80000f8c:	60e2                	ld	ra,24(sp)
    80000f8e:	6442                	ld	s0,16(sp)
    80000f90:	64a2                	ld	s1,8(sp)
    80000f92:	6105                	addi	sp,sp,32
    80000f94:	8082                	ret

0000000080000f96 <allocproc>:
{
    80000f96:	1101                	addi	sp,sp,-32
    80000f98:	ec06                	sd	ra,24(sp)
    80000f9a:	e822                	sd	s0,16(sp)
    80000f9c:	e426                	sd	s1,8(sp)
    80000f9e:	e04a                	sd	s2,0(sp)
    80000fa0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fa2:	00007497          	auipc	s1,0x7
    80000fa6:	dee48493          	addi	s1,s1,-530 # 80007d90 <proc>
    80000faa:	00014917          	auipc	s2,0x14
    80000fae:	7e690913          	addi	s2,s2,2022 # 80015790 <tickslock>
    acquire(&p->lock);
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	6dd040ef          	jal	80005e90 <acquire>
    if(p->state == UNUSED) {
    80000fb8:	4c9c                	lw	a5,24(s1)
    80000fba:	cb91                	beqz	a5,80000fce <allocproc+0x38>
      release(&p->lock);
    80000fbc:	8526                	mv	a0,s1
    80000fbe:	76b040ef          	jal	80005f28 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fc2:	36848493          	addi	s1,s1,872
    80000fc6:	ff2496e3          	bne	s1,s2,80000fb2 <allocproc+0x1c>
  return 0;
    80000fca:	4481                	li	s1,0
    80000fcc:	a83d                	j	8000100a <allocproc+0x74>
  p->pid = allocpid();
    80000fce:	e71ff0ef          	jal	80000e3e <allocpid>
    80000fd2:	d888                	sw	a0,48(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fd4:	92aff0ef          	jal	800000fe <kalloc>
    80000fd8:	892a                	mv	s2,a0
    80000fda:	eca8                	sd	a0,88(s1)
    80000fdc:	cd15                	beqz	a0,80001018 <allocproc+0x82>
  p->pagetable = proc_pagetable(p);
    80000fde:	8526                	mv	a0,s1
    80000fe0:	e9dff0ef          	jal	80000e7c <proc_pagetable>
    80000fe4:	892a                	mv	s2,a0
    80000fe6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000fe8:	c121                	beqz	a0,80001028 <allocproc+0x92>
  memset(&p->context, 0, sizeof(p->context));
    80000fea:	07000613          	li	a2,112
    80000fee:	4581                	li	a1,0
    80000ff0:	06048513          	addi	a0,s1,96
    80000ff4:	95aff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80000ff8:	00000797          	auipc	a5,0x0
    80000ffc:	e0c78793          	addi	a5,a5,-500 # 80000e04 <forkret>
    80001000:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001002:	60bc                	ld	a5,64(s1)
    80001004:	6705                	lui	a4,0x1
    80001006:	97ba                	add	a5,a5,a4
    80001008:	f4bc                	sd	a5,104(s1)
}
    8000100a:	8526                	mv	a0,s1
    8000100c:	60e2                	ld	ra,24(sp)
    8000100e:	6442                	ld	s0,16(sp)
    80001010:	64a2                	ld	s1,8(sp)
    80001012:	6902                	ld	s2,0(sp)
    80001014:	6105                	addi	sp,sp,32
    80001016:	8082                	ret
    freeproc(p);
    80001018:	8526                	mv	a0,s1
    8000101a:	f2dff0ef          	jal	80000f46 <freeproc>
    release(&p->lock);
    8000101e:	8526                	mv	a0,s1
    80001020:	709040ef          	jal	80005f28 <release>
    return 0;
    80001024:	84ca                	mv	s1,s2
    80001026:	b7d5                	j	8000100a <allocproc+0x74>
    freeproc(p);
    80001028:	8526                	mv	a0,s1
    8000102a:	f1dff0ef          	jal	80000f46 <freeproc>
    release(&p->lock);
    8000102e:	8526                	mv	a0,s1
    80001030:	6f9040ef          	jal	80005f28 <release>
    return 0;
    80001034:	84ca                	mv	s1,s2
    80001036:	bfd1                	j	8000100a <allocproc+0x74>

0000000080001038 <userinit>:
{
    80001038:	1101                	addi	sp,sp,-32
    8000103a:	ec06                	sd	ra,24(sp)
    8000103c:	e822                	sd	s0,16(sp)
    8000103e:	e426                	sd	s1,8(sp)
    80001040:	1000                	addi	s0,sp,32
  p = allocproc();
    80001042:	f55ff0ef          	jal	80000f96 <allocproc>
    80001046:	84aa                	mv	s1,a0
  initproc = p;
    80001048:	00007797          	auipc	a5,0x7
    8000104c:	8ca7bc23          	sd	a0,-1832(a5) # 80007920 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001050:	03400613          	li	a2,52
    80001054:	00007597          	auipc	a1,0x7
    80001058:	87c58593          	addi	a1,a1,-1924 # 800078d0 <initcode>
    8000105c:	6928                	ld	a0,80(a0)
    8000105e:	eaeff0ef          	jal	8000070c <uvmfirst>
  p->sz = PGSIZE;
    80001062:	6785                	lui	a5,0x1
    80001064:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001066:	6cb8                	ld	a4,88(s1)
    80001068:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000106c:	6cb8                	ld	a4,88(s1)
    8000106e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001070:	4641                	li	a2,16
    80001072:	00006597          	auipc	a1,0x6
    80001076:	12658593          	addi	a1,a1,294 # 80007198 <etext+0x198>
    8000107a:	15848513          	addi	a0,s1,344
    8000107e:	a0eff0ef          	jal	8000028c <safestrcpy>
  p->cwd = namei("/");
    80001082:	00006517          	auipc	a0,0x6
    80001086:	12650513          	addi	a0,a0,294 # 800071a8 <etext+0x1a8>
    8000108a:	010020ef          	jal	8000309a <namei>
    8000108e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001092:	478d                	li	a5,3
    80001094:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001096:	8526                	mv	a0,s1
    80001098:	691040ef          	jal	80005f28 <release>
}
    8000109c:	60e2                	ld	ra,24(sp)
    8000109e:	6442                	ld	s0,16(sp)
    800010a0:	64a2                	ld	s1,8(sp)
    800010a2:	6105                	addi	sp,sp,32
    800010a4:	8082                	ret

00000000800010a6 <growproc>:
{
    800010a6:	1101                	addi	sp,sp,-32
    800010a8:	ec06                	sd	ra,24(sp)
    800010aa:	e822                	sd	s0,16(sp)
    800010ac:	e426                	sd	s1,8(sp)
    800010ae:	e04a                	sd	s2,0(sp)
    800010b0:	1000                	addi	s0,sp,32
    800010b2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800010b4:	d21ff0ef          	jal	80000dd4 <myproc>
    800010b8:	84aa                	mv	s1,a0
  sz = p->sz;
    800010ba:	652c                	ld	a1,72(a0)
  if(n > 0){
    800010bc:	01204c63          	bgtz	s2,800010d4 <growproc+0x2e>
  } else if(n < 0){
    800010c0:	02094463          	bltz	s2,800010e8 <growproc+0x42>
  p->sz = sz;
    800010c4:	e4ac                	sd	a1,72(s1)
  return 0;
    800010c6:	4501                	li	a0,0
}
    800010c8:	60e2                	ld	ra,24(sp)
    800010ca:	6442                	ld	s0,16(sp)
    800010cc:	64a2                	ld	s1,8(sp)
    800010ce:	6902                	ld	s2,0(sp)
    800010d0:	6105                	addi	sp,sp,32
    800010d2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010d4:	4691                	li	a3,4
    800010d6:	00b90633          	add	a2,s2,a1
    800010da:	6928                	ld	a0,80(a0)
    800010dc:	ed2ff0ef          	jal	800007ae <uvmalloc>
    800010e0:	85aa                	mv	a1,a0
    800010e2:	f16d                	bnez	a0,800010c4 <growproc+0x1e>
      return -1;
    800010e4:	557d                	li	a0,-1
    800010e6:	b7cd                	j	800010c8 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010e8:	00b90633          	add	a2,s2,a1
    800010ec:	6928                	ld	a0,80(a0)
    800010ee:	e7cff0ef          	jal	8000076a <uvmdealloc>
    800010f2:	85aa                	mv	a1,a0
    800010f4:	bfc1                	j	800010c4 <growproc+0x1e>

00000000800010f6 <fork>:
{
    800010f6:	7139                	addi	sp,sp,-64
    800010f8:	fc06                	sd	ra,56(sp)
    800010fa:	f822                	sd	s0,48(sp)
    800010fc:	f426                	sd	s1,40(sp)
    800010fe:	e852                	sd	s4,16(sp)
    80001100:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001102:	cd3ff0ef          	jal	80000dd4 <myproc>
    80001106:	8a2a                	mv	s4,a0
  if((np = allocproc()) == 0){
    80001108:	e8fff0ef          	jal	80000f96 <allocproc>
    8000110c:	10050863          	beqz	a0,8000121c <fork+0x126>
    80001110:	ec4e                	sd	s3,24(sp)
    80001112:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001114:	048a3603          	ld	a2,72(s4)
    80001118:	692c                	ld	a1,80(a0)
    8000111a:	050a3503          	ld	a0,80(s4)
    8000111e:	fc8ff0ef          	jal	800008e6 <uvmcopy>
    80001122:	04054c63          	bltz	a0,8000117a <fork+0x84>
    80001126:	f04a                	sd	s2,32(sp)
    80001128:	e456                	sd	s5,8(sp)
  np->sz = p->sz;
    8000112a:	048a3783          	ld	a5,72(s4)
    8000112e:	04f9b423          	sd	a5,72(s3)
  np->parent = p;
    80001132:	0349bc23          	sd	s4,56(s3)
  *(np->trapframe) = *(p->trapframe);
    80001136:	058a3683          	ld	a3,88(s4)
    8000113a:	87b6                	mv	a5,a3
    8000113c:	0589b703          	ld	a4,88(s3)
    80001140:	12068693          	addi	a3,a3,288
    80001144:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001148:	6788                	ld	a0,8(a5)
    8000114a:	6b8c                	ld	a1,16(a5)
    8000114c:	6f90                	ld	a2,24(a5)
    8000114e:	01073023          	sd	a6,0(a4)
    80001152:	e708                	sd	a0,8(a4)
    80001154:	eb0c                	sd	a1,16(a4)
    80001156:	ef10                	sd	a2,24(a4)
    80001158:	02078793          	addi	a5,a5,32
    8000115c:	02070713          	addi	a4,a4,32
    80001160:	fed792e3          	bne	a5,a3,80001144 <fork+0x4e>
  np->trapframe->a0 = 0;
    80001164:	0589b783          	ld	a5,88(s3)
    80001168:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000116c:	0d0a0493          	addi	s1,s4,208
    80001170:	0d098913          	addi	s2,s3,208
    80001174:	150a0a93          	addi	s5,s4,336
    80001178:	a831                	j	80001194 <fork+0x9e>
    freeproc(np);
    8000117a:	854e                	mv	a0,s3
    8000117c:	dcbff0ef          	jal	80000f46 <freeproc>
    release(&np->lock);
    80001180:	854e                	mv	a0,s3
    80001182:	5a7040ef          	jal	80005f28 <release>
    return -1;
    80001186:	54fd                	li	s1,-1
    80001188:	69e2                	ld	s3,24(sp)
    8000118a:	a051                	j	8000120e <fork+0x118>
  for(i = 0; i < NOFILE; i++)
    8000118c:	04a1                	addi	s1,s1,8
    8000118e:	0921                	addi	s2,s2,8
    80001190:	01548963          	beq	s1,s5,800011a2 <fork+0xac>
    if(p->ofile[i])
    80001194:	6088                	ld	a0,0(s1)
    80001196:	d97d                	beqz	a0,8000118c <fork+0x96>
      np->ofile[i] = filedup(p->ofile[i]);
    80001198:	492020ef          	jal	8000362a <filedup>
    8000119c:	00a93023          	sd	a0,0(s2)
    800011a0:	b7f5                	j	8000118c <fork+0x96>
  np->cwd = idup(p->cwd);
    800011a2:	150a3503          	ld	a0,336(s4)
    800011a6:	7e4010ef          	jal	8000298a <idup>
    800011aa:	14a9b823          	sd	a0,336(s3)
  for (i = 0; i < NVMA; ++i) {
    800011ae:	168a0913          	addi	s2,s4,360
    800011b2:	16898493          	addi	s1,s3,360
    800011b6:	36898a93          	addi	s5,s3,872
    800011ba:	a039                	j	800011c8 <fork+0xd2>
    800011bc:	02090913          	addi	s2,s2,32
    800011c0:	02048493          	addi	s1,s1,32
    800011c4:	03548363          	beq	s1,s5,800011ea <fork+0xf4>
    if (p->vma[i].addr) {
    800011c8:	00093783          	ld	a5,0(s2)
    800011cc:	dbe5                	beqz	a5,800011bc <fork+0xc6>
      np->vma[i] = p->vma[i];
    800011ce:	86be                	mv	a3,a5
    800011d0:	00893703          	ld	a4,8(s2)
    800011d4:	01093783          	ld	a5,16(s2)
    800011d8:	01893503          	ld	a0,24(s2)
    800011dc:	e094                	sd	a3,0(s1)
    800011de:	e498                	sd	a4,8(s1)
    800011e0:	e89c                	sd	a5,16(s1)
    800011e2:	ec88                	sd	a0,24(s1)
      filedup(np->vma[i].f);
    800011e4:	446020ef          	jal	8000362a <filedup>
    800011e8:	bfd1                	j	800011bc <fork+0xc6>
  safestrcpy(np->name, p->name, sizeof(p->name));
    800011ea:	4641                	li	a2,16
    800011ec:	158a0593          	addi	a1,s4,344
    800011f0:	15898513          	addi	a0,s3,344
    800011f4:	898ff0ef          	jal	8000028c <safestrcpy>
  pid = np->pid;
    800011f8:	0309a483          	lw	s1,48(s3)
  np->state = RUNNABLE;
    800011fc:	478d                	li	a5,3
    800011fe:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001202:	854e                	mv	a0,s3
    80001204:	525040ef          	jal	80005f28 <release>
  return pid;
    80001208:	7902                	ld	s2,32(sp)
    8000120a:	69e2                	ld	s3,24(sp)
    8000120c:	6aa2                	ld	s5,8(sp)
}
    8000120e:	8526                	mv	a0,s1
    80001210:	70e2                	ld	ra,56(sp)
    80001212:	7442                	ld	s0,48(sp)
    80001214:	74a2                	ld	s1,40(sp)
    80001216:	6a42                	ld	s4,16(sp)
    80001218:	6121                	addi	sp,sp,64
    8000121a:	8082                	ret
    return -1;
    8000121c:	54fd                	li	s1,-1
    8000121e:	bfc5                	j	8000120e <fork+0x118>

0000000080001220 <reparent>:
{
    80001220:	7179                	addi	sp,sp,-48
    80001222:	f406                	sd	ra,40(sp)
    80001224:	f022                	sd	s0,32(sp)
    80001226:	ec26                	sd	s1,24(sp)
    80001228:	e84a                	sd	s2,16(sp)
    8000122a:	e44e                	sd	s3,8(sp)
    8000122c:	e052                	sd	s4,0(sp)
    8000122e:	1800                	addi	s0,sp,48
    80001230:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001232:	00007497          	auipc	s1,0x7
    80001236:	b5e48493          	addi	s1,s1,-1186 # 80007d90 <proc>
      pp->parent = initproc;
    8000123a:	00006a17          	auipc	s4,0x6
    8000123e:	6e6a0a13          	addi	s4,s4,1766 # 80007920 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001242:	00014997          	auipc	s3,0x14
    80001246:	54e98993          	addi	s3,s3,1358 # 80015790 <tickslock>
    8000124a:	a029                	j	80001254 <reparent+0x34>
    8000124c:	36848493          	addi	s1,s1,872
    80001250:	01348f63          	beq	s1,s3,8000126e <reparent+0x4e>
    if(pp->parent == p){
    80001254:	7c9c                	ld	a5,56(s1)
    80001256:	ff279be3          	bne	a5,s2,8000124c <reparent+0x2c>
      acquire(&pp->lock);
    8000125a:	8526                	mv	a0,s1
    8000125c:	435040ef          	jal	80005e90 <acquire>
      pp->parent = initproc;
    80001260:	000a3783          	ld	a5,0(s4)
    80001264:	fc9c                	sd	a5,56(s1)
      release(&pp->lock);
    80001266:	8526                	mv	a0,s1
    80001268:	4c1040ef          	jal	80005f28 <release>
    8000126c:	b7c5                	j	8000124c <reparent+0x2c>
}
    8000126e:	70a2                	ld	ra,40(sp)
    80001270:	7402                	ld	s0,32(sp)
    80001272:	64e2                	ld	s1,24(sp)
    80001274:	6942                	ld	s2,16(sp)
    80001276:	69a2                	ld	s3,8(sp)
    80001278:	6a02                	ld	s4,0(sp)
    8000127a:	6145                	addi	sp,sp,48
    8000127c:	8082                	ret

000000008000127e <scheduler>:
{
    8000127e:	715d                	addi	sp,sp,-80
    80001280:	e486                	sd	ra,72(sp)
    80001282:	e0a2                	sd	s0,64(sp)
    80001284:	fc26                	sd	s1,56(sp)
    80001286:	f84a                	sd	s2,48(sp)
    80001288:	f44e                	sd	s3,40(sp)
    8000128a:	f052                	sd	s4,32(sp)
    8000128c:	ec56                	sd	s5,24(sp)
    8000128e:	e85a                	sd	s6,16(sp)
    80001290:	e45e                	sd	s7,8(sp)
    80001292:	e062                	sd	s8,0(sp)
    80001294:	0880                	addi	s0,sp,80
    80001296:	8792                	mv	a5,tp
  int id = r_tp();
    80001298:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000129a:	00779b93          	slli	s7,a5,0x7
    8000129e:	00006717          	auipc	a4,0x6
    800012a2:	6c270713          	addi	a4,a4,1730 # 80007960 <pid_lock>
    800012a6:	975e                	add	a4,a4,s7
    800012a8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800012ac:	00006717          	auipc	a4,0x6
    800012b0:	6ec70713          	addi	a4,a4,1772 # 80007998 <cpus+0x8>
    800012b4:	9bba                	add	s7,s7,a4
    int nproc = 0;
    800012b6:	4c01                	li	s8,0
      if(p->state == RUNNABLE) {
    800012b8:	4a0d                	li	s4,3
        c->proc = p;
    800012ba:	079e                	slli	a5,a5,0x7
    800012bc:	00006a97          	auipc	s5,0x6
    800012c0:	6a4a8a93          	addi	s5,s5,1700 # 80007960 <pid_lock>
    800012c4:	9abe                	add	s5,s5,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800012c6:	00014997          	auipc	s3,0x14
    800012ca:	4ca98993          	addi	s3,s3,1226 # 80015790 <tickslock>
    800012ce:	a0b9                	j	8000131c <scheduler+0x9e>
      release(&p->lock);
    800012d0:	8526                	mv	a0,s1
    800012d2:	457040ef          	jal	80005f28 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800012d6:	36848493          	addi	s1,s1,872
    800012da:	03348663          	beq	s1,s3,80001306 <scheduler+0x88>
      acquire(&p->lock);
    800012de:	8526                	mv	a0,s1
    800012e0:	3b1040ef          	jal	80005e90 <acquire>
      if(p->state != UNUSED) {
    800012e4:	4c9c                	lw	a5,24(s1)
    800012e6:	d7ed                	beqz	a5,800012d0 <scheduler+0x52>
        nproc++;
    800012e8:	2905                	addiw	s2,s2,1
      if(p->state == RUNNABLE) {
    800012ea:	ff4793e3          	bne	a5,s4,800012d0 <scheduler+0x52>
        p->state = RUNNING;
    800012ee:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800012f2:	029ab823          	sd	s1,48(s5)
        swtch(&c->context, &p->context);
    800012f6:	06048593          	addi	a1,s1,96
    800012fa:	855e                	mv	a0,s7
    800012fc:	70c000ef          	jal	80001a08 <swtch>
        c->proc = 0;
    80001300:	020ab823          	sd	zero,48(s5)
    80001304:	b7f1                	j	800012d0 <scheduler+0x52>
    if(nproc <= 2) {   // only init and sh exist
    80001306:	4789                	li	a5,2
    80001308:	0127ca63          	blt	a5,s2,8000131c <scheduler+0x9e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000130c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001310:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001314:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001318:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000131c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001320:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001324:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80001328:	8962                	mv	s2,s8
    for(p = proc; p < &proc[NPROC]; p++) {
    8000132a:	00007497          	auipc	s1,0x7
    8000132e:	a6648493          	addi	s1,s1,-1434 # 80007d90 <proc>
        p->state = RUNNING;
    80001332:	4b11                	li	s6,4
    80001334:	b76d                	j	800012de <scheduler+0x60>

0000000080001336 <sched>:
{
    80001336:	7179                	addi	sp,sp,-48
    80001338:	f406                	sd	ra,40(sp)
    8000133a:	f022                	sd	s0,32(sp)
    8000133c:	ec26                	sd	s1,24(sp)
    8000133e:	e84a                	sd	s2,16(sp)
    80001340:	e44e                	sd	s3,8(sp)
    80001342:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001344:	a91ff0ef          	jal	80000dd4 <myproc>
    80001348:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000134a:	2dd040ef          	jal	80005e26 <holding>
    8000134e:	c92d                	beqz	a0,800013c0 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001350:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001352:	2781                	sext.w	a5,a5
    80001354:	079e                	slli	a5,a5,0x7
    80001356:	00006717          	auipc	a4,0x6
    8000135a:	60a70713          	addi	a4,a4,1546 # 80007960 <pid_lock>
    8000135e:	97ba                	add	a5,a5,a4
    80001360:	0a87a703          	lw	a4,168(a5)
    80001364:	4785                	li	a5,1
    80001366:	06f71363          	bne	a4,a5,800013cc <sched+0x96>
  if(p->state == RUNNING)
    8000136a:	4c98                	lw	a4,24(s1)
    8000136c:	4791                	li	a5,4
    8000136e:	06f70563          	beq	a4,a5,800013d8 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001372:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001376:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001378:	e7b5                	bnez	a5,800013e4 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000137a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000137c:	00006917          	auipc	s2,0x6
    80001380:	5e490913          	addi	s2,s2,1508 # 80007960 <pid_lock>
    80001384:	2781                	sext.w	a5,a5
    80001386:	079e                	slli	a5,a5,0x7
    80001388:	97ca                	add	a5,a5,s2
    8000138a:	0ac7a983          	lw	s3,172(a5)
    8000138e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001390:	2781                	sext.w	a5,a5
    80001392:	079e                	slli	a5,a5,0x7
    80001394:	00006597          	auipc	a1,0x6
    80001398:	60458593          	addi	a1,a1,1540 # 80007998 <cpus+0x8>
    8000139c:	95be                	add	a1,a1,a5
    8000139e:	06048513          	addi	a0,s1,96
    800013a2:	666000ef          	jal	80001a08 <swtch>
    800013a6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800013a8:	2781                	sext.w	a5,a5
    800013aa:	079e                	slli	a5,a5,0x7
    800013ac:	993e                	add	s2,s2,a5
    800013ae:	0b392623          	sw	s3,172(s2)
}
    800013b2:	70a2                	ld	ra,40(sp)
    800013b4:	7402                	ld	s0,32(sp)
    800013b6:	64e2                	ld	s1,24(sp)
    800013b8:	6942                	ld	s2,16(sp)
    800013ba:	69a2                	ld	s3,8(sp)
    800013bc:	6145                	addi	sp,sp,48
    800013be:	8082                	ret
    panic("sched p->lock");
    800013c0:	00006517          	auipc	a0,0x6
    800013c4:	df050513          	addi	a0,a0,-528 # 800071b0 <etext+0x1b0>
    800013c8:	79a040ef          	jal	80005b62 <panic>
    panic("sched locks");
    800013cc:	00006517          	auipc	a0,0x6
    800013d0:	df450513          	addi	a0,a0,-524 # 800071c0 <etext+0x1c0>
    800013d4:	78e040ef          	jal	80005b62 <panic>
    panic("sched running");
    800013d8:	00006517          	auipc	a0,0x6
    800013dc:	df850513          	addi	a0,a0,-520 # 800071d0 <etext+0x1d0>
    800013e0:	782040ef          	jal	80005b62 <panic>
    panic("sched interruptible");
    800013e4:	00006517          	auipc	a0,0x6
    800013e8:	dfc50513          	addi	a0,a0,-516 # 800071e0 <etext+0x1e0>
    800013ec:	776040ef          	jal	80005b62 <panic>

00000000800013f0 <exit>:
{
    800013f0:	7175                	addi	sp,sp,-144
    800013f2:	e506                	sd	ra,136(sp)
    800013f4:	e122                	sd	s0,128(sp)
    800013f6:	f86a                	sd	s10,48(sp)
    800013f8:	0900                	addi	s0,sp,144
    800013fa:	f6a43823          	sd	a0,-144(s0)
  struct proc *p = myproc();
    800013fe:	9d7ff0ef          	jal	80000dd4 <myproc>
    80001402:	f6a43c23          	sd	a0,-136(s0)
  if(p == initproc)
    80001406:	00006797          	auipc	a5,0x6
    8000140a:	51a7b783          	ld	a5,1306(a5) # 80007920 <initproc>
    8000140e:	16850d13          	addi	s10,a0,360
    80001412:	f8043023          	sd	zero,-128(s0)
    80001416:	00a78d63          	beq	a5,a0,80001430 <exit+0x40>
    8000141a:	fca6                	sd	s1,120(sp)
    8000141c:	f8ca                	sd	s2,112(sp)
    8000141e:	f4ce                	sd	s3,104(sp)
    80001420:	f0d2                	sd	s4,96(sp)
    80001422:	ecd6                	sd	s5,88(sp)
    80001424:	e8da                	sd	s6,80(sp)
    80001426:	e4de                	sd	s7,72(sp)
    80001428:	e0e2                	sd	s8,64(sp)
    8000142a:	fc66                	sd	s9,56(sp)
    8000142c:	f46e                	sd	s11,40(sp)
    8000142e:	aa15                	j	80001562 <exit+0x172>
    80001430:	fca6                	sd	s1,120(sp)
    80001432:	f8ca                	sd	s2,112(sp)
    80001434:	f4ce                	sd	s3,104(sp)
    80001436:	f0d2                	sd	s4,96(sp)
    80001438:	ecd6                	sd	s5,88(sp)
    8000143a:	e8da                	sd	s6,80(sp)
    8000143c:	e4de                	sd	s7,72(sp)
    8000143e:	e0e2                	sd	s8,64(sp)
    80001440:	fc66                	sd	s9,56(sp)
    80001442:	f46e                	sd	s11,40(sp)
    panic("init exiting");
    80001444:	00006517          	auipc	a0,0x6
    80001448:	db450513          	addi	a0,a0,-588 # 800071f8 <etext+0x1f8>
    8000144c:	716040ef          	jal	80005b62 <panic>
          n1 = min(maxsz, n - i);
    80001450:	0009891b          	sext.w	s2,s3
          begin_op();
    80001454:	603010ef          	jal	80003256 <begin_op>
          ilock(vma->f->ip);
    80001458:	6c9c                	ld	a5,24(s1)
    8000145a:	6f88                	ld	a0,24(a5)
    8000145c:	564010ef          	jal	800029c0 <ilock>
          if (writei(vma->f->ip, 1, va + i, va - vma->addr + vma->offset + i, n1) != n1) {
    80001460:	48d4                	lw	a3,20(s1)
    80001462:	019686bb          	addw	a3,a3,s9
    80001466:	609c                	ld	a5,0(s1)
    80001468:	9e9d                	subw	a3,a3,a5
    8000146a:	6c9c                	ld	a5,24(s1)
    8000146c:	874a                	mv	a4,s2
    8000146e:	015686bb          	addw	a3,a3,s5
    80001472:	865e                	mv	a2,s7
    80001474:	4585                	li	a1,1
    80001476:	6f88                	ld	a0,24(a5)
    80001478:	099010ef          	jal	80002d10 <writei>
    8000147c:	2501                	sext.w	a0,a0
    8000147e:	03251363          	bne	a0,s2,800014a4 <exit+0xb4>
          iunlock(vma->f->ip);
    80001482:	6c9c                	ld	a5,24(s1)
    80001484:	6f88                	ld	a0,24(a5)
    80001486:	5e8010ef          	jal	80002a6e <iunlock>
          end_op();
    8000148a:	637010ef          	jal	800032c0 <end_op>
        for (r = 0; r < n; r += n1) {
    8000148e:	01498a3b          	addw	s4,s3,s4
    80001492:	036a7c63          	bgeu	s4,s6,800014ca <exit+0xda>
          n1 = min(maxsz, n - i);
    80001496:	f8c42983          	lw	s3,-116(s0)
    8000149a:	fbbc7be3          	bgeu	s8,s11,80001450 <exit+0x60>
    8000149e:	f8842983          	lw	s3,-120(s0)
    800014a2:	b77d                	j	80001450 <exit+0x60>
            iunlock(vma->f->ip);
    800014a4:	f8042783          	lw	a5,-128(s0)
    800014a8:	0796                	slli	a5,a5,0x5
    800014aa:	f7843703          	ld	a4,-136(s0)
    800014ae:	97ba                	add	a5,a5,a4
    800014b0:	1807b783          	ld	a5,384(a5)
    800014b4:	6f88                	ld	a0,24(a5)
    800014b6:	5b8010ef          	jal	80002a6e <iunlock>
            end_op();
    800014ba:	607010ef          	jal	800032c0 <end_op>
            panic("exit: writei failed");
    800014be:	00006517          	auipc	a0,0x6
    800014c2:	d4a50513          	addi	a0,a0,-694 # 80007208 <etext+0x208>
    800014c6:	69c040ef          	jal	80005b62 <panic>
      for (va = vma->addr; va < vma->addr + vma->len; va += PGSIZE) {
    800014ca:	6785                	lui	a5,0x1
    800014cc:	9abe                	add	s5,s5,a5
    800014ce:	9bbe                	add	s7,s7,a5
    800014d0:	449c                	lw	a5,8(s1)
    800014d2:	6098                	ld	a4,0(s1)
    800014d4:	97ba                	add	a5,a5,a4
    800014d6:	02fafe63          	bgeu	s5,a5,80001512 <exit+0x122>
        if (uvmgetdirty(p->pagetable, va) == 0) {
    800014da:	85d6                	mv	a1,s5
    800014dc:	f7843783          	ld	a5,-136(s0)
    800014e0:	6ba8                	ld	a0,80(a5)
    800014e2:	ef4ff0ef          	jal	80000bd6 <uvmgetdirty>
    800014e6:	d175                	beqz	a0,800014ca <exit+0xda>
        n = min(PGSIZE, vma->addr + vma->len - va);
    800014e8:	0084ab03          	lw	s6,8(s1)
    800014ec:	609c                	ld	a5,0(s1)
    800014ee:	9b3e                	add	s6,s6,a5
    800014f0:	415b0b33          	sub	s6,s6,s5
    800014f4:	6785                	lui	a5,0x1
    800014f6:	0167f363          	bgeu	a5,s6,800014fc <exit+0x10c>
    800014fa:	6b05                	lui	s6,0x1
    800014fc:	2b01                	sext.w	s6,s6
        for (r = 0; r < n; r += n1) {
    800014fe:	fc0b06e3          	beqz	s6,800014ca <exit+0xda>
    80001502:	4a01                	li	s4,0
          n1 = min(maxsz, n - i);
    80001504:	419b07bb          	subw	a5,s6,s9
    80001508:	f8f42623          	sw	a5,-116(s0)
    8000150c:	00078d9b          	sext.w	s11,a5
    80001510:	b759                	j	80001496 <exit+0xa6>
    uvmunmap(p->pagetable, vma->addr, (vma->len - 1) / PGSIZE + 1, 1);
    80001512:	449c                	lw	a5,8(s1)
    80001514:	37fd                	addiw	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001516:	41f7d61b          	sraiw	a2,a5,0x1f
    8000151a:	0146561b          	srliw	a2,a2,0x14
    8000151e:	9e3d                	addw	a2,a2,a5
    80001520:	40c6561b          	sraiw	a2,a2,0xc
    80001524:	4685                	li	a3,1
    80001526:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80001528:	608c                	ld	a1,0(s1)
    8000152a:	f7843783          	ld	a5,-136(s0)
    8000152e:	6ba8                	ld	a0,80(a5)
    80001530:	910ff0ef          	jal	80000640 <uvmunmap>
    vma->addr = 0;
    80001534:	0004b023          	sd	zero,0(s1)
    vma->len = 0;
    80001538:	0004a423          	sw	zero,8(s1)
    vma->offset = 0;
    8000153c:	0004aa23          	sw	zero,20(s1)
    vma->flags = 0;
    80001540:	0004a823          	sw	zero,16(s1)
    fileclose(vma->f);
    80001544:	6c88                	ld	a0,24(s1)
    80001546:	12a020ef          	jal	80003670 <fileclose>
    vma->f = 0;
    8000154a:	0004bc23          	sd	zero,24(s1)
  for (i = 0; i < NVMA; ++i) {
    8000154e:	f8043783          	ld	a5,-128(s0)
    80001552:	0785                	addi	a5,a5,1
    80001554:	f8f43023          	sd	a5,-128(s0)
    80001558:	020d0d13          	addi	s10,s10,32 # 1020 <_entry-0x7fffefe0>
    8000155c:	4741                	li	a4,16
    8000155e:	02e78f63          	beq	a5,a4,8000159c <exit+0x1ac>
    if (p->vma[i].addr == 0) {
    80001562:	84ea                	mv	s1,s10
    80001564:	000d3a83          	ld	s5,0(s10)
    80001568:	fe0a83e3          	beqz	s5,8000154e <exit+0x15e>
    if ((vma->flags & MAP_SHARED)) {
    8000156c:	010d2783          	lw	a5,16(s10)
    80001570:	8b85                	andi	a5,a5,1
    80001572:	d3c5                	beqz	a5,80001512 <exit+0x122>
      for (va = vma->addr; va < vma->addr + vma->len; va += PGSIZE) {
    80001574:	008d2783          	lw	a5,8(s10)
    80001578:	97d6                	add	a5,a5,s5
    8000157a:	f8fafce3          	bgeu	s5,a5,80001512 <exit+0x122>
    8000157e:	f8043783          	ld	a5,-128(s0)
    80001582:	00078c9b          	sext.w	s9,a5
    80001586:	00fa8bb3          	add	s7,s5,a5
          n1 = min(maxsz, n - i);
    8000158a:	6c05                	lui	s8,0x1
    8000158c:	c00c0c13          	addi	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80001590:	6785                	lui	a5,0x1
    80001592:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80001596:	f8f42423          	sw	a5,-120(s0)
    8000159a:	b781                	j	800014da <exit+0xea>
    8000159c:	f7843783          	ld	a5,-136(s0)
    800015a0:	0d078493          	addi	s1,a5,208
    800015a4:	15078913          	addi	s2,a5,336
    800015a8:	a021                	j	800015b0 <exit+0x1c0>
  for(int fd = 0; fd < NOFILE; fd++){
    800015aa:	04a1                	addi	s1,s1,8
    800015ac:	01248963          	beq	s1,s2,800015be <exit+0x1ce>
    if(p->ofile[fd]){
    800015b0:	6088                	ld	a0,0(s1)
    800015b2:	dd65                	beqz	a0,800015aa <exit+0x1ba>
      fileclose(f);
    800015b4:	0bc020ef          	jal	80003670 <fileclose>
      p->ofile[fd] = 0;
    800015b8:	0004b023          	sd	zero,0(s1)
    800015bc:	b7fd                	j	800015aa <exit+0x1ba>
  begin_op();
    800015be:	499010ef          	jal	80003256 <begin_op>
  iput(p->cwd);
    800015c2:	f7843903          	ld	s2,-136(s0)
    800015c6:	15093503          	ld	a0,336(s2)
    800015ca:	578010ef          	jal	80002b42 <iput>
  end_op();
    800015ce:	4f3010ef          	jal	800032c0 <end_op>
  p->cwd = 0;
    800015d2:	14093823          	sd	zero,336(s2)
  acquire(&initproc->lock);
    800015d6:	00006497          	auipc	s1,0x6
    800015da:	34a48493          	addi	s1,s1,842 # 80007920 <initproc>
    800015de:	6088                	ld	a0,0(s1)
    800015e0:	0b1040ef          	jal	80005e90 <acquire>
  wakeup1(initproc);
    800015e4:	6088                	ld	a0,0(s1)
    800015e6:	e38ff0ef          	jal	80000c1e <wakeup1>
  release(&initproc->lock);
    800015ea:	6088                	ld	a0,0(s1)
    800015ec:	13d040ef          	jal	80005f28 <release>
  acquire(&p->lock);
    800015f0:	854a                	mv	a0,s2
    800015f2:	09f040ef          	jal	80005e90 <acquire>
  struct proc *original_parent = p->parent;
    800015f6:	03893483          	ld	s1,56(s2)
  release(&p->lock);
    800015fa:	854a                	mv	a0,s2
    800015fc:	12d040ef          	jal	80005f28 <release>
  acquire(&original_parent->lock);
    80001600:	8526                	mv	a0,s1
    80001602:	08f040ef          	jal	80005e90 <acquire>
  acquire(&p->lock);
    80001606:	854a                	mv	a0,s2
    80001608:	089040ef          	jal	80005e90 <acquire>
  reparent(p);
    8000160c:	854a                	mv	a0,s2
    8000160e:	c13ff0ef          	jal	80001220 <reparent>
  wakeup1(original_parent);
    80001612:	8526                	mv	a0,s1
    80001614:	e0aff0ef          	jal	80000c1e <wakeup1>
  p->xstate = status;
    80001618:	f7043783          	ld	a5,-144(s0)
    8000161c:	02f92623          	sw	a5,44(s2)
  p->state = ZOMBIE;
    80001620:	4795                	li	a5,5
    80001622:	00f92c23          	sw	a5,24(s2)
  release(&original_parent->lock);
    80001626:	8526                	mv	a0,s1
    80001628:	101040ef          	jal	80005f28 <release>
  sched();
    8000162c:	d0bff0ef          	jal	80001336 <sched>
  panic("zombie exit");
    80001630:	00006517          	auipc	a0,0x6
    80001634:	bf050513          	addi	a0,a0,-1040 # 80007220 <etext+0x220>
    80001638:	52a040ef          	jal	80005b62 <panic>

000000008000163c <yield>:
{
    8000163c:	1101                	addi	sp,sp,-32
    8000163e:	ec06                	sd	ra,24(sp)
    80001640:	e822                	sd	s0,16(sp)
    80001642:	e426                	sd	s1,8(sp)
    80001644:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001646:	f8eff0ef          	jal	80000dd4 <myproc>
    8000164a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000164c:	045040ef          	jal	80005e90 <acquire>
  p->state = RUNNABLE;
    80001650:	478d                	li	a5,3
    80001652:	cc9c                	sw	a5,24(s1)
  sched();
    80001654:	ce3ff0ef          	jal	80001336 <sched>
  release(&p->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	0cf040ef          	jal	80005f28 <release>
}
    8000165e:	60e2                	ld	ra,24(sp)
    80001660:	6442                	ld	s0,16(sp)
    80001662:	64a2                	ld	s1,8(sp)
    80001664:	6105                	addi	sp,sp,32
    80001666:	8082                	ret

0000000080001668 <sleep>:
{
    80001668:	7179                	addi	sp,sp,-48
    8000166a:	f406                	sd	ra,40(sp)
    8000166c:	f022                	sd	s0,32(sp)
    8000166e:	ec26                	sd	s1,24(sp)
    80001670:	e84a                	sd	s2,16(sp)
    80001672:	e44e                	sd	s3,8(sp)
    80001674:	1800                	addi	s0,sp,48
    80001676:	89aa                	mv	s3,a0
    80001678:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000167a:	f5aff0ef          	jal	80000dd4 <myproc>
    8000167e:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80001680:	01250763          	beq	a0,s2,8000168e <sleep+0x26>
    acquire(&p->lock);  //DOC: sleeplock1
    80001684:	00d040ef          	jal	80005e90 <acquire>
    release(lk);
    80001688:	854a                	mv	a0,s2
    8000168a:	09f040ef          	jal	80005f28 <release>
  p->chan = chan;
    8000168e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001692:	4789                	li	a5,2
    80001694:	cc9c                	sw	a5,24(s1)
  sched();
    80001696:	ca1ff0ef          	jal	80001336 <sched>
  p->chan = 0;
    8000169a:	0204b023          	sd	zero,32(s1)
  release(&p->lock);
    8000169e:	8526                	mv	a0,s1
    800016a0:	089040ef          	jal	80005f28 <release>
  acquire(lk);
    800016a4:	854a                	mv	a0,s2
    800016a6:	7ea040ef          	jal	80005e90 <acquire>
}
    800016aa:	70a2                	ld	ra,40(sp)
    800016ac:	7402                	ld	s0,32(sp)
    800016ae:	64e2                	ld	s1,24(sp)
    800016b0:	6942                	ld	s2,16(sp)
    800016b2:	69a2                	ld	s3,8(sp)
    800016b4:	6145                	addi	sp,sp,48
    800016b6:	8082                	ret

00000000800016b8 <wakeup>:
{
    800016b8:	7139                	addi	sp,sp,-64
    800016ba:	fc06                	sd	ra,56(sp)
    800016bc:	f822                	sd	s0,48(sp)
    800016be:	f426                	sd	s1,40(sp)
    800016c0:	f04a                	sd	s2,32(sp)
    800016c2:	ec4e                	sd	s3,24(sp)
    800016c4:	e852                	sd	s4,16(sp)
    800016c6:	e456                	sd	s5,8(sp)
    800016c8:	0080                	addi	s0,sp,64
    800016ca:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800016cc:	00006497          	auipc	s1,0x6
    800016d0:	6c448493          	addi	s1,s1,1732 # 80007d90 <proc>
      if(p->state == SLEEPING && p->chan == chan) {
    800016d4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016d6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d8:	00014917          	auipc	s2,0x14
    800016dc:	0b890913          	addi	s2,s2,184 # 80015790 <tickslock>
    800016e0:	a801                	j	800016f0 <wakeup+0x38>
      release(&p->lock);
    800016e2:	8526                	mv	a0,s1
    800016e4:	045040ef          	jal	80005f28 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e8:	36848493          	addi	s1,s1,872
    800016ec:	03248263          	beq	s1,s2,80001710 <wakeup+0x58>
    if(p != myproc()){
    800016f0:	ee4ff0ef          	jal	80000dd4 <myproc>
    800016f4:	fea48ae3          	beq	s1,a0,800016e8 <wakeup+0x30>
      acquire(&p->lock);
    800016f8:	8526                	mv	a0,s1
    800016fa:	796040ef          	jal	80005e90 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016fe:	4c9c                	lw	a5,24(s1)
    80001700:	ff3791e3          	bne	a5,s3,800016e2 <wakeup+0x2a>
    80001704:	709c                	ld	a5,32(s1)
    80001706:	fd479ee3          	bne	a5,s4,800016e2 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000170a:	0154ac23          	sw	s5,24(s1)
    8000170e:	bfd1                	j	800016e2 <wakeup+0x2a>
}
    80001710:	70e2                	ld	ra,56(sp)
    80001712:	7442                	ld	s0,48(sp)
    80001714:	74a2                	ld	s1,40(sp)
    80001716:	7902                	ld	s2,32(sp)
    80001718:	69e2                	ld	s3,24(sp)
    8000171a:	6a42                	ld	s4,16(sp)
    8000171c:	6aa2                	ld	s5,8(sp)
    8000171e:	6121                	addi	sp,sp,64
    80001720:	8082                	ret

0000000080001722 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001722:	7179                	addi	sp,sp,-48
    80001724:	f406                	sd	ra,40(sp)
    80001726:	f022                	sd	s0,32(sp)
    80001728:	ec26                	sd	s1,24(sp)
    8000172a:	e84a                	sd	s2,16(sp)
    8000172c:	e44e                	sd	s3,8(sp)
    8000172e:	1800                	addi	s0,sp,48
    80001730:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001732:	00006497          	auipc	s1,0x6
    80001736:	65e48493          	addi	s1,s1,1630 # 80007d90 <proc>
    8000173a:	00014997          	auipc	s3,0x14
    8000173e:	05698993          	addi	s3,s3,86 # 80015790 <tickslock>
    acquire(&p->lock);
    80001742:	8526                	mv	a0,s1
    80001744:	74c040ef          	jal	80005e90 <acquire>
    if(p->pid == pid){
    80001748:	589c                	lw	a5,48(s1)
    8000174a:	01278b63          	beq	a5,s2,80001760 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000174e:	8526                	mv	a0,s1
    80001750:	7d8040ef          	jal	80005f28 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001754:	36848493          	addi	s1,s1,872
    80001758:	ff3495e3          	bne	s1,s3,80001742 <kill+0x20>
  }
  return -1;
    8000175c:	557d                	li	a0,-1
    8000175e:	a819                	j	80001774 <kill+0x52>
      p->killed = 1;
    80001760:	4785                	li	a5,1
    80001762:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001764:	4c98                	lw	a4,24(s1)
    80001766:	4789                	li	a5,2
    80001768:	00f70d63          	beq	a4,a5,80001782 <kill+0x60>
      release(&p->lock);
    8000176c:	8526                	mv	a0,s1
    8000176e:	7ba040ef          	jal	80005f28 <release>
      return 0;
    80001772:	4501                	li	a0,0
}
    80001774:	70a2                	ld	ra,40(sp)
    80001776:	7402                	ld	s0,32(sp)
    80001778:	64e2                	ld	s1,24(sp)
    8000177a:	6942                	ld	s2,16(sp)
    8000177c:	69a2                	ld	s3,8(sp)
    8000177e:	6145                	addi	sp,sp,48
    80001780:	8082                	ret
        p->state = RUNNABLE;
    80001782:	478d                	li	a5,3
    80001784:	cc9c                	sw	a5,24(s1)
    80001786:	b7dd                	j	8000176c <kill+0x4a>

0000000080001788 <setkilled>:

void
setkilled(struct proc *p)
{
    80001788:	1101                	addi	sp,sp,-32
    8000178a:	ec06                	sd	ra,24(sp)
    8000178c:	e822                	sd	s0,16(sp)
    8000178e:	e426                	sd	s1,8(sp)
    80001790:	1000                	addi	s0,sp,32
    80001792:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001794:	6fc040ef          	jal	80005e90 <acquire>
  p->killed = 1;
    80001798:	4785                	li	a5,1
    8000179a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000179c:	8526                	mv	a0,s1
    8000179e:	78a040ef          	jal	80005f28 <release>
}
    800017a2:	60e2                	ld	ra,24(sp)
    800017a4:	6442                	ld	s0,16(sp)
    800017a6:	64a2                	ld	s1,8(sp)
    800017a8:	6105                	addi	sp,sp,32
    800017aa:	8082                	ret

00000000800017ac <killed>:

int
killed(struct proc *p)
{
    800017ac:	1101                	addi	sp,sp,-32
    800017ae:	ec06                	sd	ra,24(sp)
    800017b0:	e822                	sd	s0,16(sp)
    800017b2:	e426                	sd	s1,8(sp)
    800017b4:	e04a                	sd	s2,0(sp)
    800017b6:	1000                	addi	s0,sp,32
    800017b8:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017ba:	6d6040ef          	jal	80005e90 <acquire>
  k = p->killed;
    800017be:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017c2:	8526                	mv	a0,s1
    800017c4:	764040ef          	jal	80005f28 <release>
  return k;
}
    800017c8:	854a                	mv	a0,s2
    800017ca:	60e2                	ld	ra,24(sp)
    800017cc:	6442                	ld	s0,16(sp)
    800017ce:	64a2                	ld	s1,8(sp)
    800017d0:	6902                	ld	s2,0(sp)
    800017d2:	6105                	addi	sp,sp,32
    800017d4:	8082                	ret

00000000800017d6 <wait>:
{
    800017d6:	715d                	addi	sp,sp,-80
    800017d8:	e486                	sd	ra,72(sp)
    800017da:	e0a2                	sd	s0,64(sp)
    800017dc:	fc26                	sd	s1,56(sp)
    800017de:	f84a                	sd	s2,48(sp)
    800017e0:	f44e                	sd	s3,40(sp)
    800017e2:	f052                	sd	s4,32(sp)
    800017e4:	ec56                	sd	s5,24(sp)
    800017e6:	e85a                	sd	s6,16(sp)
    800017e8:	e45e                	sd	s7,8(sp)
    800017ea:	e062                	sd	s8,0(sp)
    800017ec:	0880                	addi	s0,sp,80
    800017ee:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017f0:	de4ff0ef          	jal	80000dd4 <myproc>
    800017f4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017f6:	00006517          	auipc	a0,0x6
    800017fa:	18250513          	addi	a0,a0,386 # 80007978 <wait_lock>
    800017fe:	692040ef          	jal	80005e90 <acquire>
    havekids = 0;
    80001802:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001804:	4a15                	li	s4,5
        havekids = 1;
    80001806:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001808:	00014997          	auipc	s3,0x14
    8000180c:	f8898993          	addi	s3,s3,-120 # 80015790 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001810:	00006c17          	auipc	s8,0x6
    80001814:	168c0c13          	addi	s8,s8,360 # 80007978 <wait_lock>
    80001818:	a871                	j	800018b4 <wait+0xde>
          pid = pp->pid;
    8000181a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000181e:	000b0c63          	beqz	s6,80001836 <wait+0x60>
    80001822:	4691                	li	a3,4
    80001824:	02c48613          	addi	a2,s1,44
    80001828:	85da                	mv	a1,s6
    8000182a:	05093503          	ld	a0,80(s2)
    8000182e:	994ff0ef          	jal	800009c2 <copyout>
    80001832:	02054b63          	bltz	a0,80001868 <wait+0x92>
          freeproc(pp);
    80001836:	8526                	mv	a0,s1
    80001838:	f0eff0ef          	jal	80000f46 <freeproc>
          release(&pp->lock);
    8000183c:	8526                	mv	a0,s1
    8000183e:	6ea040ef          	jal	80005f28 <release>
          release(&wait_lock);
    80001842:	00006517          	auipc	a0,0x6
    80001846:	13650513          	addi	a0,a0,310 # 80007978 <wait_lock>
    8000184a:	6de040ef          	jal	80005f28 <release>
}
    8000184e:	854e                	mv	a0,s3
    80001850:	60a6                	ld	ra,72(sp)
    80001852:	6406                	ld	s0,64(sp)
    80001854:	74e2                	ld	s1,56(sp)
    80001856:	7942                	ld	s2,48(sp)
    80001858:	79a2                	ld	s3,40(sp)
    8000185a:	7a02                	ld	s4,32(sp)
    8000185c:	6ae2                	ld	s5,24(sp)
    8000185e:	6b42                	ld	s6,16(sp)
    80001860:	6ba2                	ld	s7,8(sp)
    80001862:	6c02                	ld	s8,0(sp)
    80001864:	6161                	addi	sp,sp,80
    80001866:	8082                	ret
            release(&pp->lock);
    80001868:	8526                	mv	a0,s1
    8000186a:	6be040ef          	jal	80005f28 <release>
            release(&wait_lock);
    8000186e:	00006517          	auipc	a0,0x6
    80001872:	10a50513          	addi	a0,a0,266 # 80007978 <wait_lock>
    80001876:	6b2040ef          	jal	80005f28 <release>
            return -1;
    8000187a:	59fd                	li	s3,-1
    8000187c:	bfc9                	j	8000184e <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000187e:	36848493          	addi	s1,s1,872
    80001882:	03348063          	beq	s1,s3,800018a2 <wait+0xcc>
      if(pp->parent == p){
    80001886:	7c9c                	ld	a5,56(s1)
    80001888:	ff279be3          	bne	a5,s2,8000187e <wait+0xa8>
        acquire(&pp->lock);
    8000188c:	8526                	mv	a0,s1
    8000188e:	602040ef          	jal	80005e90 <acquire>
        if(pp->state == ZOMBIE){
    80001892:	4c9c                	lw	a5,24(s1)
    80001894:	f94783e3          	beq	a5,s4,8000181a <wait+0x44>
        release(&pp->lock);
    80001898:	8526                	mv	a0,s1
    8000189a:	68e040ef          	jal	80005f28 <release>
        havekids = 1;
    8000189e:	8756                	mv	a4,s5
    800018a0:	bff9                	j	8000187e <wait+0xa8>
    if(!havekids || killed(p)){
    800018a2:	cf19                	beqz	a4,800018c0 <wait+0xea>
    800018a4:	854a                	mv	a0,s2
    800018a6:	f07ff0ef          	jal	800017ac <killed>
    800018aa:	e919                	bnez	a0,800018c0 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018ac:	85e2                	mv	a1,s8
    800018ae:	854a                	mv	a0,s2
    800018b0:	db9ff0ef          	jal	80001668 <sleep>
    havekids = 0;
    800018b4:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018b6:	00006497          	auipc	s1,0x6
    800018ba:	4da48493          	addi	s1,s1,1242 # 80007d90 <proc>
    800018be:	b7e1                	j	80001886 <wait+0xb0>
      release(&wait_lock);
    800018c0:	00006517          	auipc	a0,0x6
    800018c4:	0b850513          	addi	a0,a0,184 # 80007978 <wait_lock>
    800018c8:	660040ef          	jal	80005f28 <release>
      return -1;
    800018cc:	59fd                	li	s3,-1
    800018ce:	b741                	j	8000184e <wait+0x78>

00000000800018d0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018d0:	7179                	addi	sp,sp,-48
    800018d2:	f406                	sd	ra,40(sp)
    800018d4:	f022                	sd	s0,32(sp)
    800018d6:	ec26                	sd	s1,24(sp)
    800018d8:	e84a                	sd	s2,16(sp)
    800018da:	e44e                	sd	s3,8(sp)
    800018dc:	e052                	sd	s4,0(sp)
    800018de:	1800                	addi	s0,sp,48
    800018e0:	84aa                	mv	s1,a0
    800018e2:	892e                	mv	s2,a1
    800018e4:	89b2                	mv	s3,a2
    800018e6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018e8:	cecff0ef          	jal	80000dd4 <myproc>
  if(user_dst){
    800018ec:	cc99                	beqz	s1,8000190a <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800018ee:	86d2                	mv	a3,s4
    800018f0:	864e                	mv	a2,s3
    800018f2:	85ca                	mv	a1,s2
    800018f4:	6928                	ld	a0,80(a0)
    800018f6:	8ccff0ef          	jal	800009c2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018fa:	70a2                	ld	ra,40(sp)
    800018fc:	7402                	ld	s0,32(sp)
    800018fe:	64e2                	ld	s1,24(sp)
    80001900:	6942                	ld	s2,16(sp)
    80001902:	69a2                	ld	s3,8(sp)
    80001904:	6a02                	ld	s4,0(sp)
    80001906:	6145                	addi	sp,sp,48
    80001908:	8082                	ret
    memmove((char *)dst, src, len);
    8000190a:	000a061b          	sext.w	a2,s4
    8000190e:	85ce                	mv	a1,s3
    80001910:	854a                	mv	a0,s2
    80001912:	899fe0ef          	jal	800001aa <memmove>
    return 0;
    80001916:	8526                	mv	a0,s1
    80001918:	b7cd                	j	800018fa <either_copyout+0x2a>

000000008000191a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000191a:	7179                	addi	sp,sp,-48
    8000191c:	f406                	sd	ra,40(sp)
    8000191e:	f022                	sd	s0,32(sp)
    80001920:	ec26                	sd	s1,24(sp)
    80001922:	e84a                	sd	s2,16(sp)
    80001924:	e44e                	sd	s3,8(sp)
    80001926:	e052                	sd	s4,0(sp)
    80001928:	1800                	addi	s0,sp,48
    8000192a:	892a                	mv	s2,a0
    8000192c:	84ae                	mv	s1,a1
    8000192e:	89b2                	mv	s3,a2
    80001930:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001932:	ca2ff0ef          	jal	80000dd4 <myproc>
  if(user_src){
    80001936:	cc99                	beqz	s1,80001954 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001938:	86d2                	mv	a3,s4
    8000193a:	864e                	mv	a2,s3
    8000193c:	85ca                	mv	a1,s2
    8000193e:	6928                	ld	a0,80(a0)
    80001940:	958ff0ef          	jal	80000a98 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001944:	70a2                	ld	ra,40(sp)
    80001946:	7402                	ld	s0,32(sp)
    80001948:	64e2                	ld	s1,24(sp)
    8000194a:	6942                	ld	s2,16(sp)
    8000194c:	69a2                	ld	s3,8(sp)
    8000194e:	6a02                	ld	s4,0(sp)
    80001950:	6145                	addi	sp,sp,48
    80001952:	8082                	ret
    memmove(dst, (char*)src, len);
    80001954:	000a061b          	sext.w	a2,s4
    80001958:	85ce                	mv	a1,s3
    8000195a:	854a                	mv	a0,s2
    8000195c:	84ffe0ef          	jal	800001aa <memmove>
    return 0;
    80001960:	8526                	mv	a0,s1
    80001962:	b7cd                	j	80001944 <either_copyin+0x2a>

0000000080001964 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001964:	715d                	addi	sp,sp,-80
    80001966:	e486                	sd	ra,72(sp)
    80001968:	e0a2                	sd	s0,64(sp)
    8000196a:	fc26                	sd	s1,56(sp)
    8000196c:	f84a                	sd	s2,48(sp)
    8000196e:	f44e                	sd	s3,40(sp)
    80001970:	f052                	sd	s4,32(sp)
    80001972:	ec56                	sd	s5,24(sp)
    80001974:	e85a                	sd	s6,16(sp)
    80001976:	e45e                	sd	s7,8(sp)
    80001978:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000197a:	00005517          	auipc	a0,0x5
    8000197e:	69e50513          	addi	a0,a0,1694 # 80007018 <etext+0x18>
    80001982:	70f030ef          	jal	80005890 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001986:	00006497          	auipc	s1,0x6
    8000198a:	56248493          	addi	s1,s1,1378 # 80007ee8 <proc+0x158>
    8000198e:	00014917          	auipc	s2,0x14
    80001992:	f5a90913          	addi	s2,s2,-166 # 800158e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001996:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001998:	00006997          	auipc	s3,0x6
    8000199c:	89898993          	addi	s3,s3,-1896 # 80007230 <etext+0x230>
    printf("%d %s %s", p->pid, state, p->name);
    800019a0:	00006a97          	auipc	s5,0x6
    800019a4:	898a8a93          	addi	s5,s5,-1896 # 80007238 <etext+0x238>
    printf("\n");
    800019a8:	00005a17          	auipc	s4,0x5
    800019ac:	670a0a13          	addi	s4,s4,1648 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019b0:	00006b97          	auipc	s7,0x6
    800019b4:	df0b8b93          	addi	s7,s7,-528 # 800077a0 <states.0>
    800019b8:	a829                	j	800019d2 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800019ba:	ed86a583          	lw	a1,-296(a3)
    800019be:	8556                	mv	a0,s5
    800019c0:	6d1030ef          	jal	80005890 <printf>
    printf("\n");
    800019c4:	8552                	mv	a0,s4
    800019c6:	6cb030ef          	jal	80005890 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ca:	36848493          	addi	s1,s1,872
    800019ce:	03248263          	beq	s1,s2,800019f2 <procdump+0x8e>
    if(p->state == UNUSED)
    800019d2:	86a6                	mv	a3,s1
    800019d4:	ec04a783          	lw	a5,-320(s1)
    800019d8:	dbed                	beqz	a5,800019ca <procdump+0x66>
      state = "???";
    800019da:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019dc:	fcfb6fe3          	bltu	s6,a5,800019ba <procdump+0x56>
    800019e0:	02079713          	slli	a4,a5,0x20
    800019e4:	01d75793          	srli	a5,a4,0x1d
    800019e8:	97de                	add	a5,a5,s7
    800019ea:	6390                	ld	a2,0(a5)
    800019ec:	f679                	bnez	a2,800019ba <procdump+0x56>
      state = "???";
    800019ee:	864e                	mv	a2,s3
    800019f0:	b7e9                	j	800019ba <procdump+0x56>
  }
}
    800019f2:	60a6                	ld	ra,72(sp)
    800019f4:	6406                	ld	s0,64(sp)
    800019f6:	74e2                	ld	s1,56(sp)
    800019f8:	7942                	ld	s2,48(sp)
    800019fa:	79a2                	ld	s3,40(sp)
    800019fc:	7a02                	ld	s4,32(sp)
    800019fe:	6ae2                	ld	s5,24(sp)
    80001a00:	6b42                	ld	s6,16(sp)
    80001a02:	6ba2                	ld	s7,8(sp)
    80001a04:	6161                	addi	sp,sp,80
    80001a06:	8082                	ret

0000000080001a08 <swtch>:
    80001a08:	00153023          	sd	ra,0(a0)
    80001a0c:	00253423          	sd	sp,8(a0)
    80001a10:	e900                	sd	s0,16(a0)
    80001a12:	ed04                	sd	s1,24(a0)
    80001a14:	03253023          	sd	s2,32(a0)
    80001a18:	03353423          	sd	s3,40(a0)
    80001a1c:	03453823          	sd	s4,48(a0)
    80001a20:	03553c23          	sd	s5,56(a0)
    80001a24:	05653023          	sd	s6,64(a0)
    80001a28:	05753423          	sd	s7,72(a0)
    80001a2c:	05853823          	sd	s8,80(a0)
    80001a30:	05953c23          	sd	s9,88(a0)
    80001a34:	07a53023          	sd	s10,96(a0)
    80001a38:	07b53423          	sd	s11,104(a0)
    80001a3c:	0005b083          	ld	ra,0(a1)
    80001a40:	0085b103          	ld	sp,8(a1)
    80001a44:	6980                	ld	s0,16(a1)
    80001a46:	6d84                	ld	s1,24(a1)
    80001a48:	0205b903          	ld	s2,32(a1)
    80001a4c:	0285b983          	ld	s3,40(a1)
    80001a50:	0305ba03          	ld	s4,48(a1)
    80001a54:	0385ba83          	ld	s5,56(a1)
    80001a58:	0405bb03          	ld	s6,64(a1)
    80001a5c:	0485bb83          	ld	s7,72(a1)
    80001a60:	0505bc03          	ld	s8,80(a1)
    80001a64:	0585bc83          	ld	s9,88(a1)
    80001a68:	0605bd03          	ld	s10,96(a1)
    80001a6c:	0685bd83          	ld	s11,104(a1)
    80001a70:	8082                	ret

0000000080001a72 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a72:	1141                	addi	sp,sp,-16
    80001a74:	e406                	sd	ra,8(sp)
    80001a76:	e022                	sd	s0,0(sp)
    80001a78:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a7a:	00005597          	auipc	a1,0x5
    80001a7e:	7fe58593          	addi	a1,a1,2046 # 80007278 <etext+0x278>
    80001a82:	00014517          	auipc	a0,0x14
    80001a86:	d0e50513          	addi	a0,a0,-754 # 80015790 <tickslock>
    80001a8a:	386040ef          	jal	80005e10 <initlock>
}
    80001a8e:	60a2                	ld	ra,8(sp)
    80001a90:	6402                	ld	s0,0(sp)
    80001a92:	0141                	addi	sp,sp,16
    80001a94:	8082                	ret

0000000080001a96 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a96:	1141                	addi	sp,sp,-16
    80001a98:	e422                	sd	s0,8(sp)
    80001a9a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a9c:	00003797          	auipc	a5,0x3
    80001aa0:	33478793          	addi	a5,a5,820 # 80004dd0 <kernelvec>
    80001aa4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aa8:	6422                	ld	s0,8(sp)
    80001aaa:	0141                	addi	sp,sp,16
    80001aac:	8082                	ret

0000000080001aae <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aae:	1141                	addi	sp,sp,-16
    80001ab0:	e406                	sd	ra,8(sp)
    80001ab2:	e022                	sd	s0,0(sp)
    80001ab4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ab6:	b1eff0ef          	jal	80000dd4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001abe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001ac4:	00004697          	auipc	a3,0x4
    80001ac8:	53c68693          	addi	a3,a3,1340 # 80006000 <_trampoline>
    80001acc:	00004717          	auipc	a4,0x4
    80001ad0:	53470713          	addi	a4,a4,1332 # 80006000 <_trampoline>
    80001ad4:	8f15                	sub	a4,a4,a3
    80001ad6:	040007b7          	lui	a5,0x4000
    80001ada:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001adc:	07b2                	slli	a5,a5,0xc
    80001ade:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae0:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ae4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ae6:	18002673          	csrr	a2,satp
    80001aea:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001aec:	6d30                	ld	a2,88(a0)
    80001aee:	6138                	ld	a4,64(a0)
    80001af0:	6585                	lui	a1,0x1
    80001af2:	972e                	add	a4,a4,a1
    80001af4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001af6:	6d38                	ld	a4,88(a0)
    80001af8:	00000617          	auipc	a2,0x0
    80001afc:	11060613          	addi	a2,a2,272 # 80001c08 <usertrap>
    80001b00:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b02:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b04:	8612                	mv	a2,tp
    80001b06:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b08:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b0c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b10:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b14:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b18:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b1a:	6f18                	ld	a4,24(a4)
    80001b1c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b20:	6928                	ld	a0,80(a0)
    80001b22:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b24:	00004717          	auipc	a4,0x4
    80001b28:	57870713          	addi	a4,a4,1400 # 8000609c <userret>
    80001b2c:	8f15                	sub	a4,a4,a3
    80001b2e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b30:	577d                	li	a4,-1
    80001b32:	177e                	slli	a4,a4,0x3f
    80001b34:	8d59                	or	a0,a0,a4
    80001b36:	9782                	jalr	a5
}
    80001b38:	60a2                	ld	ra,8(sp)
    80001b3a:	6402                	ld	s0,0(sp)
    80001b3c:	0141                	addi	sp,sp,16
    80001b3e:	8082                	ret

0000000080001b40 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b40:	1101                	addi	sp,sp,-32
    80001b42:	ec06                	sd	ra,24(sp)
    80001b44:	e822                	sd	s0,16(sp)
    80001b46:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001b48:	a60ff0ef          	jal	80000da8 <cpuid>
    80001b4c:	cd11                	beqz	a0,80001b68 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001b4e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001b52:	000f4737          	lui	a4,0xf4
    80001b56:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001b5a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001b5c:	14d79073          	csrw	stimecmp,a5
}
    80001b60:	60e2                	ld	ra,24(sp)
    80001b62:	6442                	ld	s0,16(sp)
    80001b64:	6105                	addi	sp,sp,32
    80001b66:	8082                	ret
    80001b68:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001b6a:	00014497          	auipc	s1,0x14
    80001b6e:	c2648493          	addi	s1,s1,-986 # 80015790 <tickslock>
    80001b72:	8526                	mv	a0,s1
    80001b74:	31c040ef          	jal	80005e90 <acquire>
    ticks++;
    80001b78:	00006517          	auipc	a0,0x6
    80001b7c:	db050513          	addi	a0,a0,-592 # 80007928 <ticks>
    80001b80:	411c                	lw	a5,0(a0)
    80001b82:	2785                	addiw	a5,a5,1
    80001b84:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001b86:	b33ff0ef          	jal	800016b8 <wakeup>
    release(&tickslock);
    80001b8a:	8526                	mv	a0,s1
    80001b8c:	39c040ef          	jal	80005f28 <release>
    80001b90:	64a2                	ld	s1,8(sp)
    80001b92:	bf75                	j	80001b4e <clockintr+0xe>

0000000080001b94 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b94:	1101                	addi	sp,sp,-32
    80001b96:	ec06                	sd	ra,24(sp)
    80001b98:	e822                	sd	s0,16(sp)
    80001b9a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b9c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001ba0:	57fd                	li	a5,-1
    80001ba2:	17fe                	slli	a5,a5,0x3f
    80001ba4:	07a5                	addi	a5,a5,9
    80001ba6:	00f70c63          	beq	a4,a5,80001bbe <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001baa:	57fd                	li	a5,-1
    80001bac:	17fe                	slli	a5,a5,0x3f
    80001bae:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001bb0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001bb2:	04f70763          	beq	a4,a5,80001c00 <devintr+0x6c>
  }
}
    80001bb6:	60e2                	ld	ra,24(sp)
    80001bb8:	6442                	ld	s0,16(sp)
    80001bba:	6105                	addi	sp,sp,32
    80001bbc:	8082                	ret
    80001bbe:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001bc0:	2bc030ef          	jal	80004e7c <plic_claim>
    80001bc4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bc6:	47a9                	li	a5,10
    80001bc8:	00f50963          	beq	a0,a5,80001bda <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001bcc:	4785                	li	a5,1
    80001bce:	00f50963          	beq	a0,a5,80001be0 <devintr+0x4c>
    return 1;
    80001bd2:	4505                	li	a0,1
    } else if(irq){
    80001bd4:	e889                	bnez	s1,80001be6 <devintr+0x52>
    80001bd6:	64a2                	ld	s1,8(sp)
    80001bd8:	bff9                	j	80001bb6 <devintr+0x22>
      uartintr();
    80001bda:	1fa040ef          	jal	80005dd4 <uartintr>
    if(irq)
    80001bde:	a819                	j	80001bf4 <devintr+0x60>
      virtio_disk_intr();
    80001be0:	762030ef          	jal	80005342 <virtio_disk_intr>
    if(irq)
    80001be4:	a801                	j	80001bf4 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001be6:	85a6                	mv	a1,s1
    80001be8:	00005517          	auipc	a0,0x5
    80001bec:	69850513          	addi	a0,a0,1688 # 80007280 <etext+0x280>
    80001bf0:	4a1030ef          	jal	80005890 <printf>
      plic_complete(irq);
    80001bf4:	8526                	mv	a0,s1
    80001bf6:	2a6030ef          	jal	80004e9c <plic_complete>
    return 1;
    80001bfa:	4505                	li	a0,1
    80001bfc:	64a2                	ld	s1,8(sp)
    80001bfe:	bf65                	j	80001bb6 <devintr+0x22>
    clockintr();
    80001c00:	f41ff0ef          	jal	80001b40 <clockintr>
    return 2;
    80001c04:	4509                	li	a0,2
    80001c06:	bf45                	j	80001bb6 <devintr+0x22>

0000000080001c08 <usertrap>:
{
    80001c08:	7179                	addi	sp,sp,-48
    80001c0a:	f406                	sd	ra,40(sp)
    80001c0c:	f022                	sd	s0,32(sp)
    80001c0e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c10:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c14:	1007f793          	andi	a5,a5,256
    80001c18:	efb9                	bnez	a5,80001c76 <usertrap+0x6e>
    80001c1a:	ec26                	sd	s1,24(sp)
    80001c1c:	e44e                	sd	s3,8(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c1e:	00003797          	auipc	a5,0x3
    80001c22:	1b278793          	addi	a5,a5,434 # 80004dd0 <kernelvec>
    80001c26:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c2a:	9aaff0ef          	jal	80000dd4 <myproc>
    80001c2e:	89aa                	mv	s3,a0
  p->trapframe->epc = r_sepc();
    80001c30:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c32:	14102773          	csrr	a4,sepc
    80001c36:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c38:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c3c:	47a1                	li	a5,8
    80001c3e:	04f70663          	beq	a4,a5,80001c8a <usertrap+0x82>
    80001c42:	14202773          	csrr	a4,scause
  } else if (r_scause() == 12 || r_scause() == 13 || r_scause() == 15) { // mmap page fault - lab10
    80001c46:	47b1                	li	a5,12
    80001c48:	00f70c63          	beq	a4,a5,80001c60 <usertrap+0x58>
    80001c4c:	14202773          	csrr	a4,scause
    80001c50:	47b5                	li	a5,13
    80001c52:	00f70763          	beq	a4,a5,80001c60 <usertrap+0x58>
    80001c56:	14202773          	csrr	a4,scause
    80001c5a:	47bd                	li	a5,15
    80001c5c:	18f71b63          	bne	a4,a5,80001df2 <usertrap+0x1ea>
    80001c60:	e84a                	sd	s2,16(sp)
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001c62:	14302973          	csrr	s2,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80001c66:	77fd                	lui	a5,0xfffff
    80001c68:	00f97933          	and	s2,s2,a5
    for (i = 0; i < NVMA; ++i) {
    80001c6c:	16898793          	addi	a5,s3,360
    80001c70:	4701                	li	a4,0
    80001c72:	45c1                	li	a1,16
    80001c74:	a0b9                	j	80001cc2 <usertrap+0xba>
    80001c76:	ec26                	sd	s1,24(sp)
    80001c78:	e84a                	sd	s2,16(sp)
    80001c7a:	e44e                	sd	s3,8(sp)
    80001c7c:	e052                	sd	s4,0(sp)
    panic("usertrap: not from user mode");
    80001c7e:	00005517          	auipc	a0,0x5
    80001c82:	62250513          	addi	a0,a0,1570 # 800072a0 <etext+0x2a0>
    80001c86:	6dd030ef          	jal	80005b62 <panic>
    if(killed(p))
    80001c8a:	b23ff0ef          	jal	800017ac <killed>
    80001c8e:	ed19                	bnez	a0,80001cac <usertrap+0xa4>
    p->trapframe->epc += 4;
    80001c90:	0589b703          	ld	a4,88(s3)
    80001c94:	6f1c                	ld	a5,24(a4)
    80001c96:	0791                	addi	a5,a5,4 # fffffffffffff004 <end+0xffffffff7ffd6394>
    80001c98:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c9a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c9e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ca2:	10079073          	csrw	sstatus,a5
    syscall();
    80001ca6:	356000ef          	jal	80001ffc <syscall>
    80001caa:	a0ed                	j	80001d94 <usertrap+0x18c>
      exit(-1);
    80001cac:	557d                	li	a0,-1
    80001cae:	f42ff0ef          	jal	800013f0 <exit>
    80001cb2:	bff9                	j	80001c90 <usertrap+0x88>
    80001cb4:	6942                	ld	s2,16(sp)
    80001cb6:	a845                	j	80001d66 <usertrap+0x15e>
    for (i = 0; i < NVMA; ++i) {
    80001cb8:	2705                	addiw	a4,a4,1
    80001cba:	02078793          	addi	a5,a5,32
    80001cbe:	0ab70363          	beq	a4,a1,80001d64 <usertrap+0x15c>
      if (p->vma[i].addr && va >= p->vma[i].addr
    80001cc2:	6394                	ld	a3,0(a5)
    80001cc4:	daf5                	beqz	a3,80001cb8 <usertrap+0xb0>
    80001cc6:	fed969e3          	bltu	s2,a3,80001cb8 <usertrap+0xb0>
          && va < p->vma[i].addr + p->vma[i].len) {
    80001cca:	4790                	lw	a2,8(a5)
    80001ccc:	96b2                	add	a3,a3,a2
    80001cce:	fed975e3          	bgeu	s2,a3,80001cb8 <usertrap+0xb0>
        vma = &p->vma[i];
    80001cd2:	00571493          	slli	s1,a4,0x5
    80001cd6:	16848493          	addi	s1,s1,360
    80001cda:	94ce                	add	s1,s1,s3
    if (!vma) {
    80001cdc:	dce1                	beqz	s1,80001cb4 <usertrap+0xac>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cde:	14202773          	csrr	a4,scause
    if (r_scause() == 15 && (vma->prot & PROT_WRITE)
    80001ce2:	47bd                	li	a5,15
    80001ce4:	00f71563          	bne	a4,a5,80001cee <usertrap+0xe6>
    80001ce8:	44dc                	lw	a5,12(s1)
    80001cea:	8b89                	andi	a5,a5,2
    80001cec:	e3e1                	bnez	a5,80001dac <usertrap+0x1a4>
    80001cee:	e052                	sd	s4,0(sp)
      if ((pa = kalloc()) == 0) {
    80001cf0:	c0efe0ef          	jal	800000fe <kalloc>
    80001cf4:	8a2a                	mv	s4,a0
    80001cf6:	10050763          	beqz	a0,80001e04 <usertrap+0x1fc>
      memset(pa, 0, PGSIZE);
    80001cfa:	6605                	lui	a2,0x1
    80001cfc:	4581                	li	a1,0
    80001cfe:	c50fe0ef          	jal	8000014e <memset>
      ilock(vma->f->ip);
    80001d02:	6c9c                	ld	a5,24(s1)
    80001d04:	6f88                	ld	a0,24(a5)
    80001d06:	4bb000ef          	jal	800029c0 <ilock>
      if (readi(vma->f->ip, 0, (uint64)pa, va - vma->addr + vma->offset, PGSIZE) < 0) {
    80001d0a:	48dc                	lw	a5,20(s1)
    80001d0c:	012787bb          	addw	a5,a5,s2
    80001d10:	6094                	ld	a3,0(s1)
    80001d12:	6c88                	ld	a0,24(s1)
    80001d14:	6705                	lui	a4,0x1
    80001d16:	40d786bb          	subw	a3,a5,a3
    80001d1a:	8652                	mv	a2,s4
    80001d1c:	4581                	li	a1,0
    80001d1e:	6d08                	ld	a0,24(a0)
    80001d20:	6f5000ef          	jal	80002c14 <readi>
    80001d24:	0a054463          	bltz	a0,80001dcc <usertrap+0x1c4>
      iunlock(vma->f->ip);
    80001d28:	6c9c                	ld	a5,24(s1)
    80001d2a:	6f88                	ld	a0,24(a5)
    80001d2c:	543000ef          	jal	80002a6e <iunlock>
      if ((vma->prot & PROT_READ)) {
    80001d30:	44dc                	lw	a5,12(s1)
    80001d32:	0017f693          	andi	a3,a5,1
        flags |= PTE_R;
    80001d36:	4749                	li	a4,18
      if ((vma->prot & PROT_READ)) {
    80001d38:	e291                	bnez	a3,80001d3c <usertrap+0x134>
    int flags = PTE_U;
    80001d3a:	4741                	li	a4,16
    80001d3c:	14202673          	csrr	a2,scause
      if (r_scause() == 15 && (vma->prot & PROT_WRITE)) {
    80001d40:	46bd                	li	a3,15
    80001d42:	08d60c63          	beq	a2,a3,80001dda <usertrap+0x1d2>
      if ((vma->prot & PROT_EXEC)) {
    80001d46:	8b91                	andi	a5,a5,4
    80001d48:	c399                	beqz	a5,80001d4e <usertrap+0x146>
        flags |= PTE_X;
    80001d4a:	00876713          	ori	a4,a4,8
      if (mappages(p->pagetable, va, PGSIZE, (uint64)pa, flags) != 0) {
    80001d4e:	86d2                	mv	a3,s4
    80001d50:	6605                	lui	a2,0x1
    80001d52:	85ca                	mv	a1,s2
    80001d54:	0509b503          	ld	a0,80(s3)
    80001d58:	f42fe0ef          	jal	8000049a <mappages>
    80001d5c:	e549                	bnez	a0,80001de6 <usertrap+0x1de>
    80001d5e:	6942                	ld	s2,16(sp)
    80001d60:	6a02                	ld	s4,0(sp)
    80001d62:	a80d                	j	80001d94 <usertrap+0x18c>
    80001d64:	6942                	ld	s2,16(sp)
    80001d66:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %ld pid=%d\n", r_scause(), p->pid);
    80001d6a:	0309a603          	lw	a2,48(s3)
    80001d6e:	00005517          	auipc	a0,0x5
    80001d72:	55250513          	addi	a0,a0,1362 # 800072c0 <etext+0x2c0>
    80001d76:	31b030ef          	jal	80005890 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d7a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d7e:	14302673          	csrr	a2,stval
    printf("            sepc=%ld stval=%ld\n", r_sepc(), r_stval());
    80001d82:	00005517          	auipc	a0,0x5
    80001d86:	56e50513          	addi	a0,a0,1390 # 800072f0 <etext+0x2f0>
    80001d8a:	307030ef          	jal	80005890 <printf>
    setkilled(p);
    80001d8e:	854e                	mv	a0,s3
    80001d90:	9f9ff0ef          	jal	80001788 <setkilled>
  if(killed(p))
    80001d94:	854e                	mv	a0,s3
    80001d96:	a17ff0ef          	jal	800017ac <killed>
    80001d9a:	e925                	bnez	a0,80001e0a <usertrap+0x202>
  usertrapret();
    80001d9c:	d13ff0ef          	jal	80001aae <usertrapret>
    80001da0:	64e2                	ld	s1,24(sp)
    80001da2:	69a2                	ld	s3,8(sp)
}
    80001da4:	70a2                	ld	ra,40(sp)
    80001da6:	7402                	ld	s0,32(sp)
    80001da8:	6145                	addi	sp,sp,48
    80001daa:	8082                	ret
        && walkaddr(p->pagetable, va)) {
    80001dac:	85ca                	mv	a1,s2
    80001dae:	0509b503          	ld	a0,80(s3)
    80001db2:	eaafe0ef          	jal	8000045c <walkaddr>
    80001db6:	dd05                	beqz	a0,80001cee <usertrap+0xe6>
      if (uvmsetdirtywrite(p->pagetable, va)) {
    80001db8:	85ca                	mv	a1,s2
    80001dba:	0509b503          	ld	a0,80(s3)
    80001dbe:	e3bfe0ef          	jal	80000bf8 <uvmsetdirtywrite>
    80001dc2:	e119                	bnez	a0,80001dc8 <usertrap+0x1c0>
    80001dc4:	6942                	ld	s2,16(sp)
    80001dc6:	b7f9                	j	80001d94 <usertrap+0x18c>
    80001dc8:	6942                	ld	s2,16(sp)
    80001dca:	bf71                	j	80001d66 <usertrap+0x15e>
        iunlock(vma->f->ip);
    80001dcc:	6c9c                	ld	a5,24(s1)
    80001dce:	6f88                	ld	a0,24(a5)
    80001dd0:	49f000ef          	jal	80002a6e <iunlock>
        goto err;
    80001dd4:	6942                	ld	s2,16(sp)
    80001dd6:	6a02                	ld	s4,0(sp)
    80001dd8:	b779                	j	80001d66 <usertrap+0x15e>
      if (r_scause() == 15 && (vma->prot & PROT_WRITE)) {
    80001dda:	0027f693          	andi	a3,a5,2
    80001dde:	d6a5                	beqz	a3,80001d46 <usertrap+0x13e>
        flags |= PTE_W | PTE_D;
    80001de0:	08476713          	ori	a4,a4,132
    80001de4:	b78d                	j	80001d46 <usertrap+0x13e>
        kfree(pa);
    80001de6:	8552                	mv	a0,s4
    80001de8:	a34fe0ef          	jal	8000001c <kfree>
        goto err;
    80001dec:	6942                	ld	s2,16(sp)
    80001dee:	6a02                	ld	s4,0(sp)
    80001df0:	bf9d                	j	80001d66 <usertrap+0x15e>
  } else if((which_dev = devintr()) != 0){
    80001df2:	da3ff0ef          	jal	80001b94 <devintr>
    80001df6:	84aa                	mv	s1,a0
    80001df8:	d53d                	beqz	a0,80001d66 <usertrap+0x15e>
  if(killed(p))
    80001dfa:	854e                	mv	a0,s3
    80001dfc:	9b1ff0ef          	jal	800017ac <killed>
    80001e00:	c909                	beqz	a0,80001e12 <usertrap+0x20a>
    80001e02:	a029                	j	80001e0c <usertrap+0x204>
    80001e04:	6942                	ld	s2,16(sp)
    80001e06:	6a02                	ld	s4,0(sp)
    80001e08:	bfb9                	j	80001d66 <usertrap+0x15e>
    80001e0a:	4481                	li	s1,0
    exit(-1);
    80001e0c:	557d                	li	a0,-1
    80001e0e:	de2ff0ef          	jal	800013f0 <exit>
  if(which_dev == 2)
    80001e12:	4789                	li	a5,2
    80001e14:	f8f494e3          	bne	s1,a5,80001d9c <usertrap+0x194>
    yield();
    80001e18:	825ff0ef          	jal	8000163c <yield>
    80001e1c:	b741                	j	80001d9c <usertrap+0x194>

0000000080001e1e <kerneltrap>:
{
    80001e1e:	7179                	addi	sp,sp,-48
    80001e20:	f406                	sd	ra,40(sp)
    80001e22:	f022                	sd	s0,32(sp)
    80001e24:	ec26                	sd	s1,24(sp)
    80001e26:	e84a                	sd	s2,16(sp)
    80001e28:	e44e                	sd	s3,8(sp)
    80001e2a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e30:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e34:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e38:	1004f793          	andi	a5,s1,256
    80001e3c:	c795                	beqz	a5,80001e68 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e3e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e42:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e44:	eb85                	bnez	a5,80001e74 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001e46:	d4fff0ef          	jal	80001b94 <devintr>
    80001e4a:	c91d                	beqz	a0,80001e80 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001e4c:	4789                	li	a5,2
    80001e4e:	04f50a63          	beq	a0,a5,80001ea2 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e52:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e56:	10049073          	csrw	sstatus,s1
}
    80001e5a:	70a2                	ld	ra,40(sp)
    80001e5c:	7402                	ld	s0,32(sp)
    80001e5e:	64e2                	ld	s1,24(sp)
    80001e60:	6942                	ld	s2,16(sp)
    80001e62:	69a2                	ld	s3,8(sp)
    80001e64:	6145                	addi	sp,sp,48
    80001e66:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e68:	00005517          	auipc	a0,0x5
    80001e6c:	4a850513          	addi	a0,a0,1192 # 80007310 <etext+0x310>
    80001e70:	4f3030ef          	jal	80005b62 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e74:	00005517          	auipc	a0,0x5
    80001e78:	4c450513          	addi	a0,a0,1220 # 80007338 <etext+0x338>
    80001e7c:	4e7030ef          	jal	80005b62 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e80:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e84:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001e88:	85ce                	mv	a1,s3
    80001e8a:	00005517          	auipc	a0,0x5
    80001e8e:	4ce50513          	addi	a0,a0,1230 # 80007358 <etext+0x358>
    80001e92:	1ff030ef          	jal	80005890 <printf>
    panic("kerneltrap");
    80001e96:	00005517          	auipc	a0,0x5
    80001e9a:	4ea50513          	addi	a0,a0,1258 # 80007380 <etext+0x380>
    80001e9e:	4c5030ef          	jal	80005b62 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001ea2:	f33fe0ef          	jal	80000dd4 <myproc>
    80001ea6:	d555                	beqz	a0,80001e52 <kerneltrap+0x34>
    yield();
    80001ea8:	f94ff0ef          	jal	8000163c <yield>
    80001eac:	b75d                	j	80001e52 <kerneltrap+0x34>

0000000080001eae <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001eae:	1101                	addi	sp,sp,-32
    80001eb0:	ec06                	sd	ra,24(sp)
    80001eb2:	e822                	sd	s0,16(sp)
    80001eb4:	e426                	sd	s1,8(sp)
    80001eb6:	1000                	addi	s0,sp,32
    80001eb8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eba:	f1bfe0ef          	jal	80000dd4 <myproc>
  switch (n) {
    80001ebe:	4795                	li	a5,5
    80001ec0:	0497e163          	bltu	a5,s1,80001f02 <argraw+0x54>
    80001ec4:	048a                	slli	s1,s1,0x2
    80001ec6:	00006717          	auipc	a4,0x6
    80001eca:	90a70713          	addi	a4,a4,-1782 # 800077d0 <states.0+0x30>
    80001ece:	94ba                	add	s1,s1,a4
    80001ed0:	409c                	lw	a5,0(s1)
    80001ed2:	97ba                	add	a5,a5,a4
    80001ed4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ed6:	6d3c                	ld	a5,88(a0)
    80001ed8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eda:	60e2                	ld	ra,24(sp)
    80001edc:	6442                	ld	s0,16(sp)
    80001ede:	64a2                	ld	s1,8(sp)
    80001ee0:	6105                	addi	sp,sp,32
    80001ee2:	8082                	ret
    return p->trapframe->a1;
    80001ee4:	6d3c                	ld	a5,88(a0)
    80001ee6:	7fa8                	ld	a0,120(a5)
    80001ee8:	bfcd                	j	80001eda <argraw+0x2c>
    return p->trapframe->a2;
    80001eea:	6d3c                	ld	a5,88(a0)
    80001eec:	63c8                	ld	a0,128(a5)
    80001eee:	b7f5                	j	80001eda <argraw+0x2c>
    return p->trapframe->a3;
    80001ef0:	6d3c                	ld	a5,88(a0)
    80001ef2:	67c8                	ld	a0,136(a5)
    80001ef4:	b7dd                	j	80001eda <argraw+0x2c>
    return p->trapframe->a4;
    80001ef6:	6d3c                	ld	a5,88(a0)
    80001ef8:	6bc8                	ld	a0,144(a5)
    80001efa:	b7c5                	j	80001eda <argraw+0x2c>
    return p->trapframe->a5;
    80001efc:	6d3c                	ld	a5,88(a0)
    80001efe:	6fc8                	ld	a0,152(a5)
    80001f00:	bfe9                	j	80001eda <argraw+0x2c>
  panic("argraw");
    80001f02:	00005517          	auipc	a0,0x5
    80001f06:	48e50513          	addi	a0,a0,1166 # 80007390 <etext+0x390>
    80001f0a:	459030ef          	jal	80005b62 <panic>

0000000080001f0e <fetchaddr>:
{
    80001f0e:	1101                	addi	sp,sp,-32
    80001f10:	ec06                	sd	ra,24(sp)
    80001f12:	e822                	sd	s0,16(sp)
    80001f14:	e426                	sd	s1,8(sp)
    80001f16:	e04a                	sd	s2,0(sp)
    80001f18:	1000                	addi	s0,sp,32
    80001f1a:	84aa                	mv	s1,a0
    80001f1c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f1e:	eb7fe0ef          	jal	80000dd4 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f22:	653c                	ld	a5,72(a0)
    80001f24:	02f4f663          	bgeu	s1,a5,80001f50 <fetchaddr+0x42>
    80001f28:	00848713          	addi	a4,s1,8
    80001f2c:	02e7e463          	bltu	a5,a4,80001f54 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f30:	46a1                	li	a3,8
    80001f32:	8626                	mv	a2,s1
    80001f34:	85ca                	mv	a1,s2
    80001f36:	6928                	ld	a0,80(a0)
    80001f38:	b61fe0ef          	jal	80000a98 <copyin>
    80001f3c:	00a03533          	snez	a0,a0
    80001f40:	40a00533          	neg	a0,a0
}
    80001f44:	60e2                	ld	ra,24(sp)
    80001f46:	6442                	ld	s0,16(sp)
    80001f48:	64a2                	ld	s1,8(sp)
    80001f4a:	6902                	ld	s2,0(sp)
    80001f4c:	6105                	addi	sp,sp,32
    80001f4e:	8082                	ret
    return -1;
    80001f50:	557d                	li	a0,-1
    80001f52:	bfcd                	j	80001f44 <fetchaddr+0x36>
    80001f54:	557d                	li	a0,-1
    80001f56:	b7fd                	j	80001f44 <fetchaddr+0x36>

0000000080001f58 <fetchstr>:
{
    80001f58:	7179                	addi	sp,sp,-48
    80001f5a:	f406                	sd	ra,40(sp)
    80001f5c:	f022                	sd	s0,32(sp)
    80001f5e:	ec26                	sd	s1,24(sp)
    80001f60:	e84a                	sd	s2,16(sp)
    80001f62:	e44e                	sd	s3,8(sp)
    80001f64:	1800                	addi	s0,sp,48
    80001f66:	892a                	mv	s2,a0
    80001f68:	84ae                	mv	s1,a1
    80001f6a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f6c:	e69fe0ef          	jal	80000dd4 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f70:	86ce                	mv	a3,s3
    80001f72:	864a                	mv	a2,s2
    80001f74:	85a6                	mv	a1,s1
    80001f76:	6928                	ld	a0,80(a0)
    80001f78:	ba7fe0ef          	jal	80000b1e <copyinstr>
    80001f7c:	00054c63          	bltz	a0,80001f94 <fetchstr+0x3c>
  return strlen(buf);
    80001f80:	8526                	mv	a0,s1
    80001f82:	b3cfe0ef          	jal	800002be <strlen>
}
    80001f86:	70a2                	ld	ra,40(sp)
    80001f88:	7402                	ld	s0,32(sp)
    80001f8a:	64e2                	ld	s1,24(sp)
    80001f8c:	6942                	ld	s2,16(sp)
    80001f8e:	69a2                	ld	s3,8(sp)
    80001f90:	6145                	addi	sp,sp,48
    80001f92:	8082                	ret
    return -1;
    80001f94:	557d                	li	a0,-1
    80001f96:	bfc5                	j	80001f86 <fetchstr+0x2e>

0000000080001f98 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f98:	1101                	addi	sp,sp,-32
    80001f9a:	ec06                	sd	ra,24(sp)
    80001f9c:	e822                	sd	s0,16(sp)
    80001f9e:	e426                	sd	s1,8(sp)
    80001fa0:	1000                	addi	s0,sp,32
    80001fa2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fa4:	f0bff0ef          	jal	80001eae <argraw>
    80001fa8:	c088                	sw	a0,0(s1)
  return 0;
}
    80001faa:	4501                	li	a0,0
    80001fac:	60e2                	ld	ra,24(sp)
    80001fae:	6442                	ld	s0,16(sp)
    80001fb0:	64a2                	ld	s1,8(sp)
    80001fb2:	6105                	addi	sp,sp,32
    80001fb4:	8082                	ret

0000000080001fb6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fb6:	1101                	addi	sp,sp,-32
    80001fb8:	ec06                	sd	ra,24(sp)
    80001fba:	e822                	sd	s0,16(sp)
    80001fbc:	e426                	sd	s1,8(sp)
    80001fbe:	1000                	addi	s0,sp,32
    80001fc0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fc2:	eedff0ef          	jal	80001eae <argraw>
    80001fc6:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fc8:	4501                	li	a0,0
    80001fca:	60e2                	ld	ra,24(sp)
    80001fcc:	6442                	ld	s0,16(sp)
    80001fce:	64a2                	ld	s1,8(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret

0000000080001fd4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fd4:	1101                	addi	sp,sp,-32
    80001fd6:	ec06                	sd	ra,24(sp)
    80001fd8:	e822                	sd	s0,16(sp)
    80001fda:	e426                	sd	s1,8(sp)
    80001fdc:	e04a                	sd	s2,0(sp)
    80001fde:	1000                	addi	s0,sp,32
    80001fe0:	84ae                	mv	s1,a1
    80001fe2:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fe4:	ecbff0ef          	jal	80001eae <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fe8:	864a                	mv	a2,s2
    80001fea:	85a6                	mv	a1,s1
    80001fec:	f6dff0ef          	jal	80001f58 <fetchstr>
}
    80001ff0:	60e2                	ld	ra,24(sp)
    80001ff2:	6442                	ld	s0,16(sp)
    80001ff4:	64a2                	ld	s1,8(sp)
    80001ff6:	6902                	ld	s2,0(sp)
    80001ff8:	6105                	addi	sp,sp,32
    80001ffa:	8082                	ret

0000000080001ffc <syscall>:
[SYS_munmap]   sys_munmap,
};

void
syscall(void)
{
    80001ffc:	1101                	addi	sp,sp,-32
    80001ffe:	ec06                	sd	ra,24(sp)
    80002000:	e822                	sd	s0,16(sp)
    80002002:	e426                	sd	s1,8(sp)
    80002004:	e04a                	sd	s2,0(sp)
    80002006:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002008:	dcdfe0ef          	jal	80000dd4 <myproc>
    8000200c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000200e:	05853903          	ld	s2,88(a0)
    80002012:	0a893783          	ld	a5,168(s2)
    80002016:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000201a:	37fd                	addiw	a5,a5,-1
    8000201c:	4759                	li	a4,22
    8000201e:	00f76f63          	bltu	a4,a5,8000203c <syscall+0x40>
    80002022:	00369713          	slli	a4,a3,0x3
    80002026:	00005797          	auipc	a5,0x5
    8000202a:	7c278793          	addi	a5,a5,1986 # 800077e8 <syscalls>
    8000202e:	97ba                	add	a5,a5,a4
    80002030:	639c                	ld	a5,0(a5)
    80002032:	c789                	beqz	a5,8000203c <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002034:	9782                	jalr	a5
    80002036:	06a93823          	sd	a0,112(s2)
    8000203a:	a829                	j	80002054 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000203c:	15848613          	addi	a2,s1,344
    80002040:	588c                	lw	a1,48(s1)
    80002042:	00005517          	auipc	a0,0x5
    80002046:	35650513          	addi	a0,a0,854 # 80007398 <etext+0x398>
    8000204a:	047030ef          	jal	80005890 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000204e:	6cbc                	ld	a5,88(s1)
    80002050:	577d                	li	a4,-1
    80002052:	fbb8                	sd	a4,112(a5)
  }
}
    80002054:	60e2                	ld	ra,24(sp)
    80002056:	6442                	ld	s0,16(sp)
    80002058:	64a2                	ld	s1,8(sp)
    8000205a:	6902                	ld	s2,0(sp)
    8000205c:	6105                	addi	sp,sp,32
    8000205e:	8082                	ret

0000000080002060 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002060:	1101                	addi	sp,sp,-32
    80002062:	ec06                	sd	ra,24(sp)
    80002064:	e822                	sd	s0,16(sp)
    80002066:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002068:	fec40593          	addi	a1,s0,-20
    8000206c:	4501                	li	a0,0
    8000206e:	f2bff0ef          	jal	80001f98 <argint>
  exit(n);
    80002072:	fec42503          	lw	a0,-20(s0)
    80002076:	b7aff0ef          	jal	800013f0 <exit>
  return 0;  // not reached
}
    8000207a:	4501                	li	a0,0
    8000207c:	60e2                	ld	ra,24(sp)
    8000207e:	6442                	ld	s0,16(sp)
    80002080:	6105                	addi	sp,sp,32
    80002082:	8082                	ret

0000000080002084 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002084:	1141                	addi	sp,sp,-16
    80002086:	e406                	sd	ra,8(sp)
    80002088:	e022                	sd	s0,0(sp)
    8000208a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000208c:	d49fe0ef          	jal	80000dd4 <myproc>
}
    80002090:	5908                	lw	a0,48(a0)
    80002092:	60a2                	ld	ra,8(sp)
    80002094:	6402                	ld	s0,0(sp)
    80002096:	0141                	addi	sp,sp,16
    80002098:	8082                	ret

000000008000209a <sys_fork>:

uint64
sys_fork(void)
{
    8000209a:	1141                	addi	sp,sp,-16
    8000209c:	e406                	sd	ra,8(sp)
    8000209e:	e022                	sd	s0,0(sp)
    800020a0:	0800                	addi	s0,sp,16
  return fork();
    800020a2:	854ff0ef          	jal	800010f6 <fork>
}
    800020a6:	60a2                	ld	ra,8(sp)
    800020a8:	6402                	ld	s0,0(sp)
    800020aa:	0141                	addi	sp,sp,16
    800020ac:	8082                	ret

00000000800020ae <sys_wait>:

uint64
sys_wait(void)
{
    800020ae:	1101                	addi	sp,sp,-32
    800020b0:	ec06                	sd	ra,24(sp)
    800020b2:	e822                	sd	s0,16(sp)
    800020b4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020b6:	fe840593          	addi	a1,s0,-24
    800020ba:	4501                	li	a0,0
    800020bc:	efbff0ef          	jal	80001fb6 <argaddr>
  return wait(p);
    800020c0:	fe843503          	ld	a0,-24(s0)
    800020c4:	f12ff0ef          	jal	800017d6 <wait>
}
    800020c8:	60e2                	ld	ra,24(sp)
    800020ca:	6442                	ld	s0,16(sp)
    800020cc:	6105                	addi	sp,sp,32
    800020ce:	8082                	ret

00000000800020d0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020d0:	7179                	addi	sp,sp,-48
    800020d2:	f406                	sd	ra,40(sp)
    800020d4:	f022                	sd	s0,32(sp)
    800020d6:	ec26                	sd	s1,24(sp)
    800020d8:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020da:	fdc40593          	addi	a1,s0,-36
    800020de:	4501                	li	a0,0
    800020e0:	eb9ff0ef          	jal	80001f98 <argint>
  addr = myproc()->sz;
    800020e4:	cf1fe0ef          	jal	80000dd4 <myproc>
    800020e8:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800020ea:	fdc42503          	lw	a0,-36(s0)
    800020ee:	fb9fe0ef          	jal	800010a6 <growproc>
    800020f2:	00054863          	bltz	a0,80002102 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    800020f6:	8526                	mv	a0,s1
    800020f8:	70a2                	ld	ra,40(sp)
    800020fa:	7402                	ld	s0,32(sp)
    800020fc:	64e2                	ld	s1,24(sp)
    800020fe:	6145                	addi	sp,sp,48
    80002100:	8082                	ret
    return -1;
    80002102:	54fd                	li	s1,-1
    80002104:	bfcd                	j	800020f6 <sys_sbrk+0x26>

0000000080002106 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002106:	7139                	addi	sp,sp,-64
    80002108:	fc06                	sd	ra,56(sp)
    8000210a:	f822                	sd	s0,48(sp)
    8000210c:	f04a                	sd	s2,32(sp)
    8000210e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002110:	fcc40593          	addi	a1,s0,-52
    80002114:	4501                	li	a0,0
    80002116:	e83ff0ef          	jal	80001f98 <argint>
  if(n < 0)
    8000211a:	fcc42783          	lw	a5,-52(s0)
    8000211e:	0607c763          	bltz	a5,8000218c <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002122:	00013517          	auipc	a0,0x13
    80002126:	66e50513          	addi	a0,a0,1646 # 80015790 <tickslock>
    8000212a:	567030ef          	jal	80005e90 <acquire>
  ticks0 = ticks;
    8000212e:	00005917          	auipc	s2,0x5
    80002132:	7fa92903          	lw	s2,2042(s2) # 80007928 <ticks>
  while(ticks - ticks0 < n){
    80002136:	fcc42783          	lw	a5,-52(s0)
    8000213a:	cf8d                	beqz	a5,80002174 <sys_sleep+0x6e>
    8000213c:	f426                	sd	s1,40(sp)
    8000213e:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002140:	00013997          	auipc	s3,0x13
    80002144:	65098993          	addi	s3,s3,1616 # 80015790 <tickslock>
    80002148:	00005497          	auipc	s1,0x5
    8000214c:	7e048493          	addi	s1,s1,2016 # 80007928 <ticks>
    if(killed(myproc())){
    80002150:	c85fe0ef          	jal	80000dd4 <myproc>
    80002154:	e58ff0ef          	jal	800017ac <killed>
    80002158:	ed0d                	bnez	a0,80002192 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    8000215a:	85ce                	mv	a1,s3
    8000215c:	8526                	mv	a0,s1
    8000215e:	d0aff0ef          	jal	80001668 <sleep>
  while(ticks - ticks0 < n){
    80002162:	409c                	lw	a5,0(s1)
    80002164:	412787bb          	subw	a5,a5,s2
    80002168:	fcc42703          	lw	a4,-52(s0)
    8000216c:	fee7e2e3          	bltu	a5,a4,80002150 <sys_sleep+0x4a>
    80002170:	74a2                	ld	s1,40(sp)
    80002172:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002174:	00013517          	auipc	a0,0x13
    80002178:	61c50513          	addi	a0,a0,1564 # 80015790 <tickslock>
    8000217c:	5ad030ef          	jal	80005f28 <release>
  return 0;
    80002180:	4501                	li	a0,0
}
    80002182:	70e2                	ld	ra,56(sp)
    80002184:	7442                	ld	s0,48(sp)
    80002186:	7902                	ld	s2,32(sp)
    80002188:	6121                	addi	sp,sp,64
    8000218a:	8082                	ret
    n = 0;
    8000218c:	fc042623          	sw	zero,-52(s0)
    80002190:	bf49                	j	80002122 <sys_sleep+0x1c>
      release(&tickslock);
    80002192:	00013517          	auipc	a0,0x13
    80002196:	5fe50513          	addi	a0,a0,1534 # 80015790 <tickslock>
    8000219a:	58f030ef          	jal	80005f28 <release>
      return -1;
    8000219e:	557d                	li	a0,-1
    800021a0:	74a2                	ld	s1,40(sp)
    800021a2:	69e2                	ld	s3,24(sp)
    800021a4:	bff9                	j	80002182 <sys_sleep+0x7c>

00000000800021a6 <sys_kill>:

uint64
sys_kill(void)
{
    800021a6:	1101                	addi	sp,sp,-32
    800021a8:	ec06                	sd	ra,24(sp)
    800021aa:	e822                	sd	s0,16(sp)
    800021ac:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021ae:	fec40593          	addi	a1,s0,-20
    800021b2:	4501                	li	a0,0
    800021b4:	de5ff0ef          	jal	80001f98 <argint>
  return kill(pid);
    800021b8:	fec42503          	lw	a0,-20(s0)
    800021bc:	d66ff0ef          	jal	80001722 <kill>
}
    800021c0:	60e2                	ld	ra,24(sp)
    800021c2:	6442                	ld	s0,16(sp)
    800021c4:	6105                	addi	sp,sp,32
    800021c6:	8082                	ret

00000000800021c8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021c8:	1101                	addi	sp,sp,-32
    800021ca:	ec06                	sd	ra,24(sp)
    800021cc:	e822                	sd	s0,16(sp)
    800021ce:	e426                	sd	s1,8(sp)
    800021d0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021d2:	00013517          	auipc	a0,0x13
    800021d6:	5be50513          	addi	a0,a0,1470 # 80015790 <tickslock>
    800021da:	4b7030ef          	jal	80005e90 <acquire>
  xticks = ticks;
    800021de:	00005497          	auipc	s1,0x5
    800021e2:	74a4a483          	lw	s1,1866(s1) # 80007928 <ticks>
  release(&tickslock);
    800021e6:	00013517          	auipc	a0,0x13
    800021ea:	5aa50513          	addi	a0,a0,1450 # 80015790 <tickslock>
    800021ee:	53b030ef          	jal	80005f28 <release>
  return xticks;
}
    800021f2:	02049513          	slli	a0,s1,0x20
    800021f6:	9101                	srli	a0,a0,0x20
    800021f8:	60e2                	ld	ra,24(sp)
    800021fa:	6442                	ld	s0,16(sp)
    800021fc:	64a2                	ld	s1,8(sp)
    800021fe:	6105                	addi	sp,sp,32
    80002200:	8082                	ret

0000000080002202 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002202:	7179                	addi	sp,sp,-48
    80002204:	f406                	sd	ra,40(sp)
    80002206:	f022                	sd	s0,32(sp)
    80002208:	ec26                	sd	s1,24(sp)
    8000220a:	e84a                	sd	s2,16(sp)
    8000220c:	e44e                	sd	s3,8(sp)
    8000220e:	e052                	sd	s4,0(sp)
    80002210:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002212:	00005597          	auipc	a1,0x5
    80002216:	1a658593          	addi	a1,a1,422 # 800073b8 <etext+0x3b8>
    8000221a:	00013517          	auipc	a0,0x13
    8000221e:	58e50513          	addi	a0,a0,1422 # 800157a8 <bcache>
    80002222:	3ef030ef          	jal	80005e10 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002226:	0001b797          	auipc	a5,0x1b
    8000222a:	58278793          	addi	a5,a5,1410 # 8001d7a8 <bcache+0x8000>
    8000222e:	0001b717          	auipc	a4,0x1b
    80002232:	7e270713          	addi	a4,a4,2018 # 8001da10 <bcache+0x8268>
    80002236:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000223a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000223e:	00013497          	auipc	s1,0x13
    80002242:	58248493          	addi	s1,s1,1410 # 800157c0 <bcache+0x18>
    b->next = bcache.head.next;
    80002246:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002248:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000224a:	00005a17          	auipc	s4,0x5
    8000224e:	176a0a13          	addi	s4,s4,374 # 800073c0 <etext+0x3c0>
    b->next = bcache.head.next;
    80002252:	2b893783          	ld	a5,696(s2)
    80002256:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002258:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000225c:	85d2                	mv	a1,s4
    8000225e:	01048513          	addi	a0,s1,16
    80002262:	248010ef          	jal	800034aa <initsleeplock>
    bcache.head.next->prev = b;
    80002266:	2b893783          	ld	a5,696(s2)
    8000226a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000226c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002270:	45848493          	addi	s1,s1,1112
    80002274:	fd349fe3          	bne	s1,s3,80002252 <binit+0x50>
  }
}
    80002278:	70a2                	ld	ra,40(sp)
    8000227a:	7402                	ld	s0,32(sp)
    8000227c:	64e2                	ld	s1,24(sp)
    8000227e:	6942                	ld	s2,16(sp)
    80002280:	69a2                	ld	s3,8(sp)
    80002282:	6a02                	ld	s4,0(sp)
    80002284:	6145                	addi	sp,sp,48
    80002286:	8082                	ret

0000000080002288 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002288:	7179                	addi	sp,sp,-48
    8000228a:	f406                	sd	ra,40(sp)
    8000228c:	f022                	sd	s0,32(sp)
    8000228e:	ec26                	sd	s1,24(sp)
    80002290:	e84a                	sd	s2,16(sp)
    80002292:	e44e                	sd	s3,8(sp)
    80002294:	1800                	addi	s0,sp,48
    80002296:	892a                	mv	s2,a0
    80002298:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000229a:	00013517          	auipc	a0,0x13
    8000229e:	50e50513          	addi	a0,a0,1294 # 800157a8 <bcache>
    800022a2:	3ef030ef          	jal	80005e90 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022a6:	0001b497          	auipc	s1,0x1b
    800022aa:	7ba4b483          	ld	s1,1978(s1) # 8001da60 <bcache+0x82b8>
    800022ae:	0001b797          	auipc	a5,0x1b
    800022b2:	76278793          	addi	a5,a5,1890 # 8001da10 <bcache+0x8268>
    800022b6:	02f48b63          	beq	s1,a5,800022ec <bread+0x64>
    800022ba:	873e                	mv	a4,a5
    800022bc:	a021                	j	800022c4 <bread+0x3c>
    800022be:	68a4                	ld	s1,80(s1)
    800022c0:	02e48663          	beq	s1,a4,800022ec <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800022c4:	449c                	lw	a5,8(s1)
    800022c6:	ff279ce3          	bne	a5,s2,800022be <bread+0x36>
    800022ca:	44dc                	lw	a5,12(s1)
    800022cc:	ff3799e3          	bne	a5,s3,800022be <bread+0x36>
      b->refcnt++;
    800022d0:	40bc                	lw	a5,64(s1)
    800022d2:	2785                	addiw	a5,a5,1
    800022d4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022d6:	00013517          	auipc	a0,0x13
    800022da:	4d250513          	addi	a0,a0,1234 # 800157a8 <bcache>
    800022de:	44b030ef          	jal	80005f28 <release>
      acquiresleep(&b->lock);
    800022e2:	01048513          	addi	a0,s1,16
    800022e6:	1fa010ef          	jal	800034e0 <acquiresleep>
      return b;
    800022ea:	a889                	j	8000233c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022ec:	0001b497          	auipc	s1,0x1b
    800022f0:	76c4b483          	ld	s1,1900(s1) # 8001da58 <bcache+0x82b0>
    800022f4:	0001b797          	auipc	a5,0x1b
    800022f8:	71c78793          	addi	a5,a5,1820 # 8001da10 <bcache+0x8268>
    800022fc:	00f48863          	beq	s1,a5,8000230c <bread+0x84>
    80002300:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002302:	40bc                	lw	a5,64(s1)
    80002304:	cb91                	beqz	a5,80002318 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002306:	64a4                	ld	s1,72(s1)
    80002308:	fee49de3          	bne	s1,a4,80002302 <bread+0x7a>
  panic("bget: no buffers");
    8000230c:	00005517          	auipc	a0,0x5
    80002310:	0bc50513          	addi	a0,a0,188 # 800073c8 <etext+0x3c8>
    80002314:	04f030ef          	jal	80005b62 <panic>
      b->dev = dev;
    80002318:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000231c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002320:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002324:	4785                	li	a5,1
    80002326:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002328:	00013517          	auipc	a0,0x13
    8000232c:	48050513          	addi	a0,a0,1152 # 800157a8 <bcache>
    80002330:	3f9030ef          	jal	80005f28 <release>
      acquiresleep(&b->lock);
    80002334:	01048513          	addi	a0,s1,16
    80002338:	1a8010ef          	jal	800034e0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000233c:	409c                	lw	a5,0(s1)
    8000233e:	cb89                	beqz	a5,80002350 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002340:	8526                	mv	a0,s1
    80002342:	70a2                	ld	ra,40(sp)
    80002344:	7402                	ld	s0,32(sp)
    80002346:	64e2                	ld	s1,24(sp)
    80002348:	6942                	ld	s2,16(sp)
    8000234a:	69a2                	ld	s3,8(sp)
    8000234c:	6145                	addi	sp,sp,48
    8000234e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002350:	4581                	li	a1,0
    80002352:	8526                	mv	a0,s1
    80002354:	5dd020ef          	jal	80005130 <virtio_disk_rw>
    b->valid = 1;
    80002358:	4785                	li	a5,1
    8000235a:	c09c                	sw	a5,0(s1)
  return b;
    8000235c:	b7d5                	j	80002340 <bread+0xb8>

000000008000235e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000235e:	1101                	addi	sp,sp,-32
    80002360:	ec06                	sd	ra,24(sp)
    80002362:	e822                	sd	s0,16(sp)
    80002364:	e426                	sd	s1,8(sp)
    80002366:	1000                	addi	s0,sp,32
    80002368:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000236a:	0541                	addi	a0,a0,16
    8000236c:	1f2010ef          	jal	8000355e <holdingsleep>
    80002370:	c911                	beqz	a0,80002384 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002372:	4585                	li	a1,1
    80002374:	8526                	mv	a0,s1
    80002376:	5bb020ef          	jal	80005130 <virtio_disk_rw>
}
    8000237a:	60e2                	ld	ra,24(sp)
    8000237c:	6442                	ld	s0,16(sp)
    8000237e:	64a2                	ld	s1,8(sp)
    80002380:	6105                	addi	sp,sp,32
    80002382:	8082                	ret
    panic("bwrite");
    80002384:	00005517          	auipc	a0,0x5
    80002388:	05c50513          	addi	a0,a0,92 # 800073e0 <etext+0x3e0>
    8000238c:	7d6030ef          	jal	80005b62 <panic>

0000000080002390 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002390:	1101                	addi	sp,sp,-32
    80002392:	ec06                	sd	ra,24(sp)
    80002394:	e822                	sd	s0,16(sp)
    80002396:	e426                	sd	s1,8(sp)
    80002398:	e04a                	sd	s2,0(sp)
    8000239a:	1000                	addi	s0,sp,32
    8000239c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000239e:	01050913          	addi	s2,a0,16
    800023a2:	854a                	mv	a0,s2
    800023a4:	1ba010ef          	jal	8000355e <holdingsleep>
    800023a8:	c135                	beqz	a0,8000240c <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800023aa:	854a                	mv	a0,s2
    800023ac:	17a010ef          	jal	80003526 <releasesleep>

  acquire(&bcache.lock);
    800023b0:	00013517          	auipc	a0,0x13
    800023b4:	3f850513          	addi	a0,a0,1016 # 800157a8 <bcache>
    800023b8:	2d9030ef          	jal	80005e90 <acquire>
  b->refcnt--;
    800023bc:	40bc                	lw	a5,64(s1)
    800023be:	37fd                	addiw	a5,a5,-1
    800023c0:	0007871b          	sext.w	a4,a5
    800023c4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023c6:	e71d                	bnez	a4,800023f4 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800023c8:	68b8                	ld	a4,80(s1)
    800023ca:	64bc                	ld	a5,72(s1)
    800023cc:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800023ce:	68b8                	ld	a4,80(s1)
    800023d0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800023d2:	0001b797          	auipc	a5,0x1b
    800023d6:	3d678793          	addi	a5,a5,982 # 8001d7a8 <bcache+0x8000>
    800023da:	2b87b703          	ld	a4,696(a5)
    800023de:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800023e0:	0001b717          	auipc	a4,0x1b
    800023e4:	63070713          	addi	a4,a4,1584 # 8001da10 <bcache+0x8268>
    800023e8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800023ea:	2b87b703          	ld	a4,696(a5)
    800023ee:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800023f0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800023f4:	00013517          	auipc	a0,0x13
    800023f8:	3b450513          	addi	a0,a0,948 # 800157a8 <bcache>
    800023fc:	32d030ef          	jal	80005f28 <release>
}
    80002400:	60e2                	ld	ra,24(sp)
    80002402:	6442                	ld	s0,16(sp)
    80002404:	64a2                	ld	s1,8(sp)
    80002406:	6902                	ld	s2,0(sp)
    80002408:	6105                	addi	sp,sp,32
    8000240a:	8082                	ret
    panic("brelse");
    8000240c:	00005517          	auipc	a0,0x5
    80002410:	fdc50513          	addi	a0,a0,-36 # 800073e8 <etext+0x3e8>
    80002414:	74e030ef          	jal	80005b62 <panic>

0000000080002418 <bpin>:

void
bpin(struct buf *b) {
    80002418:	1101                	addi	sp,sp,-32
    8000241a:	ec06                	sd	ra,24(sp)
    8000241c:	e822                	sd	s0,16(sp)
    8000241e:	e426                	sd	s1,8(sp)
    80002420:	1000                	addi	s0,sp,32
    80002422:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002424:	00013517          	auipc	a0,0x13
    80002428:	38450513          	addi	a0,a0,900 # 800157a8 <bcache>
    8000242c:	265030ef          	jal	80005e90 <acquire>
  b->refcnt++;
    80002430:	40bc                	lw	a5,64(s1)
    80002432:	2785                	addiw	a5,a5,1
    80002434:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002436:	00013517          	auipc	a0,0x13
    8000243a:	37250513          	addi	a0,a0,882 # 800157a8 <bcache>
    8000243e:	2eb030ef          	jal	80005f28 <release>
}
    80002442:	60e2                	ld	ra,24(sp)
    80002444:	6442                	ld	s0,16(sp)
    80002446:	64a2                	ld	s1,8(sp)
    80002448:	6105                	addi	sp,sp,32
    8000244a:	8082                	ret

000000008000244c <bunpin>:

void
bunpin(struct buf *b) {
    8000244c:	1101                	addi	sp,sp,-32
    8000244e:	ec06                	sd	ra,24(sp)
    80002450:	e822                	sd	s0,16(sp)
    80002452:	e426                	sd	s1,8(sp)
    80002454:	1000                	addi	s0,sp,32
    80002456:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002458:	00013517          	auipc	a0,0x13
    8000245c:	35050513          	addi	a0,a0,848 # 800157a8 <bcache>
    80002460:	231030ef          	jal	80005e90 <acquire>
  b->refcnt--;
    80002464:	40bc                	lw	a5,64(s1)
    80002466:	37fd                	addiw	a5,a5,-1
    80002468:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000246a:	00013517          	auipc	a0,0x13
    8000246e:	33e50513          	addi	a0,a0,830 # 800157a8 <bcache>
    80002472:	2b7030ef          	jal	80005f28 <release>
    80002476:	60e2                	ld	ra,24(sp)
    80002478:	6442                	ld	s0,16(sp)
    8000247a:	64a2                	ld	s1,8(sp)
    8000247c:	6105                	addi	sp,sp,32
    8000247e:	8082                	ret

0000000080002480 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002480:	1101                	addi	sp,sp,-32
    80002482:	ec06                	sd	ra,24(sp)
    80002484:	e822                	sd	s0,16(sp)
    80002486:	e426                	sd	s1,8(sp)
    80002488:	e04a                	sd	s2,0(sp)
    8000248a:	1000                	addi	s0,sp,32
    8000248c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000248e:	00d5d59b          	srliw	a1,a1,0xd
    80002492:	0001c797          	auipc	a5,0x1c
    80002496:	9f27a783          	lw	a5,-1550(a5) # 8001de84 <sb+0x1c>
    8000249a:	9dbd                	addw	a1,a1,a5
    8000249c:	dedff0ef          	jal	80002288 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024a0:	0074f713          	andi	a4,s1,7
    800024a4:	4785                	li	a5,1
    800024a6:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800024aa:	14ce                	slli	s1,s1,0x33
    800024ac:	90d9                	srli	s1,s1,0x36
    800024ae:	00950733          	add	a4,a0,s1
    800024b2:	05874703          	lbu	a4,88(a4)
    800024b6:	00e7f6b3          	and	a3,a5,a4
    800024ba:	c29d                	beqz	a3,800024e0 <bfree+0x60>
    800024bc:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800024be:	94aa                	add	s1,s1,a0
    800024c0:	fff7c793          	not	a5,a5
    800024c4:	8f7d                	and	a4,a4,a5
    800024c6:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800024ca:	711000ef          	jal	800033da <log_write>
  brelse(bp);
    800024ce:	854a                	mv	a0,s2
    800024d0:	ec1ff0ef          	jal	80002390 <brelse>
}
    800024d4:	60e2                	ld	ra,24(sp)
    800024d6:	6442                	ld	s0,16(sp)
    800024d8:	64a2                	ld	s1,8(sp)
    800024da:	6902                	ld	s2,0(sp)
    800024dc:	6105                	addi	sp,sp,32
    800024de:	8082                	ret
    panic("freeing free block");
    800024e0:	00005517          	auipc	a0,0x5
    800024e4:	f1050513          	addi	a0,a0,-240 # 800073f0 <etext+0x3f0>
    800024e8:	67a030ef          	jal	80005b62 <panic>

00000000800024ec <balloc>:
{
    800024ec:	711d                	addi	sp,sp,-96
    800024ee:	ec86                	sd	ra,88(sp)
    800024f0:	e8a2                	sd	s0,80(sp)
    800024f2:	e4a6                	sd	s1,72(sp)
    800024f4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800024f6:	0001c797          	auipc	a5,0x1c
    800024fa:	9767a783          	lw	a5,-1674(a5) # 8001de6c <sb+0x4>
    800024fe:	0e078f63          	beqz	a5,800025fc <balloc+0x110>
    80002502:	e0ca                	sd	s2,64(sp)
    80002504:	fc4e                	sd	s3,56(sp)
    80002506:	f852                	sd	s4,48(sp)
    80002508:	f456                	sd	s5,40(sp)
    8000250a:	f05a                	sd	s6,32(sp)
    8000250c:	ec5e                	sd	s7,24(sp)
    8000250e:	e862                	sd	s8,16(sp)
    80002510:	e466                	sd	s9,8(sp)
    80002512:	8baa                	mv	s7,a0
    80002514:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002516:	0001cb17          	auipc	s6,0x1c
    8000251a:	952b0b13          	addi	s6,s6,-1710 # 8001de68 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000251e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002520:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002522:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002524:	6c89                	lui	s9,0x2
    80002526:	a0b5                	j	80002592 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002528:	97ca                	add	a5,a5,s2
    8000252a:	8e55                	or	a2,a2,a3
    8000252c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002530:	854a                	mv	a0,s2
    80002532:	6a9000ef          	jal	800033da <log_write>
        brelse(bp);
    80002536:	854a                	mv	a0,s2
    80002538:	e59ff0ef          	jal	80002390 <brelse>
  bp = bread(dev, bno);
    8000253c:	85a6                	mv	a1,s1
    8000253e:	855e                	mv	a0,s7
    80002540:	d49ff0ef          	jal	80002288 <bread>
    80002544:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002546:	40000613          	li	a2,1024
    8000254a:	4581                	li	a1,0
    8000254c:	05850513          	addi	a0,a0,88
    80002550:	bfffd0ef          	jal	8000014e <memset>
  log_write(bp);
    80002554:	854a                	mv	a0,s2
    80002556:	685000ef          	jal	800033da <log_write>
  brelse(bp);
    8000255a:	854a                	mv	a0,s2
    8000255c:	e35ff0ef          	jal	80002390 <brelse>
}
    80002560:	6906                	ld	s2,64(sp)
    80002562:	79e2                	ld	s3,56(sp)
    80002564:	7a42                	ld	s4,48(sp)
    80002566:	7aa2                	ld	s5,40(sp)
    80002568:	7b02                	ld	s6,32(sp)
    8000256a:	6be2                	ld	s7,24(sp)
    8000256c:	6c42                	ld	s8,16(sp)
    8000256e:	6ca2                	ld	s9,8(sp)
}
    80002570:	8526                	mv	a0,s1
    80002572:	60e6                	ld	ra,88(sp)
    80002574:	6446                	ld	s0,80(sp)
    80002576:	64a6                	ld	s1,72(sp)
    80002578:	6125                	addi	sp,sp,96
    8000257a:	8082                	ret
    brelse(bp);
    8000257c:	854a                	mv	a0,s2
    8000257e:	e13ff0ef          	jal	80002390 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002582:	015c87bb          	addw	a5,s9,s5
    80002586:	00078a9b          	sext.w	s5,a5
    8000258a:	004b2703          	lw	a4,4(s6)
    8000258e:	04eaff63          	bgeu	s5,a4,800025ec <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002592:	41fad79b          	sraiw	a5,s5,0x1f
    80002596:	0137d79b          	srliw	a5,a5,0x13
    8000259a:	015787bb          	addw	a5,a5,s5
    8000259e:	40d7d79b          	sraiw	a5,a5,0xd
    800025a2:	01cb2583          	lw	a1,28(s6)
    800025a6:	9dbd                	addw	a1,a1,a5
    800025a8:	855e                	mv	a0,s7
    800025aa:	cdfff0ef          	jal	80002288 <bread>
    800025ae:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025b0:	004b2503          	lw	a0,4(s6)
    800025b4:	000a849b          	sext.w	s1,s5
    800025b8:	8762                	mv	a4,s8
    800025ba:	fca4f1e3          	bgeu	s1,a0,8000257c <balloc+0x90>
      m = 1 << (bi % 8);
    800025be:	00777693          	andi	a3,a4,7
    800025c2:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025c6:	41f7579b          	sraiw	a5,a4,0x1f
    800025ca:	01d7d79b          	srliw	a5,a5,0x1d
    800025ce:	9fb9                	addw	a5,a5,a4
    800025d0:	4037d79b          	sraiw	a5,a5,0x3
    800025d4:	00f90633          	add	a2,s2,a5
    800025d8:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    800025dc:	00c6f5b3          	and	a1,a3,a2
    800025e0:	d5a1                	beqz	a1,80002528 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025e2:	2705                	addiw	a4,a4,1
    800025e4:	2485                	addiw	s1,s1,1
    800025e6:	fd471ae3          	bne	a4,s4,800025ba <balloc+0xce>
    800025ea:	bf49                	j	8000257c <balloc+0x90>
    800025ec:	6906                	ld	s2,64(sp)
    800025ee:	79e2                	ld	s3,56(sp)
    800025f0:	7a42                	ld	s4,48(sp)
    800025f2:	7aa2                	ld	s5,40(sp)
    800025f4:	7b02                	ld	s6,32(sp)
    800025f6:	6be2                	ld	s7,24(sp)
    800025f8:	6c42                	ld	s8,16(sp)
    800025fa:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800025fc:	00005517          	auipc	a0,0x5
    80002600:	e0c50513          	addi	a0,a0,-500 # 80007408 <etext+0x408>
    80002604:	28c030ef          	jal	80005890 <printf>
  return 0;
    80002608:	4481                	li	s1,0
    8000260a:	b79d                	j	80002570 <balloc+0x84>

000000008000260c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000260c:	7179                	addi	sp,sp,-48
    8000260e:	f406                	sd	ra,40(sp)
    80002610:	f022                	sd	s0,32(sp)
    80002612:	ec26                	sd	s1,24(sp)
    80002614:	e84a                	sd	s2,16(sp)
    80002616:	e44e                	sd	s3,8(sp)
    80002618:	1800                	addi	s0,sp,48
    8000261a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000261c:	47ad                	li	a5,11
    8000261e:	02b7e663          	bltu	a5,a1,8000264a <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002622:	02059793          	slli	a5,a1,0x20
    80002626:	01e7d593          	srli	a1,a5,0x1e
    8000262a:	00b504b3          	add	s1,a0,a1
    8000262e:	0504a903          	lw	s2,80(s1)
    80002632:	06091a63          	bnez	s2,800026a6 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002636:	4108                	lw	a0,0(a0)
    80002638:	eb5ff0ef          	jal	800024ec <balloc>
    8000263c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002640:	06090363          	beqz	s2,800026a6 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002644:	0524a823          	sw	s2,80(s1)
    80002648:	a8b9                	j	800026a6 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000264a:	ff45849b          	addiw	s1,a1,-12
    8000264e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002652:	0ff00793          	li	a5,255
    80002656:	06e7ee63          	bltu	a5,a4,800026d2 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000265a:	08052903          	lw	s2,128(a0)
    8000265e:	00091d63          	bnez	s2,80002678 <bmap+0x6c>
      addr = balloc(ip->dev);
    80002662:	4108                	lw	a0,0(a0)
    80002664:	e89ff0ef          	jal	800024ec <balloc>
    80002668:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000266c:	02090d63          	beqz	s2,800026a6 <bmap+0x9a>
    80002670:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002672:	0929a023          	sw	s2,128(s3)
    80002676:	a011                	j	8000267a <bmap+0x6e>
    80002678:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000267a:	85ca                	mv	a1,s2
    8000267c:	0009a503          	lw	a0,0(s3)
    80002680:	c09ff0ef          	jal	80002288 <bread>
    80002684:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002686:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000268a:	02049713          	slli	a4,s1,0x20
    8000268e:	01e75593          	srli	a1,a4,0x1e
    80002692:	00b784b3          	add	s1,a5,a1
    80002696:	0004a903          	lw	s2,0(s1)
    8000269a:	00090e63          	beqz	s2,800026b6 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000269e:	8552                	mv	a0,s4
    800026a0:	cf1ff0ef          	jal	80002390 <brelse>
    return addr;
    800026a4:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800026a6:	854a                	mv	a0,s2
    800026a8:	70a2                	ld	ra,40(sp)
    800026aa:	7402                	ld	s0,32(sp)
    800026ac:	64e2                	ld	s1,24(sp)
    800026ae:	6942                	ld	s2,16(sp)
    800026b0:	69a2                	ld	s3,8(sp)
    800026b2:	6145                	addi	sp,sp,48
    800026b4:	8082                	ret
      addr = balloc(ip->dev);
    800026b6:	0009a503          	lw	a0,0(s3)
    800026ba:	e33ff0ef          	jal	800024ec <balloc>
    800026be:	0005091b          	sext.w	s2,a0
      if(addr){
    800026c2:	fc090ee3          	beqz	s2,8000269e <bmap+0x92>
        a[bn] = addr;
    800026c6:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800026ca:	8552                	mv	a0,s4
    800026cc:	50f000ef          	jal	800033da <log_write>
    800026d0:	b7f9                	j	8000269e <bmap+0x92>
    800026d2:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800026d4:	00005517          	auipc	a0,0x5
    800026d8:	d4c50513          	addi	a0,a0,-692 # 80007420 <etext+0x420>
    800026dc:	486030ef          	jal	80005b62 <panic>

00000000800026e0 <iget>:
{
    800026e0:	7179                	addi	sp,sp,-48
    800026e2:	f406                	sd	ra,40(sp)
    800026e4:	f022                	sd	s0,32(sp)
    800026e6:	ec26                	sd	s1,24(sp)
    800026e8:	e84a                	sd	s2,16(sp)
    800026ea:	e44e                	sd	s3,8(sp)
    800026ec:	e052                	sd	s4,0(sp)
    800026ee:	1800                	addi	s0,sp,48
    800026f0:	89aa                	mv	s3,a0
    800026f2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800026f4:	0001b517          	auipc	a0,0x1b
    800026f8:	79450513          	addi	a0,a0,1940 # 8001de88 <itable>
    800026fc:	794030ef          	jal	80005e90 <acquire>
  empty = 0;
    80002700:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002702:	0001b497          	auipc	s1,0x1b
    80002706:	79e48493          	addi	s1,s1,1950 # 8001dea0 <itable+0x18>
    8000270a:	0001d697          	auipc	a3,0x1d
    8000270e:	22668693          	addi	a3,a3,550 # 8001f930 <log>
    80002712:	a039                	j	80002720 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002714:	02090963          	beqz	s2,80002746 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002718:	08848493          	addi	s1,s1,136
    8000271c:	02d48863          	beq	s1,a3,8000274c <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002720:	449c                	lw	a5,8(s1)
    80002722:	fef059e3          	blez	a5,80002714 <iget+0x34>
    80002726:	4098                	lw	a4,0(s1)
    80002728:	ff3716e3          	bne	a4,s3,80002714 <iget+0x34>
    8000272c:	40d8                	lw	a4,4(s1)
    8000272e:	ff4713e3          	bne	a4,s4,80002714 <iget+0x34>
      ip->ref++;
    80002732:	2785                	addiw	a5,a5,1
    80002734:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002736:	0001b517          	auipc	a0,0x1b
    8000273a:	75250513          	addi	a0,a0,1874 # 8001de88 <itable>
    8000273e:	7ea030ef          	jal	80005f28 <release>
      return ip;
    80002742:	8926                	mv	s2,s1
    80002744:	a02d                	j	8000276e <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002746:	fbe9                	bnez	a5,80002718 <iget+0x38>
      empty = ip;
    80002748:	8926                	mv	s2,s1
    8000274a:	b7f9                	j	80002718 <iget+0x38>
  if(empty == 0)
    8000274c:	02090a63          	beqz	s2,80002780 <iget+0xa0>
  ip->dev = dev;
    80002750:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002754:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002758:	4785                	li	a5,1
    8000275a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000275e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002762:	0001b517          	auipc	a0,0x1b
    80002766:	72650513          	addi	a0,a0,1830 # 8001de88 <itable>
    8000276a:	7be030ef          	jal	80005f28 <release>
}
    8000276e:	854a                	mv	a0,s2
    80002770:	70a2                	ld	ra,40(sp)
    80002772:	7402                	ld	s0,32(sp)
    80002774:	64e2                	ld	s1,24(sp)
    80002776:	6942                	ld	s2,16(sp)
    80002778:	69a2                	ld	s3,8(sp)
    8000277a:	6a02                	ld	s4,0(sp)
    8000277c:	6145                	addi	sp,sp,48
    8000277e:	8082                	ret
    panic("iget: no inodes");
    80002780:	00005517          	auipc	a0,0x5
    80002784:	cb850513          	addi	a0,a0,-840 # 80007438 <etext+0x438>
    80002788:	3da030ef          	jal	80005b62 <panic>

000000008000278c <fsinit>:
fsinit(int dev) {
    8000278c:	7179                	addi	sp,sp,-48
    8000278e:	f406                	sd	ra,40(sp)
    80002790:	f022                	sd	s0,32(sp)
    80002792:	ec26                	sd	s1,24(sp)
    80002794:	e84a                	sd	s2,16(sp)
    80002796:	e44e                	sd	s3,8(sp)
    80002798:	1800                	addi	s0,sp,48
    8000279a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000279c:	4585                	li	a1,1
    8000279e:	aebff0ef          	jal	80002288 <bread>
    800027a2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800027a4:	0001b997          	auipc	s3,0x1b
    800027a8:	6c498993          	addi	s3,s3,1732 # 8001de68 <sb>
    800027ac:	02000613          	li	a2,32
    800027b0:	05850593          	addi	a1,a0,88
    800027b4:	854e                	mv	a0,s3
    800027b6:	9f5fd0ef          	jal	800001aa <memmove>
  brelse(bp);
    800027ba:	8526                	mv	a0,s1
    800027bc:	bd5ff0ef          	jal	80002390 <brelse>
  if(sb.magic != FSMAGIC)
    800027c0:	0009a703          	lw	a4,0(s3)
    800027c4:	102037b7          	lui	a5,0x10203
    800027c8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800027cc:	02f71063          	bne	a4,a5,800027ec <fsinit+0x60>
  initlog(dev, &sb);
    800027d0:	0001b597          	auipc	a1,0x1b
    800027d4:	69858593          	addi	a1,a1,1688 # 8001de68 <sb>
    800027d8:	854a                	mv	a0,s2
    800027da:	1f9000ef          	jal	800031d2 <initlog>
}
    800027de:	70a2                	ld	ra,40(sp)
    800027e0:	7402                	ld	s0,32(sp)
    800027e2:	64e2                	ld	s1,24(sp)
    800027e4:	6942                	ld	s2,16(sp)
    800027e6:	69a2                	ld	s3,8(sp)
    800027e8:	6145                	addi	sp,sp,48
    800027ea:	8082                	ret
    panic("invalid file system");
    800027ec:	00005517          	auipc	a0,0x5
    800027f0:	c5c50513          	addi	a0,a0,-932 # 80007448 <etext+0x448>
    800027f4:	36e030ef          	jal	80005b62 <panic>

00000000800027f8 <iinit>:
{
    800027f8:	7179                	addi	sp,sp,-48
    800027fa:	f406                	sd	ra,40(sp)
    800027fc:	f022                	sd	s0,32(sp)
    800027fe:	ec26                	sd	s1,24(sp)
    80002800:	e84a                	sd	s2,16(sp)
    80002802:	e44e                	sd	s3,8(sp)
    80002804:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002806:	00005597          	auipc	a1,0x5
    8000280a:	c5a58593          	addi	a1,a1,-934 # 80007460 <etext+0x460>
    8000280e:	0001b517          	auipc	a0,0x1b
    80002812:	67a50513          	addi	a0,a0,1658 # 8001de88 <itable>
    80002816:	5fa030ef          	jal	80005e10 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000281a:	0001b497          	auipc	s1,0x1b
    8000281e:	69648493          	addi	s1,s1,1686 # 8001deb0 <itable+0x28>
    80002822:	0001d997          	auipc	s3,0x1d
    80002826:	11e98993          	addi	s3,s3,286 # 8001f940 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000282a:	00005917          	auipc	s2,0x5
    8000282e:	c3e90913          	addi	s2,s2,-962 # 80007468 <etext+0x468>
    80002832:	85ca                	mv	a1,s2
    80002834:	8526                	mv	a0,s1
    80002836:	475000ef          	jal	800034aa <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000283a:	08848493          	addi	s1,s1,136
    8000283e:	ff349ae3          	bne	s1,s3,80002832 <iinit+0x3a>
}
    80002842:	70a2                	ld	ra,40(sp)
    80002844:	7402                	ld	s0,32(sp)
    80002846:	64e2                	ld	s1,24(sp)
    80002848:	6942                	ld	s2,16(sp)
    8000284a:	69a2                	ld	s3,8(sp)
    8000284c:	6145                	addi	sp,sp,48
    8000284e:	8082                	ret

0000000080002850 <ialloc>:
{
    80002850:	7139                	addi	sp,sp,-64
    80002852:	fc06                	sd	ra,56(sp)
    80002854:	f822                	sd	s0,48(sp)
    80002856:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002858:	0001b717          	auipc	a4,0x1b
    8000285c:	61c72703          	lw	a4,1564(a4) # 8001de74 <sb+0xc>
    80002860:	4785                	li	a5,1
    80002862:	06e7f063          	bgeu	a5,a4,800028c2 <ialloc+0x72>
    80002866:	f426                	sd	s1,40(sp)
    80002868:	f04a                	sd	s2,32(sp)
    8000286a:	ec4e                	sd	s3,24(sp)
    8000286c:	e852                	sd	s4,16(sp)
    8000286e:	e456                	sd	s5,8(sp)
    80002870:	e05a                	sd	s6,0(sp)
    80002872:	8aaa                	mv	s5,a0
    80002874:	8b2e                	mv	s6,a1
    80002876:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002878:	0001ba17          	auipc	s4,0x1b
    8000287c:	5f0a0a13          	addi	s4,s4,1520 # 8001de68 <sb>
    80002880:	00495593          	srli	a1,s2,0x4
    80002884:	018a2783          	lw	a5,24(s4)
    80002888:	9dbd                	addw	a1,a1,a5
    8000288a:	8556                	mv	a0,s5
    8000288c:	9fdff0ef          	jal	80002288 <bread>
    80002890:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002892:	05850993          	addi	s3,a0,88
    80002896:	00f97793          	andi	a5,s2,15
    8000289a:	079a                	slli	a5,a5,0x6
    8000289c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000289e:	00099783          	lh	a5,0(s3)
    800028a2:	cb9d                	beqz	a5,800028d8 <ialloc+0x88>
    brelse(bp);
    800028a4:	aedff0ef          	jal	80002390 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800028a8:	0905                	addi	s2,s2,1
    800028aa:	00ca2703          	lw	a4,12(s4)
    800028ae:	0009079b          	sext.w	a5,s2
    800028b2:	fce7e7e3          	bltu	a5,a4,80002880 <ialloc+0x30>
    800028b6:	74a2                	ld	s1,40(sp)
    800028b8:	7902                	ld	s2,32(sp)
    800028ba:	69e2                	ld	s3,24(sp)
    800028bc:	6a42                	ld	s4,16(sp)
    800028be:	6aa2                	ld	s5,8(sp)
    800028c0:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800028c2:	00005517          	auipc	a0,0x5
    800028c6:	bae50513          	addi	a0,a0,-1106 # 80007470 <etext+0x470>
    800028ca:	7c7020ef          	jal	80005890 <printf>
  return 0;
    800028ce:	4501                	li	a0,0
}
    800028d0:	70e2                	ld	ra,56(sp)
    800028d2:	7442                	ld	s0,48(sp)
    800028d4:	6121                	addi	sp,sp,64
    800028d6:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800028d8:	04000613          	li	a2,64
    800028dc:	4581                	li	a1,0
    800028de:	854e                	mv	a0,s3
    800028e0:	86ffd0ef          	jal	8000014e <memset>
      dip->type = type;
    800028e4:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800028e8:	8526                	mv	a0,s1
    800028ea:	2f1000ef          	jal	800033da <log_write>
      brelse(bp);
    800028ee:	8526                	mv	a0,s1
    800028f0:	aa1ff0ef          	jal	80002390 <brelse>
      return iget(dev, inum);
    800028f4:	0009059b          	sext.w	a1,s2
    800028f8:	8556                	mv	a0,s5
    800028fa:	de7ff0ef          	jal	800026e0 <iget>
    800028fe:	74a2                	ld	s1,40(sp)
    80002900:	7902                	ld	s2,32(sp)
    80002902:	69e2                	ld	s3,24(sp)
    80002904:	6a42                	ld	s4,16(sp)
    80002906:	6aa2                	ld	s5,8(sp)
    80002908:	6b02                	ld	s6,0(sp)
    8000290a:	b7d9                	j	800028d0 <ialloc+0x80>

000000008000290c <iupdate>:
{
    8000290c:	1101                	addi	sp,sp,-32
    8000290e:	ec06                	sd	ra,24(sp)
    80002910:	e822                	sd	s0,16(sp)
    80002912:	e426                	sd	s1,8(sp)
    80002914:	e04a                	sd	s2,0(sp)
    80002916:	1000                	addi	s0,sp,32
    80002918:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000291a:	415c                	lw	a5,4(a0)
    8000291c:	0047d79b          	srliw	a5,a5,0x4
    80002920:	0001b597          	auipc	a1,0x1b
    80002924:	5605a583          	lw	a1,1376(a1) # 8001de80 <sb+0x18>
    80002928:	9dbd                	addw	a1,a1,a5
    8000292a:	4108                	lw	a0,0(a0)
    8000292c:	95dff0ef          	jal	80002288 <bread>
    80002930:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002932:	05850793          	addi	a5,a0,88
    80002936:	40d8                	lw	a4,4(s1)
    80002938:	8b3d                	andi	a4,a4,15
    8000293a:	071a                	slli	a4,a4,0x6
    8000293c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000293e:	04449703          	lh	a4,68(s1)
    80002942:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002946:	04649703          	lh	a4,70(s1)
    8000294a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000294e:	04849703          	lh	a4,72(s1)
    80002952:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002956:	04a49703          	lh	a4,74(s1)
    8000295a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000295e:	44f8                	lw	a4,76(s1)
    80002960:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002962:	03400613          	li	a2,52
    80002966:	05048593          	addi	a1,s1,80
    8000296a:	00c78513          	addi	a0,a5,12
    8000296e:	83dfd0ef          	jal	800001aa <memmove>
  log_write(bp);
    80002972:	854a                	mv	a0,s2
    80002974:	267000ef          	jal	800033da <log_write>
  brelse(bp);
    80002978:	854a                	mv	a0,s2
    8000297a:	a17ff0ef          	jal	80002390 <brelse>
}
    8000297e:	60e2                	ld	ra,24(sp)
    80002980:	6442                	ld	s0,16(sp)
    80002982:	64a2                	ld	s1,8(sp)
    80002984:	6902                	ld	s2,0(sp)
    80002986:	6105                	addi	sp,sp,32
    80002988:	8082                	ret

000000008000298a <idup>:
{
    8000298a:	1101                	addi	sp,sp,-32
    8000298c:	ec06                	sd	ra,24(sp)
    8000298e:	e822                	sd	s0,16(sp)
    80002990:	e426                	sd	s1,8(sp)
    80002992:	1000                	addi	s0,sp,32
    80002994:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002996:	0001b517          	auipc	a0,0x1b
    8000299a:	4f250513          	addi	a0,a0,1266 # 8001de88 <itable>
    8000299e:	4f2030ef          	jal	80005e90 <acquire>
  ip->ref++;
    800029a2:	449c                	lw	a5,8(s1)
    800029a4:	2785                	addiw	a5,a5,1
    800029a6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800029a8:	0001b517          	auipc	a0,0x1b
    800029ac:	4e050513          	addi	a0,a0,1248 # 8001de88 <itable>
    800029b0:	578030ef          	jal	80005f28 <release>
}
    800029b4:	8526                	mv	a0,s1
    800029b6:	60e2                	ld	ra,24(sp)
    800029b8:	6442                	ld	s0,16(sp)
    800029ba:	64a2                	ld	s1,8(sp)
    800029bc:	6105                	addi	sp,sp,32
    800029be:	8082                	ret

00000000800029c0 <ilock>:
{
    800029c0:	1101                	addi	sp,sp,-32
    800029c2:	ec06                	sd	ra,24(sp)
    800029c4:	e822                	sd	s0,16(sp)
    800029c6:	e426                	sd	s1,8(sp)
    800029c8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800029ca:	cd19                	beqz	a0,800029e8 <ilock+0x28>
    800029cc:	84aa                	mv	s1,a0
    800029ce:	451c                	lw	a5,8(a0)
    800029d0:	00f05c63          	blez	a5,800029e8 <ilock+0x28>
  acquiresleep(&ip->lock);
    800029d4:	0541                	addi	a0,a0,16
    800029d6:	30b000ef          	jal	800034e0 <acquiresleep>
  if(ip->valid == 0){
    800029da:	40bc                	lw	a5,64(s1)
    800029dc:	cf89                	beqz	a5,800029f6 <ilock+0x36>
}
    800029de:	60e2                	ld	ra,24(sp)
    800029e0:	6442                	ld	s0,16(sp)
    800029e2:	64a2                	ld	s1,8(sp)
    800029e4:	6105                	addi	sp,sp,32
    800029e6:	8082                	ret
    800029e8:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800029ea:	00005517          	auipc	a0,0x5
    800029ee:	a9e50513          	addi	a0,a0,-1378 # 80007488 <etext+0x488>
    800029f2:	170030ef          	jal	80005b62 <panic>
    800029f6:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800029f8:	40dc                	lw	a5,4(s1)
    800029fa:	0047d79b          	srliw	a5,a5,0x4
    800029fe:	0001b597          	auipc	a1,0x1b
    80002a02:	4825a583          	lw	a1,1154(a1) # 8001de80 <sb+0x18>
    80002a06:	9dbd                	addw	a1,a1,a5
    80002a08:	4088                	lw	a0,0(s1)
    80002a0a:	87fff0ef          	jal	80002288 <bread>
    80002a0e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a10:	05850593          	addi	a1,a0,88
    80002a14:	40dc                	lw	a5,4(s1)
    80002a16:	8bbd                	andi	a5,a5,15
    80002a18:	079a                	slli	a5,a5,0x6
    80002a1a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002a1c:	00059783          	lh	a5,0(a1)
    80002a20:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002a24:	00259783          	lh	a5,2(a1)
    80002a28:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002a2c:	00459783          	lh	a5,4(a1)
    80002a30:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002a34:	00659783          	lh	a5,6(a1)
    80002a38:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002a3c:	459c                	lw	a5,8(a1)
    80002a3e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002a40:	03400613          	li	a2,52
    80002a44:	05b1                	addi	a1,a1,12
    80002a46:	05048513          	addi	a0,s1,80
    80002a4a:	f60fd0ef          	jal	800001aa <memmove>
    brelse(bp);
    80002a4e:	854a                	mv	a0,s2
    80002a50:	941ff0ef          	jal	80002390 <brelse>
    ip->valid = 1;
    80002a54:	4785                	li	a5,1
    80002a56:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002a58:	04449783          	lh	a5,68(s1)
    80002a5c:	c399                	beqz	a5,80002a62 <ilock+0xa2>
    80002a5e:	6902                	ld	s2,0(sp)
    80002a60:	bfbd                	j	800029de <ilock+0x1e>
      panic("ilock: no type");
    80002a62:	00005517          	auipc	a0,0x5
    80002a66:	a2e50513          	addi	a0,a0,-1490 # 80007490 <etext+0x490>
    80002a6a:	0f8030ef          	jal	80005b62 <panic>

0000000080002a6e <iunlock>:
{
    80002a6e:	1101                	addi	sp,sp,-32
    80002a70:	ec06                	sd	ra,24(sp)
    80002a72:	e822                	sd	s0,16(sp)
    80002a74:	e426                	sd	s1,8(sp)
    80002a76:	e04a                	sd	s2,0(sp)
    80002a78:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002a7a:	c505                	beqz	a0,80002aa2 <iunlock+0x34>
    80002a7c:	84aa                	mv	s1,a0
    80002a7e:	01050913          	addi	s2,a0,16
    80002a82:	854a                	mv	a0,s2
    80002a84:	2db000ef          	jal	8000355e <holdingsleep>
    80002a88:	cd09                	beqz	a0,80002aa2 <iunlock+0x34>
    80002a8a:	449c                	lw	a5,8(s1)
    80002a8c:	00f05b63          	blez	a5,80002aa2 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002a90:	854a                	mv	a0,s2
    80002a92:	295000ef          	jal	80003526 <releasesleep>
}
    80002a96:	60e2                	ld	ra,24(sp)
    80002a98:	6442                	ld	s0,16(sp)
    80002a9a:	64a2                	ld	s1,8(sp)
    80002a9c:	6902                	ld	s2,0(sp)
    80002a9e:	6105                	addi	sp,sp,32
    80002aa0:	8082                	ret
    panic("iunlock");
    80002aa2:	00005517          	auipc	a0,0x5
    80002aa6:	9fe50513          	addi	a0,a0,-1538 # 800074a0 <etext+0x4a0>
    80002aaa:	0b8030ef          	jal	80005b62 <panic>

0000000080002aae <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002aae:	7179                	addi	sp,sp,-48
    80002ab0:	f406                	sd	ra,40(sp)
    80002ab2:	f022                	sd	s0,32(sp)
    80002ab4:	ec26                	sd	s1,24(sp)
    80002ab6:	e84a                	sd	s2,16(sp)
    80002ab8:	e44e                	sd	s3,8(sp)
    80002aba:	1800                	addi	s0,sp,48
    80002abc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002abe:	05050493          	addi	s1,a0,80
    80002ac2:	08050913          	addi	s2,a0,128
    80002ac6:	a021                	j	80002ace <itrunc+0x20>
    80002ac8:	0491                	addi	s1,s1,4
    80002aca:	01248b63          	beq	s1,s2,80002ae0 <itrunc+0x32>
    if(ip->addrs[i]){
    80002ace:	408c                	lw	a1,0(s1)
    80002ad0:	dde5                	beqz	a1,80002ac8 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002ad2:	0009a503          	lw	a0,0(s3)
    80002ad6:	9abff0ef          	jal	80002480 <bfree>
      ip->addrs[i] = 0;
    80002ada:	0004a023          	sw	zero,0(s1)
    80002ade:	b7ed                	j	80002ac8 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ae0:	0809a583          	lw	a1,128(s3)
    80002ae4:	ed89                	bnez	a1,80002afe <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ae6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002aea:	854e                	mv	a0,s3
    80002aec:	e21ff0ef          	jal	8000290c <iupdate>
}
    80002af0:	70a2                	ld	ra,40(sp)
    80002af2:	7402                	ld	s0,32(sp)
    80002af4:	64e2                	ld	s1,24(sp)
    80002af6:	6942                	ld	s2,16(sp)
    80002af8:	69a2                	ld	s3,8(sp)
    80002afa:	6145                	addi	sp,sp,48
    80002afc:	8082                	ret
    80002afe:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002b00:	0009a503          	lw	a0,0(s3)
    80002b04:	f84ff0ef          	jal	80002288 <bread>
    80002b08:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002b0a:	05850493          	addi	s1,a0,88
    80002b0e:	45850913          	addi	s2,a0,1112
    80002b12:	a021                	j	80002b1a <itrunc+0x6c>
    80002b14:	0491                	addi	s1,s1,4
    80002b16:	01248963          	beq	s1,s2,80002b28 <itrunc+0x7a>
      if(a[j])
    80002b1a:	408c                	lw	a1,0(s1)
    80002b1c:	dde5                	beqz	a1,80002b14 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002b1e:	0009a503          	lw	a0,0(s3)
    80002b22:	95fff0ef          	jal	80002480 <bfree>
    80002b26:	b7fd                	j	80002b14 <itrunc+0x66>
    brelse(bp);
    80002b28:	8552                	mv	a0,s4
    80002b2a:	867ff0ef          	jal	80002390 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002b2e:	0809a583          	lw	a1,128(s3)
    80002b32:	0009a503          	lw	a0,0(s3)
    80002b36:	94bff0ef          	jal	80002480 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002b3a:	0809a023          	sw	zero,128(s3)
    80002b3e:	6a02                	ld	s4,0(sp)
    80002b40:	b75d                	j	80002ae6 <itrunc+0x38>

0000000080002b42 <iput>:
{
    80002b42:	1101                	addi	sp,sp,-32
    80002b44:	ec06                	sd	ra,24(sp)
    80002b46:	e822                	sd	s0,16(sp)
    80002b48:	e426                	sd	s1,8(sp)
    80002b4a:	1000                	addi	s0,sp,32
    80002b4c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b4e:	0001b517          	auipc	a0,0x1b
    80002b52:	33a50513          	addi	a0,a0,826 # 8001de88 <itable>
    80002b56:	33a030ef          	jal	80005e90 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002b5a:	4498                	lw	a4,8(s1)
    80002b5c:	4785                	li	a5,1
    80002b5e:	02f70063          	beq	a4,a5,80002b7e <iput+0x3c>
  ip->ref--;
    80002b62:	449c                	lw	a5,8(s1)
    80002b64:	37fd                	addiw	a5,a5,-1
    80002b66:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b68:	0001b517          	auipc	a0,0x1b
    80002b6c:	32050513          	addi	a0,a0,800 # 8001de88 <itable>
    80002b70:	3b8030ef          	jal	80005f28 <release>
}
    80002b74:	60e2                	ld	ra,24(sp)
    80002b76:	6442                	ld	s0,16(sp)
    80002b78:	64a2                	ld	s1,8(sp)
    80002b7a:	6105                	addi	sp,sp,32
    80002b7c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002b7e:	40bc                	lw	a5,64(s1)
    80002b80:	d3ed                	beqz	a5,80002b62 <iput+0x20>
    80002b82:	04a49783          	lh	a5,74(s1)
    80002b86:	fff1                	bnez	a5,80002b62 <iput+0x20>
    80002b88:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002b8a:	01048913          	addi	s2,s1,16
    80002b8e:	854a                	mv	a0,s2
    80002b90:	151000ef          	jal	800034e0 <acquiresleep>
    release(&itable.lock);
    80002b94:	0001b517          	auipc	a0,0x1b
    80002b98:	2f450513          	addi	a0,a0,756 # 8001de88 <itable>
    80002b9c:	38c030ef          	jal	80005f28 <release>
    itrunc(ip);
    80002ba0:	8526                	mv	a0,s1
    80002ba2:	f0dff0ef          	jal	80002aae <itrunc>
    ip->type = 0;
    80002ba6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002baa:	8526                	mv	a0,s1
    80002bac:	d61ff0ef          	jal	8000290c <iupdate>
    ip->valid = 0;
    80002bb0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002bb4:	854a                	mv	a0,s2
    80002bb6:	171000ef          	jal	80003526 <releasesleep>
    acquire(&itable.lock);
    80002bba:	0001b517          	auipc	a0,0x1b
    80002bbe:	2ce50513          	addi	a0,a0,718 # 8001de88 <itable>
    80002bc2:	2ce030ef          	jal	80005e90 <acquire>
    80002bc6:	6902                	ld	s2,0(sp)
    80002bc8:	bf69                	j	80002b62 <iput+0x20>

0000000080002bca <iunlockput>:
{
    80002bca:	1101                	addi	sp,sp,-32
    80002bcc:	ec06                	sd	ra,24(sp)
    80002bce:	e822                	sd	s0,16(sp)
    80002bd0:	e426                	sd	s1,8(sp)
    80002bd2:	1000                	addi	s0,sp,32
    80002bd4:	84aa                	mv	s1,a0
  iunlock(ip);
    80002bd6:	e99ff0ef          	jal	80002a6e <iunlock>
  iput(ip);
    80002bda:	8526                	mv	a0,s1
    80002bdc:	f67ff0ef          	jal	80002b42 <iput>
}
    80002be0:	60e2                	ld	ra,24(sp)
    80002be2:	6442                	ld	s0,16(sp)
    80002be4:	64a2                	ld	s1,8(sp)
    80002be6:	6105                	addi	sp,sp,32
    80002be8:	8082                	ret

0000000080002bea <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002bea:	1141                	addi	sp,sp,-16
    80002bec:	e422                	sd	s0,8(sp)
    80002bee:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002bf0:	411c                	lw	a5,0(a0)
    80002bf2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002bf4:	415c                	lw	a5,4(a0)
    80002bf6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002bf8:	04451783          	lh	a5,68(a0)
    80002bfc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002c00:	04a51783          	lh	a5,74(a0)
    80002c04:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002c08:	04c56783          	lwu	a5,76(a0)
    80002c0c:	e99c                	sd	a5,16(a1)
}
    80002c0e:	6422                	ld	s0,8(sp)
    80002c10:	0141                	addi	sp,sp,16
    80002c12:	8082                	ret

0000000080002c14 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002c14:	457c                	lw	a5,76(a0)
    80002c16:	0ed7eb63          	bltu	a5,a3,80002d0c <readi+0xf8>
{
    80002c1a:	7159                	addi	sp,sp,-112
    80002c1c:	f486                	sd	ra,104(sp)
    80002c1e:	f0a2                	sd	s0,96(sp)
    80002c20:	eca6                	sd	s1,88(sp)
    80002c22:	e0d2                	sd	s4,64(sp)
    80002c24:	fc56                	sd	s5,56(sp)
    80002c26:	f85a                	sd	s6,48(sp)
    80002c28:	f45e                	sd	s7,40(sp)
    80002c2a:	1880                	addi	s0,sp,112
    80002c2c:	8b2a                	mv	s6,a0
    80002c2e:	8bae                	mv	s7,a1
    80002c30:	8a32                	mv	s4,a2
    80002c32:	84b6                	mv	s1,a3
    80002c34:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002c36:	9f35                	addw	a4,a4,a3
    return 0;
    80002c38:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002c3a:	0cd76063          	bltu	a4,a3,80002cfa <readi+0xe6>
    80002c3e:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002c40:	00e7f463          	bgeu	a5,a4,80002c48 <readi+0x34>
    n = ip->size - off;
    80002c44:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002c48:	080a8f63          	beqz	s5,80002ce6 <readi+0xd2>
    80002c4c:	e8ca                	sd	s2,80(sp)
    80002c4e:	f062                	sd	s8,32(sp)
    80002c50:	ec66                	sd	s9,24(sp)
    80002c52:	e86a                	sd	s10,16(sp)
    80002c54:	e46e                	sd	s11,8(sp)
    80002c56:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c58:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002c5c:	5c7d                	li	s8,-1
    80002c5e:	a80d                	j	80002c90 <readi+0x7c>
    80002c60:	020d1d93          	slli	s11,s10,0x20
    80002c64:	020ddd93          	srli	s11,s11,0x20
    80002c68:	05890613          	addi	a2,s2,88
    80002c6c:	86ee                	mv	a3,s11
    80002c6e:	963a                	add	a2,a2,a4
    80002c70:	85d2                	mv	a1,s4
    80002c72:	855e                	mv	a0,s7
    80002c74:	c5dfe0ef          	jal	800018d0 <either_copyout>
    80002c78:	05850763          	beq	a0,s8,80002cc6 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002c7c:	854a                	mv	a0,s2
    80002c7e:	f12ff0ef          	jal	80002390 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002c82:	013d09bb          	addw	s3,s10,s3
    80002c86:	009d04bb          	addw	s1,s10,s1
    80002c8a:	9a6e                	add	s4,s4,s11
    80002c8c:	0559f763          	bgeu	s3,s5,80002cda <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002c90:	00a4d59b          	srliw	a1,s1,0xa
    80002c94:	855a                	mv	a0,s6
    80002c96:	977ff0ef          	jal	8000260c <bmap>
    80002c9a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002c9e:	c5b1                	beqz	a1,80002cea <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002ca0:	000b2503          	lw	a0,0(s6)
    80002ca4:	de4ff0ef          	jal	80002288 <bread>
    80002ca8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002caa:	3ff4f713          	andi	a4,s1,1023
    80002cae:	40ec87bb          	subw	a5,s9,a4
    80002cb2:	413a86bb          	subw	a3,s5,s3
    80002cb6:	8d3e                	mv	s10,a5
    80002cb8:	2781                	sext.w	a5,a5
    80002cba:	0006861b          	sext.w	a2,a3
    80002cbe:	faf671e3          	bgeu	a2,a5,80002c60 <readi+0x4c>
    80002cc2:	8d36                	mv	s10,a3
    80002cc4:	bf71                	j	80002c60 <readi+0x4c>
      brelse(bp);
    80002cc6:	854a                	mv	a0,s2
    80002cc8:	ec8ff0ef          	jal	80002390 <brelse>
      tot = -1;
    80002ccc:	59fd                	li	s3,-1
      break;
    80002cce:	6946                	ld	s2,80(sp)
    80002cd0:	7c02                	ld	s8,32(sp)
    80002cd2:	6ce2                	ld	s9,24(sp)
    80002cd4:	6d42                	ld	s10,16(sp)
    80002cd6:	6da2                	ld	s11,8(sp)
    80002cd8:	a831                	j	80002cf4 <readi+0xe0>
    80002cda:	6946                	ld	s2,80(sp)
    80002cdc:	7c02                	ld	s8,32(sp)
    80002cde:	6ce2                	ld	s9,24(sp)
    80002ce0:	6d42                	ld	s10,16(sp)
    80002ce2:	6da2                	ld	s11,8(sp)
    80002ce4:	a801                	j	80002cf4 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ce6:	89d6                	mv	s3,s5
    80002ce8:	a031                	j	80002cf4 <readi+0xe0>
    80002cea:	6946                	ld	s2,80(sp)
    80002cec:	7c02                	ld	s8,32(sp)
    80002cee:	6ce2                	ld	s9,24(sp)
    80002cf0:	6d42                	ld	s10,16(sp)
    80002cf2:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002cf4:	0009851b          	sext.w	a0,s3
    80002cf8:	69a6                	ld	s3,72(sp)
}
    80002cfa:	70a6                	ld	ra,104(sp)
    80002cfc:	7406                	ld	s0,96(sp)
    80002cfe:	64e6                	ld	s1,88(sp)
    80002d00:	6a06                	ld	s4,64(sp)
    80002d02:	7ae2                	ld	s5,56(sp)
    80002d04:	7b42                	ld	s6,48(sp)
    80002d06:	7ba2                	ld	s7,40(sp)
    80002d08:	6165                	addi	sp,sp,112
    80002d0a:	8082                	ret
    return 0;
    80002d0c:	4501                	li	a0,0
}
    80002d0e:	8082                	ret

0000000080002d10 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d10:	457c                	lw	a5,76(a0)
    80002d12:	10d7e063          	bltu	a5,a3,80002e12 <writei+0x102>
{
    80002d16:	7159                	addi	sp,sp,-112
    80002d18:	f486                	sd	ra,104(sp)
    80002d1a:	f0a2                	sd	s0,96(sp)
    80002d1c:	e8ca                	sd	s2,80(sp)
    80002d1e:	e0d2                	sd	s4,64(sp)
    80002d20:	fc56                	sd	s5,56(sp)
    80002d22:	f85a                	sd	s6,48(sp)
    80002d24:	f45e                	sd	s7,40(sp)
    80002d26:	1880                	addi	s0,sp,112
    80002d28:	8aaa                	mv	s5,a0
    80002d2a:	8bae                	mv	s7,a1
    80002d2c:	8a32                	mv	s4,a2
    80002d2e:	8936                	mv	s2,a3
    80002d30:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002d32:	00e687bb          	addw	a5,a3,a4
    80002d36:	0ed7e063          	bltu	a5,a3,80002e16 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002d3a:	00043737          	lui	a4,0x43
    80002d3e:	0cf76e63          	bltu	a4,a5,80002e1a <writei+0x10a>
    80002d42:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002d44:	0a0b0f63          	beqz	s6,80002e02 <writei+0xf2>
    80002d48:	eca6                	sd	s1,88(sp)
    80002d4a:	f062                	sd	s8,32(sp)
    80002d4c:	ec66                	sd	s9,24(sp)
    80002d4e:	e86a                	sd	s10,16(sp)
    80002d50:	e46e                	sd	s11,8(sp)
    80002d52:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d54:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002d58:	5c7d                	li	s8,-1
    80002d5a:	a825                	j	80002d92 <writei+0x82>
    80002d5c:	020d1d93          	slli	s11,s10,0x20
    80002d60:	020ddd93          	srli	s11,s11,0x20
    80002d64:	05848513          	addi	a0,s1,88
    80002d68:	86ee                	mv	a3,s11
    80002d6a:	8652                	mv	a2,s4
    80002d6c:	85de                	mv	a1,s7
    80002d6e:	953a                	add	a0,a0,a4
    80002d70:	babfe0ef          	jal	8000191a <either_copyin>
    80002d74:	05850a63          	beq	a0,s8,80002dc8 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002d78:	8526                	mv	a0,s1
    80002d7a:	660000ef          	jal	800033da <log_write>
    brelse(bp);
    80002d7e:	8526                	mv	a0,s1
    80002d80:	e10ff0ef          	jal	80002390 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002d84:	013d09bb          	addw	s3,s10,s3
    80002d88:	012d093b          	addw	s2,s10,s2
    80002d8c:	9a6e                	add	s4,s4,s11
    80002d8e:	0569f063          	bgeu	s3,s6,80002dce <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002d92:	00a9559b          	srliw	a1,s2,0xa
    80002d96:	8556                	mv	a0,s5
    80002d98:	875ff0ef          	jal	8000260c <bmap>
    80002d9c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002da0:	c59d                	beqz	a1,80002dce <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002da2:	000aa503          	lw	a0,0(s5)
    80002da6:	ce2ff0ef          	jal	80002288 <bread>
    80002daa:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dac:	3ff97713          	andi	a4,s2,1023
    80002db0:	40ec87bb          	subw	a5,s9,a4
    80002db4:	413b06bb          	subw	a3,s6,s3
    80002db8:	8d3e                	mv	s10,a5
    80002dba:	2781                	sext.w	a5,a5
    80002dbc:	0006861b          	sext.w	a2,a3
    80002dc0:	f8f67ee3          	bgeu	a2,a5,80002d5c <writei+0x4c>
    80002dc4:	8d36                	mv	s10,a3
    80002dc6:	bf59                	j	80002d5c <writei+0x4c>
      brelse(bp);
    80002dc8:	8526                	mv	a0,s1
    80002dca:	dc6ff0ef          	jal	80002390 <brelse>
  }

  if(off > ip->size)
    80002dce:	04caa783          	lw	a5,76(s5)
    80002dd2:	0327fa63          	bgeu	a5,s2,80002e06 <writei+0xf6>
    ip->size = off;
    80002dd6:	052aa623          	sw	s2,76(s5)
    80002dda:	64e6                	ld	s1,88(sp)
    80002ddc:	7c02                	ld	s8,32(sp)
    80002dde:	6ce2                	ld	s9,24(sp)
    80002de0:	6d42                	ld	s10,16(sp)
    80002de2:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002de4:	8556                	mv	a0,s5
    80002de6:	b27ff0ef          	jal	8000290c <iupdate>

  return tot;
    80002dea:	0009851b          	sext.w	a0,s3
    80002dee:	69a6                	ld	s3,72(sp)
}
    80002df0:	70a6                	ld	ra,104(sp)
    80002df2:	7406                	ld	s0,96(sp)
    80002df4:	6946                	ld	s2,80(sp)
    80002df6:	6a06                	ld	s4,64(sp)
    80002df8:	7ae2                	ld	s5,56(sp)
    80002dfa:	7b42                	ld	s6,48(sp)
    80002dfc:	7ba2                	ld	s7,40(sp)
    80002dfe:	6165                	addi	sp,sp,112
    80002e00:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e02:	89da                	mv	s3,s6
    80002e04:	b7c5                	j	80002de4 <writei+0xd4>
    80002e06:	64e6                	ld	s1,88(sp)
    80002e08:	7c02                	ld	s8,32(sp)
    80002e0a:	6ce2                	ld	s9,24(sp)
    80002e0c:	6d42                	ld	s10,16(sp)
    80002e0e:	6da2                	ld	s11,8(sp)
    80002e10:	bfd1                	j	80002de4 <writei+0xd4>
    return -1;
    80002e12:	557d                	li	a0,-1
}
    80002e14:	8082                	ret
    return -1;
    80002e16:	557d                	li	a0,-1
    80002e18:	bfe1                	j	80002df0 <writei+0xe0>
    return -1;
    80002e1a:	557d                	li	a0,-1
    80002e1c:	bfd1                	j	80002df0 <writei+0xe0>

0000000080002e1e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002e1e:	1141                	addi	sp,sp,-16
    80002e20:	e406                	sd	ra,8(sp)
    80002e22:	e022                	sd	s0,0(sp)
    80002e24:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002e26:	4639                	li	a2,14
    80002e28:	bf2fd0ef          	jal	8000021a <strncmp>
}
    80002e2c:	60a2                	ld	ra,8(sp)
    80002e2e:	6402                	ld	s0,0(sp)
    80002e30:	0141                	addi	sp,sp,16
    80002e32:	8082                	ret

0000000080002e34 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002e34:	7139                	addi	sp,sp,-64
    80002e36:	fc06                	sd	ra,56(sp)
    80002e38:	f822                	sd	s0,48(sp)
    80002e3a:	f426                	sd	s1,40(sp)
    80002e3c:	f04a                	sd	s2,32(sp)
    80002e3e:	ec4e                	sd	s3,24(sp)
    80002e40:	e852                	sd	s4,16(sp)
    80002e42:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002e44:	04451703          	lh	a4,68(a0)
    80002e48:	4785                	li	a5,1
    80002e4a:	00f71a63          	bne	a4,a5,80002e5e <dirlookup+0x2a>
    80002e4e:	892a                	mv	s2,a0
    80002e50:	89ae                	mv	s3,a1
    80002e52:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e54:	457c                	lw	a5,76(a0)
    80002e56:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002e58:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e5a:	e39d                	bnez	a5,80002e80 <dirlookup+0x4c>
    80002e5c:	a095                	j	80002ec0 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002e5e:	00004517          	auipc	a0,0x4
    80002e62:	64a50513          	addi	a0,a0,1610 # 800074a8 <etext+0x4a8>
    80002e66:	4fd020ef          	jal	80005b62 <panic>
      panic("dirlookup read");
    80002e6a:	00004517          	auipc	a0,0x4
    80002e6e:	65650513          	addi	a0,a0,1622 # 800074c0 <etext+0x4c0>
    80002e72:	4f1020ef          	jal	80005b62 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e76:	24c1                	addiw	s1,s1,16
    80002e78:	04c92783          	lw	a5,76(s2)
    80002e7c:	04f4f163          	bgeu	s1,a5,80002ebe <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e80:	4741                	li	a4,16
    80002e82:	86a6                	mv	a3,s1
    80002e84:	fc040613          	addi	a2,s0,-64
    80002e88:	4581                	li	a1,0
    80002e8a:	854a                	mv	a0,s2
    80002e8c:	d89ff0ef          	jal	80002c14 <readi>
    80002e90:	47c1                	li	a5,16
    80002e92:	fcf51ce3          	bne	a0,a5,80002e6a <dirlookup+0x36>
    if(de.inum == 0)
    80002e96:	fc045783          	lhu	a5,-64(s0)
    80002e9a:	dff1                	beqz	a5,80002e76 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002e9c:	fc240593          	addi	a1,s0,-62
    80002ea0:	854e                	mv	a0,s3
    80002ea2:	f7dff0ef          	jal	80002e1e <namecmp>
    80002ea6:	f961                	bnez	a0,80002e76 <dirlookup+0x42>
      if(poff)
    80002ea8:	000a0463          	beqz	s4,80002eb0 <dirlookup+0x7c>
        *poff = off;
    80002eac:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002eb0:	fc045583          	lhu	a1,-64(s0)
    80002eb4:	00092503          	lw	a0,0(s2)
    80002eb8:	829ff0ef          	jal	800026e0 <iget>
    80002ebc:	a011                	j	80002ec0 <dirlookup+0x8c>
  return 0;
    80002ebe:	4501                	li	a0,0
}
    80002ec0:	70e2                	ld	ra,56(sp)
    80002ec2:	7442                	ld	s0,48(sp)
    80002ec4:	74a2                	ld	s1,40(sp)
    80002ec6:	7902                	ld	s2,32(sp)
    80002ec8:	69e2                	ld	s3,24(sp)
    80002eca:	6a42                	ld	s4,16(sp)
    80002ecc:	6121                	addi	sp,sp,64
    80002ece:	8082                	ret

0000000080002ed0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002ed0:	711d                	addi	sp,sp,-96
    80002ed2:	ec86                	sd	ra,88(sp)
    80002ed4:	e8a2                	sd	s0,80(sp)
    80002ed6:	e4a6                	sd	s1,72(sp)
    80002ed8:	e0ca                	sd	s2,64(sp)
    80002eda:	fc4e                	sd	s3,56(sp)
    80002edc:	f852                	sd	s4,48(sp)
    80002ede:	f456                	sd	s5,40(sp)
    80002ee0:	f05a                	sd	s6,32(sp)
    80002ee2:	ec5e                	sd	s7,24(sp)
    80002ee4:	e862                	sd	s8,16(sp)
    80002ee6:	e466                	sd	s9,8(sp)
    80002ee8:	1080                	addi	s0,sp,96
    80002eea:	84aa                	mv	s1,a0
    80002eec:	8b2e                	mv	s6,a1
    80002eee:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002ef0:	00054703          	lbu	a4,0(a0)
    80002ef4:	02f00793          	li	a5,47
    80002ef8:	00f70e63          	beq	a4,a5,80002f14 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002efc:	ed9fd0ef          	jal	80000dd4 <myproc>
    80002f00:	15053503          	ld	a0,336(a0)
    80002f04:	a87ff0ef          	jal	8000298a <idup>
    80002f08:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002f0a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002f0e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002f10:	4b85                	li	s7,1
    80002f12:	a871                	j	80002fae <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002f14:	4585                	li	a1,1
    80002f16:	4505                	li	a0,1
    80002f18:	fc8ff0ef          	jal	800026e0 <iget>
    80002f1c:	8a2a                	mv	s4,a0
    80002f1e:	b7f5                	j	80002f0a <namex+0x3a>
      iunlockput(ip);
    80002f20:	8552                	mv	a0,s4
    80002f22:	ca9ff0ef          	jal	80002bca <iunlockput>
      return 0;
    80002f26:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002f28:	8552                	mv	a0,s4
    80002f2a:	60e6                	ld	ra,88(sp)
    80002f2c:	6446                	ld	s0,80(sp)
    80002f2e:	64a6                	ld	s1,72(sp)
    80002f30:	6906                	ld	s2,64(sp)
    80002f32:	79e2                	ld	s3,56(sp)
    80002f34:	7a42                	ld	s4,48(sp)
    80002f36:	7aa2                	ld	s5,40(sp)
    80002f38:	7b02                	ld	s6,32(sp)
    80002f3a:	6be2                	ld	s7,24(sp)
    80002f3c:	6c42                	ld	s8,16(sp)
    80002f3e:	6ca2                	ld	s9,8(sp)
    80002f40:	6125                	addi	sp,sp,96
    80002f42:	8082                	ret
      iunlock(ip);
    80002f44:	8552                	mv	a0,s4
    80002f46:	b29ff0ef          	jal	80002a6e <iunlock>
      return ip;
    80002f4a:	bff9                	j	80002f28 <namex+0x58>
      iunlockput(ip);
    80002f4c:	8552                	mv	a0,s4
    80002f4e:	c7dff0ef          	jal	80002bca <iunlockput>
      return 0;
    80002f52:	8a4e                	mv	s4,s3
    80002f54:	bfd1                	j	80002f28 <namex+0x58>
  len = path - s;
    80002f56:	40998633          	sub	a2,s3,s1
    80002f5a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002f5e:	099c5063          	bge	s8,s9,80002fde <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002f62:	4639                	li	a2,14
    80002f64:	85a6                	mv	a1,s1
    80002f66:	8556                	mv	a0,s5
    80002f68:	a42fd0ef          	jal	800001aa <memmove>
    80002f6c:	84ce                	mv	s1,s3
  while(*path == '/')
    80002f6e:	0004c783          	lbu	a5,0(s1)
    80002f72:	01279763          	bne	a5,s2,80002f80 <namex+0xb0>
    path++;
    80002f76:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002f78:	0004c783          	lbu	a5,0(s1)
    80002f7c:	ff278de3          	beq	a5,s2,80002f76 <namex+0xa6>
    ilock(ip);
    80002f80:	8552                	mv	a0,s4
    80002f82:	a3fff0ef          	jal	800029c0 <ilock>
    if(ip->type != T_DIR){
    80002f86:	044a1783          	lh	a5,68(s4)
    80002f8a:	f9779be3          	bne	a5,s7,80002f20 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002f8e:	000b0563          	beqz	s6,80002f98 <namex+0xc8>
    80002f92:	0004c783          	lbu	a5,0(s1)
    80002f96:	d7dd                	beqz	a5,80002f44 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002f98:	4601                	li	a2,0
    80002f9a:	85d6                	mv	a1,s5
    80002f9c:	8552                	mv	a0,s4
    80002f9e:	e97ff0ef          	jal	80002e34 <dirlookup>
    80002fa2:	89aa                	mv	s3,a0
    80002fa4:	d545                	beqz	a0,80002f4c <namex+0x7c>
    iunlockput(ip);
    80002fa6:	8552                	mv	a0,s4
    80002fa8:	c23ff0ef          	jal	80002bca <iunlockput>
    ip = next;
    80002fac:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002fae:	0004c783          	lbu	a5,0(s1)
    80002fb2:	01279763          	bne	a5,s2,80002fc0 <namex+0xf0>
    path++;
    80002fb6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002fb8:	0004c783          	lbu	a5,0(s1)
    80002fbc:	ff278de3          	beq	a5,s2,80002fb6 <namex+0xe6>
  if(*path == 0)
    80002fc0:	cb8d                	beqz	a5,80002ff2 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002fc2:	0004c783          	lbu	a5,0(s1)
    80002fc6:	89a6                	mv	s3,s1
  len = path - s;
    80002fc8:	4c81                	li	s9,0
    80002fca:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002fcc:	01278963          	beq	a5,s2,80002fde <namex+0x10e>
    80002fd0:	d3d9                	beqz	a5,80002f56 <namex+0x86>
    path++;
    80002fd2:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002fd4:	0009c783          	lbu	a5,0(s3)
    80002fd8:	ff279ce3          	bne	a5,s2,80002fd0 <namex+0x100>
    80002fdc:	bfad                	j	80002f56 <namex+0x86>
    memmove(name, s, len);
    80002fde:	2601                	sext.w	a2,a2
    80002fe0:	85a6                	mv	a1,s1
    80002fe2:	8556                	mv	a0,s5
    80002fe4:	9c6fd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80002fe8:	9cd6                	add	s9,s9,s5
    80002fea:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002fee:	84ce                	mv	s1,s3
    80002ff0:	bfbd                	j	80002f6e <namex+0x9e>
  if(nameiparent){
    80002ff2:	f20b0be3          	beqz	s6,80002f28 <namex+0x58>
    iput(ip);
    80002ff6:	8552                	mv	a0,s4
    80002ff8:	b4bff0ef          	jal	80002b42 <iput>
    return 0;
    80002ffc:	4a01                	li	s4,0
    80002ffe:	b72d                	j	80002f28 <namex+0x58>

0000000080003000 <dirlink>:
{
    80003000:	7139                	addi	sp,sp,-64
    80003002:	fc06                	sd	ra,56(sp)
    80003004:	f822                	sd	s0,48(sp)
    80003006:	f04a                	sd	s2,32(sp)
    80003008:	ec4e                	sd	s3,24(sp)
    8000300a:	e852                	sd	s4,16(sp)
    8000300c:	0080                	addi	s0,sp,64
    8000300e:	892a                	mv	s2,a0
    80003010:	8a2e                	mv	s4,a1
    80003012:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003014:	4601                	li	a2,0
    80003016:	e1fff0ef          	jal	80002e34 <dirlookup>
    8000301a:	e535                	bnez	a0,80003086 <dirlink+0x86>
    8000301c:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000301e:	04c92483          	lw	s1,76(s2)
    80003022:	c48d                	beqz	s1,8000304c <dirlink+0x4c>
    80003024:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003026:	4741                	li	a4,16
    80003028:	86a6                	mv	a3,s1
    8000302a:	fc040613          	addi	a2,s0,-64
    8000302e:	4581                	li	a1,0
    80003030:	854a                	mv	a0,s2
    80003032:	be3ff0ef          	jal	80002c14 <readi>
    80003036:	47c1                	li	a5,16
    80003038:	04f51b63          	bne	a0,a5,8000308e <dirlink+0x8e>
    if(de.inum == 0)
    8000303c:	fc045783          	lhu	a5,-64(s0)
    80003040:	c791                	beqz	a5,8000304c <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003042:	24c1                	addiw	s1,s1,16
    80003044:	04c92783          	lw	a5,76(s2)
    80003048:	fcf4efe3          	bltu	s1,a5,80003026 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    8000304c:	4639                	li	a2,14
    8000304e:	85d2                	mv	a1,s4
    80003050:	fc240513          	addi	a0,s0,-62
    80003054:	9fcfd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    80003058:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000305c:	4741                	li	a4,16
    8000305e:	86a6                	mv	a3,s1
    80003060:	fc040613          	addi	a2,s0,-64
    80003064:	4581                	li	a1,0
    80003066:	854a                	mv	a0,s2
    80003068:	ca9ff0ef          	jal	80002d10 <writei>
    8000306c:	1541                	addi	a0,a0,-16
    8000306e:	00a03533          	snez	a0,a0
    80003072:	40a00533          	neg	a0,a0
    80003076:	74a2                	ld	s1,40(sp)
}
    80003078:	70e2                	ld	ra,56(sp)
    8000307a:	7442                	ld	s0,48(sp)
    8000307c:	7902                	ld	s2,32(sp)
    8000307e:	69e2                	ld	s3,24(sp)
    80003080:	6a42                	ld	s4,16(sp)
    80003082:	6121                	addi	sp,sp,64
    80003084:	8082                	ret
    iput(ip);
    80003086:	abdff0ef          	jal	80002b42 <iput>
    return -1;
    8000308a:	557d                	li	a0,-1
    8000308c:	b7f5                	j	80003078 <dirlink+0x78>
      panic("dirlink read");
    8000308e:	00004517          	auipc	a0,0x4
    80003092:	44250513          	addi	a0,a0,1090 # 800074d0 <etext+0x4d0>
    80003096:	2cd020ef          	jal	80005b62 <panic>

000000008000309a <namei>:

struct inode*
namei(char *path)
{
    8000309a:	1101                	addi	sp,sp,-32
    8000309c:	ec06                	sd	ra,24(sp)
    8000309e:	e822                	sd	s0,16(sp)
    800030a0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800030a2:	fe040613          	addi	a2,s0,-32
    800030a6:	4581                	li	a1,0
    800030a8:	e29ff0ef          	jal	80002ed0 <namex>
}
    800030ac:	60e2                	ld	ra,24(sp)
    800030ae:	6442                	ld	s0,16(sp)
    800030b0:	6105                	addi	sp,sp,32
    800030b2:	8082                	ret

00000000800030b4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800030b4:	1141                	addi	sp,sp,-16
    800030b6:	e406                	sd	ra,8(sp)
    800030b8:	e022                	sd	s0,0(sp)
    800030ba:	0800                	addi	s0,sp,16
    800030bc:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800030be:	4585                	li	a1,1
    800030c0:	e11ff0ef          	jal	80002ed0 <namex>
}
    800030c4:	60a2                	ld	ra,8(sp)
    800030c6:	6402                	ld	s0,0(sp)
    800030c8:	0141                	addi	sp,sp,16
    800030ca:	8082                	ret

00000000800030cc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800030cc:	1101                	addi	sp,sp,-32
    800030ce:	ec06                	sd	ra,24(sp)
    800030d0:	e822                	sd	s0,16(sp)
    800030d2:	e426                	sd	s1,8(sp)
    800030d4:	e04a                	sd	s2,0(sp)
    800030d6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800030d8:	0001d917          	auipc	s2,0x1d
    800030dc:	85890913          	addi	s2,s2,-1960 # 8001f930 <log>
    800030e0:	01892583          	lw	a1,24(s2)
    800030e4:	02892503          	lw	a0,40(s2)
    800030e8:	9a0ff0ef          	jal	80002288 <bread>
    800030ec:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800030ee:	02c92603          	lw	a2,44(s2)
    800030f2:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800030f4:	00c05f63          	blez	a2,80003112 <write_head+0x46>
    800030f8:	0001d717          	auipc	a4,0x1d
    800030fc:	86870713          	addi	a4,a4,-1944 # 8001f960 <log+0x30>
    80003100:	87aa                	mv	a5,a0
    80003102:	060a                	slli	a2,a2,0x2
    80003104:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003106:	4314                	lw	a3,0(a4)
    80003108:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000310a:	0711                	addi	a4,a4,4
    8000310c:	0791                	addi	a5,a5,4
    8000310e:	fec79ce3          	bne	a5,a2,80003106 <write_head+0x3a>
  }
  bwrite(buf);
    80003112:	8526                	mv	a0,s1
    80003114:	a4aff0ef          	jal	8000235e <bwrite>
  brelse(buf);
    80003118:	8526                	mv	a0,s1
    8000311a:	a76ff0ef          	jal	80002390 <brelse>
}
    8000311e:	60e2                	ld	ra,24(sp)
    80003120:	6442                	ld	s0,16(sp)
    80003122:	64a2                	ld	s1,8(sp)
    80003124:	6902                	ld	s2,0(sp)
    80003126:	6105                	addi	sp,sp,32
    80003128:	8082                	ret

000000008000312a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000312a:	0001d797          	auipc	a5,0x1d
    8000312e:	8327a783          	lw	a5,-1998(a5) # 8001f95c <log+0x2c>
    80003132:	08f05f63          	blez	a5,800031d0 <install_trans+0xa6>
{
    80003136:	7139                	addi	sp,sp,-64
    80003138:	fc06                	sd	ra,56(sp)
    8000313a:	f822                	sd	s0,48(sp)
    8000313c:	f426                	sd	s1,40(sp)
    8000313e:	f04a                	sd	s2,32(sp)
    80003140:	ec4e                	sd	s3,24(sp)
    80003142:	e852                	sd	s4,16(sp)
    80003144:	e456                	sd	s5,8(sp)
    80003146:	e05a                	sd	s6,0(sp)
    80003148:	0080                	addi	s0,sp,64
    8000314a:	8b2a                	mv	s6,a0
    8000314c:	0001da97          	auipc	s5,0x1d
    80003150:	814a8a93          	addi	s5,s5,-2028 # 8001f960 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003154:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003156:	0001c997          	auipc	s3,0x1c
    8000315a:	7da98993          	addi	s3,s3,2010 # 8001f930 <log>
    8000315e:	a829                	j	80003178 <install_trans+0x4e>
    brelse(lbuf);
    80003160:	854a                	mv	a0,s2
    80003162:	a2eff0ef          	jal	80002390 <brelse>
    brelse(dbuf);
    80003166:	8526                	mv	a0,s1
    80003168:	a28ff0ef          	jal	80002390 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000316c:	2a05                	addiw	s4,s4,1
    8000316e:	0a91                	addi	s5,s5,4
    80003170:	02c9a783          	lw	a5,44(s3)
    80003174:	04fa5463          	bge	s4,a5,800031bc <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003178:	0189a583          	lw	a1,24(s3)
    8000317c:	014585bb          	addw	a1,a1,s4
    80003180:	2585                	addiw	a1,a1,1
    80003182:	0289a503          	lw	a0,40(s3)
    80003186:	902ff0ef          	jal	80002288 <bread>
    8000318a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000318c:	000aa583          	lw	a1,0(s5)
    80003190:	0289a503          	lw	a0,40(s3)
    80003194:	8f4ff0ef          	jal	80002288 <bread>
    80003198:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000319a:	40000613          	li	a2,1024
    8000319e:	05890593          	addi	a1,s2,88
    800031a2:	05850513          	addi	a0,a0,88
    800031a6:	804fd0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    800031aa:	8526                	mv	a0,s1
    800031ac:	9b2ff0ef          	jal	8000235e <bwrite>
    if(recovering == 0)
    800031b0:	fa0b18e3          	bnez	s6,80003160 <install_trans+0x36>
      bunpin(dbuf);
    800031b4:	8526                	mv	a0,s1
    800031b6:	a96ff0ef          	jal	8000244c <bunpin>
    800031ba:	b75d                	j	80003160 <install_trans+0x36>
}
    800031bc:	70e2                	ld	ra,56(sp)
    800031be:	7442                	ld	s0,48(sp)
    800031c0:	74a2                	ld	s1,40(sp)
    800031c2:	7902                	ld	s2,32(sp)
    800031c4:	69e2                	ld	s3,24(sp)
    800031c6:	6a42                	ld	s4,16(sp)
    800031c8:	6aa2                	ld	s5,8(sp)
    800031ca:	6b02                	ld	s6,0(sp)
    800031cc:	6121                	addi	sp,sp,64
    800031ce:	8082                	ret
    800031d0:	8082                	ret

00000000800031d2 <initlog>:
{
    800031d2:	7179                	addi	sp,sp,-48
    800031d4:	f406                	sd	ra,40(sp)
    800031d6:	f022                	sd	s0,32(sp)
    800031d8:	ec26                	sd	s1,24(sp)
    800031da:	e84a                	sd	s2,16(sp)
    800031dc:	e44e                	sd	s3,8(sp)
    800031de:	1800                	addi	s0,sp,48
    800031e0:	892a                	mv	s2,a0
    800031e2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800031e4:	0001c497          	auipc	s1,0x1c
    800031e8:	74c48493          	addi	s1,s1,1868 # 8001f930 <log>
    800031ec:	00004597          	auipc	a1,0x4
    800031f0:	2f458593          	addi	a1,a1,756 # 800074e0 <etext+0x4e0>
    800031f4:	8526                	mv	a0,s1
    800031f6:	41b020ef          	jal	80005e10 <initlock>
  log.start = sb->logstart;
    800031fa:	0149a583          	lw	a1,20(s3)
    800031fe:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003200:	0109a783          	lw	a5,16(s3)
    80003204:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003206:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000320a:	854a                	mv	a0,s2
    8000320c:	87cff0ef          	jal	80002288 <bread>
  log.lh.n = lh->n;
    80003210:	4d30                	lw	a2,88(a0)
    80003212:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003214:	00c05f63          	blez	a2,80003232 <initlog+0x60>
    80003218:	87aa                	mv	a5,a0
    8000321a:	0001c717          	auipc	a4,0x1c
    8000321e:	74670713          	addi	a4,a4,1862 # 8001f960 <log+0x30>
    80003222:	060a                	slli	a2,a2,0x2
    80003224:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003226:	4ff4                	lw	a3,92(a5)
    80003228:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000322a:	0791                	addi	a5,a5,4
    8000322c:	0711                	addi	a4,a4,4
    8000322e:	fec79ce3          	bne	a5,a2,80003226 <initlog+0x54>
  brelse(buf);
    80003232:	95eff0ef          	jal	80002390 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003236:	4505                	li	a0,1
    80003238:	ef3ff0ef          	jal	8000312a <install_trans>
  log.lh.n = 0;
    8000323c:	0001c797          	auipc	a5,0x1c
    80003240:	7207a023          	sw	zero,1824(a5) # 8001f95c <log+0x2c>
  write_head(); // clear the log
    80003244:	e89ff0ef          	jal	800030cc <write_head>
}
    80003248:	70a2                	ld	ra,40(sp)
    8000324a:	7402                	ld	s0,32(sp)
    8000324c:	64e2                	ld	s1,24(sp)
    8000324e:	6942                	ld	s2,16(sp)
    80003250:	69a2                	ld	s3,8(sp)
    80003252:	6145                	addi	sp,sp,48
    80003254:	8082                	ret

0000000080003256 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003256:	1101                	addi	sp,sp,-32
    80003258:	ec06                	sd	ra,24(sp)
    8000325a:	e822                	sd	s0,16(sp)
    8000325c:	e426                	sd	s1,8(sp)
    8000325e:	e04a                	sd	s2,0(sp)
    80003260:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003262:	0001c517          	auipc	a0,0x1c
    80003266:	6ce50513          	addi	a0,a0,1742 # 8001f930 <log>
    8000326a:	427020ef          	jal	80005e90 <acquire>
  while(1){
    if(log.committing){
    8000326e:	0001c497          	auipc	s1,0x1c
    80003272:	6c248493          	addi	s1,s1,1730 # 8001f930 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003276:	4979                	li	s2,30
    80003278:	a029                	j	80003282 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000327a:	85a6                	mv	a1,s1
    8000327c:	8526                	mv	a0,s1
    8000327e:	beafe0ef          	jal	80001668 <sleep>
    if(log.committing){
    80003282:	50dc                	lw	a5,36(s1)
    80003284:	fbfd                	bnez	a5,8000327a <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003286:	5098                	lw	a4,32(s1)
    80003288:	2705                	addiw	a4,a4,1
    8000328a:	0027179b          	slliw	a5,a4,0x2
    8000328e:	9fb9                	addw	a5,a5,a4
    80003290:	0017979b          	slliw	a5,a5,0x1
    80003294:	54d4                	lw	a3,44(s1)
    80003296:	9fb5                	addw	a5,a5,a3
    80003298:	00f95763          	bge	s2,a5,800032a6 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000329c:	85a6                	mv	a1,s1
    8000329e:	8526                	mv	a0,s1
    800032a0:	bc8fe0ef          	jal	80001668 <sleep>
    800032a4:	bff9                	j	80003282 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800032a6:	0001c517          	auipc	a0,0x1c
    800032aa:	68a50513          	addi	a0,a0,1674 # 8001f930 <log>
    800032ae:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800032b0:	479020ef          	jal	80005f28 <release>
      break;
    }
  }
}
    800032b4:	60e2                	ld	ra,24(sp)
    800032b6:	6442                	ld	s0,16(sp)
    800032b8:	64a2                	ld	s1,8(sp)
    800032ba:	6902                	ld	s2,0(sp)
    800032bc:	6105                	addi	sp,sp,32
    800032be:	8082                	ret

00000000800032c0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800032c0:	7139                	addi	sp,sp,-64
    800032c2:	fc06                	sd	ra,56(sp)
    800032c4:	f822                	sd	s0,48(sp)
    800032c6:	f426                	sd	s1,40(sp)
    800032c8:	f04a                	sd	s2,32(sp)
    800032ca:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800032cc:	0001c497          	auipc	s1,0x1c
    800032d0:	66448493          	addi	s1,s1,1636 # 8001f930 <log>
    800032d4:	8526                	mv	a0,s1
    800032d6:	3bb020ef          	jal	80005e90 <acquire>
  log.outstanding -= 1;
    800032da:	509c                	lw	a5,32(s1)
    800032dc:	37fd                	addiw	a5,a5,-1
    800032de:	0007891b          	sext.w	s2,a5
    800032e2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800032e4:	50dc                	lw	a5,36(s1)
    800032e6:	ef9d                	bnez	a5,80003324 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    800032e8:	04091763          	bnez	s2,80003336 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    800032ec:	0001c497          	auipc	s1,0x1c
    800032f0:	64448493          	addi	s1,s1,1604 # 8001f930 <log>
    800032f4:	4785                	li	a5,1
    800032f6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800032f8:	8526                	mv	a0,s1
    800032fa:	42f020ef          	jal	80005f28 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800032fe:	54dc                	lw	a5,44(s1)
    80003300:	04f04b63          	bgtz	a5,80003356 <end_op+0x96>
    acquire(&log.lock);
    80003304:	0001c497          	auipc	s1,0x1c
    80003308:	62c48493          	addi	s1,s1,1580 # 8001f930 <log>
    8000330c:	8526                	mv	a0,s1
    8000330e:	383020ef          	jal	80005e90 <acquire>
    log.committing = 0;
    80003312:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003316:	8526                	mv	a0,s1
    80003318:	ba0fe0ef          	jal	800016b8 <wakeup>
    release(&log.lock);
    8000331c:	8526                	mv	a0,s1
    8000331e:	40b020ef          	jal	80005f28 <release>
}
    80003322:	a025                	j	8000334a <end_op+0x8a>
    80003324:	ec4e                	sd	s3,24(sp)
    80003326:	e852                	sd	s4,16(sp)
    80003328:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000332a:	00004517          	auipc	a0,0x4
    8000332e:	1be50513          	addi	a0,a0,446 # 800074e8 <etext+0x4e8>
    80003332:	031020ef          	jal	80005b62 <panic>
    wakeup(&log);
    80003336:	0001c497          	auipc	s1,0x1c
    8000333a:	5fa48493          	addi	s1,s1,1530 # 8001f930 <log>
    8000333e:	8526                	mv	a0,s1
    80003340:	b78fe0ef          	jal	800016b8 <wakeup>
  release(&log.lock);
    80003344:	8526                	mv	a0,s1
    80003346:	3e3020ef          	jal	80005f28 <release>
}
    8000334a:	70e2                	ld	ra,56(sp)
    8000334c:	7442                	ld	s0,48(sp)
    8000334e:	74a2                	ld	s1,40(sp)
    80003350:	7902                	ld	s2,32(sp)
    80003352:	6121                	addi	sp,sp,64
    80003354:	8082                	ret
    80003356:	ec4e                	sd	s3,24(sp)
    80003358:	e852                	sd	s4,16(sp)
    8000335a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000335c:	0001ca97          	auipc	s5,0x1c
    80003360:	604a8a93          	addi	s5,s5,1540 # 8001f960 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003364:	0001ca17          	auipc	s4,0x1c
    80003368:	5cca0a13          	addi	s4,s4,1484 # 8001f930 <log>
    8000336c:	018a2583          	lw	a1,24(s4)
    80003370:	012585bb          	addw	a1,a1,s2
    80003374:	2585                	addiw	a1,a1,1
    80003376:	028a2503          	lw	a0,40(s4)
    8000337a:	f0ffe0ef          	jal	80002288 <bread>
    8000337e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003380:	000aa583          	lw	a1,0(s5)
    80003384:	028a2503          	lw	a0,40(s4)
    80003388:	f01fe0ef          	jal	80002288 <bread>
    8000338c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000338e:	40000613          	li	a2,1024
    80003392:	05850593          	addi	a1,a0,88
    80003396:	05848513          	addi	a0,s1,88
    8000339a:	e11fc0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    8000339e:	8526                	mv	a0,s1
    800033a0:	fbffe0ef          	jal	8000235e <bwrite>
    brelse(from);
    800033a4:	854e                	mv	a0,s3
    800033a6:	febfe0ef          	jal	80002390 <brelse>
    brelse(to);
    800033aa:	8526                	mv	a0,s1
    800033ac:	fe5fe0ef          	jal	80002390 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033b0:	2905                	addiw	s2,s2,1
    800033b2:	0a91                	addi	s5,s5,4
    800033b4:	02ca2783          	lw	a5,44(s4)
    800033b8:	faf94ae3          	blt	s2,a5,8000336c <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800033bc:	d11ff0ef          	jal	800030cc <write_head>
    install_trans(0); // Now install writes to home locations
    800033c0:	4501                	li	a0,0
    800033c2:	d69ff0ef          	jal	8000312a <install_trans>
    log.lh.n = 0;
    800033c6:	0001c797          	auipc	a5,0x1c
    800033ca:	5807ab23          	sw	zero,1430(a5) # 8001f95c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800033ce:	cffff0ef          	jal	800030cc <write_head>
    800033d2:	69e2                	ld	s3,24(sp)
    800033d4:	6a42                	ld	s4,16(sp)
    800033d6:	6aa2                	ld	s5,8(sp)
    800033d8:	b735                	j	80003304 <end_op+0x44>

00000000800033da <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800033da:	1101                	addi	sp,sp,-32
    800033dc:	ec06                	sd	ra,24(sp)
    800033de:	e822                	sd	s0,16(sp)
    800033e0:	e426                	sd	s1,8(sp)
    800033e2:	e04a                	sd	s2,0(sp)
    800033e4:	1000                	addi	s0,sp,32
    800033e6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800033e8:	0001c917          	auipc	s2,0x1c
    800033ec:	54890913          	addi	s2,s2,1352 # 8001f930 <log>
    800033f0:	854a                	mv	a0,s2
    800033f2:	29f020ef          	jal	80005e90 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800033f6:	02c92603          	lw	a2,44(s2)
    800033fa:	47f5                	li	a5,29
    800033fc:	06c7c363          	blt	a5,a2,80003462 <log_write+0x88>
    80003400:	0001c797          	auipc	a5,0x1c
    80003404:	54c7a783          	lw	a5,1356(a5) # 8001f94c <log+0x1c>
    80003408:	37fd                	addiw	a5,a5,-1
    8000340a:	04f65c63          	bge	a2,a5,80003462 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000340e:	0001c797          	auipc	a5,0x1c
    80003412:	5427a783          	lw	a5,1346(a5) # 8001f950 <log+0x20>
    80003416:	04f05c63          	blez	a5,8000346e <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000341a:	4781                	li	a5,0
    8000341c:	04c05f63          	blez	a2,8000347a <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003420:	44cc                	lw	a1,12(s1)
    80003422:	0001c717          	auipc	a4,0x1c
    80003426:	53e70713          	addi	a4,a4,1342 # 8001f960 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000342a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000342c:	4314                	lw	a3,0(a4)
    8000342e:	04b68663          	beq	a3,a1,8000347a <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003432:	2785                	addiw	a5,a5,1
    80003434:	0711                	addi	a4,a4,4
    80003436:	fef61be3          	bne	a2,a5,8000342c <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000343a:	0621                	addi	a2,a2,8
    8000343c:	060a                	slli	a2,a2,0x2
    8000343e:	0001c797          	auipc	a5,0x1c
    80003442:	4f278793          	addi	a5,a5,1266 # 8001f930 <log>
    80003446:	97b2                	add	a5,a5,a2
    80003448:	44d8                	lw	a4,12(s1)
    8000344a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000344c:	8526                	mv	a0,s1
    8000344e:	fcbfe0ef          	jal	80002418 <bpin>
    log.lh.n++;
    80003452:	0001c717          	auipc	a4,0x1c
    80003456:	4de70713          	addi	a4,a4,1246 # 8001f930 <log>
    8000345a:	575c                	lw	a5,44(a4)
    8000345c:	2785                	addiw	a5,a5,1
    8000345e:	d75c                	sw	a5,44(a4)
    80003460:	a80d                	j	80003492 <log_write+0xb8>
    panic("too big a transaction");
    80003462:	00004517          	auipc	a0,0x4
    80003466:	09650513          	addi	a0,a0,150 # 800074f8 <etext+0x4f8>
    8000346a:	6f8020ef          	jal	80005b62 <panic>
    panic("log_write outside of trans");
    8000346e:	00004517          	auipc	a0,0x4
    80003472:	0a250513          	addi	a0,a0,162 # 80007510 <etext+0x510>
    80003476:	6ec020ef          	jal	80005b62 <panic>
  log.lh.block[i] = b->blockno;
    8000347a:	00878693          	addi	a3,a5,8
    8000347e:	068a                	slli	a3,a3,0x2
    80003480:	0001c717          	auipc	a4,0x1c
    80003484:	4b070713          	addi	a4,a4,1200 # 8001f930 <log>
    80003488:	9736                	add	a4,a4,a3
    8000348a:	44d4                	lw	a3,12(s1)
    8000348c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000348e:	faf60fe3          	beq	a2,a5,8000344c <log_write+0x72>
  }
  release(&log.lock);
    80003492:	0001c517          	auipc	a0,0x1c
    80003496:	49e50513          	addi	a0,a0,1182 # 8001f930 <log>
    8000349a:	28f020ef          	jal	80005f28 <release>
}
    8000349e:	60e2                	ld	ra,24(sp)
    800034a0:	6442                	ld	s0,16(sp)
    800034a2:	64a2                	ld	s1,8(sp)
    800034a4:	6902                	ld	s2,0(sp)
    800034a6:	6105                	addi	sp,sp,32
    800034a8:	8082                	ret

00000000800034aa <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800034aa:	1101                	addi	sp,sp,-32
    800034ac:	ec06                	sd	ra,24(sp)
    800034ae:	e822                	sd	s0,16(sp)
    800034b0:	e426                	sd	s1,8(sp)
    800034b2:	e04a                	sd	s2,0(sp)
    800034b4:	1000                	addi	s0,sp,32
    800034b6:	84aa                	mv	s1,a0
    800034b8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800034ba:	00004597          	auipc	a1,0x4
    800034be:	07658593          	addi	a1,a1,118 # 80007530 <etext+0x530>
    800034c2:	0521                	addi	a0,a0,8
    800034c4:	14d020ef          	jal	80005e10 <initlock>
  lk->name = name;
    800034c8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800034cc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800034d0:	0204a423          	sw	zero,40(s1)
}
    800034d4:	60e2                	ld	ra,24(sp)
    800034d6:	6442                	ld	s0,16(sp)
    800034d8:	64a2                	ld	s1,8(sp)
    800034da:	6902                	ld	s2,0(sp)
    800034dc:	6105                	addi	sp,sp,32
    800034de:	8082                	ret

00000000800034e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800034e0:	1101                	addi	sp,sp,-32
    800034e2:	ec06                	sd	ra,24(sp)
    800034e4:	e822                	sd	s0,16(sp)
    800034e6:	e426                	sd	s1,8(sp)
    800034e8:	e04a                	sd	s2,0(sp)
    800034ea:	1000                	addi	s0,sp,32
    800034ec:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800034ee:	00850913          	addi	s2,a0,8
    800034f2:	854a                	mv	a0,s2
    800034f4:	19d020ef          	jal	80005e90 <acquire>
  while (lk->locked) {
    800034f8:	409c                	lw	a5,0(s1)
    800034fa:	c799                	beqz	a5,80003508 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800034fc:	85ca                	mv	a1,s2
    800034fe:	8526                	mv	a0,s1
    80003500:	968fe0ef          	jal	80001668 <sleep>
  while (lk->locked) {
    80003504:	409c                	lw	a5,0(s1)
    80003506:	fbfd                	bnez	a5,800034fc <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003508:	4785                	li	a5,1
    8000350a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000350c:	8c9fd0ef          	jal	80000dd4 <myproc>
    80003510:	591c                	lw	a5,48(a0)
    80003512:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003514:	854a                	mv	a0,s2
    80003516:	213020ef          	jal	80005f28 <release>
}
    8000351a:	60e2                	ld	ra,24(sp)
    8000351c:	6442                	ld	s0,16(sp)
    8000351e:	64a2                	ld	s1,8(sp)
    80003520:	6902                	ld	s2,0(sp)
    80003522:	6105                	addi	sp,sp,32
    80003524:	8082                	ret

0000000080003526 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003526:	1101                	addi	sp,sp,-32
    80003528:	ec06                	sd	ra,24(sp)
    8000352a:	e822                	sd	s0,16(sp)
    8000352c:	e426                	sd	s1,8(sp)
    8000352e:	e04a                	sd	s2,0(sp)
    80003530:	1000                	addi	s0,sp,32
    80003532:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003534:	00850913          	addi	s2,a0,8
    80003538:	854a                	mv	a0,s2
    8000353a:	157020ef          	jal	80005e90 <acquire>
  lk->locked = 0;
    8000353e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003542:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003546:	8526                	mv	a0,s1
    80003548:	970fe0ef          	jal	800016b8 <wakeup>
  release(&lk->lk);
    8000354c:	854a                	mv	a0,s2
    8000354e:	1db020ef          	jal	80005f28 <release>
}
    80003552:	60e2                	ld	ra,24(sp)
    80003554:	6442                	ld	s0,16(sp)
    80003556:	64a2                	ld	s1,8(sp)
    80003558:	6902                	ld	s2,0(sp)
    8000355a:	6105                	addi	sp,sp,32
    8000355c:	8082                	ret

000000008000355e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000355e:	7179                	addi	sp,sp,-48
    80003560:	f406                	sd	ra,40(sp)
    80003562:	f022                	sd	s0,32(sp)
    80003564:	ec26                	sd	s1,24(sp)
    80003566:	e84a                	sd	s2,16(sp)
    80003568:	1800                	addi	s0,sp,48
    8000356a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000356c:	00850913          	addi	s2,a0,8
    80003570:	854a                	mv	a0,s2
    80003572:	11f020ef          	jal	80005e90 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003576:	409c                	lw	a5,0(s1)
    80003578:	ef81                	bnez	a5,80003590 <holdingsleep+0x32>
    8000357a:	4481                	li	s1,0
  release(&lk->lk);
    8000357c:	854a                	mv	a0,s2
    8000357e:	1ab020ef          	jal	80005f28 <release>
  return r;
}
    80003582:	8526                	mv	a0,s1
    80003584:	70a2                	ld	ra,40(sp)
    80003586:	7402                	ld	s0,32(sp)
    80003588:	64e2                	ld	s1,24(sp)
    8000358a:	6942                	ld	s2,16(sp)
    8000358c:	6145                	addi	sp,sp,48
    8000358e:	8082                	ret
    80003590:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003592:	0284a983          	lw	s3,40(s1)
    80003596:	83ffd0ef          	jal	80000dd4 <myproc>
    8000359a:	5904                	lw	s1,48(a0)
    8000359c:	413484b3          	sub	s1,s1,s3
    800035a0:	0014b493          	seqz	s1,s1
    800035a4:	69a2                	ld	s3,8(sp)
    800035a6:	bfd9                	j	8000357c <holdingsleep+0x1e>

00000000800035a8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800035a8:	1141                	addi	sp,sp,-16
    800035aa:	e406                	sd	ra,8(sp)
    800035ac:	e022                	sd	s0,0(sp)
    800035ae:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800035b0:	00004597          	auipc	a1,0x4
    800035b4:	f9058593          	addi	a1,a1,-112 # 80007540 <etext+0x540>
    800035b8:	0001c517          	auipc	a0,0x1c
    800035bc:	4c050513          	addi	a0,a0,1216 # 8001fa78 <ftable>
    800035c0:	051020ef          	jal	80005e10 <initlock>
}
    800035c4:	60a2                	ld	ra,8(sp)
    800035c6:	6402                	ld	s0,0(sp)
    800035c8:	0141                	addi	sp,sp,16
    800035ca:	8082                	ret

00000000800035cc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800035cc:	1101                	addi	sp,sp,-32
    800035ce:	ec06                	sd	ra,24(sp)
    800035d0:	e822                	sd	s0,16(sp)
    800035d2:	e426                	sd	s1,8(sp)
    800035d4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800035d6:	0001c517          	auipc	a0,0x1c
    800035da:	4a250513          	addi	a0,a0,1186 # 8001fa78 <ftable>
    800035de:	0b3020ef          	jal	80005e90 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800035e2:	0001c497          	auipc	s1,0x1c
    800035e6:	4ae48493          	addi	s1,s1,1198 # 8001fa90 <ftable+0x18>
    800035ea:	0001d717          	auipc	a4,0x1d
    800035ee:	44670713          	addi	a4,a4,1094 # 80020a30 <disk>
    if(f->ref == 0){
    800035f2:	40dc                	lw	a5,4(s1)
    800035f4:	cf89                	beqz	a5,8000360e <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800035f6:	02848493          	addi	s1,s1,40
    800035fa:	fee49ce3          	bne	s1,a4,800035f2 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800035fe:	0001c517          	auipc	a0,0x1c
    80003602:	47a50513          	addi	a0,a0,1146 # 8001fa78 <ftable>
    80003606:	123020ef          	jal	80005f28 <release>
  return 0;
    8000360a:	4481                	li	s1,0
    8000360c:	a809                	j	8000361e <filealloc+0x52>
      f->ref = 1;
    8000360e:	4785                	li	a5,1
    80003610:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003612:	0001c517          	auipc	a0,0x1c
    80003616:	46650513          	addi	a0,a0,1126 # 8001fa78 <ftable>
    8000361a:	10f020ef          	jal	80005f28 <release>
}
    8000361e:	8526                	mv	a0,s1
    80003620:	60e2                	ld	ra,24(sp)
    80003622:	6442                	ld	s0,16(sp)
    80003624:	64a2                	ld	s1,8(sp)
    80003626:	6105                	addi	sp,sp,32
    80003628:	8082                	ret

000000008000362a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000362a:	1101                	addi	sp,sp,-32
    8000362c:	ec06                	sd	ra,24(sp)
    8000362e:	e822                	sd	s0,16(sp)
    80003630:	e426                	sd	s1,8(sp)
    80003632:	1000                	addi	s0,sp,32
    80003634:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003636:	0001c517          	auipc	a0,0x1c
    8000363a:	44250513          	addi	a0,a0,1090 # 8001fa78 <ftable>
    8000363e:	053020ef          	jal	80005e90 <acquire>
  if(f->ref < 1)
    80003642:	40dc                	lw	a5,4(s1)
    80003644:	02f05063          	blez	a5,80003664 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003648:	2785                	addiw	a5,a5,1
    8000364a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000364c:	0001c517          	auipc	a0,0x1c
    80003650:	42c50513          	addi	a0,a0,1068 # 8001fa78 <ftable>
    80003654:	0d5020ef          	jal	80005f28 <release>
  return f;
}
    80003658:	8526                	mv	a0,s1
    8000365a:	60e2                	ld	ra,24(sp)
    8000365c:	6442                	ld	s0,16(sp)
    8000365e:	64a2                	ld	s1,8(sp)
    80003660:	6105                	addi	sp,sp,32
    80003662:	8082                	ret
    panic("filedup");
    80003664:	00004517          	auipc	a0,0x4
    80003668:	ee450513          	addi	a0,a0,-284 # 80007548 <etext+0x548>
    8000366c:	4f6020ef          	jal	80005b62 <panic>

0000000080003670 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003670:	7139                	addi	sp,sp,-64
    80003672:	fc06                	sd	ra,56(sp)
    80003674:	f822                	sd	s0,48(sp)
    80003676:	f426                	sd	s1,40(sp)
    80003678:	0080                	addi	s0,sp,64
    8000367a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000367c:	0001c517          	auipc	a0,0x1c
    80003680:	3fc50513          	addi	a0,a0,1020 # 8001fa78 <ftable>
    80003684:	00d020ef          	jal	80005e90 <acquire>
  if(f->ref < 1)
    80003688:	40dc                	lw	a5,4(s1)
    8000368a:	04f05a63          	blez	a5,800036de <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    8000368e:	37fd                	addiw	a5,a5,-1
    80003690:	0007871b          	sext.w	a4,a5
    80003694:	c0dc                	sw	a5,4(s1)
    80003696:	04e04e63          	bgtz	a4,800036f2 <fileclose+0x82>
    8000369a:	f04a                	sd	s2,32(sp)
    8000369c:	ec4e                	sd	s3,24(sp)
    8000369e:	e852                	sd	s4,16(sp)
    800036a0:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800036a2:	0004a903          	lw	s2,0(s1)
    800036a6:	0094ca83          	lbu	s5,9(s1)
    800036aa:	0104ba03          	ld	s4,16(s1)
    800036ae:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800036b2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800036b6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800036ba:	0001c517          	auipc	a0,0x1c
    800036be:	3be50513          	addi	a0,a0,958 # 8001fa78 <ftable>
    800036c2:	067020ef          	jal	80005f28 <release>

  if(ff.type == FD_PIPE){
    800036c6:	4785                	li	a5,1
    800036c8:	04f90063          	beq	s2,a5,80003708 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800036cc:	3979                	addiw	s2,s2,-2
    800036ce:	4785                	li	a5,1
    800036d0:	0527f563          	bgeu	a5,s2,8000371a <fileclose+0xaa>
    800036d4:	7902                	ld	s2,32(sp)
    800036d6:	69e2                	ld	s3,24(sp)
    800036d8:	6a42                	ld	s4,16(sp)
    800036da:	6aa2                	ld	s5,8(sp)
    800036dc:	a00d                	j	800036fe <fileclose+0x8e>
    800036de:	f04a                	sd	s2,32(sp)
    800036e0:	ec4e                	sd	s3,24(sp)
    800036e2:	e852                	sd	s4,16(sp)
    800036e4:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800036e6:	00004517          	auipc	a0,0x4
    800036ea:	e6a50513          	addi	a0,a0,-406 # 80007550 <etext+0x550>
    800036ee:	474020ef          	jal	80005b62 <panic>
    release(&ftable.lock);
    800036f2:	0001c517          	auipc	a0,0x1c
    800036f6:	38650513          	addi	a0,a0,902 # 8001fa78 <ftable>
    800036fa:	02f020ef          	jal	80005f28 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800036fe:	70e2                	ld	ra,56(sp)
    80003700:	7442                	ld	s0,48(sp)
    80003702:	74a2                	ld	s1,40(sp)
    80003704:	6121                	addi	sp,sp,64
    80003706:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003708:	85d6                	mv	a1,s5
    8000370a:	8552                	mv	a0,s4
    8000370c:	336000ef          	jal	80003a42 <pipeclose>
    80003710:	7902                	ld	s2,32(sp)
    80003712:	69e2                	ld	s3,24(sp)
    80003714:	6a42                	ld	s4,16(sp)
    80003716:	6aa2                	ld	s5,8(sp)
    80003718:	b7dd                	j	800036fe <fileclose+0x8e>
    begin_op();
    8000371a:	b3dff0ef          	jal	80003256 <begin_op>
    iput(ff.ip);
    8000371e:	854e                	mv	a0,s3
    80003720:	c22ff0ef          	jal	80002b42 <iput>
    end_op();
    80003724:	b9dff0ef          	jal	800032c0 <end_op>
    80003728:	7902                	ld	s2,32(sp)
    8000372a:	69e2                	ld	s3,24(sp)
    8000372c:	6a42                	ld	s4,16(sp)
    8000372e:	6aa2                	ld	s5,8(sp)
    80003730:	b7f9                	j	800036fe <fileclose+0x8e>

0000000080003732 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003732:	715d                	addi	sp,sp,-80
    80003734:	e486                	sd	ra,72(sp)
    80003736:	e0a2                	sd	s0,64(sp)
    80003738:	fc26                	sd	s1,56(sp)
    8000373a:	f44e                	sd	s3,40(sp)
    8000373c:	0880                	addi	s0,sp,80
    8000373e:	84aa                	mv	s1,a0
    80003740:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003742:	e92fd0ef          	jal	80000dd4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003746:	409c                	lw	a5,0(s1)
    80003748:	37f9                	addiw	a5,a5,-2
    8000374a:	4705                	li	a4,1
    8000374c:	04f76063          	bltu	a4,a5,8000378c <filestat+0x5a>
    80003750:	f84a                	sd	s2,48(sp)
    80003752:	892a                	mv	s2,a0
    ilock(f->ip);
    80003754:	6c88                	ld	a0,24(s1)
    80003756:	a6aff0ef          	jal	800029c0 <ilock>
    stati(f->ip, &st);
    8000375a:	fb840593          	addi	a1,s0,-72
    8000375e:	6c88                	ld	a0,24(s1)
    80003760:	c8aff0ef          	jal	80002bea <stati>
    iunlock(f->ip);
    80003764:	6c88                	ld	a0,24(s1)
    80003766:	b08ff0ef          	jal	80002a6e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000376a:	46e1                	li	a3,24
    8000376c:	fb840613          	addi	a2,s0,-72
    80003770:	85ce                	mv	a1,s3
    80003772:	05093503          	ld	a0,80(s2)
    80003776:	a4cfd0ef          	jal	800009c2 <copyout>
    8000377a:	41f5551b          	sraiw	a0,a0,0x1f
    8000377e:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003780:	60a6                	ld	ra,72(sp)
    80003782:	6406                	ld	s0,64(sp)
    80003784:	74e2                	ld	s1,56(sp)
    80003786:	79a2                	ld	s3,40(sp)
    80003788:	6161                	addi	sp,sp,80
    8000378a:	8082                	ret
  return -1;
    8000378c:	557d                	li	a0,-1
    8000378e:	bfcd                	j	80003780 <filestat+0x4e>

0000000080003790 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003790:	7179                	addi	sp,sp,-48
    80003792:	f406                	sd	ra,40(sp)
    80003794:	f022                	sd	s0,32(sp)
    80003796:	e84a                	sd	s2,16(sp)
    80003798:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000379a:	00854783          	lbu	a5,8(a0)
    8000379e:	cfd1                	beqz	a5,8000383a <fileread+0xaa>
    800037a0:	ec26                	sd	s1,24(sp)
    800037a2:	e44e                	sd	s3,8(sp)
    800037a4:	84aa                	mv	s1,a0
    800037a6:	89ae                	mv	s3,a1
    800037a8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800037aa:	411c                	lw	a5,0(a0)
    800037ac:	4705                	li	a4,1
    800037ae:	04e78363          	beq	a5,a4,800037f4 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800037b2:	470d                	li	a4,3
    800037b4:	04e78763          	beq	a5,a4,80003802 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800037b8:	4709                	li	a4,2
    800037ba:	06e79a63          	bne	a5,a4,8000382e <fileread+0x9e>
    ilock(f->ip);
    800037be:	6d08                	ld	a0,24(a0)
    800037c0:	a00ff0ef          	jal	800029c0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800037c4:	874a                	mv	a4,s2
    800037c6:	5094                	lw	a3,32(s1)
    800037c8:	864e                	mv	a2,s3
    800037ca:	4585                	li	a1,1
    800037cc:	6c88                	ld	a0,24(s1)
    800037ce:	c46ff0ef          	jal	80002c14 <readi>
    800037d2:	892a                	mv	s2,a0
    800037d4:	00a05563          	blez	a0,800037de <fileread+0x4e>
      f->off += r;
    800037d8:	509c                	lw	a5,32(s1)
    800037da:	9fa9                	addw	a5,a5,a0
    800037dc:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800037de:	6c88                	ld	a0,24(s1)
    800037e0:	a8eff0ef          	jal	80002a6e <iunlock>
    800037e4:	64e2                	ld	s1,24(sp)
    800037e6:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800037e8:	854a                	mv	a0,s2
    800037ea:	70a2                	ld	ra,40(sp)
    800037ec:	7402                	ld	s0,32(sp)
    800037ee:	6942                	ld	s2,16(sp)
    800037f0:	6145                	addi	sp,sp,48
    800037f2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800037f4:	6908                	ld	a0,16(a0)
    800037f6:	388000ef          	jal	80003b7e <piperead>
    800037fa:	892a                	mv	s2,a0
    800037fc:	64e2                	ld	s1,24(sp)
    800037fe:	69a2                	ld	s3,8(sp)
    80003800:	b7e5                	j	800037e8 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003802:	02451783          	lh	a5,36(a0)
    80003806:	03079693          	slli	a3,a5,0x30
    8000380a:	92c1                	srli	a3,a3,0x30
    8000380c:	4725                	li	a4,9
    8000380e:	02d76863          	bltu	a4,a3,8000383e <fileread+0xae>
    80003812:	0792                	slli	a5,a5,0x4
    80003814:	0001c717          	auipc	a4,0x1c
    80003818:	1c470713          	addi	a4,a4,452 # 8001f9d8 <devsw>
    8000381c:	97ba                	add	a5,a5,a4
    8000381e:	639c                	ld	a5,0(a5)
    80003820:	c39d                	beqz	a5,80003846 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003822:	4505                	li	a0,1
    80003824:	9782                	jalr	a5
    80003826:	892a                	mv	s2,a0
    80003828:	64e2                	ld	s1,24(sp)
    8000382a:	69a2                	ld	s3,8(sp)
    8000382c:	bf75                	j	800037e8 <fileread+0x58>
    panic("fileread");
    8000382e:	00004517          	auipc	a0,0x4
    80003832:	d3250513          	addi	a0,a0,-718 # 80007560 <etext+0x560>
    80003836:	32c020ef          	jal	80005b62 <panic>
    return -1;
    8000383a:	597d                	li	s2,-1
    8000383c:	b775                	j	800037e8 <fileread+0x58>
      return -1;
    8000383e:	597d                	li	s2,-1
    80003840:	64e2                	ld	s1,24(sp)
    80003842:	69a2                	ld	s3,8(sp)
    80003844:	b755                	j	800037e8 <fileread+0x58>
    80003846:	597d                	li	s2,-1
    80003848:	64e2                	ld	s1,24(sp)
    8000384a:	69a2                	ld	s3,8(sp)
    8000384c:	bf71                	j	800037e8 <fileread+0x58>

000000008000384e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000384e:	00954783          	lbu	a5,9(a0)
    80003852:	10078b63          	beqz	a5,80003968 <filewrite+0x11a>
{
    80003856:	715d                	addi	sp,sp,-80
    80003858:	e486                	sd	ra,72(sp)
    8000385a:	e0a2                	sd	s0,64(sp)
    8000385c:	f84a                	sd	s2,48(sp)
    8000385e:	f052                	sd	s4,32(sp)
    80003860:	e85a                	sd	s6,16(sp)
    80003862:	0880                	addi	s0,sp,80
    80003864:	892a                	mv	s2,a0
    80003866:	8b2e                	mv	s6,a1
    80003868:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000386a:	411c                	lw	a5,0(a0)
    8000386c:	4705                	li	a4,1
    8000386e:	02e78763          	beq	a5,a4,8000389c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003872:	470d                	li	a4,3
    80003874:	02e78863          	beq	a5,a4,800038a4 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003878:	4709                	li	a4,2
    8000387a:	0ce79c63          	bne	a5,a4,80003952 <filewrite+0x104>
    8000387e:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003880:	0ac05863          	blez	a2,80003930 <filewrite+0xe2>
    80003884:	fc26                	sd	s1,56(sp)
    80003886:	ec56                	sd	s5,24(sp)
    80003888:	e45e                	sd	s7,8(sp)
    8000388a:	e062                	sd	s8,0(sp)
    int i = 0;
    8000388c:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000388e:	6b85                	lui	s7,0x1
    80003890:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003894:	6c05                	lui	s8,0x1
    80003896:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000389a:	a8b5                	j	80003916 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000389c:	6908                	ld	a0,16(a0)
    8000389e:	1fc000ef          	jal	80003a9a <pipewrite>
    800038a2:	a04d                	j	80003944 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800038a4:	02451783          	lh	a5,36(a0)
    800038a8:	03079693          	slli	a3,a5,0x30
    800038ac:	92c1                	srli	a3,a3,0x30
    800038ae:	4725                	li	a4,9
    800038b0:	0ad76e63          	bltu	a4,a3,8000396c <filewrite+0x11e>
    800038b4:	0792                	slli	a5,a5,0x4
    800038b6:	0001c717          	auipc	a4,0x1c
    800038ba:	12270713          	addi	a4,a4,290 # 8001f9d8 <devsw>
    800038be:	97ba                	add	a5,a5,a4
    800038c0:	679c                	ld	a5,8(a5)
    800038c2:	c7dd                	beqz	a5,80003970 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800038c4:	4505                	li	a0,1
    800038c6:	9782                	jalr	a5
    800038c8:	a8b5                	j	80003944 <filewrite+0xf6>
      if(n1 > max)
    800038ca:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800038ce:	989ff0ef          	jal	80003256 <begin_op>
      ilock(f->ip);
    800038d2:	01893503          	ld	a0,24(s2)
    800038d6:	8eaff0ef          	jal	800029c0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800038da:	8756                	mv	a4,s5
    800038dc:	02092683          	lw	a3,32(s2)
    800038e0:	01698633          	add	a2,s3,s6
    800038e4:	4585                	li	a1,1
    800038e6:	01893503          	ld	a0,24(s2)
    800038ea:	c26ff0ef          	jal	80002d10 <writei>
    800038ee:	84aa                	mv	s1,a0
    800038f0:	00a05763          	blez	a0,800038fe <filewrite+0xb0>
        f->off += r;
    800038f4:	02092783          	lw	a5,32(s2)
    800038f8:	9fa9                	addw	a5,a5,a0
    800038fa:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800038fe:	01893503          	ld	a0,24(s2)
    80003902:	96cff0ef          	jal	80002a6e <iunlock>
      end_op();
    80003906:	9bbff0ef          	jal	800032c0 <end_op>

      if(r != n1){
    8000390a:	029a9563          	bne	s5,s1,80003934 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000390e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003912:	0149da63          	bge	s3,s4,80003926 <filewrite+0xd8>
      int n1 = n - i;
    80003916:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000391a:	0004879b          	sext.w	a5,s1
    8000391e:	fafbd6e3          	bge	s7,a5,800038ca <filewrite+0x7c>
    80003922:	84e2                	mv	s1,s8
    80003924:	b75d                	j	800038ca <filewrite+0x7c>
    80003926:	74e2                	ld	s1,56(sp)
    80003928:	6ae2                	ld	s5,24(sp)
    8000392a:	6ba2                	ld	s7,8(sp)
    8000392c:	6c02                	ld	s8,0(sp)
    8000392e:	a039                	j	8000393c <filewrite+0xee>
    int i = 0;
    80003930:	4981                	li	s3,0
    80003932:	a029                	j	8000393c <filewrite+0xee>
    80003934:	74e2                	ld	s1,56(sp)
    80003936:	6ae2                	ld	s5,24(sp)
    80003938:	6ba2                	ld	s7,8(sp)
    8000393a:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000393c:	033a1c63          	bne	s4,s3,80003974 <filewrite+0x126>
    80003940:	8552                	mv	a0,s4
    80003942:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003944:	60a6                	ld	ra,72(sp)
    80003946:	6406                	ld	s0,64(sp)
    80003948:	7942                	ld	s2,48(sp)
    8000394a:	7a02                	ld	s4,32(sp)
    8000394c:	6b42                	ld	s6,16(sp)
    8000394e:	6161                	addi	sp,sp,80
    80003950:	8082                	ret
    80003952:	fc26                	sd	s1,56(sp)
    80003954:	f44e                	sd	s3,40(sp)
    80003956:	ec56                	sd	s5,24(sp)
    80003958:	e45e                	sd	s7,8(sp)
    8000395a:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000395c:	00004517          	auipc	a0,0x4
    80003960:	c1450513          	addi	a0,a0,-1004 # 80007570 <etext+0x570>
    80003964:	1fe020ef          	jal	80005b62 <panic>
    return -1;
    80003968:	557d                	li	a0,-1
}
    8000396a:	8082                	ret
      return -1;
    8000396c:	557d                	li	a0,-1
    8000396e:	bfd9                	j	80003944 <filewrite+0xf6>
    80003970:	557d                	li	a0,-1
    80003972:	bfc9                	j	80003944 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003974:	557d                	li	a0,-1
    80003976:	79a2                	ld	s3,40(sp)
    80003978:	b7f1                	j	80003944 <filewrite+0xf6>

000000008000397a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000397a:	7179                	addi	sp,sp,-48
    8000397c:	f406                	sd	ra,40(sp)
    8000397e:	f022                	sd	s0,32(sp)
    80003980:	ec26                	sd	s1,24(sp)
    80003982:	e052                	sd	s4,0(sp)
    80003984:	1800                	addi	s0,sp,48
    80003986:	84aa                	mv	s1,a0
    80003988:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000398a:	0005b023          	sd	zero,0(a1)
    8000398e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003992:	c3bff0ef          	jal	800035cc <filealloc>
    80003996:	e088                	sd	a0,0(s1)
    80003998:	c549                	beqz	a0,80003a22 <pipealloc+0xa8>
    8000399a:	c33ff0ef          	jal	800035cc <filealloc>
    8000399e:	00aa3023          	sd	a0,0(s4)
    800039a2:	cd25                	beqz	a0,80003a1a <pipealloc+0xa0>
    800039a4:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800039a6:	f58fc0ef          	jal	800000fe <kalloc>
    800039aa:	892a                	mv	s2,a0
    800039ac:	c12d                	beqz	a0,80003a0e <pipealloc+0x94>
    800039ae:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800039b0:	4985                	li	s3,1
    800039b2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800039b6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800039ba:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800039be:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800039c2:	00004597          	auipc	a1,0x4
    800039c6:	bbe58593          	addi	a1,a1,-1090 # 80007580 <etext+0x580>
    800039ca:	446020ef          	jal	80005e10 <initlock>
  (*f0)->type = FD_PIPE;
    800039ce:	609c                	ld	a5,0(s1)
    800039d0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800039d4:	609c                	ld	a5,0(s1)
    800039d6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800039da:	609c                	ld	a5,0(s1)
    800039dc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800039e0:	609c                	ld	a5,0(s1)
    800039e2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800039e6:	000a3783          	ld	a5,0(s4)
    800039ea:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800039ee:	000a3783          	ld	a5,0(s4)
    800039f2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800039f6:	000a3783          	ld	a5,0(s4)
    800039fa:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800039fe:	000a3783          	ld	a5,0(s4)
    80003a02:	0127b823          	sd	s2,16(a5)
  return 0;
    80003a06:	4501                	li	a0,0
    80003a08:	6942                	ld	s2,16(sp)
    80003a0a:	69a2                	ld	s3,8(sp)
    80003a0c:	a01d                	j	80003a32 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003a0e:	6088                	ld	a0,0(s1)
    80003a10:	c119                	beqz	a0,80003a16 <pipealloc+0x9c>
    80003a12:	6942                	ld	s2,16(sp)
    80003a14:	a029                	j	80003a1e <pipealloc+0xa4>
    80003a16:	6942                	ld	s2,16(sp)
    80003a18:	a029                	j	80003a22 <pipealloc+0xa8>
    80003a1a:	6088                	ld	a0,0(s1)
    80003a1c:	c10d                	beqz	a0,80003a3e <pipealloc+0xc4>
    fileclose(*f0);
    80003a1e:	c53ff0ef          	jal	80003670 <fileclose>
  if(*f1)
    80003a22:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003a26:	557d                	li	a0,-1
  if(*f1)
    80003a28:	c789                	beqz	a5,80003a32 <pipealloc+0xb8>
    fileclose(*f1);
    80003a2a:	853e                	mv	a0,a5
    80003a2c:	c45ff0ef          	jal	80003670 <fileclose>
  return -1;
    80003a30:	557d                	li	a0,-1
}
    80003a32:	70a2                	ld	ra,40(sp)
    80003a34:	7402                	ld	s0,32(sp)
    80003a36:	64e2                	ld	s1,24(sp)
    80003a38:	6a02                	ld	s4,0(sp)
    80003a3a:	6145                	addi	sp,sp,48
    80003a3c:	8082                	ret
  return -1;
    80003a3e:	557d                	li	a0,-1
    80003a40:	bfcd                	j	80003a32 <pipealloc+0xb8>

0000000080003a42 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003a42:	1101                	addi	sp,sp,-32
    80003a44:	ec06                	sd	ra,24(sp)
    80003a46:	e822                	sd	s0,16(sp)
    80003a48:	e426                	sd	s1,8(sp)
    80003a4a:	e04a                	sd	s2,0(sp)
    80003a4c:	1000                	addi	s0,sp,32
    80003a4e:	84aa                	mv	s1,a0
    80003a50:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003a52:	43e020ef          	jal	80005e90 <acquire>
  if(writable){
    80003a56:	02090763          	beqz	s2,80003a84 <pipeclose+0x42>
    pi->writeopen = 0;
    80003a5a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003a5e:	21848513          	addi	a0,s1,536
    80003a62:	c57fd0ef          	jal	800016b8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003a66:	2204b783          	ld	a5,544(s1)
    80003a6a:	e785                	bnez	a5,80003a92 <pipeclose+0x50>
    release(&pi->lock);
    80003a6c:	8526                	mv	a0,s1
    80003a6e:	4ba020ef          	jal	80005f28 <release>
    kfree((char*)pi);
    80003a72:	8526                	mv	a0,s1
    80003a74:	da8fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003a78:	60e2                	ld	ra,24(sp)
    80003a7a:	6442                	ld	s0,16(sp)
    80003a7c:	64a2                	ld	s1,8(sp)
    80003a7e:	6902                	ld	s2,0(sp)
    80003a80:	6105                	addi	sp,sp,32
    80003a82:	8082                	ret
    pi->readopen = 0;
    80003a84:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003a88:	21c48513          	addi	a0,s1,540
    80003a8c:	c2dfd0ef          	jal	800016b8 <wakeup>
    80003a90:	bfd9                	j	80003a66 <pipeclose+0x24>
    release(&pi->lock);
    80003a92:	8526                	mv	a0,s1
    80003a94:	494020ef          	jal	80005f28 <release>
}
    80003a98:	b7c5                	j	80003a78 <pipeclose+0x36>

0000000080003a9a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003a9a:	711d                	addi	sp,sp,-96
    80003a9c:	ec86                	sd	ra,88(sp)
    80003a9e:	e8a2                	sd	s0,80(sp)
    80003aa0:	e4a6                	sd	s1,72(sp)
    80003aa2:	e0ca                	sd	s2,64(sp)
    80003aa4:	fc4e                	sd	s3,56(sp)
    80003aa6:	f852                	sd	s4,48(sp)
    80003aa8:	f456                	sd	s5,40(sp)
    80003aaa:	1080                	addi	s0,sp,96
    80003aac:	84aa                	mv	s1,a0
    80003aae:	8aae                	mv	s5,a1
    80003ab0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ab2:	b22fd0ef          	jal	80000dd4 <myproc>
    80003ab6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ab8:	8526                	mv	a0,s1
    80003aba:	3d6020ef          	jal	80005e90 <acquire>
  while(i < n){
    80003abe:	0b405a63          	blez	s4,80003b72 <pipewrite+0xd8>
    80003ac2:	f05a                	sd	s6,32(sp)
    80003ac4:	ec5e                	sd	s7,24(sp)
    80003ac6:	e862                	sd	s8,16(sp)
  int i = 0;
    80003ac8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003aca:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003acc:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ad0:	21c48b93          	addi	s7,s1,540
    80003ad4:	a81d                	j	80003b0a <pipewrite+0x70>
      release(&pi->lock);
    80003ad6:	8526                	mv	a0,s1
    80003ad8:	450020ef          	jal	80005f28 <release>
      return -1;
    80003adc:	597d                	li	s2,-1
    80003ade:	7b02                	ld	s6,32(sp)
    80003ae0:	6be2                	ld	s7,24(sp)
    80003ae2:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ae4:	854a                	mv	a0,s2
    80003ae6:	60e6                	ld	ra,88(sp)
    80003ae8:	6446                	ld	s0,80(sp)
    80003aea:	64a6                	ld	s1,72(sp)
    80003aec:	6906                	ld	s2,64(sp)
    80003aee:	79e2                	ld	s3,56(sp)
    80003af0:	7a42                	ld	s4,48(sp)
    80003af2:	7aa2                	ld	s5,40(sp)
    80003af4:	6125                	addi	sp,sp,96
    80003af6:	8082                	ret
      wakeup(&pi->nread);
    80003af8:	8562                	mv	a0,s8
    80003afa:	bbffd0ef          	jal	800016b8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003afe:	85a6                	mv	a1,s1
    80003b00:	855e                	mv	a0,s7
    80003b02:	b67fd0ef          	jal	80001668 <sleep>
  while(i < n){
    80003b06:	05495b63          	bge	s2,s4,80003b5c <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003b0a:	2204a783          	lw	a5,544(s1)
    80003b0e:	d7e1                	beqz	a5,80003ad6 <pipewrite+0x3c>
    80003b10:	854e                	mv	a0,s3
    80003b12:	c9bfd0ef          	jal	800017ac <killed>
    80003b16:	f161                	bnez	a0,80003ad6 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003b18:	2184a783          	lw	a5,536(s1)
    80003b1c:	21c4a703          	lw	a4,540(s1)
    80003b20:	2007879b          	addiw	a5,a5,512
    80003b24:	fcf70ae3          	beq	a4,a5,80003af8 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003b28:	4685                	li	a3,1
    80003b2a:	01590633          	add	a2,s2,s5
    80003b2e:	faf40593          	addi	a1,s0,-81
    80003b32:	0509b503          	ld	a0,80(s3)
    80003b36:	f63fc0ef          	jal	80000a98 <copyin>
    80003b3a:	03650e63          	beq	a0,s6,80003b76 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003b3e:	21c4a783          	lw	a5,540(s1)
    80003b42:	0017871b          	addiw	a4,a5,1
    80003b46:	20e4ae23          	sw	a4,540(s1)
    80003b4a:	1ff7f793          	andi	a5,a5,511
    80003b4e:	97a6                	add	a5,a5,s1
    80003b50:	faf44703          	lbu	a4,-81(s0)
    80003b54:	00e78c23          	sb	a4,24(a5)
      i++;
    80003b58:	2905                	addiw	s2,s2,1
    80003b5a:	b775                	j	80003b06 <pipewrite+0x6c>
    80003b5c:	7b02                	ld	s6,32(sp)
    80003b5e:	6be2                	ld	s7,24(sp)
    80003b60:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003b62:	21848513          	addi	a0,s1,536
    80003b66:	b53fd0ef          	jal	800016b8 <wakeup>
  release(&pi->lock);
    80003b6a:	8526                	mv	a0,s1
    80003b6c:	3bc020ef          	jal	80005f28 <release>
  return i;
    80003b70:	bf95                	j	80003ae4 <pipewrite+0x4a>
  int i = 0;
    80003b72:	4901                	li	s2,0
    80003b74:	b7fd                	j	80003b62 <pipewrite+0xc8>
    80003b76:	7b02                	ld	s6,32(sp)
    80003b78:	6be2                	ld	s7,24(sp)
    80003b7a:	6c42                	ld	s8,16(sp)
    80003b7c:	b7dd                	j	80003b62 <pipewrite+0xc8>

0000000080003b7e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003b7e:	715d                	addi	sp,sp,-80
    80003b80:	e486                	sd	ra,72(sp)
    80003b82:	e0a2                	sd	s0,64(sp)
    80003b84:	fc26                	sd	s1,56(sp)
    80003b86:	f84a                	sd	s2,48(sp)
    80003b88:	f44e                	sd	s3,40(sp)
    80003b8a:	f052                	sd	s4,32(sp)
    80003b8c:	ec56                	sd	s5,24(sp)
    80003b8e:	0880                	addi	s0,sp,80
    80003b90:	84aa                	mv	s1,a0
    80003b92:	892e                	mv	s2,a1
    80003b94:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003b96:	a3efd0ef          	jal	80000dd4 <myproc>
    80003b9a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003b9c:	8526                	mv	a0,s1
    80003b9e:	2f2020ef          	jal	80005e90 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ba2:	2184a703          	lw	a4,536(s1)
    80003ba6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003baa:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003bae:	02f71563          	bne	a4,a5,80003bd8 <piperead+0x5a>
    80003bb2:	2244a783          	lw	a5,548(s1)
    80003bb6:	cb85                	beqz	a5,80003be6 <piperead+0x68>
    if(killed(pr)){
    80003bb8:	8552                	mv	a0,s4
    80003bba:	bf3fd0ef          	jal	800017ac <killed>
    80003bbe:	ed19                	bnez	a0,80003bdc <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003bc0:	85a6                	mv	a1,s1
    80003bc2:	854e                	mv	a0,s3
    80003bc4:	aa5fd0ef          	jal	80001668 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003bc8:	2184a703          	lw	a4,536(s1)
    80003bcc:	21c4a783          	lw	a5,540(s1)
    80003bd0:	fef701e3          	beq	a4,a5,80003bb2 <piperead+0x34>
    80003bd4:	e85a                	sd	s6,16(sp)
    80003bd6:	a809                	j	80003be8 <piperead+0x6a>
    80003bd8:	e85a                	sd	s6,16(sp)
    80003bda:	a039                	j	80003be8 <piperead+0x6a>
      release(&pi->lock);
    80003bdc:	8526                	mv	a0,s1
    80003bde:	34a020ef          	jal	80005f28 <release>
      return -1;
    80003be2:	59fd                	li	s3,-1
    80003be4:	a8b1                	j	80003c40 <piperead+0xc2>
    80003be6:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003be8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003bea:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003bec:	05505263          	blez	s5,80003c30 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003bf0:	2184a783          	lw	a5,536(s1)
    80003bf4:	21c4a703          	lw	a4,540(s1)
    80003bf8:	02f70c63          	beq	a4,a5,80003c30 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003bfc:	0017871b          	addiw	a4,a5,1
    80003c00:	20e4ac23          	sw	a4,536(s1)
    80003c04:	1ff7f793          	andi	a5,a5,511
    80003c08:	97a6                	add	a5,a5,s1
    80003c0a:	0187c783          	lbu	a5,24(a5)
    80003c0e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003c12:	4685                	li	a3,1
    80003c14:	fbf40613          	addi	a2,s0,-65
    80003c18:	85ca                	mv	a1,s2
    80003c1a:	050a3503          	ld	a0,80(s4)
    80003c1e:	da5fc0ef          	jal	800009c2 <copyout>
    80003c22:	01650763          	beq	a0,s6,80003c30 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c26:	2985                	addiw	s3,s3,1
    80003c28:	0905                	addi	s2,s2,1
    80003c2a:	fd3a93e3          	bne	s5,s3,80003bf0 <piperead+0x72>
    80003c2e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003c30:	21c48513          	addi	a0,s1,540
    80003c34:	a85fd0ef          	jal	800016b8 <wakeup>
  release(&pi->lock);
    80003c38:	8526                	mv	a0,s1
    80003c3a:	2ee020ef          	jal	80005f28 <release>
    80003c3e:	6b42                	ld	s6,16(sp)
  return i;
}
    80003c40:	854e                	mv	a0,s3
    80003c42:	60a6                	ld	ra,72(sp)
    80003c44:	6406                	ld	s0,64(sp)
    80003c46:	74e2                	ld	s1,56(sp)
    80003c48:	7942                	ld	s2,48(sp)
    80003c4a:	79a2                	ld	s3,40(sp)
    80003c4c:	7a02                	ld	s4,32(sp)
    80003c4e:	6ae2                	ld	s5,24(sp)
    80003c50:	6161                	addi	sp,sp,80
    80003c52:	8082                	ret

0000000080003c54 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003c54:	1141                	addi	sp,sp,-16
    80003c56:	e422                	sd	s0,8(sp)
    80003c58:	0800                	addi	s0,sp,16
    80003c5a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003c5c:	8905                	andi	a0,a0,1
    80003c5e:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003c60:	8b89                	andi	a5,a5,2
    80003c62:	c399                	beqz	a5,80003c68 <flags2perm+0x14>
      perm |= PTE_W;
    80003c64:	00456513          	ori	a0,a0,4
    return perm;
}
    80003c68:	6422                	ld	s0,8(sp)
    80003c6a:	0141                	addi	sp,sp,16
    80003c6c:	8082                	ret

0000000080003c6e <exec>:

int
exec(char *path, char **argv)
{
    80003c6e:	df010113          	addi	sp,sp,-528
    80003c72:	20113423          	sd	ra,520(sp)
    80003c76:	20813023          	sd	s0,512(sp)
    80003c7a:	ffa6                	sd	s1,504(sp)
    80003c7c:	fbca                	sd	s2,496(sp)
    80003c7e:	0c00                	addi	s0,sp,528
    80003c80:	892a                	mv	s2,a0
    80003c82:	dea43c23          	sd	a0,-520(s0)
    80003c86:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003c8a:	94afd0ef          	jal	80000dd4 <myproc>
    80003c8e:	84aa                	mv	s1,a0

  begin_op();
    80003c90:	dc6ff0ef          	jal	80003256 <begin_op>

  if((ip = namei(path)) == 0){
    80003c94:	854a                	mv	a0,s2
    80003c96:	c04ff0ef          	jal	8000309a <namei>
    80003c9a:	c931                	beqz	a0,80003cee <exec+0x80>
    80003c9c:	f3d2                	sd	s4,480(sp)
    80003c9e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003ca0:	d21fe0ef          	jal	800029c0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003ca4:	04000713          	li	a4,64
    80003ca8:	4681                	li	a3,0
    80003caa:	e5040613          	addi	a2,s0,-432
    80003cae:	4581                	li	a1,0
    80003cb0:	8552                	mv	a0,s4
    80003cb2:	f63fe0ef          	jal	80002c14 <readi>
    80003cb6:	04000793          	li	a5,64
    80003cba:	00f51a63          	bne	a0,a5,80003cce <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003cbe:	e5042703          	lw	a4,-432(s0)
    80003cc2:	464c47b7          	lui	a5,0x464c4
    80003cc6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003cca:	02f70663          	beq	a4,a5,80003cf6 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003cce:	8552                	mv	a0,s4
    80003cd0:	efbfe0ef          	jal	80002bca <iunlockput>
    end_op();
    80003cd4:	decff0ef          	jal	800032c0 <end_op>
  }
  return -1;
    80003cd8:	557d                	li	a0,-1
    80003cda:	7a1e                	ld	s4,480(sp)
}
    80003cdc:	20813083          	ld	ra,520(sp)
    80003ce0:	20013403          	ld	s0,512(sp)
    80003ce4:	74fe                	ld	s1,504(sp)
    80003ce6:	795e                	ld	s2,496(sp)
    80003ce8:	21010113          	addi	sp,sp,528
    80003cec:	8082                	ret
    end_op();
    80003cee:	dd2ff0ef          	jal	800032c0 <end_op>
    return -1;
    80003cf2:	557d                	li	a0,-1
    80003cf4:	b7e5                	j	80003cdc <exec+0x6e>
    80003cf6:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003cf8:	8526                	mv	a0,s1
    80003cfa:	982fd0ef          	jal	80000e7c <proc_pagetable>
    80003cfe:	8b2a                	mv	s6,a0
    80003d00:	2c050b63          	beqz	a0,80003fd6 <exec+0x368>
    80003d04:	f7ce                	sd	s3,488(sp)
    80003d06:	efd6                	sd	s5,472(sp)
    80003d08:	e7de                	sd	s7,456(sp)
    80003d0a:	e3e2                	sd	s8,448(sp)
    80003d0c:	ff66                	sd	s9,440(sp)
    80003d0e:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d10:	e7042d03          	lw	s10,-400(s0)
    80003d14:	e8845783          	lhu	a5,-376(s0)
    80003d18:	12078963          	beqz	a5,80003e4a <exec+0x1dc>
    80003d1c:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d1e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d20:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003d22:	6c85                	lui	s9,0x1
    80003d24:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003d28:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003d2c:	6a85                	lui	s5,0x1
    80003d2e:	a085                	j	80003d8e <exec+0x120>
      panic("loadseg: address should exist");
    80003d30:	00004517          	auipc	a0,0x4
    80003d34:	85850513          	addi	a0,a0,-1960 # 80007588 <etext+0x588>
    80003d38:	62b010ef          	jal	80005b62 <panic>
    if(sz - i < PGSIZE)
    80003d3c:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003d3e:	8726                	mv	a4,s1
    80003d40:	012c06bb          	addw	a3,s8,s2
    80003d44:	4581                	li	a1,0
    80003d46:	8552                	mv	a0,s4
    80003d48:	ecdfe0ef          	jal	80002c14 <readi>
    80003d4c:	2501                	sext.w	a0,a0
    80003d4e:	24a49a63          	bne	s1,a0,80003fa2 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003d52:	012a893b          	addw	s2,s5,s2
    80003d56:	03397363          	bgeu	s2,s3,80003d7c <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003d5a:	02091593          	slli	a1,s2,0x20
    80003d5e:	9181                	srli	a1,a1,0x20
    80003d60:	95de                	add	a1,a1,s7
    80003d62:	855a                	mv	a0,s6
    80003d64:	ef8fc0ef          	jal	8000045c <walkaddr>
    80003d68:	862a                	mv	a2,a0
    if(pa == 0)
    80003d6a:	d179                	beqz	a0,80003d30 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003d6c:	412984bb          	subw	s1,s3,s2
    80003d70:	0004879b          	sext.w	a5,s1
    80003d74:	fcfcf4e3          	bgeu	s9,a5,80003d3c <exec+0xce>
    80003d78:	84d6                	mv	s1,s5
    80003d7a:	b7c9                	j	80003d3c <exec+0xce>
    sz = sz1;
    80003d7c:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d80:	2d85                	addiw	s11,s11,1
    80003d82:	038d0d1b          	addiw	s10,s10,56
    80003d86:	e8845783          	lhu	a5,-376(s0)
    80003d8a:	08fdd063          	bge	s11,a5,80003e0a <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003d8e:	2d01                	sext.w	s10,s10
    80003d90:	03800713          	li	a4,56
    80003d94:	86ea                	mv	a3,s10
    80003d96:	e1840613          	addi	a2,s0,-488
    80003d9a:	4581                	li	a1,0
    80003d9c:	8552                	mv	a0,s4
    80003d9e:	e77fe0ef          	jal	80002c14 <readi>
    80003da2:	03800793          	li	a5,56
    80003da6:	1cf51663          	bne	a0,a5,80003f72 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003daa:	e1842783          	lw	a5,-488(s0)
    80003dae:	4705                	li	a4,1
    80003db0:	fce798e3          	bne	a5,a4,80003d80 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003db4:	e4043483          	ld	s1,-448(s0)
    80003db8:	e3843783          	ld	a5,-456(s0)
    80003dbc:	1af4ef63          	bltu	s1,a5,80003f7a <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003dc0:	e2843783          	ld	a5,-472(s0)
    80003dc4:	94be                	add	s1,s1,a5
    80003dc6:	1af4ee63          	bltu	s1,a5,80003f82 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003dca:	df043703          	ld	a4,-528(s0)
    80003dce:	8ff9                	and	a5,a5,a4
    80003dd0:	1a079d63          	bnez	a5,80003f8a <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003dd4:	e1c42503          	lw	a0,-484(s0)
    80003dd8:	e7dff0ef          	jal	80003c54 <flags2perm>
    80003ddc:	86aa                	mv	a3,a0
    80003dde:	8626                	mv	a2,s1
    80003de0:	85ca                	mv	a1,s2
    80003de2:	855a                	mv	a0,s6
    80003de4:	9cbfc0ef          	jal	800007ae <uvmalloc>
    80003de8:	e0a43423          	sd	a0,-504(s0)
    80003dec:	1a050363          	beqz	a0,80003f92 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003df0:	e2843b83          	ld	s7,-472(s0)
    80003df4:	e2042c03          	lw	s8,-480(s0)
    80003df8:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003dfc:	00098463          	beqz	s3,80003e04 <exec+0x196>
    80003e00:	4901                	li	s2,0
    80003e02:	bfa1                	j	80003d5a <exec+0xec>
    sz = sz1;
    80003e04:	e0843903          	ld	s2,-504(s0)
    80003e08:	bfa5                	j	80003d80 <exec+0x112>
    80003e0a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003e0c:	8552                	mv	a0,s4
    80003e0e:	dbdfe0ef          	jal	80002bca <iunlockput>
  end_op();
    80003e12:	caeff0ef          	jal	800032c0 <end_op>
  p = myproc();
    80003e16:	fbffc0ef          	jal	80000dd4 <myproc>
    80003e1a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003e1c:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003e20:	6985                	lui	s3,0x1
    80003e22:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003e24:	99ca                	add	s3,s3,s2
    80003e26:	77fd                	lui	a5,0xfffff
    80003e28:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003e2c:	4691                	li	a3,4
    80003e2e:	6609                	lui	a2,0x2
    80003e30:	964e                	add	a2,a2,s3
    80003e32:	85ce                	mv	a1,s3
    80003e34:	855a                	mv	a0,s6
    80003e36:	979fc0ef          	jal	800007ae <uvmalloc>
    80003e3a:	892a                	mv	s2,a0
    80003e3c:	e0a43423          	sd	a0,-504(s0)
    80003e40:	e519                	bnez	a0,80003e4e <exec+0x1e0>
  if(pagetable)
    80003e42:	e1343423          	sd	s3,-504(s0)
    80003e46:	4a01                	li	s4,0
    80003e48:	aab1                	j	80003fa4 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003e4a:	4901                	li	s2,0
    80003e4c:	b7c1                	j	80003e0c <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003e4e:	75f9                	lui	a1,0xffffe
    80003e50:	95aa                	add	a1,a1,a0
    80003e52:	855a                	mv	a0,s6
    80003e54:	b45fc0ef          	jal	80000998 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003e58:	7bfd                	lui	s7,0xfffff
    80003e5a:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003e5c:	e0043783          	ld	a5,-512(s0)
    80003e60:	6388                	ld	a0,0(a5)
    80003e62:	cd39                	beqz	a0,80003ec0 <exec+0x252>
    80003e64:	e9040993          	addi	s3,s0,-368
    80003e68:	f9040c13          	addi	s8,s0,-112
    80003e6c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003e6e:	c50fc0ef          	jal	800002be <strlen>
    80003e72:	0015079b          	addiw	a5,a0,1
    80003e76:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003e7a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003e7e:	11796e63          	bltu	s2,s7,80003f9a <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003e82:	e0043d03          	ld	s10,-512(s0)
    80003e86:	000d3a03          	ld	s4,0(s10)
    80003e8a:	8552                	mv	a0,s4
    80003e8c:	c32fc0ef          	jal	800002be <strlen>
    80003e90:	0015069b          	addiw	a3,a0,1
    80003e94:	8652                	mv	a2,s4
    80003e96:	85ca                	mv	a1,s2
    80003e98:	855a                	mv	a0,s6
    80003e9a:	b29fc0ef          	jal	800009c2 <copyout>
    80003e9e:	10054063          	bltz	a0,80003f9e <exec+0x330>
    ustack[argc] = sp;
    80003ea2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003ea6:	0485                	addi	s1,s1,1
    80003ea8:	008d0793          	addi	a5,s10,8
    80003eac:	e0f43023          	sd	a5,-512(s0)
    80003eb0:	008d3503          	ld	a0,8(s10)
    80003eb4:	c909                	beqz	a0,80003ec6 <exec+0x258>
    if(argc >= MAXARG)
    80003eb6:	09a1                	addi	s3,s3,8
    80003eb8:	fb899be3          	bne	s3,s8,80003e6e <exec+0x200>
  ip = 0;
    80003ebc:	4a01                	li	s4,0
    80003ebe:	a0dd                	j	80003fa4 <exec+0x336>
  sp = sz;
    80003ec0:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003ec4:	4481                	li	s1,0
  ustack[argc] = 0;
    80003ec6:	00349793          	slli	a5,s1,0x3
    80003eca:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd6320>
    80003ece:	97a2                	add	a5,a5,s0
    80003ed0:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003ed4:	00148693          	addi	a3,s1,1
    80003ed8:	068e                	slli	a3,a3,0x3
    80003eda:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003ede:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003ee2:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003ee6:	f5796ee3          	bltu	s2,s7,80003e42 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003eea:	e9040613          	addi	a2,s0,-368
    80003eee:	85ca                	mv	a1,s2
    80003ef0:	855a                	mv	a0,s6
    80003ef2:	ad1fc0ef          	jal	800009c2 <copyout>
    80003ef6:	0e054263          	bltz	a0,80003fda <exec+0x36c>
  p->trapframe->a1 = sp;
    80003efa:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003efe:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003f02:	df843783          	ld	a5,-520(s0)
    80003f06:	0007c703          	lbu	a4,0(a5)
    80003f0a:	cf11                	beqz	a4,80003f26 <exec+0x2b8>
    80003f0c:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003f0e:	02f00693          	li	a3,47
    80003f12:	a039                	j	80003f20 <exec+0x2b2>
      last = s+1;
    80003f14:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003f18:	0785                	addi	a5,a5,1
    80003f1a:	fff7c703          	lbu	a4,-1(a5)
    80003f1e:	c701                	beqz	a4,80003f26 <exec+0x2b8>
    if(*s == '/')
    80003f20:	fed71ce3          	bne	a4,a3,80003f18 <exec+0x2aa>
    80003f24:	bfc5                	j	80003f14 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003f26:	4641                	li	a2,16
    80003f28:	df843583          	ld	a1,-520(s0)
    80003f2c:	158a8513          	addi	a0,s5,344
    80003f30:	b5cfc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003f34:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003f38:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003f3c:	e0843783          	ld	a5,-504(s0)
    80003f40:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003f44:	058ab783          	ld	a5,88(s5)
    80003f48:	e6843703          	ld	a4,-408(s0)
    80003f4c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003f4e:	058ab783          	ld	a5,88(s5)
    80003f52:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003f56:	85e6                	mv	a1,s9
    80003f58:	fa9fc0ef          	jal	80000f00 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003f5c:	0004851b          	sext.w	a0,s1
    80003f60:	79be                	ld	s3,488(sp)
    80003f62:	7a1e                	ld	s4,480(sp)
    80003f64:	6afe                	ld	s5,472(sp)
    80003f66:	6b5e                	ld	s6,464(sp)
    80003f68:	6bbe                	ld	s7,456(sp)
    80003f6a:	6c1e                	ld	s8,448(sp)
    80003f6c:	7cfa                	ld	s9,440(sp)
    80003f6e:	7d5a                	ld	s10,432(sp)
    80003f70:	b3b5                	j	80003cdc <exec+0x6e>
    80003f72:	e1243423          	sd	s2,-504(s0)
    80003f76:	7dba                	ld	s11,424(sp)
    80003f78:	a035                	j	80003fa4 <exec+0x336>
    80003f7a:	e1243423          	sd	s2,-504(s0)
    80003f7e:	7dba                	ld	s11,424(sp)
    80003f80:	a015                	j	80003fa4 <exec+0x336>
    80003f82:	e1243423          	sd	s2,-504(s0)
    80003f86:	7dba                	ld	s11,424(sp)
    80003f88:	a831                	j	80003fa4 <exec+0x336>
    80003f8a:	e1243423          	sd	s2,-504(s0)
    80003f8e:	7dba                	ld	s11,424(sp)
    80003f90:	a811                	j	80003fa4 <exec+0x336>
    80003f92:	e1243423          	sd	s2,-504(s0)
    80003f96:	7dba                	ld	s11,424(sp)
    80003f98:	a031                	j	80003fa4 <exec+0x336>
  ip = 0;
    80003f9a:	4a01                	li	s4,0
    80003f9c:	a021                	j	80003fa4 <exec+0x336>
    80003f9e:	4a01                	li	s4,0
  if(pagetable)
    80003fa0:	a011                	j	80003fa4 <exec+0x336>
    80003fa2:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003fa4:	e0843583          	ld	a1,-504(s0)
    80003fa8:	855a                	mv	a0,s6
    80003faa:	f57fc0ef          	jal	80000f00 <proc_freepagetable>
  return -1;
    80003fae:	557d                	li	a0,-1
  if(ip){
    80003fb0:	000a1b63          	bnez	s4,80003fc6 <exec+0x358>
    80003fb4:	79be                	ld	s3,488(sp)
    80003fb6:	7a1e                	ld	s4,480(sp)
    80003fb8:	6afe                	ld	s5,472(sp)
    80003fba:	6b5e                	ld	s6,464(sp)
    80003fbc:	6bbe                	ld	s7,456(sp)
    80003fbe:	6c1e                	ld	s8,448(sp)
    80003fc0:	7cfa                	ld	s9,440(sp)
    80003fc2:	7d5a                	ld	s10,432(sp)
    80003fc4:	bb21                	j	80003cdc <exec+0x6e>
    80003fc6:	79be                	ld	s3,488(sp)
    80003fc8:	6afe                	ld	s5,472(sp)
    80003fca:	6b5e                	ld	s6,464(sp)
    80003fcc:	6bbe                	ld	s7,456(sp)
    80003fce:	6c1e                	ld	s8,448(sp)
    80003fd0:	7cfa                	ld	s9,440(sp)
    80003fd2:	7d5a                	ld	s10,432(sp)
    80003fd4:	b9ed                	j	80003cce <exec+0x60>
    80003fd6:	6b5e                	ld	s6,464(sp)
    80003fd8:	b9dd                	j	80003cce <exec+0x60>
  sz = sz1;
    80003fda:	e0843983          	ld	s3,-504(s0)
    80003fde:	b595                	j	80003e42 <exec+0x1d4>

0000000080003fe0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003fe0:	7179                	addi	sp,sp,-48
    80003fe2:	f406                	sd	ra,40(sp)
    80003fe4:	f022                	sd	s0,32(sp)
    80003fe6:	ec26                	sd	s1,24(sp)
    80003fe8:	e84a                	sd	s2,16(sp)
    80003fea:	1800                	addi	s0,sp,48
    80003fec:	892e                	mv	s2,a1
    80003fee:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80003ff0:	fdc40593          	addi	a1,s0,-36
    80003ff4:	fa5fd0ef          	jal	80001f98 <argint>
    80003ff8:	02054e63          	bltz	a0,80004034 <argfd+0x54>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003ffc:	fdc42703          	lw	a4,-36(s0)
    80004000:	47bd                	li	a5,15
    80004002:	02e7eb63          	bltu	a5,a4,80004038 <argfd+0x58>
    80004006:	dcffc0ef          	jal	80000dd4 <myproc>
    8000400a:	fdc42703          	lw	a4,-36(s0)
    8000400e:	01a70793          	addi	a5,a4,26
    80004012:	078e                	slli	a5,a5,0x3
    80004014:	953e                	add	a0,a0,a5
    80004016:	611c                	ld	a5,0(a0)
    80004018:	c395                	beqz	a5,8000403c <argfd+0x5c>
    return -1;
  if(pfd)
    8000401a:	00090463          	beqz	s2,80004022 <argfd+0x42>
    *pfd = fd;
    8000401e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004022:	4501                	li	a0,0
  if(pf)
    80004024:	c091                	beqz	s1,80004028 <argfd+0x48>
    *pf = f;
    80004026:	e09c                	sd	a5,0(s1)
}
    80004028:	70a2                	ld	ra,40(sp)
    8000402a:	7402                	ld	s0,32(sp)
    8000402c:	64e2                	ld	s1,24(sp)
    8000402e:	6942                	ld	s2,16(sp)
    80004030:	6145                	addi	sp,sp,48
    80004032:	8082                	ret
    return -1;
    80004034:	557d                	li	a0,-1
    80004036:	bfcd                	j	80004028 <argfd+0x48>
    return -1;
    80004038:	557d                	li	a0,-1
    8000403a:	b7fd                	j	80004028 <argfd+0x48>
    8000403c:	557d                	li	a0,-1
    8000403e:	b7ed                	j	80004028 <argfd+0x48>

0000000080004040 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004040:	1101                	addi	sp,sp,-32
    80004042:	ec06                	sd	ra,24(sp)
    80004044:	e822                	sd	s0,16(sp)
    80004046:	e426                	sd	s1,8(sp)
    80004048:	1000                	addi	s0,sp,32
    8000404a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000404c:	d89fc0ef          	jal	80000dd4 <myproc>
    80004050:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004052:	0d050793          	addi	a5,a0,208
    80004056:	4501                	li	a0,0
    80004058:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000405a:	6398                	ld	a4,0(a5)
    8000405c:	cb19                	beqz	a4,80004072 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000405e:	2505                	addiw	a0,a0,1
    80004060:	07a1                	addi	a5,a5,8
    80004062:	fed51ce3          	bne	a0,a3,8000405a <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004066:	557d                	li	a0,-1
}
    80004068:	60e2                	ld	ra,24(sp)
    8000406a:	6442                	ld	s0,16(sp)
    8000406c:	64a2                	ld	s1,8(sp)
    8000406e:	6105                	addi	sp,sp,32
    80004070:	8082                	ret
      p->ofile[fd] = f;
    80004072:	01a50793          	addi	a5,a0,26
    80004076:	078e                	slli	a5,a5,0x3
    80004078:	963e                	add	a2,a2,a5
    8000407a:	e204                	sd	s1,0(a2)
      return fd;
    8000407c:	b7f5                	j	80004068 <fdalloc+0x28>

000000008000407e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000407e:	715d                	addi	sp,sp,-80
    80004080:	e486                	sd	ra,72(sp)
    80004082:	e0a2                	sd	s0,64(sp)
    80004084:	fc26                	sd	s1,56(sp)
    80004086:	f84a                	sd	s2,48(sp)
    80004088:	f44e                	sd	s3,40(sp)
    8000408a:	f052                	sd	s4,32(sp)
    8000408c:	ec56                	sd	s5,24(sp)
    8000408e:	0880                	addi	s0,sp,80
    80004090:	8aae                	mv	s5,a1
    80004092:	8a32                	mv	s4,a2
    80004094:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004096:	fb040593          	addi	a1,s0,-80
    8000409a:	81aff0ef          	jal	800030b4 <nameiparent>
    8000409e:	892a                	mv	s2,a0
    800040a0:	0e050c63          	beqz	a0,80004198 <create+0x11a>
    return 0;

  ilock(dp);
    800040a4:	91dfe0ef          	jal	800029c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800040a8:	4601                	li	a2,0
    800040aa:	fb040593          	addi	a1,s0,-80
    800040ae:	854a                	mv	a0,s2
    800040b0:	d85fe0ef          	jal	80002e34 <dirlookup>
    800040b4:	84aa                	mv	s1,a0
    800040b6:	c129                	beqz	a0,800040f8 <create+0x7a>
    iunlockput(dp);
    800040b8:	854a                	mv	a0,s2
    800040ba:	b11fe0ef          	jal	80002bca <iunlockput>
    ilock(ip);
    800040be:	8526                	mv	a0,s1
    800040c0:	901fe0ef          	jal	800029c0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800040c4:	4789                	li	a5,2
    800040c6:	02fa9463          	bne	s5,a5,800040ee <create+0x70>
    800040ca:	0444d783          	lhu	a5,68(s1)
    800040ce:	37f9                	addiw	a5,a5,-2
    800040d0:	17c2                	slli	a5,a5,0x30
    800040d2:	93c1                	srli	a5,a5,0x30
    800040d4:	4705                	li	a4,1
    800040d6:	00f76c63          	bltu	a4,a5,800040ee <create+0x70>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800040da:	8526                	mv	a0,s1
    800040dc:	60a6                	ld	ra,72(sp)
    800040de:	6406                	ld	s0,64(sp)
    800040e0:	74e2                	ld	s1,56(sp)
    800040e2:	7942                	ld	s2,48(sp)
    800040e4:	79a2                	ld	s3,40(sp)
    800040e6:	7a02                	ld	s4,32(sp)
    800040e8:	6ae2                	ld	s5,24(sp)
    800040ea:	6161                	addi	sp,sp,80
    800040ec:	8082                	ret
    iunlockput(ip);
    800040ee:	8526                	mv	a0,s1
    800040f0:	adbfe0ef          	jal	80002bca <iunlockput>
    return 0;
    800040f4:	4481                	li	s1,0
    800040f6:	b7d5                	j	800040da <create+0x5c>
  if((ip = ialloc(dp->dev, type)) == 0)
    800040f8:	85d6                	mv	a1,s5
    800040fa:	00092503          	lw	a0,0(s2)
    800040fe:	f52fe0ef          	jal	80002850 <ialloc>
    80004102:	84aa                	mv	s1,a0
    80004104:	c91d                	beqz	a0,8000413a <create+0xbc>
  ilock(ip);
    80004106:	8bbfe0ef          	jal	800029c0 <ilock>
  ip->major = major;
    8000410a:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    8000410e:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004112:	4985                	li	s3,1
    80004114:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004118:	8526                	mv	a0,s1
    8000411a:	ff2fe0ef          	jal	8000290c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000411e:	033a8463          	beq	s5,s3,80004146 <create+0xc8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004122:	40d0                	lw	a2,4(s1)
    80004124:	fb040593          	addi	a1,s0,-80
    80004128:	854a                	mv	a0,s2
    8000412a:	ed7fe0ef          	jal	80003000 <dirlink>
    8000412e:	04054f63          	bltz	a0,8000418c <create+0x10e>
  iunlockput(dp);
    80004132:	854a                	mv	a0,s2
    80004134:	a97fe0ef          	jal	80002bca <iunlockput>
  return ip;
    80004138:	b74d                	j	800040da <create+0x5c>
    panic("create: ialloc");
    8000413a:	00003517          	auipc	a0,0x3
    8000413e:	46e50513          	addi	a0,a0,1134 # 800075a8 <etext+0x5a8>
    80004142:	221010ef          	jal	80005b62 <panic>
    dp->nlink++;  // for ".."
    80004146:	04a95783          	lhu	a5,74(s2)
    8000414a:	2785                	addiw	a5,a5,1
    8000414c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004150:	854a                	mv	a0,s2
    80004152:	fbafe0ef          	jal	8000290c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004156:	40d0                	lw	a2,4(s1)
    80004158:	00003597          	auipc	a1,0x3
    8000415c:	46058593          	addi	a1,a1,1120 # 800075b8 <etext+0x5b8>
    80004160:	8526                	mv	a0,s1
    80004162:	e9ffe0ef          	jal	80003000 <dirlink>
    80004166:	00054d63          	bltz	a0,80004180 <create+0x102>
    8000416a:	00492603          	lw	a2,4(s2)
    8000416e:	00003597          	auipc	a1,0x3
    80004172:	45258593          	addi	a1,a1,1106 # 800075c0 <etext+0x5c0>
    80004176:	8526                	mv	a0,s1
    80004178:	e89fe0ef          	jal	80003000 <dirlink>
    8000417c:	fa0553e3          	bgez	a0,80004122 <create+0xa4>
      panic("create dots");
    80004180:	00003517          	auipc	a0,0x3
    80004184:	44850513          	addi	a0,a0,1096 # 800075c8 <etext+0x5c8>
    80004188:	1db010ef          	jal	80005b62 <panic>
    panic("create: dirlink");
    8000418c:	00003517          	auipc	a0,0x3
    80004190:	44c50513          	addi	a0,a0,1100 # 800075d8 <etext+0x5d8>
    80004194:	1cf010ef          	jal	80005b62 <panic>
    return 0;
    80004198:	84aa                	mv	s1,a0
    8000419a:	b781                	j	800040da <create+0x5c>

000000008000419c <sys_dup>:
{
    8000419c:	7179                	addi	sp,sp,-48
    8000419e:	f406                	sd	ra,40(sp)
    800041a0:	f022                	sd	s0,32(sp)
    800041a2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800041a4:	fd840613          	addi	a2,s0,-40
    800041a8:	4581                	li	a1,0
    800041aa:	4501                	li	a0,0
    800041ac:	e35ff0ef          	jal	80003fe0 <argfd>
    return -1;
    800041b0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800041b2:	02054363          	bltz	a0,800041d8 <sys_dup+0x3c>
    800041b6:	ec26                	sd	s1,24(sp)
    800041b8:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800041ba:	fd843903          	ld	s2,-40(s0)
    800041be:	854a                	mv	a0,s2
    800041c0:	e81ff0ef          	jal	80004040 <fdalloc>
    800041c4:	84aa                	mv	s1,a0
    return -1;
    800041c6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800041c8:	00054d63          	bltz	a0,800041e2 <sys_dup+0x46>
  filedup(f);
    800041cc:	854a                	mv	a0,s2
    800041ce:	c5cff0ef          	jal	8000362a <filedup>
  return fd;
    800041d2:	87a6                	mv	a5,s1
    800041d4:	64e2                	ld	s1,24(sp)
    800041d6:	6942                	ld	s2,16(sp)
}
    800041d8:	853e                	mv	a0,a5
    800041da:	70a2                	ld	ra,40(sp)
    800041dc:	7402                	ld	s0,32(sp)
    800041de:	6145                	addi	sp,sp,48
    800041e0:	8082                	ret
    800041e2:	64e2                	ld	s1,24(sp)
    800041e4:	6942                	ld	s2,16(sp)
    800041e6:	bfcd                	j	800041d8 <sys_dup+0x3c>

00000000800041e8 <sys_read>:
{
    800041e8:	7179                	addi	sp,sp,-48
    800041ea:	f406                	sd	ra,40(sp)
    800041ec:	f022                	sd	s0,32(sp)
    800041ee:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800041f0:	fe840613          	addi	a2,s0,-24
    800041f4:	4581                	li	a1,0
    800041f6:	4501                	li	a0,0
    800041f8:	de9ff0ef          	jal	80003fe0 <argfd>
    return -1;
    800041fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800041fe:	02054b63          	bltz	a0,80004234 <sys_read+0x4c>
    80004202:	fe440593          	addi	a1,s0,-28
    80004206:	4509                	li	a0,2
    80004208:	d91fd0ef          	jal	80001f98 <argint>
    return -1;
    8000420c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000420e:	02054363          	bltz	a0,80004234 <sys_read+0x4c>
    80004212:	fd840593          	addi	a1,s0,-40
    80004216:	4505                	li	a0,1
    80004218:	d9ffd0ef          	jal	80001fb6 <argaddr>
    return -1;
    8000421c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000421e:	00054b63          	bltz	a0,80004234 <sys_read+0x4c>
  return fileread(f, p, n);
    80004222:	fe442603          	lw	a2,-28(s0)
    80004226:	fd843583          	ld	a1,-40(s0)
    8000422a:	fe843503          	ld	a0,-24(s0)
    8000422e:	d62ff0ef          	jal	80003790 <fileread>
    80004232:	87aa                	mv	a5,a0
}
    80004234:	853e                	mv	a0,a5
    80004236:	70a2                	ld	ra,40(sp)
    80004238:	7402                	ld	s0,32(sp)
    8000423a:	6145                	addi	sp,sp,48
    8000423c:	8082                	ret

000000008000423e <sys_write>:
{
    8000423e:	7179                	addi	sp,sp,-48
    80004240:	f406                	sd	ra,40(sp)
    80004242:	f022                	sd	s0,32(sp)
    80004244:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004246:	fe840613          	addi	a2,s0,-24
    8000424a:	4581                	li	a1,0
    8000424c:	4501                	li	a0,0
    8000424e:	d93ff0ef          	jal	80003fe0 <argfd>
    return -1;
    80004252:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004254:	02054b63          	bltz	a0,8000428a <sys_write+0x4c>
    80004258:	fe440593          	addi	a1,s0,-28
    8000425c:	4509                	li	a0,2
    8000425e:	d3bfd0ef          	jal	80001f98 <argint>
    return -1;
    80004262:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004264:	02054363          	bltz	a0,8000428a <sys_write+0x4c>
    80004268:	fd840593          	addi	a1,s0,-40
    8000426c:	4505                	li	a0,1
    8000426e:	d49fd0ef          	jal	80001fb6 <argaddr>
    return -1;
    80004272:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004274:	00054b63          	bltz	a0,8000428a <sys_write+0x4c>
  return filewrite(f, p, n);
    80004278:	fe442603          	lw	a2,-28(s0)
    8000427c:	fd843583          	ld	a1,-40(s0)
    80004280:	fe843503          	ld	a0,-24(s0)
    80004284:	dcaff0ef          	jal	8000384e <filewrite>
    80004288:	87aa                	mv	a5,a0
}
    8000428a:	853e                	mv	a0,a5
    8000428c:	70a2                	ld	ra,40(sp)
    8000428e:	7402                	ld	s0,32(sp)
    80004290:	6145                	addi	sp,sp,48
    80004292:	8082                	ret

0000000080004294 <sys_close>:
{
    80004294:	1101                	addi	sp,sp,-32
    80004296:	ec06                	sd	ra,24(sp)
    80004298:	e822                	sd	s0,16(sp)
    8000429a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000429c:	fe040613          	addi	a2,s0,-32
    800042a0:	fec40593          	addi	a1,s0,-20
    800042a4:	4501                	li	a0,0
    800042a6:	d3bff0ef          	jal	80003fe0 <argfd>
    return -1;
    800042aa:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800042ac:	02054063          	bltz	a0,800042cc <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800042b0:	b25fc0ef          	jal	80000dd4 <myproc>
    800042b4:	fec42783          	lw	a5,-20(s0)
    800042b8:	07e9                	addi	a5,a5,26
    800042ba:	078e                	slli	a5,a5,0x3
    800042bc:	953e                	add	a0,a0,a5
    800042be:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800042c2:	fe043503          	ld	a0,-32(s0)
    800042c6:	baaff0ef          	jal	80003670 <fileclose>
  return 0;
    800042ca:	4781                	li	a5,0
}
    800042cc:	853e                	mv	a0,a5
    800042ce:	60e2                	ld	ra,24(sp)
    800042d0:	6442                	ld	s0,16(sp)
    800042d2:	6105                	addi	sp,sp,32
    800042d4:	8082                	ret

00000000800042d6 <sys_fstat>:
{
    800042d6:	1101                	addi	sp,sp,-32
    800042d8:	ec06                	sd	ra,24(sp)
    800042da:	e822                	sd	s0,16(sp)
    800042dc:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800042de:	fe840613          	addi	a2,s0,-24
    800042e2:	4581                	li	a1,0
    800042e4:	4501                	li	a0,0
    800042e6:	cfbff0ef          	jal	80003fe0 <argfd>
    return -1;
    800042ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800042ec:	02054163          	bltz	a0,8000430e <sys_fstat+0x38>
    800042f0:	fe040593          	addi	a1,s0,-32
    800042f4:	4505                	li	a0,1
    800042f6:	cc1fd0ef          	jal	80001fb6 <argaddr>
    return -1;
    800042fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800042fc:	00054963          	bltz	a0,8000430e <sys_fstat+0x38>
  return filestat(f, st);
    80004300:	fe043583          	ld	a1,-32(s0)
    80004304:	fe843503          	ld	a0,-24(s0)
    80004308:	c2aff0ef          	jal	80003732 <filestat>
    8000430c:	87aa                	mv	a5,a0
}
    8000430e:	853e                	mv	a0,a5
    80004310:	60e2                	ld	ra,24(sp)
    80004312:	6442                	ld	s0,16(sp)
    80004314:	6105                	addi	sp,sp,32
    80004316:	8082                	ret

0000000080004318 <sys_link>:
{
    80004318:	7169                	addi	sp,sp,-304
    8000431a:	f606                	sd	ra,296(sp)
    8000431c:	f222                	sd	s0,288(sp)
    8000431e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004320:	08000613          	li	a2,128
    80004324:	ed040593          	addi	a1,s0,-304
    80004328:	4501                	li	a0,0
    8000432a:	cabfd0ef          	jal	80001fd4 <argstr>
    return -1;
    8000432e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004330:	0c054e63          	bltz	a0,8000440c <sys_link+0xf4>
    80004334:	08000613          	li	a2,128
    80004338:	f5040593          	addi	a1,s0,-176
    8000433c:	4505                	li	a0,1
    8000433e:	c97fd0ef          	jal	80001fd4 <argstr>
    return -1;
    80004342:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004344:	0c054463          	bltz	a0,8000440c <sys_link+0xf4>
    80004348:	ee26                	sd	s1,280(sp)
  begin_op();
    8000434a:	f0dfe0ef          	jal	80003256 <begin_op>
  if((ip = namei(old)) == 0){
    8000434e:	ed040513          	addi	a0,s0,-304
    80004352:	d49fe0ef          	jal	8000309a <namei>
    80004356:	84aa                	mv	s1,a0
    80004358:	c53d                	beqz	a0,800043c6 <sys_link+0xae>
  ilock(ip);
    8000435a:	e66fe0ef          	jal	800029c0 <ilock>
  if(ip->type == T_DIR){
    8000435e:	04449703          	lh	a4,68(s1)
    80004362:	4785                	li	a5,1
    80004364:	06f70663          	beq	a4,a5,800043d0 <sys_link+0xb8>
    80004368:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000436a:	04a4d783          	lhu	a5,74(s1)
    8000436e:	2785                	addiw	a5,a5,1
    80004370:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004374:	8526                	mv	a0,s1
    80004376:	d96fe0ef          	jal	8000290c <iupdate>
  iunlock(ip);
    8000437a:	8526                	mv	a0,s1
    8000437c:	ef2fe0ef          	jal	80002a6e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004380:	fd040593          	addi	a1,s0,-48
    80004384:	f5040513          	addi	a0,s0,-176
    80004388:	d2dfe0ef          	jal	800030b4 <nameiparent>
    8000438c:	892a                	mv	s2,a0
    8000438e:	cd21                	beqz	a0,800043e6 <sys_link+0xce>
  ilock(dp);
    80004390:	e30fe0ef          	jal	800029c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004394:	00092703          	lw	a4,0(s2)
    80004398:	409c                	lw	a5,0(s1)
    8000439a:	04f71363          	bne	a4,a5,800043e0 <sys_link+0xc8>
    8000439e:	40d0                	lw	a2,4(s1)
    800043a0:	fd040593          	addi	a1,s0,-48
    800043a4:	854a                	mv	a0,s2
    800043a6:	c5bfe0ef          	jal	80003000 <dirlink>
    800043aa:	02054b63          	bltz	a0,800043e0 <sys_link+0xc8>
  iunlockput(dp);
    800043ae:	854a                	mv	a0,s2
    800043b0:	81bfe0ef          	jal	80002bca <iunlockput>
  iput(ip);
    800043b4:	8526                	mv	a0,s1
    800043b6:	f8cfe0ef          	jal	80002b42 <iput>
  end_op();
    800043ba:	f07fe0ef          	jal	800032c0 <end_op>
  return 0;
    800043be:	4781                	li	a5,0
    800043c0:	64f2                	ld	s1,280(sp)
    800043c2:	6952                	ld	s2,272(sp)
    800043c4:	a0a1                	j	8000440c <sys_link+0xf4>
    end_op();
    800043c6:	efbfe0ef          	jal	800032c0 <end_op>
    return -1;
    800043ca:	57fd                	li	a5,-1
    800043cc:	64f2                	ld	s1,280(sp)
    800043ce:	a83d                	j	8000440c <sys_link+0xf4>
    iunlockput(ip);
    800043d0:	8526                	mv	a0,s1
    800043d2:	ff8fe0ef          	jal	80002bca <iunlockput>
    end_op();
    800043d6:	eebfe0ef          	jal	800032c0 <end_op>
    return -1;
    800043da:	57fd                	li	a5,-1
    800043dc:	64f2                	ld	s1,280(sp)
    800043de:	a03d                	j	8000440c <sys_link+0xf4>
    iunlockput(dp);
    800043e0:	854a                	mv	a0,s2
    800043e2:	fe8fe0ef          	jal	80002bca <iunlockput>
  ilock(ip);
    800043e6:	8526                	mv	a0,s1
    800043e8:	dd8fe0ef          	jal	800029c0 <ilock>
  ip->nlink--;
    800043ec:	04a4d783          	lhu	a5,74(s1)
    800043f0:	37fd                	addiw	a5,a5,-1
    800043f2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800043f6:	8526                	mv	a0,s1
    800043f8:	d14fe0ef          	jal	8000290c <iupdate>
  iunlockput(ip);
    800043fc:	8526                	mv	a0,s1
    800043fe:	fccfe0ef          	jal	80002bca <iunlockput>
  end_op();
    80004402:	ebffe0ef          	jal	800032c0 <end_op>
  return -1;
    80004406:	57fd                	li	a5,-1
    80004408:	64f2                	ld	s1,280(sp)
    8000440a:	6952                	ld	s2,272(sp)
}
    8000440c:	853e                	mv	a0,a5
    8000440e:	70b2                	ld	ra,296(sp)
    80004410:	7412                	ld	s0,288(sp)
    80004412:	6155                	addi	sp,sp,304
    80004414:	8082                	ret

0000000080004416 <sys_unlink>:
{
    80004416:	7151                	addi	sp,sp,-240
    80004418:	f586                	sd	ra,232(sp)
    8000441a:	f1a2                	sd	s0,224(sp)
    8000441c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000441e:	08000613          	li	a2,128
    80004422:	f3040593          	addi	a1,s0,-208
    80004426:	4501                	li	a0,0
    80004428:	badfd0ef          	jal	80001fd4 <argstr>
    8000442c:	16054063          	bltz	a0,8000458c <sys_unlink+0x176>
    80004430:	eda6                	sd	s1,216(sp)
  begin_op();
    80004432:	e25fe0ef          	jal	80003256 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004436:	fb040593          	addi	a1,s0,-80
    8000443a:	f3040513          	addi	a0,s0,-208
    8000443e:	c77fe0ef          	jal	800030b4 <nameiparent>
    80004442:	84aa                	mv	s1,a0
    80004444:	c945                	beqz	a0,800044f4 <sys_unlink+0xde>
  ilock(dp);
    80004446:	d7afe0ef          	jal	800029c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000444a:	00003597          	auipc	a1,0x3
    8000444e:	16e58593          	addi	a1,a1,366 # 800075b8 <etext+0x5b8>
    80004452:	fb040513          	addi	a0,s0,-80
    80004456:	9c9fe0ef          	jal	80002e1e <namecmp>
    8000445a:	10050e63          	beqz	a0,80004576 <sys_unlink+0x160>
    8000445e:	00003597          	auipc	a1,0x3
    80004462:	16258593          	addi	a1,a1,354 # 800075c0 <etext+0x5c0>
    80004466:	fb040513          	addi	a0,s0,-80
    8000446a:	9b5fe0ef          	jal	80002e1e <namecmp>
    8000446e:	10050463          	beqz	a0,80004576 <sys_unlink+0x160>
    80004472:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004474:	f2c40613          	addi	a2,s0,-212
    80004478:	fb040593          	addi	a1,s0,-80
    8000447c:	8526                	mv	a0,s1
    8000447e:	9b7fe0ef          	jal	80002e34 <dirlookup>
    80004482:	892a                	mv	s2,a0
    80004484:	0e050863          	beqz	a0,80004574 <sys_unlink+0x15e>
  ilock(ip);
    80004488:	d38fe0ef          	jal	800029c0 <ilock>
  if(ip->nlink < 1)
    8000448c:	04a91783          	lh	a5,74(s2)
    80004490:	06f05763          	blez	a5,800044fe <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004494:	04491703          	lh	a4,68(s2)
    80004498:	4785                	li	a5,1
    8000449a:	06f70963          	beq	a4,a5,8000450c <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    8000449e:	4641                	li	a2,16
    800044a0:	4581                	li	a1,0
    800044a2:	fc040513          	addi	a0,s0,-64
    800044a6:	ca9fb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044aa:	4741                	li	a4,16
    800044ac:	f2c42683          	lw	a3,-212(s0)
    800044b0:	fc040613          	addi	a2,s0,-64
    800044b4:	4581                	li	a1,0
    800044b6:	8526                	mv	a0,s1
    800044b8:	859fe0ef          	jal	80002d10 <writei>
    800044bc:	47c1                	li	a5,16
    800044be:	08f51b63          	bne	a0,a5,80004554 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800044c2:	04491703          	lh	a4,68(s2)
    800044c6:	4785                	li	a5,1
    800044c8:	08f70d63          	beq	a4,a5,80004562 <sys_unlink+0x14c>
  iunlockput(dp);
    800044cc:	8526                	mv	a0,s1
    800044ce:	efcfe0ef          	jal	80002bca <iunlockput>
  ip->nlink--;
    800044d2:	04a95783          	lhu	a5,74(s2)
    800044d6:	37fd                	addiw	a5,a5,-1
    800044d8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800044dc:	854a                	mv	a0,s2
    800044de:	c2efe0ef          	jal	8000290c <iupdate>
  iunlockput(ip);
    800044e2:	854a                	mv	a0,s2
    800044e4:	ee6fe0ef          	jal	80002bca <iunlockput>
  end_op();
    800044e8:	dd9fe0ef          	jal	800032c0 <end_op>
  return 0;
    800044ec:	4501                	li	a0,0
    800044ee:	64ee                	ld	s1,216(sp)
    800044f0:	694e                	ld	s2,208(sp)
    800044f2:	a849                	j	80004584 <sys_unlink+0x16e>
    end_op();
    800044f4:	dcdfe0ef          	jal	800032c0 <end_op>
    return -1;
    800044f8:	557d                	li	a0,-1
    800044fa:	64ee                	ld	s1,216(sp)
    800044fc:	a061                	j	80004584 <sys_unlink+0x16e>
    800044fe:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004500:	00003517          	auipc	a0,0x3
    80004504:	0e850513          	addi	a0,a0,232 # 800075e8 <etext+0x5e8>
    80004508:	65a010ef          	jal	80005b62 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000450c:	04c92703          	lw	a4,76(s2)
    80004510:	02000793          	li	a5,32
    80004514:	f8e7f5e3          	bgeu	a5,a4,8000449e <sys_unlink+0x88>
    80004518:	e5ce                	sd	s3,200(sp)
    8000451a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000451e:	4741                	li	a4,16
    80004520:	86ce                	mv	a3,s3
    80004522:	f1840613          	addi	a2,s0,-232
    80004526:	4581                	li	a1,0
    80004528:	854a                	mv	a0,s2
    8000452a:	eeafe0ef          	jal	80002c14 <readi>
    8000452e:	47c1                	li	a5,16
    80004530:	00f51c63          	bne	a0,a5,80004548 <sys_unlink+0x132>
    if(de.inum != 0)
    80004534:	f1845783          	lhu	a5,-232(s0)
    80004538:	efa1                	bnez	a5,80004590 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000453a:	29c1                	addiw	s3,s3,16
    8000453c:	04c92783          	lw	a5,76(s2)
    80004540:	fcf9efe3          	bltu	s3,a5,8000451e <sys_unlink+0x108>
    80004544:	69ae                	ld	s3,200(sp)
    80004546:	bfa1                	j	8000449e <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004548:	00003517          	auipc	a0,0x3
    8000454c:	0b850513          	addi	a0,a0,184 # 80007600 <etext+0x600>
    80004550:	612010ef          	jal	80005b62 <panic>
    80004554:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004556:	00003517          	auipc	a0,0x3
    8000455a:	0c250513          	addi	a0,a0,194 # 80007618 <etext+0x618>
    8000455e:	604010ef          	jal	80005b62 <panic>
    dp->nlink--;
    80004562:	04a4d783          	lhu	a5,74(s1)
    80004566:	37fd                	addiw	a5,a5,-1
    80004568:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000456c:	8526                	mv	a0,s1
    8000456e:	b9efe0ef          	jal	8000290c <iupdate>
    80004572:	bfa9                	j	800044cc <sys_unlink+0xb6>
    80004574:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004576:	8526                	mv	a0,s1
    80004578:	e52fe0ef          	jal	80002bca <iunlockput>
  end_op();
    8000457c:	d45fe0ef          	jal	800032c0 <end_op>
  return -1;
    80004580:	557d                	li	a0,-1
    80004582:	64ee                	ld	s1,216(sp)
}
    80004584:	70ae                	ld	ra,232(sp)
    80004586:	740e                	ld	s0,224(sp)
    80004588:	616d                	addi	sp,sp,240
    8000458a:	8082                	ret
    return -1;
    8000458c:	557d                	li	a0,-1
    8000458e:	bfdd                	j	80004584 <sys_unlink+0x16e>
    iunlockput(ip);
    80004590:	854a                	mv	a0,s2
    80004592:	e38fe0ef          	jal	80002bca <iunlockput>
    goto bad;
    80004596:	694e                	ld	s2,208(sp)
    80004598:	69ae                	ld	s3,200(sp)
    8000459a:	bff1                	j	80004576 <sys_unlink+0x160>

000000008000459c <sys_open>:

uint64
sys_open(void)
{
    8000459c:	7131                	addi	sp,sp,-192
    8000459e:	fd06                	sd	ra,184(sp)
    800045a0:	f922                	sd	s0,176(sp)
    800045a2:	f526                	sd	s1,168(sp)
    800045a4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800045a6:	08000613          	li	a2,128
    800045aa:	f5040593          	addi	a1,s0,-176
    800045ae:	4501                	li	a0,0
    800045b0:	a25fd0ef          	jal	80001fd4 <argstr>
    return -1;
    800045b4:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800045b6:	0a054663          	bltz	a0,80004662 <sys_open+0xc6>
    800045ba:	f4c40593          	addi	a1,s0,-180
    800045be:	4505                	li	a0,1
    800045c0:	9d9fd0ef          	jal	80001f98 <argint>
    800045c4:	08054f63          	bltz	a0,80004662 <sys_open+0xc6>
    800045c8:	f14a                	sd	s2,160(sp)

  begin_op();
    800045ca:	c8dfe0ef          	jal	80003256 <begin_op>

  if(omode & O_CREATE){
    800045ce:	f4c42783          	lw	a5,-180(s0)
    800045d2:	2007f793          	andi	a5,a5,512
    800045d6:	c3c5                	beqz	a5,80004676 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800045d8:	4681                	li	a3,0
    800045da:	4601                	li	a2,0
    800045dc:	4589                	li	a1,2
    800045de:	f5040513          	addi	a0,s0,-176
    800045e2:	a9dff0ef          	jal	8000407e <create>
    800045e6:	892a                	mv	s2,a0
    if(ip == 0){
    800045e8:	c159                	beqz	a0,8000466e <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800045ea:	04491703          	lh	a4,68(s2)
    800045ee:	478d                	li	a5,3
    800045f0:	00f71763          	bne	a4,a5,800045fe <sys_open+0x62>
    800045f4:	04695703          	lhu	a4,70(s2)
    800045f8:	47a5                	li	a5,9
    800045fa:	0ae7eb63          	bltu	a5,a4,800046b0 <sys_open+0x114>
    800045fe:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004600:	fcdfe0ef          	jal	800035cc <filealloc>
    80004604:	89aa                	mv	s3,a0
    80004606:	c161                	beqz	a0,800046c6 <sys_open+0x12a>
    80004608:	a39ff0ef          	jal	80004040 <fdalloc>
    8000460c:	84aa                	mv	s1,a0
    8000460e:	0a054963          	bltz	a0,800046c0 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004612:	04491703          	lh	a4,68(s2)
    80004616:	478d                	li	a5,3
    80004618:	0cf70063          	beq	a4,a5,800046d8 <sys_open+0x13c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000461c:	4789                	li	a5,2
    8000461e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004622:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004626:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    8000462a:	f4c42783          	lw	a5,-180(s0)
    8000462e:	0017c713          	xori	a4,a5,1
    80004632:	8b05                	andi	a4,a4,1
    80004634:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004638:	0037f713          	andi	a4,a5,3
    8000463c:	00e03733          	snez	a4,a4
    80004640:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004644:	4007f793          	andi	a5,a5,1024
    80004648:	c791                	beqz	a5,80004654 <sys_open+0xb8>
    8000464a:	04491703          	lh	a4,68(s2)
    8000464e:	4789                	li	a5,2
    80004650:	08f70b63          	beq	a4,a5,800046e6 <sys_open+0x14a>
    itrunc(ip);
  }

  iunlock(ip);
    80004654:	854a                	mv	a0,s2
    80004656:	c18fe0ef          	jal	80002a6e <iunlock>
  end_op();
    8000465a:	c67fe0ef          	jal	800032c0 <end_op>
    8000465e:	790a                	ld	s2,160(sp)
    80004660:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004662:	8526                	mv	a0,s1
    80004664:	70ea                	ld	ra,184(sp)
    80004666:	744a                	ld	s0,176(sp)
    80004668:	74aa                	ld	s1,168(sp)
    8000466a:	6129                	addi	sp,sp,192
    8000466c:	8082                	ret
      end_op();
    8000466e:	c53fe0ef          	jal	800032c0 <end_op>
      return -1;
    80004672:	790a                	ld	s2,160(sp)
    80004674:	b7fd                	j	80004662 <sys_open+0xc6>
    if((ip = namei(path)) == 0){
    80004676:	f5040513          	addi	a0,s0,-176
    8000467a:	a21fe0ef          	jal	8000309a <namei>
    8000467e:	892a                	mv	s2,a0
    80004680:	c11d                	beqz	a0,800046a6 <sys_open+0x10a>
    ilock(ip);
    80004682:	b3efe0ef          	jal	800029c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004686:	04491703          	lh	a4,68(s2)
    8000468a:	4785                	li	a5,1
    8000468c:	f4f71fe3          	bne	a4,a5,800045ea <sys_open+0x4e>
    80004690:	f4c42783          	lw	a5,-180(s0)
    80004694:	d7ad                	beqz	a5,800045fe <sys_open+0x62>
      iunlockput(ip);
    80004696:	854a                	mv	a0,s2
    80004698:	d32fe0ef          	jal	80002bca <iunlockput>
      end_op();
    8000469c:	c25fe0ef          	jal	800032c0 <end_op>
      return -1;
    800046a0:	54fd                	li	s1,-1
    800046a2:	790a                	ld	s2,160(sp)
    800046a4:	bf7d                	j	80004662 <sys_open+0xc6>
      end_op();
    800046a6:	c1bfe0ef          	jal	800032c0 <end_op>
      return -1;
    800046aa:	54fd                	li	s1,-1
    800046ac:	790a                	ld	s2,160(sp)
    800046ae:	bf55                	j	80004662 <sys_open+0xc6>
    iunlockput(ip);
    800046b0:	854a                	mv	a0,s2
    800046b2:	d18fe0ef          	jal	80002bca <iunlockput>
    end_op();
    800046b6:	c0bfe0ef          	jal	800032c0 <end_op>
    return -1;
    800046ba:	54fd                	li	s1,-1
    800046bc:	790a                	ld	s2,160(sp)
    800046be:	b755                	j	80004662 <sys_open+0xc6>
      fileclose(f);
    800046c0:	854e                	mv	a0,s3
    800046c2:	faffe0ef          	jal	80003670 <fileclose>
    iunlockput(ip);
    800046c6:	854a                	mv	a0,s2
    800046c8:	d02fe0ef          	jal	80002bca <iunlockput>
    end_op();
    800046cc:	bf5fe0ef          	jal	800032c0 <end_op>
    return -1;
    800046d0:	54fd                	li	s1,-1
    800046d2:	790a                	ld	s2,160(sp)
    800046d4:	69ea                	ld	s3,152(sp)
    800046d6:	b771                	j	80004662 <sys_open+0xc6>
    f->type = FD_DEVICE;
    800046d8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800046dc:	04691783          	lh	a5,70(s2)
    800046e0:	02f99223          	sh	a5,36(s3)
    800046e4:	b789                	j	80004626 <sys_open+0x8a>
    itrunc(ip);
    800046e6:	854a                	mv	a0,s2
    800046e8:	bc6fe0ef          	jal	80002aae <itrunc>
    800046ec:	b7a5                	j	80004654 <sys_open+0xb8>

00000000800046ee <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800046ee:	7175                	addi	sp,sp,-144
    800046f0:	e506                	sd	ra,136(sp)
    800046f2:	e122                	sd	s0,128(sp)
    800046f4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800046f6:	b61fe0ef          	jal	80003256 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800046fa:	08000613          	li	a2,128
    800046fe:	f7040593          	addi	a1,s0,-144
    80004702:	4501                	li	a0,0
    80004704:	8d1fd0ef          	jal	80001fd4 <argstr>
    80004708:	02054363          	bltz	a0,8000472e <sys_mkdir+0x40>
    8000470c:	4681                	li	a3,0
    8000470e:	4601                	li	a2,0
    80004710:	4585                	li	a1,1
    80004712:	f7040513          	addi	a0,s0,-144
    80004716:	969ff0ef          	jal	8000407e <create>
    8000471a:	c911                	beqz	a0,8000472e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000471c:	caefe0ef          	jal	80002bca <iunlockput>
  end_op();
    80004720:	ba1fe0ef          	jal	800032c0 <end_op>
  return 0;
    80004724:	4501                	li	a0,0
}
    80004726:	60aa                	ld	ra,136(sp)
    80004728:	640a                	ld	s0,128(sp)
    8000472a:	6149                	addi	sp,sp,144
    8000472c:	8082                	ret
    end_op();
    8000472e:	b93fe0ef          	jal	800032c0 <end_op>
    return -1;
    80004732:	557d                	li	a0,-1
    80004734:	bfcd                	j	80004726 <sys_mkdir+0x38>

0000000080004736 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004736:	7135                	addi	sp,sp,-160
    80004738:	ed06                	sd	ra,152(sp)
    8000473a:	e922                	sd	s0,144(sp)
    8000473c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000473e:	b19fe0ef          	jal	80003256 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004742:	08000613          	li	a2,128
    80004746:	f7040593          	addi	a1,s0,-144
    8000474a:	4501                	li	a0,0
    8000474c:	889fd0ef          	jal	80001fd4 <argstr>
    80004750:	04054063          	bltz	a0,80004790 <sys_mknod+0x5a>
     argint(1, &major) < 0 ||
    80004754:	f6c40593          	addi	a1,s0,-148
    80004758:	4505                	li	a0,1
    8000475a:	83ffd0ef          	jal	80001f98 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000475e:	02054963          	bltz	a0,80004790 <sys_mknod+0x5a>
     argint(2, &minor) < 0 ||
    80004762:	f6840593          	addi	a1,s0,-152
    80004766:	4509                	li	a0,2
    80004768:	831fd0ef          	jal	80001f98 <argint>
     argint(1, &major) < 0 ||
    8000476c:	02054263          	bltz	a0,80004790 <sys_mknod+0x5a>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004770:	f6841683          	lh	a3,-152(s0)
    80004774:	f6c41603          	lh	a2,-148(s0)
    80004778:	458d                	li	a1,3
    8000477a:	f7040513          	addi	a0,s0,-144
    8000477e:	901ff0ef          	jal	8000407e <create>
     argint(2, &minor) < 0 ||
    80004782:	c519                	beqz	a0,80004790 <sys_mknod+0x5a>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004784:	c46fe0ef          	jal	80002bca <iunlockput>
  end_op();
    80004788:	b39fe0ef          	jal	800032c0 <end_op>
  return 0;
    8000478c:	4501                	li	a0,0
    8000478e:	a021                	j	80004796 <sys_mknod+0x60>
    end_op();
    80004790:	b31fe0ef          	jal	800032c0 <end_op>
    return -1;
    80004794:	557d                	li	a0,-1
}
    80004796:	60ea                	ld	ra,152(sp)
    80004798:	644a                	ld	s0,144(sp)
    8000479a:	610d                	addi	sp,sp,160
    8000479c:	8082                	ret

000000008000479e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000479e:	7135                	addi	sp,sp,-160
    800047a0:	ed06                	sd	ra,152(sp)
    800047a2:	e922                	sd	s0,144(sp)
    800047a4:	e14a                	sd	s2,128(sp)
    800047a6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800047a8:	e2cfc0ef          	jal	80000dd4 <myproc>
    800047ac:	892a                	mv	s2,a0
  
  begin_op();
    800047ae:	aa9fe0ef          	jal	80003256 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800047b2:	08000613          	li	a2,128
    800047b6:	f6040593          	addi	a1,s0,-160
    800047ba:	4501                	li	a0,0
    800047bc:	819fd0ef          	jal	80001fd4 <argstr>
    800047c0:	04054363          	bltz	a0,80004806 <sys_chdir+0x68>
    800047c4:	e526                	sd	s1,136(sp)
    800047c6:	f6040513          	addi	a0,s0,-160
    800047ca:	8d1fe0ef          	jal	8000309a <namei>
    800047ce:	84aa                	mv	s1,a0
    800047d0:	c915                	beqz	a0,80004804 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800047d2:	9eefe0ef          	jal	800029c0 <ilock>
  if(ip->type != T_DIR){
    800047d6:	04449703          	lh	a4,68(s1)
    800047da:	4785                	li	a5,1
    800047dc:	02f71963          	bne	a4,a5,8000480e <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800047e0:	8526                	mv	a0,s1
    800047e2:	a8cfe0ef          	jal	80002a6e <iunlock>
  iput(p->cwd);
    800047e6:	15093503          	ld	a0,336(s2)
    800047ea:	b58fe0ef          	jal	80002b42 <iput>
  end_op();
    800047ee:	ad3fe0ef          	jal	800032c0 <end_op>
  p->cwd = ip;
    800047f2:	14993823          	sd	s1,336(s2)
  return 0;
    800047f6:	4501                	li	a0,0
    800047f8:	64aa                	ld	s1,136(sp)
}
    800047fa:	60ea                	ld	ra,152(sp)
    800047fc:	644a                	ld	s0,144(sp)
    800047fe:	690a                	ld	s2,128(sp)
    80004800:	610d                	addi	sp,sp,160
    80004802:	8082                	ret
    80004804:	64aa                	ld	s1,136(sp)
    end_op();
    80004806:	abbfe0ef          	jal	800032c0 <end_op>
    return -1;
    8000480a:	557d                	li	a0,-1
    8000480c:	b7fd                	j	800047fa <sys_chdir+0x5c>
    iunlockput(ip);
    8000480e:	8526                	mv	a0,s1
    80004810:	bbafe0ef          	jal	80002bca <iunlockput>
    end_op();
    80004814:	aadfe0ef          	jal	800032c0 <end_op>
    return -1;
    80004818:	557d                	li	a0,-1
    8000481a:	64aa                	ld	s1,136(sp)
    8000481c:	bff9                	j	800047fa <sys_chdir+0x5c>

000000008000481e <sys_exec>:

uint64
sys_exec(void)
{
    8000481e:	7121                	addi	sp,sp,-448
    80004820:	ff06                	sd	ra,440(sp)
    80004822:	fb22                	sd	s0,432(sp)
    80004824:	f34a                	sd	s2,416(sp)
    80004826:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004828:	08000613          	li	a2,128
    8000482c:	f5040593          	addi	a1,s0,-176
    80004830:	4501                	li	a0,0
    80004832:	fa2fd0ef          	jal	80001fd4 <argstr>
    return -1;
    80004836:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004838:	0c054a63          	bltz	a0,8000490c <sys_exec+0xee>
    8000483c:	e4840593          	addi	a1,s0,-440
    80004840:	4505                	li	a0,1
    80004842:	f74fd0ef          	jal	80001fb6 <argaddr>
    80004846:	0c054363          	bltz	a0,8000490c <sys_exec+0xee>
    8000484a:	f726                	sd	s1,424(sp)
    8000484c:	ef4e                	sd	s3,408(sp)
    8000484e:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004850:	10000613          	li	a2,256
    80004854:	4581                	li	a1,0
    80004856:	e5040513          	addi	a0,s0,-432
    8000485a:	8f5fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000485e:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004862:	89a6                	mv	s3,s1
    80004864:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004866:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000486a:	00391513          	slli	a0,s2,0x3
    8000486e:	e4040593          	addi	a1,s0,-448
    80004872:	e4843783          	ld	a5,-440(s0)
    80004876:	953e                	add	a0,a0,a5
    80004878:	e96fd0ef          	jal	80001f0e <fetchaddr>
    8000487c:	02054663          	bltz	a0,800048a8 <sys_exec+0x8a>
      goto bad;
    }
    if(uarg == 0){
    80004880:	e4043783          	ld	a5,-448(s0)
    80004884:	c3a1                	beqz	a5,800048c4 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004886:	879fb0ef          	jal	800000fe <kalloc>
    8000488a:	85aa                	mv	a1,a0
    8000488c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004890:	cd01                	beqz	a0,800048a8 <sys_exec+0x8a>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004892:	6605                	lui	a2,0x1
    80004894:	e4043503          	ld	a0,-448(s0)
    80004898:	ec0fd0ef          	jal	80001f58 <fetchstr>
    8000489c:	00054663          	bltz	a0,800048a8 <sys_exec+0x8a>
    if(i >= NELEM(argv)){
    800048a0:	0905                	addi	s2,s2,1
    800048a2:	09a1                	addi	s3,s3,8
    800048a4:	fd4913e3          	bne	s2,s4,8000486a <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800048a8:	f5040913          	addi	s2,s0,-176
    800048ac:	6088                	ld	a0,0(s1)
    800048ae:	c939                	beqz	a0,80004904 <sys_exec+0xe6>
    kfree(argv[i]);
    800048b0:	f6cfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800048b4:	04a1                	addi	s1,s1,8
    800048b6:	ff249be3          	bne	s1,s2,800048ac <sys_exec+0x8e>
  return -1;
    800048ba:	597d                	li	s2,-1
    800048bc:	74ba                	ld	s1,424(sp)
    800048be:	69fa                	ld	s3,408(sp)
    800048c0:	6a5a                	ld	s4,400(sp)
    800048c2:	a0a9                	j	8000490c <sys_exec+0xee>
      argv[i] = 0;
    800048c4:	0009079b          	sext.w	a5,s2
    800048c8:	078e                	slli	a5,a5,0x3
    800048ca:	fd078793          	addi	a5,a5,-48
    800048ce:	97a2                	add	a5,a5,s0
    800048d0:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800048d4:	e5040593          	addi	a1,s0,-432
    800048d8:	f5040513          	addi	a0,s0,-176
    800048dc:	b92ff0ef          	jal	80003c6e <exec>
    800048e0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800048e2:	f5040993          	addi	s3,s0,-176
    800048e6:	6088                	ld	a0,0(s1)
    800048e8:	c911                	beqz	a0,800048fc <sys_exec+0xde>
    kfree(argv[i]);
    800048ea:	f32fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800048ee:	04a1                	addi	s1,s1,8
    800048f0:	ff349be3          	bne	s1,s3,800048e6 <sys_exec+0xc8>
    800048f4:	74ba                	ld	s1,424(sp)
    800048f6:	69fa                	ld	s3,408(sp)
    800048f8:	6a5a                	ld	s4,400(sp)
    800048fa:	a809                	j	8000490c <sys_exec+0xee>
  return ret;
    800048fc:	74ba                	ld	s1,424(sp)
    800048fe:	69fa                	ld	s3,408(sp)
    80004900:	6a5a                	ld	s4,400(sp)
    80004902:	a029                	j	8000490c <sys_exec+0xee>
  return -1;
    80004904:	597d                	li	s2,-1
    80004906:	74ba                	ld	s1,424(sp)
    80004908:	69fa                	ld	s3,408(sp)
    8000490a:	6a5a                	ld	s4,400(sp)
}
    8000490c:	854a                	mv	a0,s2
    8000490e:	70fa                	ld	ra,440(sp)
    80004910:	745a                	ld	s0,432(sp)
    80004912:	791a                	ld	s2,416(sp)
    80004914:	6139                	addi	sp,sp,448
    80004916:	8082                	ret

0000000080004918 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004918:	7139                	addi	sp,sp,-64
    8000491a:	fc06                	sd	ra,56(sp)
    8000491c:	f822                	sd	s0,48(sp)
    8000491e:	f426                	sd	s1,40(sp)
    80004920:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004922:	cb2fc0ef          	jal	80000dd4 <myproc>
    80004926:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004928:	fd840593          	addi	a1,s0,-40
    8000492c:	4501                	li	a0,0
    8000492e:	e88fd0ef          	jal	80001fb6 <argaddr>
    return -1;
    80004932:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004934:	0a054e63          	bltz	a0,800049f0 <sys_pipe+0xd8>
  if(pipealloc(&rf, &wf) < 0)
    80004938:	fc840593          	addi	a1,s0,-56
    8000493c:	fd040513          	addi	a0,s0,-48
    80004940:	83aff0ef          	jal	8000397a <pipealloc>
    return -1;
    80004944:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004946:	0a054563          	bltz	a0,800049f0 <sys_pipe+0xd8>
  fd0 = -1;
    8000494a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000494e:	fd043503          	ld	a0,-48(s0)
    80004952:	eeeff0ef          	jal	80004040 <fdalloc>
    80004956:	fca42223          	sw	a0,-60(s0)
    8000495a:	08054263          	bltz	a0,800049de <sys_pipe+0xc6>
    8000495e:	fc843503          	ld	a0,-56(s0)
    80004962:	edeff0ef          	jal	80004040 <fdalloc>
    80004966:	fca42023          	sw	a0,-64(s0)
    8000496a:	06054163          	bltz	a0,800049cc <sys_pipe+0xb4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000496e:	4691                	li	a3,4
    80004970:	fc440613          	addi	a2,s0,-60
    80004974:	fd843583          	ld	a1,-40(s0)
    80004978:	68a8                	ld	a0,80(s1)
    8000497a:	848fc0ef          	jal	800009c2 <copyout>
    8000497e:	00054e63          	bltz	a0,8000499a <sys_pipe+0x82>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004982:	4691                	li	a3,4
    80004984:	fc040613          	addi	a2,s0,-64
    80004988:	fd843583          	ld	a1,-40(s0)
    8000498c:	0591                	addi	a1,a1,4
    8000498e:	68a8                	ld	a0,80(s1)
    80004990:	832fc0ef          	jal	800009c2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004994:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004996:	04055d63          	bgez	a0,800049f0 <sys_pipe+0xd8>
    p->ofile[fd0] = 0;
    8000499a:	fc442783          	lw	a5,-60(s0)
    8000499e:	07e9                	addi	a5,a5,26
    800049a0:	078e                	slli	a5,a5,0x3
    800049a2:	97a6                	add	a5,a5,s1
    800049a4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800049a8:	fc042783          	lw	a5,-64(s0)
    800049ac:	07e9                	addi	a5,a5,26
    800049ae:	078e                	slli	a5,a5,0x3
    800049b0:	00f48533          	add	a0,s1,a5
    800049b4:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800049b8:	fd043503          	ld	a0,-48(s0)
    800049bc:	cb5fe0ef          	jal	80003670 <fileclose>
    fileclose(wf);
    800049c0:	fc843503          	ld	a0,-56(s0)
    800049c4:	cadfe0ef          	jal	80003670 <fileclose>
    return -1;
    800049c8:	57fd                	li	a5,-1
    800049ca:	a01d                	j	800049f0 <sys_pipe+0xd8>
    if(fd0 >= 0)
    800049cc:	fc442783          	lw	a5,-60(s0)
    800049d0:	0007c763          	bltz	a5,800049de <sys_pipe+0xc6>
      p->ofile[fd0] = 0;
    800049d4:	07e9                	addi	a5,a5,26
    800049d6:	078e                	slli	a5,a5,0x3
    800049d8:	97a6                	add	a5,a5,s1
    800049da:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800049de:	fd043503          	ld	a0,-48(s0)
    800049e2:	c8ffe0ef          	jal	80003670 <fileclose>
    fileclose(wf);
    800049e6:	fc843503          	ld	a0,-56(s0)
    800049ea:	c87fe0ef          	jal	80003670 <fileclose>
    return -1;
    800049ee:	57fd                	li	a5,-1
}
    800049f0:	853e                	mv	a0,a5
    800049f2:	70e2                	ld	ra,56(sp)
    800049f4:	7442                	ld	s0,48(sp)
    800049f6:	74a2                	ld	s1,40(sp)
    800049f8:	6121                	addi	sp,sp,64
    800049fa:	8082                	ret

00000000800049fc <sys_mmap>:

// lab10
uint64 sys_mmap(void) {
    800049fc:	7139                	addi	sp,sp,-64
    800049fe:	fc06                	sd	ra,56(sp)
    80004a00:	f822                	sd	s0,48(sp)
    80004a02:	f426                	sd	s1,40(sp)
    80004a04:	0080                	addi	s0,sp,64
  uint64 addr;
  int len, prot, flags, offset;
  struct file *f;
  struct vm_area *vma = 0;
  struct proc *p = myproc();
    80004a06:	bcefc0ef          	jal	80000dd4 <myproc>
    80004a0a:	84aa                	mv	s1,a0
  int i;

  if (argaddr(0, &addr) < 0 || argint(1, &len) < 0
    80004a0c:	fd840593          	addi	a1,s0,-40
    80004a10:	4501                	li	a0,0
    80004a12:	da4fd0ef          	jal	80001fb6 <argaddr>
      || argint(2, &prot) < 0 || argint(3, &flags) < 0
      || argfd(4, 0, &f) < 0 || argint(5, &offset) < 0) {
    return -1;
    80004a16:	57fd                	li	a5,-1
  if (argaddr(0, &addr) < 0 || argint(1, &len) < 0
    80004a18:	12054f63          	bltz	a0,80004b56 <sys_mmap+0x15a>
    80004a1c:	fd440593          	addi	a1,s0,-44
    80004a20:	4505                	li	a0,1
    80004a22:	d76fd0ef          	jal	80001f98 <argint>
    return -1;
    80004a26:	57fd                	li	a5,-1
  if (argaddr(0, &addr) < 0 || argint(1, &len) < 0
    80004a28:	12054763          	bltz	a0,80004b56 <sys_mmap+0x15a>
      || argint(2, &prot) < 0 || argint(3, &flags) < 0
    80004a2c:	fd040593          	addi	a1,s0,-48
    80004a30:	4509                	li	a0,2
    80004a32:	d66fd0ef          	jal	80001f98 <argint>
    return -1;
    80004a36:	57fd                	li	a5,-1
      || argint(2, &prot) < 0 || argint(3, &flags) < 0
    80004a38:	10054f63          	bltz	a0,80004b56 <sys_mmap+0x15a>
    80004a3c:	fcc40593          	addi	a1,s0,-52
    80004a40:	450d                	li	a0,3
    80004a42:	d56fd0ef          	jal	80001f98 <argint>
    return -1;
    80004a46:	57fd                	li	a5,-1
      || argint(2, &prot) < 0 || argint(3, &flags) < 0
    80004a48:	10054763          	bltz	a0,80004b56 <sys_mmap+0x15a>
      || argfd(4, 0, &f) < 0 || argint(5, &offset) < 0) {
    80004a4c:	fc040613          	addi	a2,s0,-64
    80004a50:	4581                	li	a1,0
    80004a52:	4511                	li	a0,4
    80004a54:	d8cff0ef          	jal	80003fe0 <argfd>
    return -1;
    80004a58:	57fd                	li	a5,-1
      || argfd(4, 0, &f) < 0 || argint(5, &offset) < 0) {
    80004a5a:	0e054e63          	bltz	a0,80004b56 <sys_mmap+0x15a>
    80004a5e:	fc840593          	addi	a1,s0,-56
    80004a62:	4515                	li	a0,5
    80004a64:	d34fd0ef          	jal	80001f98 <argint>
    80004a68:	0e054d63          	bltz	a0,80004b62 <sys_mmap+0x166>
  }
  if (flags != MAP_SHARED && flags != MAP_PRIVATE) {
    80004a6c:	fcc42883          	lw	a7,-52(s0)
    80004a70:	fff8869b          	addiw	a3,a7,-1
    80004a74:	4705                	li	a4,1
    return -1;
    80004a76:	57fd                	li	a5,-1
  if (flags != MAP_SHARED && flags != MAP_PRIVATE) {
    80004a78:	0cd76f63          	bltu	a4,a3,80004b56 <sys_mmap+0x15a>
  }
  // the file must be written when flag is MAP_SHARED
  if (flags == MAP_SHARED && f->writable == 0 && (prot & PROT_WRITE)) {
    80004a7c:	4785                	li	a5,1
    80004a7e:	02f88d63          	beq	a7,a5,80004ab8 <sys_mmap+0xbc>
    return -1;
  }
  // offset must be a multiple of the page size
  if (len < 0 || offset < 0 || offset % PGSIZE) {
    80004a82:	fd442303          	lw	t1,-44(s0)
    80004a86:	0e034063          	bltz	t1,80004b66 <sys_mmap+0x16a>
    80004a8a:	fc842e03          	lw	t3,-56(s0)
    80004a8e:	0c0e4e63          	bltz	t3,80004b6a <sys_mmap+0x16e>
    80004a92:	034e1693          	slli	a3,t3,0x34
    80004a96:	0346d713          	srli	a4,a3,0x34
    return -1;
    80004a9a:	57fd                	li	a5,-1
  if (len < 0 || offset < 0 || offset % PGSIZE) {
    80004a9c:	eecd                	bnez	a3,80004b56 <sys_mmap+0x15a>
    80004a9e:	16848793          	addi	a5,s1,360
    80004aa2:	86be                	mv	a3,a5
  }

  // allocate a VMA for the mapped memory
  for (i = 0; i < NVMA; ++i) {
    80004aa4:	45c1                	li	a1,16
    if (!p->vma[i].addr) {
    80004aa6:	6290                	ld	a2,0(a3)
    80004aa8:	c21d                	beqz	a2,80004ace <sys_mmap+0xd2>
  for (i = 0; i < NVMA; ++i) {
    80004aaa:	2705                	addiw	a4,a4,1
    80004aac:	02068693          	addi	a3,a3,32
    80004ab0:	feb71be3          	bne	a4,a1,80004aa6 <sys_mmap+0xaa>
      vma = &p->vma[i];
      break;
    }
  }
  if (!vma) {
    return -1;
    80004ab4:	57fd                	li	a5,-1
    80004ab6:	a045                	j	80004b56 <sys_mmap+0x15a>
  if (flags == MAP_SHARED && f->writable == 0 && (prot & PROT_WRITE)) {
    80004ab8:	fc043783          	ld	a5,-64(s0)
    80004abc:	0097c783          	lbu	a5,9(a5)
    80004ac0:	f3e9                	bnez	a5,80004a82 <sys_mmap+0x86>
    80004ac2:	fd042703          	lw	a4,-48(s0)
    80004ac6:	8b09                	andi	a4,a4,2
    return -1;
    80004ac8:	57fd                	li	a5,-1
  if (flags == MAP_SHARED && f->writable == 0 && (prot & PROT_WRITE)) {
    80004aca:	df45                	beqz	a4,80004a82 <sys_mmap+0x86>
    80004acc:	a069                	j	80004b56 <sys_mmap+0x15a>
      vma = &p->vma[i];
    80004ace:	00571693          	slli	a3,a4,0x5
    80004ad2:	16868693          	addi	a3,a3,360
    80004ad6:	96a6                	add	a3,a3,s1
  if (!vma) {
    80004ad8:	cad9                	beqz	a3,80004b6e <sys_mmap+0x172>
  }

  // assume that addr will always be 0, the kernel
  //choose the page-aligned address at which to create
  //the mapping
  addr = MMAPMINADDR;
    80004ada:	010005b7          	lui	a1,0x1000
    80004ade:	15f5                	addi	a1,a1,-3 # fffffd <_entry-0x7f000003>
    80004ae0:	05ba                	slli	a1,a1,0xe
    80004ae2:	fcb43c23          	sd	a1,-40(s0)
  for (i = 0; i < NVMA; ++i) {
    80004ae6:	36848513          	addi	a0,s1,872
  addr = MMAPMINADDR;
    80004aea:	4601                	li	a2,0
    if (p->vma[i].addr) {
      // get the max address of the mapped memory
      addr = max(addr, p->vma[i].addr + p->vma[i].len);
    80004aec:	4805                	li	a6,1
    80004aee:	a031                	j	80004afa <sys_mmap+0xfe>
    80004af0:	8642                	mv	a2,a6
  for (i = 0; i < NVMA; ++i) {
    80004af2:	02078793          	addi	a5,a5,32
    80004af6:	00a78a63          	beq	a5,a0,80004b0a <sys_mmap+0x10e>
    if (p->vma[i].addr) {
    80004afa:	6398                	ld	a4,0(a5)
    80004afc:	db7d                	beqz	a4,80004af2 <sys_mmap+0xf6>
      addr = max(addr, p->vma[i].addr + p->vma[i].len);
    80004afe:	4790                	lw	a2,8(a5)
    80004b00:	9732                	add	a4,a4,a2
    80004b02:	fee5f7e3          	bgeu	a1,a4,80004af0 <sys_mmap+0xf4>
    80004b06:	85ba                	mv	a1,a4
    80004b08:	b7e5                	j	80004af0 <sys_mmap+0xf4>
    80004b0a:	c219                	beqz	a2,80004b10 <sys_mmap+0x114>
    80004b0c:	fcb43c23          	sd	a1,-40(s0)
    }
  }
  addr = PGROUNDUP(addr);
    80004b10:	fd843703          	ld	a4,-40(s0)
    80004b14:	6785                	lui	a5,0x1
    80004b16:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004b18:	973e                	add	a4,a4,a5
    80004b1a:	77fd                	lui	a5,0xfffff
    80004b1c:	8f7d                	and	a4,a4,a5
    80004b1e:	fce43c23          	sd	a4,-40(s0)
  if (addr + len > TRAPFRAME) {
    80004b22:	00e305b3          	add	a1,t1,a4
    80004b26:	02000637          	lui	a2,0x2000
    80004b2a:	167d                	addi	a2,a2,-1 # 1ffffff <_entry-0x7e000001>
    80004b2c:	0636                	slli	a2,a2,0xd
    return -1;
    80004b2e:	57fd                	li	a5,-1
  if (addr + len > TRAPFRAME) {
    80004b30:	02b66363          	bltu	a2,a1,80004b56 <sys_mmap+0x15a>
  }
  vma->addr = addr;
    80004b34:	e298                	sd	a4,0(a3)
  vma->len = len;
    80004b36:	0066a423          	sw	t1,8(a3)
  vma->prot = prot;
    80004b3a:	fd042783          	lw	a5,-48(s0)
    80004b3e:	c6dc                	sw	a5,12(a3)
  vma->flags = flags;
    80004b40:	0116a823          	sw	a7,16(a3)
  vma->offset = offset;
    80004b44:	01c6aa23          	sw	t3,20(a3)
  vma->f = f;
    80004b48:	fc043503          	ld	a0,-64(s0)
    80004b4c:	ee88                	sd	a0,24(a3)
  filedup(f);     // increase the file's reference count
    80004b4e:	addfe0ef          	jal	8000362a <filedup>

  return addr;
    80004b52:	fd843783          	ld	a5,-40(s0)
}
    80004b56:	853e                	mv	a0,a5
    80004b58:	70e2                	ld	ra,56(sp)
    80004b5a:	7442                	ld	s0,48(sp)
    80004b5c:	74a2                	ld	s1,40(sp)
    80004b5e:	6121                	addi	sp,sp,64
    80004b60:	8082                	ret
    return -1;
    80004b62:	57fd                	li	a5,-1
    80004b64:	bfcd                	j	80004b56 <sys_mmap+0x15a>
    return -1;
    80004b66:	57fd                	li	a5,-1
    80004b68:	b7fd                	j	80004b56 <sys_mmap+0x15a>
    80004b6a:	57fd                	li	a5,-1
    80004b6c:	b7ed                	j	80004b56 <sys_mmap+0x15a>
    return -1;
    80004b6e:	57fd                	li	a5,-1
    80004b70:	b7dd                	j	80004b56 <sys_mmap+0x15a>

0000000080004b72 <sys_munmap>:

// lab10
uint64 sys_munmap(void) {
    80004b72:	7175                	addi	sp,sp,-144
    80004b74:	e506                	sd	ra,136(sp)
    80004b76:	e122                	sd	s0,128(sp)
    80004b78:	e0e2                	sd	s8,64(sp)
    80004b7a:	f86a                	sd	s10,48(sp)
    80004b7c:	0900                	addi	s0,sp,144
  uint64 addr, va;
  int len;
  struct proc *p = myproc();
    80004b7e:	a56fc0ef          	jal	80000dd4 <myproc>
    80004b82:	8c2a                	mv	s8,a0
  struct vm_area *vma = 0;
  uint maxsz, n, n1;
  int i;

  if (argaddr(0, &addr) < 0 || argint(1, &len) < 0) {
    80004b84:	f8840593          	addi	a1,s0,-120
    80004b88:	4501                	li	a0,0
    80004b8a:	c2cfd0ef          	jal	80001fb6 <argaddr>
    80004b8e:	20054c63          	bltz	a0,80004da6 <sys_munmap+0x234>
    80004b92:	f8440593          	addi	a1,s0,-124
    80004b96:	4505                	li	a0,1
    80004b98:	c00fd0ef          	jal	80001f98 <argint>
    80004b9c:	20054763          	bltz	a0,80004daa <sys_munmap+0x238>
    80004ba0:	f4ce                	sd	s3,104(sp)
    return -1;
  }
  if (addr % PGSIZE || len < 0) {
    80004ba2:	f8843983          	ld	s3,-120(s0)
    80004ba6:	03499793          	slli	a5,s3,0x34
    80004baa:	0347dd13          	srli	s10,a5,0x34
    80004bae:	20079063          	bnez	a5,80004dae <sys_munmap+0x23c>
    80004bb2:	f8442583          	lw	a1,-124(s0)
    80004bb6:	1e05cf63          	bltz	a1,80004db4 <sys_munmap+0x242>
    80004bba:	fca6                	sd	s1,120(sp)
    80004bbc:	168c0793          	addi	a5,s8,360
    return -1;
  }

  // find the VMA
  for (i = 0; i < NVMA; ++i) {
    80004bc0:	4481                	li	s1,0
    if (p->vma[i].addr && addr >= p->vma[i].addr
        && addr + len <= p->vma[i].addr + p->vma[i].len) {
    80004bc2:	01358533          	add	a0,a1,s3
  for (i = 0; i < NVMA; ++i) {
    80004bc6:	4641                	li	a2,16
    80004bc8:	a031                	j	80004bd4 <sys_munmap+0x62>
    80004bca:	2485                	addiw	s1,s1,1
    80004bcc:	02078793          	addi	a5,a5,32 # fffffffffffff020 <end+0xffffffff7ffd63b0>
    80004bd0:	04c48a63          	beq	s1,a2,80004c24 <sys_munmap+0xb2>
    if (p->vma[i].addr && addr >= p->vma[i].addr
    80004bd4:	6398                	ld	a4,0(a5)
    80004bd6:	db75                	beqz	a4,80004bca <sys_munmap+0x58>
    80004bd8:	fee9e9e3          	bltu	s3,a4,80004bca <sys_munmap+0x58>
        && addr + len <= p->vma[i].addr + p->vma[i].len) {
    80004bdc:	4794                	lw	a3,8(a5)
    80004bde:	9736                	add	a4,a4,a3
    80004be0:	fea765e3          	bltu	a4,a0,80004bca <sys_munmap+0x58>
      vma = &p->vma[i];
    80004be4:	0496                	slli	s1,s1,0x5
    80004be6:	16848493          	addi	s1,s1,360
    80004bea:	94e2                	add	s1,s1,s8
      break;
    }
  }
  if (!vma) {
    80004bec:	1c048763          	beqz	s1,80004dba <sys_munmap+0x248>
    return -1;
  }

  if (len == 0) {
    80004bf0:	1c058963          	beqz	a1,80004dc2 <sys_munmap+0x250>
    return 0;
  }

  if ((vma->flags & MAP_SHARED)) {
    80004bf4:	489c                	lw	a5,16(s1)
    80004bf6:	8b85                	andi	a5,a5,1
    80004bf8:	10078663          	beqz	a5,80004d04 <sys_munmap+0x192>
    // the max size once can write to the disk
    maxsz = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    for (va = addr; va < addr + len; va += PGSIZE) {
    80004bfc:	95ce                	add	a1,a1,s3
    80004bfe:	10b9f363          	bgeu	s3,a1,80004d04 <sys_munmap+0x192>
    80004c02:	f8ca                	sd	s2,112(sp)
    80004c04:	f0d2                	sd	s4,96(sp)
    80004c06:	ecd6                	sd	s5,88(sp)
    80004c08:	e8da                	sd	s6,80(sp)
    80004c0a:	e4de                	sd	s7,72(sp)
    80004c0c:	fc66                	sd	s9,56(sp)
    80004c0e:	f46e                	sd	s11,40(sp)
      if (uvmgetdirty(p->pagetable, va) == 0) {
        continue;
      }
      // only write the dirty page back to the mapped file
      n = min(PGSIZE, addr + len - va);
    80004c10:	6d85                	lui	s11,0x1
      for (i = 0; i < n; i += n1) {
        n1 = min(maxsz, n - i);
    80004c12:	6c85                	lui	s9,0x1
    80004c14:	c00c8c93          	addi	s9,s9,-1024 # c00 <_entry-0x7ffff400>
    80004c18:	6785                	lui	a5,0x1
    80004c1a:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80004c1e:	f6f42e23          	sw	a5,-132(s0)
    80004c22:	a065                	j	80004cca <sys_munmap+0x158>
    return -1;
    80004c24:	5d7d                	li	s10,-1
    80004c26:	74e6                	ld	s1,120(sp)
    80004c28:	79a6                	ld	s3,104(sp)
    vma->len -= len;
  } else {
    panic("unexpected munmap");
  }
  return 0;
    80004c2a:	856a                	mv	a0,s10
    80004c2c:	60aa                	ld	ra,136(sp)
    80004c2e:	640a                	ld	s0,128(sp)
    80004c30:	6c06                	ld	s8,64(sp)
    80004c32:	7d42                	ld	s10,48(sp)
    80004c34:	6149                	addi	sp,sp,144
    80004c36:	8082                	ret
        n1 = min(maxsz, n - i);
    80004c38:	00090a1b          	sext.w	s4,s2
        begin_op();
    80004c3c:	e1afe0ef          	jal	80003256 <begin_op>
        ilock(vma->f->ip);
    80004c40:	6c9c                	ld	a5,24(s1)
    80004c42:	6f88                	ld	a0,24(a5)
    80004c44:	d7dfd0ef          	jal	800029c0 <ilock>
        if (writei(vma->f->ip, 1, va + i, va - vma->addr + vma->offset + i, n1) != n1) {
    80004c48:	609c                	ld	a5,0(s1)
    80004c4a:	48d4                	lw	a3,20(s1)
    80004c4c:	9e9d                	subw	a3,a3,a5
    80004c4e:	013686bb          	addw	a3,a3,s3
    80004c52:	6c9c                	ld	a5,24(s1)
    80004c54:	8752                	mv	a4,s4
    80004c56:	015686bb          	addw	a3,a3,s5
    80004c5a:	013b8633          	add	a2,s7,s3
    80004c5e:	4585                	li	a1,1
    80004c60:	6f88                	ld	a0,24(a5)
    80004c62:	8aefe0ef          	jal	80002d10 <writei>
    80004c66:	2501                	sext.w	a0,a0
    80004c68:	03451863          	bne	a0,s4,80004c98 <sys_munmap+0x126>
        iunlock(vma->f->ip);
    80004c6c:	6c9c                	ld	a5,24(s1)
    80004c6e:	6f88                	ld	a0,24(a5)
    80004c70:	dfffd0ef          	jal	80002a6e <iunlock>
        end_op();
    80004c74:	e4cfe0ef          	jal	800032c0 <end_op>
      for (i = 0; i < n; i += n1) {
    80004c78:	0159093b          	addw	s2,s2,s5
    80004c7c:	00090a9b          	sext.w	s5,s2
    80004c80:	8bd6                	mv	s7,s5
    80004c82:	036afc63          	bgeu	s5,s6,80004cba <sys_munmap+0x148>
        n1 = min(maxsz, n - i);
    80004c86:	415b093b          	subw	s2,s6,s5
    80004c8a:	0009079b          	sext.w	a5,s2
    80004c8e:	fafcf5e3          	bgeu	s9,a5,80004c38 <sys_munmap+0xc6>
    80004c92:	f7c42903          	lw	s2,-132(s0)
    80004c96:	b74d                	j	80004c38 <sys_munmap+0xc6>
          iunlock(vma->f->ip);
    80004c98:	6c9c                	ld	a5,24(s1)
    80004c9a:	6f88                	ld	a0,24(a5)
    80004c9c:	dd3fd0ef          	jal	80002a6e <iunlock>
          end_op();
    80004ca0:	e20fe0ef          	jal	800032c0 <end_op>
          return -1;
    80004ca4:	5d7d                	li	s10,-1
    80004ca6:	74e6                	ld	s1,120(sp)
    80004ca8:	7946                	ld	s2,112(sp)
    80004caa:	79a6                	ld	s3,104(sp)
    80004cac:	7a06                	ld	s4,96(sp)
    80004cae:	6ae6                	ld	s5,88(sp)
    80004cb0:	6b46                	ld	s6,80(sp)
    80004cb2:	6ba6                	ld	s7,72(sp)
    80004cb4:	7ce2                	ld	s9,56(sp)
    80004cb6:	7da2                	ld	s11,40(sp)
    80004cb8:	bf8d                	j	80004c2a <sys_munmap+0xb8>
    for (va = addr; va < addr + len; va += PGSIZE) {
    80004cba:	99ee                	add	s3,s3,s11
    80004cbc:	f8442783          	lw	a5,-124(s0)
    80004cc0:	f8843703          	ld	a4,-120(s0)
    80004cc4:	97ba                	add	a5,a5,a4
    80004cc6:	02f9f863          	bgeu	s3,a5,80004cf6 <sys_munmap+0x184>
      if (uvmgetdirty(p->pagetable, va) == 0) {
    80004cca:	85ce                	mv	a1,s3
    80004ccc:	050c3503          	ld	a0,80(s8)
    80004cd0:	f07fb0ef          	jal	80000bd6 <uvmgetdirty>
    80004cd4:	d17d                	beqz	a0,80004cba <sys_munmap+0x148>
      n = min(PGSIZE, addr + len - va);
    80004cd6:	f8442b03          	lw	s6,-124(s0)
    80004cda:	f8843783          	ld	a5,-120(s0)
    80004cde:	9b3e                	add	s6,s6,a5
    80004ce0:	413b0b33          	sub	s6,s6,s3
    80004ce4:	016df363          	bgeu	s11,s6,80004cea <sys_munmap+0x178>
    80004ce8:	6b05                	lui	s6,0x1
    80004cea:	2b01                	sext.w	s6,s6
      for (i = 0; i < n; i += n1) {
    80004cec:	fc0b07e3          	beqz	s6,80004cba <sys_munmap+0x148>
    80004cf0:	4b81                	li	s7,0
    80004cf2:	4a81                	li	s5,0
    80004cf4:	bf49                	j	80004c86 <sys_munmap+0x114>
    80004cf6:	7946                	ld	s2,112(sp)
    80004cf8:	7a06                	ld	s4,96(sp)
    80004cfa:	6ae6                	ld	s5,88(sp)
    80004cfc:	6b46                	ld	s6,80(sp)
    80004cfe:	6ba6                	ld	s7,72(sp)
    80004d00:	7ce2                	ld	s9,56(sp)
    80004d02:	7da2                	ld	s11,40(sp)
  uvmunmap(p->pagetable, addr, (len - 1) / PGSIZE + 1, 1);
    80004d04:	f8442783          	lw	a5,-124(s0)
    80004d08:	37fd                	addiw	a5,a5,-1
    80004d0a:	41f7d61b          	sraiw	a2,a5,0x1f
    80004d0e:	0146561b          	srliw	a2,a2,0x14
    80004d12:	9e3d                	addw	a2,a2,a5
    80004d14:	40c6561b          	sraiw	a2,a2,0xc
    80004d18:	4685                	li	a3,1
    80004d1a:	2605                	addiw	a2,a2,1
    80004d1c:	f8843583          	ld	a1,-120(s0)
    80004d20:	050c3503          	ld	a0,80(s8)
    80004d24:	91dfb0ef          	jal	80000640 <uvmunmap>
  if (addr == vma->addr && len == vma->len) {
    80004d28:	609c                	ld	a5,0(s1)
    80004d2a:	f8843703          	ld	a4,-120(s0)
    80004d2e:	00e78e63          	beq	a5,a4,80004d4a <sys_munmap+0x1d8>
  } else if (addr + len == vma->addr + vma->len) {
    80004d32:	f8442603          	lw	a2,-124(s0)
    80004d36:	4494                	lw	a3,8(s1)
    80004d38:	9732                	add	a4,a4,a2
    80004d3a:	97b6                	add	a5,a5,a3
    80004d3c:	04f71863          	bne	a4,a5,80004d8c <sys_munmap+0x21a>
    vma->len -= len;
    80004d40:	9e91                	subw	a3,a3,a2
    80004d42:	c494                	sw	a3,8(s1)
    80004d44:	74e6                	ld	s1,120(sp)
    80004d46:	79a6                	ld	s3,104(sp)
    80004d48:	b5cd                	j	80004c2a <sys_munmap+0xb8>
  if (addr == vma->addr && len == vma->len) {
    80004d4a:	4498                	lw	a4,8(s1)
    80004d4c:	f8442683          	lw	a3,-124(s0)
    80004d50:	00d70c63          	beq	a4,a3,80004d68 <sys_munmap+0x1f6>
    vma->addr += len;
    80004d54:	97b6                	add	a5,a5,a3
    80004d56:	e09c                	sd	a5,0(s1)
    vma->offset += len;
    80004d58:	48dc                	lw	a5,20(s1)
    80004d5a:	9fb5                	addw	a5,a5,a3
    80004d5c:	c8dc                	sw	a5,20(s1)
    vma->len -= len;
    80004d5e:	9f15                	subw	a4,a4,a3
    80004d60:	c498                	sw	a4,8(s1)
    80004d62:	74e6                	ld	s1,120(sp)
    80004d64:	79a6                	ld	s3,104(sp)
    80004d66:	b5d1                	j	80004c2a <sys_munmap+0xb8>
    vma->addr = 0;
    80004d68:	0004b023          	sd	zero,0(s1)
    vma->len = 0;
    80004d6c:	0004a423          	sw	zero,8(s1)
    vma->offset = 0;
    80004d70:	0004aa23          	sw	zero,20(s1)
    vma->flags = 0;
    80004d74:	0004a823          	sw	zero,16(s1)
    vma->prot = 0;
    80004d78:	0004a623          	sw	zero,12(s1)
    fileclose(vma->f);
    80004d7c:	6c88                	ld	a0,24(s1)
    80004d7e:	8f3fe0ef          	jal	80003670 <fileclose>
    vma->f = 0;
    80004d82:	0004bc23          	sd	zero,24(s1)
    80004d86:	74e6                	ld	s1,120(sp)
    80004d88:	79a6                	ld	s3,104(sp)
    80004d8a:	b545                	j	80004c2a <sys_munmap+0xb8>
    80004d8c:	f8ca                	sd	s2,112(sp)
    80004d8e:	f0d2                	sd	s4,96(sp)
    80004d90:	ecd6                	sd	s5,88(sp)
    80004d92:	e8da                	sd	s6,80(sp)
    80004d94:	e4de                	sd	s7,72(sp)
    80004d96:	fc66                	sd	s9,56(sp)
    80004d98:	f46e                	sd	s11,40(sp)
    panic("unexpected munmap");
    80004d9a:	00003517          	auipc	a0,0x3
    80004d9e:	88e50513          	addi	a0,a0,-1906 # 80007628 <etext+0x628>
    80004da2:	5c1000ef          	jal	80005b62 <panic>
    return -1;
    80004da6:	5d7d                	li	s10,-1
    80004da8:	b549                	j	80004c2a <sys_munmap+0xb8>
    80004daa:	5d7d                	li	s10,-1
    80004dac:	bdbd                	j	80004c2a <sys_munmap+0xb8>
    return -1;
    80004dae:	5d7d                	li	s10,-1
    80004db0:	79a6                	ld	s3,104(sp)
    80004db2:	bda5                	j	80004c2a <sys_munmap+0xb8>
    80004db4:	5d7d                	li	s10,-1
    80004db6:	79a6                	ld	s3,104(sp)
    80004db8:	bd8d                	j	80004c2a <sys_munmap+0xb8>
    return -1;
    80004dba:	5d7d                	li	s10,-1
    80004dbc:	74e6                	ld	s1,120(sp)
    80004dbe:	79a6                	ld	s3,104(sp)
    80004dc0:	b5ad                	j	80004c2a <sys_munmap+0xb8>
    80004dc2:	74e6                	ld	s1,120(sp)
    80004dc4:	79a6                	ld	s3,104(sp)
    80004dc6:	b595                	j	80004c2a <sys_munmap+0xb8>
	...

0000000080004dd0 <kernelvec>:
    80004dd0:	7111                	addi	sp,sp,-256
    80004dd2:	e006                	sd	ra,0(sp)
    80004dd4:	e40a                	sd	sp,8(sp)
    80004dd6:	e80e                	sd	gp,16(sp)
    80004dd8:	ec12                	sd	tp,24(sp)
    80004dda:	f016                	sd	t0,32(sp)
    80004ddc:	f41a                	sd	t1,40(sp)
    80004dde:	f81e                	sd	t2,48(sp)
    80004de0:	e4aa                	sd	a0,72(sp)
    80004de2:	e8ae                	sd	a1,80(sp)
    80004de4:	ecb2                	sd	a2,88(sp)
    80004de6:	f0b6                	sd	a3,96(sp)
    80004de8:	f4ba                	sd	a4,104(sp)
    80004dea:	f8be                	sd	a5,112(sp)
    80004dec:	fcc2                	sd	a6,120(sp)
    80004dee:	e146                	sd	a7,128(sp)
    80004df0:	edf2                	sd	t3,216(sp)
    80004df2:	f1f6                	sd	t4,224(sp)
    80004df4:	f5fa                	sd	t5,232(sp)
    80004df6:	f9fe                	sd	t6,240(sp)
    80004df8:	826fd0ef          	jal	80001e1e <kerneltrap>
    80004dfc:	6082                	ld	ra,0(sp)
    80004dfe:	6122                	ld	sp,8(sp)
    80004e00:	61c2                	ld	gp,16(sp)
    80004e02:	7282                	ld	t0,32(sp)
    80004e04:	7322                	ld	t1,40(sp)
    80004e06:	73c2                	ld	t2,48(sp)
    80004e08:	6526                	ld	a0,72(sp)
    80004e0a:	65c6                	ld	a1,80(sp)
    80004e0c:	6666                	ld	a2,88(sp)
    80004e0e:	7686                	ld	a3,96(sp)
    80004e10:	7726                	ld	a4,104(sp)
    80004e12:	77c6                	ld	a5,112(sp)
    80004e14:	7866                	ld	a6,120(sp)
    80004e16:	688a                	ld	a7,128(sp)
    80004e18:	6e6e                	ld	t3,216(sp)
    80004e1a:	7e8e                	ld	t4,224(sp)
    80004e1c:	7f2e                	ld	t5,232(sp)
    80004e1e:	7fce                	ld	t6,240(sp)
    80004e20:	6111                	addi	sp,sp,256
    80004e22:	10200073          	sret
	...

0000000080004e2e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004e2e:	1141                	addi	sp,sp,-16
    80004e30:	e422                	sd	s0,8(sp)
    80004e32:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004e34:	0c0007b7          	lui	a5,0xc000
    80004e38:	4705                	li	a4,1
    80004e3a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004e3c:	0c0007b7          	lui	a5,0xc000
    80004e40:	c3d8                	sw	a4,4(a5)
}
    80004e42:	6422                	ld	s0,8(sp)
    80004e44:	0141                	addi	sp,sp,16
    80004e46:	8082                	ret

0000000080004e48 <plicinithart>:

void
plicinithart(void)
{
    80004e48:	1141                	addi	sp,sp,-16
    80004e4a:	e406                	sd	ra,8(sp)
    80004e4c:	e022                	sd	s0,0(sp)
    80004e4e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004e50:	f59fb0ef          	jal	80000da8 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004e54:	0085171b          	slliw	a4,a0,0x8
    80004e58:	0c0027b7          	lui	a5,0xc002
    80004e5c:	97ba                	add	a5,a5,a4
    80004e5e:	40200713          	li	a4,1026
    80004e62:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004e66:	00d5151b          	slliw	a0,a0,0xd
    80004e6a:	0c2017b7          	lui	a5,0xc201
    80004e6e:	97aa                	add	a5,a5,a0
    80004e70:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004e74:	60a2                	ld	ra,8(sp)
    80004e76:	6402                	ld	s0,0(sp)
    80004e78:	0141                	addi	sp,sp,16
    80004e7a:	8082                	ret

0000000080004e7c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004e7c:	1141                	addi	sp,sp,-16
    80004e7e:	e406                	sd	ra,8(sp)
    80004e80:	e022                	sd	s0,0(sp)
    80004e82:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004e84:	f25fb0ef          	jal	80000da8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004e88:	00d5151b          	slliw	a0,a0,0xd
    80004e8c:	0c2017b7          	lui	a5,0xc201
    80004e90:	97aa                	add	a5,a5,a0
  return irq;
}
    80004e92:	43c8                	lw	a0,4(a5)
    80004e94:	60a2                	ld	ra,8(sp)
    80004e96:	6402                	ld	s0,0(sp)
    80004e98:	0141                	addi	sp,sp,16
    80004e9a:	8082                	ret

0000000080004e9c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004e9c:	1101                	addi	sp,sp,-32
    80004e9e:	ec06                	sd	ra,24(sp)
    80004ea0:	e822                	sd	s0,16(sp)
    80004ea2:	e426                	sd	s1,8(sp)
    80004ea4:	1000                	addi	s0,sp,32
    80004ea6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004ea8:	f01fb0ef          	jal	80000da8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004eac:	00d5151b          	slliw	a0,a0,0xd
    80004eb0:	0c2017b7          	lui	a5,0xc201
    80004eb4:	97aa                	add	a5,a5,a0
    80004eb6:	c3c4                	sw	s1,4(a5)
}
    80004eb8:	60e2                	ld	ra,24(sp)
    80004eba:	6442                	ld	s0,16(sp)
    80004ebc:	64a2                	ld	s1,8(sp)
    80004ebe:	6105                	addi	sp,sp,32
    80004ec0:	8082                	ret

0000000080004ec2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004ec2:	1141                	addi	sp,sp,-16
    80004ec4:	e406                	sd	ra,8(sp)
    80004ec6:	e022                	sd	s0,0(sp)
    80004ec8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004eca:	479d                	li	a5,7
    80004ecc:	04a7ca63          	blt	a5,a0,80004f20 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004ed0:	0001c797          	auipc	a5,0x1c
    80004ed4:	b6078793          	addi	a5,a5,-1184 # 80020a30 <disk>
    80004ed8:	97aa                	add	a5,a5,a0
    80004eda:	0187c783          	lbu	a5,24(a5)
    80004ede:	e7b9                	bnez	a5,80004f2c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004ee0:	00451693          	slli	a3,a0,0x4
    80004ee4:	0001c797          	auipc	a5,0x1c
    80004ee8:	b4c78793          	addi	a5,a5,-1204 # 80020a30 <disk>
    80004eec:	6398                	ld	a4,0(a5)
    80004eee:	9736                	add	a4,a4,a3
    80004ef0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004ef4:	6398                	ld	a4,0(a5)
    80004ef6:	9736                	add	a4,a4,a3
    80004ef8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004efc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004f00:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004f04:	97aa                	add	a5,a5,a0
    80004f06:	4705                	li	a4,1
    80004f08:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004f0c:	0001c517          	auipc	a0,0x1c
    80004f10:	b3c50513          	addi	a0,a0,-1220 # 80020a48 <disk+0x18>
    80004f14:	fa4fc0ef          	jal	800016b8 <wakeup>
}
    80004f18:	60a2                	ld	ra,8(sp)
    80004f1a:	6402                	ld	s0,0(sp)
    80004f1c:	0141                	addi	sp,sp,16
    80004f1e:	8082                	ret
    panic("free_desc 1");
    80004f20:	00002517          	auipc	a0,0x2
    80004f24:	72050513          	addi	a0,a0,1824 # 80007640 <etext+0x640>
    80004f28:	43b000ef          	jal	80005b62 <panic>
    panic("free_desc 2");
    80004f2c:	00002517          	auipc	a0,0x2
    80004f30:	72450513          	addi	a0,a0,1828 # 80007650 <etext+0x650>
    80004f34:	42f000ef          	jal	80005b62 <panic>

0000000080004f38 <virtio_disk_init>:
{
    80004f38:	1101                	addi	sp,sp,-32
    80004f3a:	ec06                	sd	ra,24(sp)
    80004f3c:	e822                	sd	s0,16(sp)
    80004f3e:	e426                	sd	s1,8(sp)
    80004f40:	e04a                	sd	s2,0(sp)
    80004f42:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004f44:	00002597          	auipc	a1,0x2
    80004f48:	71c58593          	addi	a1,a1,1820 # 80007660 <etext+0x660>
    80004f4c:	0001c517          	auipc	a0,0x1c
    80004f50:	c0c50513          	addi	a0,a0,-1012 # 80020b58 <disk+0x128>
    80004f54:	6bd000ef          	jal	80005e10 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004f58:	100017b7          	lui	a5,0x10001
    80004f5c:	4398                	lw	a4,0(a5)
    80004f5e:	2701                	sext.w	a4,a4
    80004f60:	747277b7          	lui	a5,0x74727
    80004f64:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004f68:	18f71063          	bne	a4,a5,800050e8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004f6c:	100017b7          	lui	a5,0x10001
    80004f70:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004f72:	439c                	lw	a5,0(a5)
    80004f74:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004f76:	4709                	li	a4,2
    80004f78:	16e79863          	bne	a5,a4,800050e8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004f7c:	100017b7          	lui	a5,0x10001
    80004f80:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004f82:	439c                	lw	a5,0(a5)
    80004f84:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004f86:	16e79163          	bne	a5,a4,800050e8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004f8a:	100017b7          	lui	a5,0x10001
    80004f8e:	47d8                	lw	a4,12(a5)
    80004f90:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004f92:	554d47b7          	lui	a5,0x554d4
    80004f96:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004f9a:	14f71763          	bne	a4,a5,800050e8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004f9e:	100017b7          	lui	a5,0x10001
    80004fa2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004fa6:	4705                	li	a4,1
    80004fa8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004faa:	470d                	li	a4,3
    80004fac:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004fae:	10001737          	lui	a4,0x10001
    80004fb2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004fb4:	c7ffe737          	lui	a4,0xc7ffe
    80004fb8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd5aef>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004fbc:	8ef9                	and	a3,a3,a4
    80004fbe:	10001737          	lui	a4,0x10001
    80004fc2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004fc4:	472d                	li	a4,11
    80004fc6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004fc8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004fcc:	439c                	lw	a5,0(a5)
    80004fce:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004fd2:	8ba1                	andi	a5,a5,8
    80004fd4:	12078063          	beqz	a5,800050f4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004fd8:	100017b7          	lui	a5,0x10001
    80004fdc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004fe0:	100017b7          	lui	a5,0x10001
    80004fe4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004fe8:	439c                	lw	a5,0(a5)
    80004fea:	2781                	sext.w	a5,a5
    80004fec:	10079a63          	bnez	a5,80005100 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004ff0:	100017b7          	lui	a5,0x10001
    80004ff4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004ff8:	439c                	lw	a5,0(a5)
    80004ffa:	2781                	sext.w	a5,a5
  if(max == 0)
    80004ffc:	10078863          	beqz	a5,8000510c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005000:	471d                	li	a4,7
    80005002:	10f77b63          	bgeu	a4,a5,80005118 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005006:	8f8fb0ef          	jal	800000fe <kalloc>
    8000500a:	0001c497          	auipc	s1,0x1c
    8000500e:	a2648493          	addi	s1,s1,-1498 # 80020a30 <disk>
    80005012:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005014:	8eafb0ef          	jal	800000fe <kalloc>
    80005018:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000501a:	8e4fb0ef          	jal	800000fe <kalloc>
    8000501e:	87aa                	mv	a5,a0
    80005020:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005022:	6088                	ld	a0,0(s1)
    80005024:	10050063          	beqz	a0,80005124 <virtio_disk_init+0x1ec>
    80005028:	0001c717          	auipc	a4,0x1c
    8000502c:	a1073703          	ld	a4,-1520(a4) # 80020a38 <disk+0x8>
    80005030:	0e070a63          	beqz	a4,80005124 <virtio_disk_init+0x1ec>
    80005034:	0e078863          	beqz	a5,80005124 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005038:	6605                	lui	a2,0x1
    8000503a:	4581                	li	a1,0
    8000503c:	912fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80005040:	0001c497          	auipc	s1,0x1c
    80005044:	9f048493          	addi	s1,s1,-1552 # 80020a30 <disk>
    80005048:	6605                	lui	a2,0x1
    8000504a:	4581                	li	a1,0
    8000504c:	6488                	ld	a0,8(s1)
    8000504e:	900fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80005052:	6605                	lui	a2,0x1
    80005054:	4581                	li	a1,0
    80005056:	6888                	ld	a0,16(s1)
    80005058:	8f6fb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000505c:	100017b7          	lui	a5,0x10001
    80005060:	4721                	li	a4,8
    80005062:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005064:	4098                	lw	a4,0(s1)
    80005066:	100017b7          	lui	a5,0x10001
    8000506a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000506e:	40d8                	lw	a4,4(s1)
    80005070:	100017b7          	lui	a5,0x10001
    80005074:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005078:	649c                	ld	a5,8(s1)
    8000507a:	0007869b          	sext.w	a3,a5
    8000507e:	10001737          	lui	a4,0x10001
    80005082:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005086:	9781                	srai	a5,a5,0x20
    80005088:	10001737          	lui	a4,0x10001
    8000508c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005090:	689c                	ld	a5,16(s1)
    80005092:	0007869b          	sext.w	a3,a5
    80005096:	10001737          	lui	a4,0x10001
    8000509a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000509e:	9781                	srai	a5,a5,0x20
    800050a0:	10001737          	lui	a4,0x10001
    800050a4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800050a8:	10001737          	lui	a4,0x10001
    800050ac:	4785                	li	a5,1
    800050ae:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800050b0:	00f48c23          	sb	a5,24(s1)
    800050b4:	00f48ca3          	sb	a5,25(s1)
    800050b8:	00f48d23          	sb	a5,26(s1)
    800050bc:	00f48da3          	sb	a5,27(s1)
    800050c0:	00f48e23          	sb	a5,28(s1)
    800050c4:	00f48ea3          	sb	a5,29(s1)
    800050c8:	00f48f23          	sb	a5,30(s1)
    800050cc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800050d0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800050d4:	100017b7          	lui	a5,0x10001
    800050d8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800050dc:	60e2                	ld	ra,24(sp)
    800050de:	6442                	ld	s0,16(sp)
    800050e0:	64a2                	ld	s1,8(sp)
    800050e2:	6902                	ld	s2,0(sp)
    800050e4:	6105                	addi	sp,sp,32
    800050e6:	8082                	ret
    panic("could not find virtio disk");
    800050e8:	00002517          	auipc	a0,0x2
    800050ec:	58850513          	addi	a0,a0,1416 # 80007670 <etext+0x670>
    800050f0:	273000ef          	jal	80005b62 <panic>
    panic("virtio disk FEATURES_OK unset");
    800050f4:	00002517          	auipc	a0,0x2
    800050f8:	59c50513          	addi	a0,a0,1436 # 80007690 <etext+0x690>
    800050fc:	267000ef          	jal	80005b62 <panic>
    panic("virtio disk should not be ready");
    80005100:	00002517          	auipc	a0,0x2
    80005104:	5b050513          	addi	a0,a0,1456 # 800076b0 <etext+0x6b0>
    80005108:	25b000ef          	jal	80005b62 <panic>
    panic("virtio disk has no queue 0");
    8000510c:	00002517          	auipc	a0,0x2
    80005110:	5c450513          	addi	a0,a0,1476 # 800076d0 <etext+0x6d0>
    80005114:	24f000ef          	jal	80005b62 <panic>
    panic("virtio disk max queue too short");
    80005118:	00002517          	auipc	a0,0x2
    8000511c:	5d850513          	addi	a0,a0,1496 # 800076f0 <etext+0x6f0>
    80005120:	243000ef          	jal	80005b62 <panic>
    panic("virtio disk kalloc");
    80005124:	00002517          	auipc	a0,0x2
    80005128:	5ec50513          	addi	a0,a0,1516 # 80007710 <etext+0x710>
    8000512c:	237000ef          	jal	80005b62 <panic>

0000000080005130 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005130:	7159                	addi	sp,sp,-112
    80005132:	f486                	sd	ra,104(sp)
    80005134:	f0a2                	sd	s0,96(sp)
    80005136:	eca6                	sd	s1,88(sp)
    80005138:	e8ca                	sd	s2,80(sp)
    8000513a:	e4ce                	sd	s3,72(sp)
    8000513c:	e0d2                	sd	s4,64(sp)
    8000513e:	fc56                	sd	s5,56(sp)
    80005140:	f85a                	sd	s6,48(sp)
    80005142:	f45e                	sd	s7,40(sp)
    80005144:	f062                	sd	s8,32(sp)
    80005146:	ec66                	sd	s9,24(sp)
    80005148:	1880                	addi	s0,sp,112
    8000514a:	8a2a                	mv	s4,a0
    8000514c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000514e:	00c52c83          	lw	s9,12(a0)
    80005152:	001c9c9b          	slliw	s9,s9,0x1
    80005156:	1c82                	slli	s9,s9,0x20
    80005158:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000515c:	0001c517          	auipc	a0,0x1c
    80005160:	9fc50513          	addi	a0,a0,-1540 # 80020b58 <disk+0x128>
    80005164:	52d000ef          	jal	80005e90 <acquire>
  for(int i = 0; i < 3; i++){
    80005168:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000516a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000516c:	0001cb17          	auipc	s6,0x1c
    80005170:	8c4b0b13          	addi	s6,s6,-1852 # 80020a30 <disk>
  for(int i = 0; i < 3; i++){
    80005174:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005176:	0001cc17          	auipc	s8,0x1c
    8000517a:	9e2c0c13          	addi	s8,s8,-1566 # 80020b58 <disk+0x128>
    8000517e:	a8b9                	j	800051dc <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005180:	00fb0733          	add	a4,s6,a5
    80005184:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005188:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000518a:	0207c563          	bltz	a5,800051b4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000518e:	2905                	addiw	s2,s2,1
    80005190:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005192:	05590963          	beq	s2,s5,800051e4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005196:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005198:	0001c717          	auipc	a4,0x1c
    8000519c:	89870713          	addi	a4,a4,-1896 # 80020a30 <disk>
    800051a0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800051a2:	01874683          	lbu	a3,24(a4)
    800051a6:	fee9                	bnez	a3,80005180 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    800051a8:	2785                	addiw	a5,a5,1
    800051aa:	0705                	addi	a4,a4,1
    800051ac:	fe979be3          	bne	a5,s1,800051a2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800051b0:	57fd                	li	a5,-1
    800051b2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800051b4:	01205d63          	blez	s2,800051ce <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800051b8:	f9042503          	lw	a0,-112(s0)
    800051bc:	d07ff0ef          	jal	80004ec2 <free_desc>
      for(int j = 0; j < i; j++)
    800051c0:	4785                	li	a5,1
    800051c2:	0127d663          	bge	a5,s2,800051ce <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800051c6:	f9442503          	lw	a0,-108(s0)
    800051ca:	cf9ff0ef          	jal	80004ec2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800051ce:	85e2                	mv	a1,s8
    800051d0:	0001c517          	auipc	a0,0x1c
    800051d4:	87850513          	addi	a0,a0,-1928 # 80020a48 <disk+0x18>
    800051d8:	c90fc0ef          	jal	80001668 <sleep>
  for(int i = 0; i < 3; i++){
    800051dc:	f9040613          	addi	a2,s0,-112
    800051e0:	894e                	mv	s2,s3
    800051e2:	bf55                	j	80005196 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800051e4:	f9042503          	lw	a0,-112(s0)
    800051e8:	00451693          	slli	a3,a0,0x4

  if(write)
    800051ec:	0001c797          	auipc	a5,0x1c
    800051f0:	84478793          	addi	a5,a5,-1980 # 80020a30 <disk>
    800051f4:	00a50713          	addi	a4,a0,10
    800051f8:	0712                	slli	a4,a4,0x4
    800051fa:	973e                	add	a4,a4,a5
    800051fc:	01703633          	snez	a2,s7
    80005200:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005202:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005206:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000520a:	6398                	ld	a4,0(a5)
    8000520c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000520e:	0a868613          	addi	a2,a3,168
    80005212:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005214:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005216:	6390                	ld	a2,0(a5)
    80005218:	00d605b3          	add	a1,a2,a3
    8000521c:	4741                	li	a4,16
    8000521e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005220:	4805                	li	a6,1
    80005222:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005226:	f9442703          	lw	a4,-108(s0)
    8000522a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000522e:	0712                	slli	a4,a4,0x4
    80005230:	963a                	add	a2,a2,a4
    80005232:	058a0593          	addi	a1,s4,88
    80005236:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005238:	0007b883          	ld	a7,0(a5)
    8000523c:	9746                	add	a4,a4,a7
    8000523e:	40000613          	li	a2,1024
    80005242:	c710                	sw	a2,8(a4)
  if(write)
    80005244:	001bb613          	seqz	a2,s7
    80005248:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000524c:	00166613          	ori	a2,a2,1
    80005250:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005254:	f9842583          	lw	a1,-104(s0)
    80005258:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000525c:	00250613          	addi	a2,a0,2
    80005260:	0612                	slli	a2,a2,0x4
    80005262:	963e                	add	a2,a2,a5
    80005264:	577d                	li	a4,-1
    80005266:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000526a:	0592                	slli	a1,a1,0x4
    8000526c:	98ae                	add	a7,a7,a1
    8000526e:	03068713          	addi	a4,a3,48
    80005272:	973e                	add	a4,a4,a5
    80005274:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005278:	6398                	ld	a4,0(a5)
    8000527a:	972e                	add	a4,a4,a1
    8000527c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005280:	4689                	li	a3,2
    80005282:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005286:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000528a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000528e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005292:	6794                	ld	a3,8(a5)
    80005294:	0026d703          	lhu	a4,2(a3)
    80005298:	8b1d                	andi	a4,a4,7
    8000529a:	0706                	slli	a4,a4,0x1
    8000529c:	96ba                	add	a3,a3,a4
    8000529e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800052a2:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800052a6:	6798                	ld	a4,8(a5)
    800052a8:	00275783          	lhu	a5,2(a4)
    800052ac:	2785                	addiw	a5,a5,1
    800052ae:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800052b2:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800052b6:	100017b7          	lui	a5,0x10001
    800052ba:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800052be:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800052c2:	0001c917          	auipc	s2,0x1c
    800052c6:	89690913          	addi	s2,s2,-1898 # 80020b58 <disk+0x128>
  while(b->disk == 1) {
    800052ca:	4485                	li	s1,1
    800052cc:	01079a63          	bne	a5,a6,800052e0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    800052d0:	85ca                	mv	a1,s2
    800052d2:	8552                	mv	a0,s4
    800052d4:	b94fc0ef          	jal	80001668 <sleep>
  while(b->disk == 1) {
    800052d8:	004a2783          	lw	a5,4(s4)
    800052dc:	fe978ae3          	beq	a5,s1,800052d0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    800052e0:	f9042903          	lw	s2,-112(s0)
    800052e4:	00290713          	addi	a4,s2,2
    800052e8:	0712                	slli	a4,a4,0x4
    800052ea:	0001b797          	auipc	a5,0x1b
    800052ee:	74678793          	addi	a5,a5,1862 # 80020a30 <disk>
    800052f2:	97ba                	add	a5,a5,a4
    800052f4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800052f8:	0001b997          	auipc	s3,0x1b
    800052fc:	73898993          	addi	s3,s3,1848 # 80020a30 <disk>
    80005300:	00491713          	slli	a4,s2,0x4
    80005304:	0009b783          	ld	a5,0(s3)
    80005308:	97ba                	add	a5,a5,a4
    8000530a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000530e:	854a                	mv	a0,s2
    80005310:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005314:	bafff0ef          	jal	80004ec2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005318:	8885                	andi	s1,s1,1
    8000531a:	f0fd                	bnez	s1,80005300 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000531c:	0001c517          	auipc	a0,0x1c
    80005320:	83c50513          	addi	a0,a0,-1988 # 80020b58 <disk+0x128>
    80005324:	405000ef          	jal	80005f28 <release>
}
    80005328:	70a6                	ld	ra,104(sp)
    8000532a:	7406                	ld	s0,96(sp)
    8000532c:	64e6                	ld	s1,88(sp)
    8000532e:	6946                	ld	s2,80(sp)
    80005330:	69a6                	ld	s3,72(sp)
    80005332:	6a06                	ld	s4,64(sp)
    80005334:	7ae2                	ld	s5,56(sp)
    80005336:	7b42                	ld	s6,48(sp)
    80005338:	7ba2                	ld	s7,40(sp)
    8000533a:	7c02                	ld	s8,32(sp)
    8000533c:	6ce2                	ld	s9,24(sp)
    8000533e:	6165                	addi	sp,sp,112
    80005340:	8082                	ret

0000000080005342 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005342:	1101                	addi	sp,sp,-32
    80005344:	ec06                	sd	ra,24(sp)
    80005346:	e822                	sd	s0,16(sp)
    80005348:	e426                	sd	s1,8(sp)
    8000534a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000534c:	0001b497          	auipc	s1,0x1b
    80005350:	6e448493          	addi	s1,s1,1764 # 80020a30 <disk>
    80005354:	0001c517          	auipc	a0,0x1c
    80005358:	80450513          	addi	a0,a0,-2044 # 80020b58 <disk+0x128>
    8000535c:	335000ef          	jal	80005e90 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005360:	100017b7          	lui	a5,0x10001
    80005364:	53b8                	lw	a4,96(a5)
    80005366:	8b0d                	andi	a4,a4,3
    80005368:	100017b7          	lui	a5,0x10001
    8000536c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000536e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005372:	689c                	ld	a5,16(s1)
    80005374:	0204d703          	lhu	a4,32(s1)
    80005378:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000537c:	04f70663          	beq	a4,a5,800053c8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005380:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005384:	6898                	ld	a4,16(s1)
    80005386:	0204d783          	lhu	a5,32(s1)
    8000538a:	8b9d                	andi	a5,a5,7
    8000538c:	078e                	slli	a5,a5,0x3
    8000538e:	97ba                	add	a5,a5,a4
    80005390:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005392:	00278713          	addi	a4,a5,2
    80005396:	0712                	slli	a4,a4,0x4
    80005398:	9726                	add	a4,a4,s1
    8000539a:	01074703          	lbu	a4,16(a4)
    8000539e:	e321                	bnez	a4,800053de <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800053a0:	0789                	addi	a5,a5,2
    800053a2:	0792                	slli	a5,a5,0x4
    800053a4:	97a6                	add	a5,a5,s1
    800053a6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800053a8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800053ac:	b0cfc0ef          	jal	800016b8 <wakeup>

    disk.used_idx += 1;
    800053b0:	0204d783          	lhu	a5,32(s1)
    800053b4:	2785                	addiw	a5,a5,1
    800053b6:	17c2                	slli	a5,a5,0x30
    800053b8:	93c1                	srli	a5,a5,0x30
    800053ba:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800053be:	6898                	ld	a4,16(s1)
    800053c0:	00275703          	lhu	a4,2(a4)
    800053c4:	faf71ee3          	bne	a4,a5,80005380 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800053c8:	0001b517          	auipc	a0,0x1b
    800053cc:	79050513          	addi	a0,a0,1936 # 80020b58 <disk+0x128>
    800053d0:	359000ef          	jal	80005f28 <release>
}
    800053d4:	60e2                	ld	ra,24(sp)
    800053d6:	6442                	ld	s0,16(sp)
    800053d8:	64a2                	ld	s1,8(sp)
    800053da:	6105                	addi	sp,sp,32
    800053dc:	8082                	ret
      panic("virtio_disk_intr status");
    800053de:	00002517          	auipc	a0,0x2
    800053e2:	34a50513          	addi	a0,a0,842 # 80007728 <etext+0x728>
    800053e6:	77c000ef          	jal	80005b62 <panic>

00000000800053ea <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    800053ea:	1141                	addi	sp,sp,-16
    800053ec:	e422                	sd	s0,8(sp)
    800053ee:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    800053f0:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    800053f4:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    800053f8:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    800053fc:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80005400:	577d                	li	a4,-1
    80005402:	177e                	slli	a4,a4,0x3f
    80005404:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80005406:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000540a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    8000540e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80005412:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80005416:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000541a:	000f4737          	lui	a4,0xf4
    8000541e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80005422:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80005424:	14d79073          	csrw	stimecmp,a5
}
    80005428:	6422                	ld	s0,8(sp)
    8000542a:	0141                	addi	sp,sp,16
    8000542c:	8082                	ret

000000008000542e <start>:
{
    8000542e:	1141                	addi	sp,sp,-16
    80005430:	e406                	sd	ra,8(sp)
    80005432:	e022                	sd	s0,0(sp)
    80005434:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005436:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000543a:	7779                	lui	a4,0xffffe
    8000543c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd5b8f>
    80005440:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005442:	6705                	lui	a4,0x1
    80005444:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005448:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000544a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000544e:	ffffb797          	auipc	a5,0xffffb
    80005452:	e9a78793          	addi	a5,a5,-358 # 800002e8 <main>
    80005456:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000545a:	4781                	li	a5,0
    8000545c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005460:	67c1                	lui	a5,0x10
    80005462:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005464:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005468:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000546c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005470:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005474:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005478:	57fd                	li	a5,-1
    8000547a:	83a9                	srli	a5,a5,0xa
    8000547c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005480:	47bd                	li	a5,15
    80005482:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005486:	f65ff0ef          	jal	800053ea <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000548a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000548e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005490:	823e                	mv	tp,a5
  asm volatile("mret");
    80005492:	30200073          	mret
}
    80005496:	60a2                	ld	ra,8(sp)
    80005498:	6402                	ld	s0,0(sp)
    8000549a:	0141                	addi	sp,sp,16
    8000549c:	8082                	ret

000000008000549e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000549e:	715d                	addi	sp,sp,-80
    800054a0:	e486                	sd	ra,72(sp)
    800054a2:	e0a2                	sd	s0,64(sp)
    800054a4:	f84a                	sd	s2,48(sp)
    800054a6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800054a8:	04c05263          	blez	a2,800054ec <consolewrite+0x4e>
    800054ac:	fc26                	sd	s1,56(sp)
    800054ae:	f44e                	sd	s3,40(sp)
    800054b0:	f052                	sd	s4,32(sp)
    800054b2:	ec56                	sd	s5,24(sp)
    800054b4:	8a2a                	mv	s4,a0
    800054b6:	84ae                	mv	s1,a1
    800054b8:	89b2                	mv	s3,a2
    800054ba:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800054bc:	5afd                	li	s5,-1
    800054be:	4685                	li	a3,1
    800054c0:	8626                	mv	a2,s1
    800054c2:	85d2                	mv	a1,s4
    800054c4:	fbf40513          	addi	a0,s0,-65
    800054c8:	c52fc0ef          	jal	8000191a <either_copyin>
    800054cc:	03550263          	beq	a0,s5,800054f0 <consolewrite+0x52>
      break;
    uartputc(c);
    800054d0:	fbf44503          	lbu	a0,-65(s0)
    800054d4:	035000ef          	jal	80005d08 <uartputc>
  for(i = 0; i < n; i++){
    800054d8:	2905                	addiw	s2,s2,1
    800054da:	0485                	addi	s1,s1,1
    800054dc:	ff2991e3          	bne	s3,s2,800054be <consolewrite+0x20>
    800054e0:	894e                	mv	s2,s3
    800054e2:	74e2                	ld	s1,56(sp)
    800054e4:	79a2                	ld	s3,40(sp)
    800054e6:	7a02                	ld	s4,32(sp)
    800054e8:	6ae2                	ld	s5,24(sp)
    800054ea:	a039                	j	800054f8 <consolewrite+0x5a>
    800054ec:	4901                	li	s2,0
    800054ee:	a029                	j	800054f8 <consolewrite+0x5a>
    800054f0:	74e2                	ld	s1,56(sp)
    800054f2:	79a2                	ld	s3,40(sp)
    800054f4:	7a02                	ld	s4,32(sp)
    800054f6:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    800054f8:	854a                	mv	a0,s2
    800054fa:	60a6                	ld	ra,72(sp)
    800054fc:	6406                	ld	s0,64(sp)
    800054fe:	7942                	ld	s2,48(sp)
    80005500:	6161                	addi	sp,sp,80
    80005502:	8082                	ret

0000000080005504 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005504:	711d                	addi	sp,sp,-96
    80005506:	ec86                	sd	ra,88(sp)
    80005508:	e8a2                	sd	s0,80(sp)
    8000550a:	e4a6                	sd	s1,72(sp)
    8000550c:	e0ca                	sd	s2,64(sp)
    8000550e:	fc4e                	sd	s3,56(sp)
    80005510:	f852                	sd	s4,48(sp)
    80005512:	f456                	sd	s5,40(sp)
    80005514:	f05a                	sd	s6,32(sp)
    80005516:	1080                	addi	s0,sp,96
    80005518:	8aaa                	mv	s5,a0
    8000551a:	8a2e                	mv	s4,a1
    8000551c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000551e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005522:	00023517          	auipc	a0,0x23
    80005526:	64e50513          	addi	a0,a0,1614 # 80028b70 <cons>
    8000552a:	167000ef          	jal	80005e90 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000552e:	00023497          	auipc	s1,0x23
    80005532:	64248493          	addi	s1,s1,1602 # 80028b70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005536:	00023917          	auipc	s2,0x23
    8000553a:	6d290913          	addi	s2,s2,1746 # 80028c08 <cons+0x98>
  while(n > 0){
    8000553e:	0b305d63          	blez	s3,800055f8 <consoleread+0xf4>
    while(cons.r == cons.w){
    80005542:	0984a783          	lw	a5,152(s1)
    80005546:	09c4a703          	lw	a4,156(s1)
    8000554a:	0af71263          	bne	a4,a5,800055ee <consoleread+0xea>
      if(killed(myproc())){
    8000554e:	887fb0ef          	jal	80000dd4 <myproc>
    80005552:	a5afc0ef          	jal	800017ac <killed>
    80005556:	e12d                	bnez	a0,800055b8 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005558:	85a6                	mv	a1,s1
    8000555a:	854a                	mv	a0,s2
    8000555c:	90cfc0ef          	jal	80001668 <sleep>
    while(cons.r == cons.w){
    80005560:	0984a783          	lw	a5,152(s1)
    80005564:	09c4a703          	lw	a4,156(s1)
    80005568:	fef703e3          	beq	a4,a5,8000554e <consoleread+0x4a>
    8000556c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000556e:	00023717          	auipc	a4,0x23
    80005572:	60270713          	addi	a4,a4,1538 # 80028b70 <cons>
    80005576:	0017869b          	addiw	a3,a5,1
    8000557a:	08d72c23          	sw	a3,152(a4)
    8000557e:	07f7f693          	andi	a3,a5,127
    80005582:	9736                	add	a4,a4,a3
    80005584:	01874703          	lbu	a4,24(a4)
    80005588:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    8000558c:	4691                	li	a3,4
    8000558e:	04db8663          	beq	s7,a3,800055da <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005592:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005596:	4685                	li	a3,1
    80005598:	faf40613          	addi	a2,s0,-81
    8000559c:	85d2                	mv	a1,s4
    8000559e:	8556                	mv	a0,s5
    800055a0:	b30fc0ef          	jal	800018d0 <either_copyout>
    800055a4:	57fd                	li	a5,-1
    800055a6:	04f50863          	beq	a0,a5,800055f6 <consoleread+0xf2>
      break;

    dst++;
    800055aa:	0a05                	addi	s4,s4,1
    --n;
    800055ac:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800055ae:	47a9                	li	a5,10
    800055b0:	04fb8d63          	beq	s7,a5,8000560a <consoleread+0x106>
    800055b4:	6be2                	ld	s7,24(sp)
    800055b6:	b761                	j	8000553e <consoleread+0x3a>
        release(&cons.lock);
    800055b8:	00023517          	auipc	a0,0x23
    800055bc:	5b850513          	addi	a0,a0,1464 # 80028b70 <cons>
    800055c0:	169000ef          	jal	80005f28 <release>
        return -1;
    800055c4:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800055c6:	60e6                	ld	ra,88(sp)
    800055c8:	6446                	ld	s0,80(sp)
    800055ca:	64a6                	ld	s1,72(sp)
    800055cc:	6906                	ld	s2,64(sp)
    800055ce:	79e2                	ld	s3,56(sp)
    800055d0:	7a42                	ld	s4,48(sp)
    800055d2:	7aa2                	ld	s5,40(sp)
    800055d4:	7b02                	ld	s6,32(sp)
    800055d6:	6125                	addi	sp,sp,96
    800055d8:	8082                	ret
      if(n < target){
    800055da:	0009871b          	sext.w	a4,s3
    800055de:	01677a63          	bgeu	a4,s6,800055f2 <consoleread+0xee>
        cons.r--;
    800055e2:	00023717          	auipc	a4,0x23
    800055e6:	62f72323          	sw	a5,1574(a4) # 80028c08 <cons+0x98>
    800055ea:	6be2                	ld	s7,24(sp)
    800055ec:	a031                	j	800055f8 <consoleread+0xf4>
    800055ee:	ec5e                	sd	s7,24(sp)
    800055f0:	bfbd                	j	8000556e <consoleread+0x6a>
    800055f2:	6be2                	ld	s7,24(sp)
    800055f4:	a011                	j	800055f8 <consoleread+0xf4>
    800055f6:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800055f8:	00023517          	auipc	a0,0x23
    800055fc:	57850513          	addi	a0,a0,1400 # 80028b70 <cons>
    80005600:	129000ef          	jal	80005f28 <release>
  return target - n;
    80005604:	413b053b          	subw	a0,s6,s3
    80005608:	bf7d                	j	800055c6 <consoleread+0xc2>
    8000560a:	6be2                	ld	s7,24(sp)
    8000560c:	b7f5                	j	800055f8 <consoleread+0xf4>

000000008000560e <consputc>:
{
    8000560e:	1141                	addi	sp,sp,-16
    80005610:	e406                	sd	ra,8(sp)
    80005612:	e022                	sd	s0,0(sp)
    80005614:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005616:	10000793          	li	a5,256
    8000561a:	00f50863          	beq	a0,a5,8000562a <consputc+0x1c>
    uartputc_sync(c);
    8000561e:	604000ef          	jal	80005c22 <uartputc_sync>
}
    80005622:	60a2                	ld	ra,8(sp)
    80005624:	6402                	ld	s0,0(sp)
    80005626:	0141                	addi	sp,sp,16
    80005628:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000562a:	4521                	li	a0,8
    8000562c:	5f6000ef          	jal	80005c22 <uartputc_sync>
    80005630:	02000513          	li	a0,32
    80005634:	5ee000ef          	jal	80005c22 <uartputc_sync>
    80005638:	4521                	li	a0,8
    8000563a:	5e8000ef          	jal	80005c22 <uartputc_sync>
    8000563e:	b7d5                	j	80005622 <consputc+0x14>

0000000080005640 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005640:	1101                	addi	sp,sp,-32
    80005642:	ec06                	sd	ra,24(sp)
    80005644:	e822                	sd	s0,16(sp)
    80005646:	e426                	sd	s1,8(sp)
    80005648:	1000                	addi	s0,sp,32
    8000564a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000564c:	00023517          	auipc	a0,0x23
    80005650:	52450513          	addi	a0,a0,1316 # 80028b70 <cons>
    80005654:	03d000ef          	jal	80005e90 <acquire>

  switch(c){
    80005658:	47d5                	li	a5,21
    8000565a:	08f48f63          	beq	s1,a5,800056f8 <consoleintr+0xb8>
    8000565e:	0297c563          	blt	a5,s1,80005688 <consoleintr+0x48>
    80005662:	47a1                	li	a5,8
    80005664:	0ef48463          	beq	s1,a5,8000574c <consoleintr+0x10c>
    80005668:	47c1                	li	a5,16
    8000566a:	10f49563          	bne	s1,a5,80005774 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    8000566e:	af6fc0ef          	jal	80001964 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005672:	00023517          	auipc	a0,0x23
    80005676:	4fe50513          	addi	a0,a0,1278 # 80028b70 <cons>
    8000567a:	0af000ef          	jal	80005f28 <release>
}
    8000567e:	60e2                	ld	ra,24(sp)
    80005680:	6442                	ld	s0,16(sp)
    80005682:	64a2                	ld	s1,8(sp)
    80005684:	6105                	addi	sp,sp,32
    80005686:	8082                	ret
  switch(c){
    80005688:	07f00793          	li	a5,127
    8000568c:	0cf48063          	beq	s1,a5,8000574c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005690:	00023717          	auipc	a4,0x23
    80005694:	4e070713          	addi	a4,a4,1248 # 80028b70 <cons>
    80005698:	0a072783          	lw	a5,160(a4)
    8000569c:	09872703          	lw	a4,152(a4)
    800056a0:	9f99                	subw	a5,a5,a4
    800056a2:	07f00713          	li	a4,127
    800056a6:	fcf766e3          	bltu	a4,a5,80005672 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800056aa:	47b5                	li	a5,13
    800056ac:	0cf48763          	beq	s1,a5,8000577a <consoleintr+0x13a>
      consputc(c);
    800056b0:	8526                	mv	a0,s1
    800056b2:	f5dff0ef          	jal	8000560e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800056b6:	00023797          	auipc	a5,0x23
    800056ba:	4ba78793          	addi	a5,a5,1210 # 80028b70 <cons>
    800056be:	0a07a683          	lw	a3,160(a5)
    800056c2:	0016871b          	addiw	a4,a3,1
    800056c6:	0007061b          	sext.w	a2,a4
    800056ca:	0ae7a023          	sw	a4,160(a5)
    800056ce:	07f6f693          	andi	a3,a3,127
    800056d2:	97b6                	add	a5,a5,a3
    800056d4:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800056d8:	47a9                	li	a5,10
    800056da:	0cf48563          	beq	s1,a5,800057a4 <consoleintr+0x164>
    800056de:	4791                	li	a5,4
    800056e0:	0cf48263          	beq	s1,a5,800057a4 <consoleintr+0x164>
    800056e4:	00023797          	auipc	a5,0x23
    800056e8:	5247a783          	lw	a5,1316(a5) # 80028c08 <cons+0x98>
    800056ec:	9f1d                	subw	a4,a4,a5
    800056ee:	08000793          	li	a5,128
    800056f2:	f8f710e3          	bne	a4,a5,80005672 <consoleintr+0x32>
    800056f6:	a07d                	j	800057a4 <consoleintr+0x164>
    800056f8:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800056fa:	00023717          	auipc	a4,0x23
    800056fe:	47670713          	addi	a4,a4,1142 # 80028b70 <cons>
    80005702:	0a072783          	lw	a5,160(a4)
    80005706:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000570a:	00023497          	auipc	s1,0x23
    8000570e:	46648493          	addi	s1,s1,1126 # 80028b70 <cons>
    while(cons.e != cons.w &&
    80005712:	4929                	li	s2,10
    80005714:	02f70863          	beq	a4,a5,80005744 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005718:	37fd                	addiw	a5,a5,-1
    8000571a:	07f7f713          	andi	a4,a5,127
    8000571e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005720:	01874703          	lbu	a4,24(a4)
    80005724:	03270263          	beq	a4,s2,80005748 <consoleintr+0x108>
      cons.e--;
    80005728:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000572c:	10000513          	li	a0,256
    80005730:	edfff0ef          	jal	8000560e <consputc>
    while(cons.e != cons.w &&
    80005734:	0a04a783          	lw	a5,160(s1)
    80005738:	09c4a703          	lw	a4,156(s1)
    8000573c:	fcf71ee3          	bne	a4,a5,80005718 <consoleintr+0xd8>
    80005740:	6902                	ld	s2,0(sp)
    80005742:	bf05                	j	80005672 <consoleintr+0x32>
    80005744:	6902                	ld	s2,0(sp)
    80005746:	b735                	j	80005672 <consoleintr+0x32>
    80005748:	6902                	ld	s2,0(sp)
    8000574a:	b725                	j	80005672 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000574c:	00023717          	auipc	a4,0x23
    80005750:	42470713          	addi	a4,a4,1060 # 80028b70 <cons>
    80005754:	0a072783          	lw	a5,160(a4)
    80005758:	09c72703          	lw	a4,156(a4)
    8000575c:	f0f70be3          	beq	a4,a5,80005672 <consoleintr+0x32>
      cons.e--;
    80005760:	37fd                	addiw	a5,a5,-1
    80005762:	00023717          	auipc	a4,0x23
    80005766:	4af72723          	sw	a5,1198(a4) # 80028c10 <cons+0xa0>
      consputc(BACKSPACE);
    8000576a:	10000513          	li	a0,256
    8000576e:	ea1ff0ef          	jal	8000560e <consputc>
    80005772:	b701                	j	80005672 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005774:	ee048fe3          	beqz	s1,80005672 <consoleintr+0x32>
    80005778:	bf21                	j	80005690 <consoleintr+0x50>
      consputc(c);
    8000577a:	4529                	li	a0,10
    8000577c:	e93ff0ef          	jal	8000560e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005780:	00023797          	auipc	a5,0x23
    80005784:	3f078793          	addi	a5,a5,1008 # 80028b70 <cons>
    80005788:	0a07a703          	lw	a4,160(a5)
    8000578c:	0017069b          	addiw	a3,a4,1
    80005790:	0006861b          	sext.w	a2,a3
    80005794:	0ad7a023          	sw	a3,160(a5)
    80005798:	07f77713          	andi	a4,a4,127
    8000579c:	97ba                	add	a5,a5,a4
    8000579e:	4729                	li	a4,10
    800057a0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800057a4:	00023797          	auipc	a5,0x23
    800057a8:	46c7a423          	sw	a2,1128(a5) # 80028c0c <cons+0x9c>
        wakeup(&cons.r);
    800057ac:	00023517          	auipc	a0,0x23
    800057b0:	45c50513          	addi	a0,a0,1116 # 80028c08 <cons+0x98>
    800057b4:	f05fb0ef          	jal	800016b8 <wakeup>
    800057b8:	bd6d                	j	80005672 <consoleintr+0x32>

00000000800057ba <consoleinit>:

void
consoleinit(void)
{
    800057ba:	1141                	addi	sp,sp,-16
    800057bc:	e406                	sd	ra,8(sp)
    800057be:	e022                	sd	s0,0(sp)
    800057c0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800057c2:	00002597          	auipc	a1,0x2
    800057c6:	f7e58593          	addi	a1,a1,-130 # 80007740 <etext+0x740>
    800057ca:	00023517          	auipc	a0,0x23
    800057ce:	3a650513          	addi	a0,a0,934 # 80028b70 <cons>
    800057d2:	63e000ef          	jal	80005e10 <initlock>

  uartinit();
    800057d6:	3f4000ef          	jal	80005bca <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800057da:	0001a797          	auipc	a5,0x1a
    800057de:	1fe78793          	addi	a5,a5,510 # 8001f9d8 <devsw>
    800057e2:	00000717          	auipc	a4,0x0
    800057e6:	d2270713          	addi	a4,a4,-734 # 80005504 <consoleread>
    800057ea:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800057ec:	00000717          	auipc	a4,0x0
    800057f0:	cb270713          	addi	a4,a4,-846 # 8000549e <consolewrite>
    800057f4:	ef98                	sd	a4,24(a5)
}
    800057f6:	60a2                	ld	ra,8(sp)
    800057f8:	6402                	ld	s0,0(sp)
    800057fa:	0141                	addi	sp,sp,16
    800057fc:	8082                	ret

00000000800057fe <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800057fe:	7179                	addi	sp,sp,-48
    80005800:	f406                	sd	ra,40(sp)
    80005802:	f022                	sd	s0,32(sp)
    80005804:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005806:	c219                	beqz	a2,8000580c <printint+0xe>
    80005808:	08054063          	bltz	a0,80005888 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000580c:	4881                	li	a7,0
    8000580e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005812:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005814:	00002617          	auipc	a2,0x2
    80005818:	09460613          	addi	a2,a2,148 # 800078a8 <digits>
    8000581c:	883e                	mv	a6,a5
    8000581e:	2785                	addiw	a5,a5,1
    80005820:	02b57733          	remu	a4,a0,a1
    80005824:	9732                	add	a4,a4,a2
    80005826:	00074703          	lbu	a4,0(a4)
    8000582a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000582e:	872a                	mv	a4,a0
    80005830:	02b55533          	divu	a0,a0,a1
    80005834:	0685                	addi	a3,a3,1
    80005836:	feb773e3          	bgeu	a4,a1,8000581c <printint+0x1e>

  if(sign)
    8000583a:	00088a63          	beqz	a7,8000584e <printint+0x50>
    buf[i++] = '-';
    8000583e:	1781                	addi	a5,a5,-32
    80005840:	97a2                	add	a5,a5,s0
    80005842:	02d00713          	li	a4,45
    80005846:	fee78823          	sb	a4,-16(a5)
    8000584a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000584e:	02f05963          	blez	a5,80005880 <printint+0x82>
    80005852:	ec26                	sd	s1,24(sp)
    80005854:	e84a                	sd	s2,16(sp)
    80005856:	fd040713          	addi	a4,s0,-48
    8000585a:	00f704b3          	add	s1,a4,a5
    8000585e:	fff70913          	addi	s2,a4,-1
    80005862:	993e                	add	s2,s2,a5
    80005864:	37fd                	addiw	a5,a5,-1
    80005866:	1782                	slli	a5,a5,0x20
    80005868:	9381                	srli	a5,a5,0x20
    8000586a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000586e:	fff4c503          	lbu	a0,-1(s1)
    80005872:	d9dff0ef          	jal	8000560e <consputc>
  while(--i >= 0)
    80005876:	14fd                	addi	s1,s1,-1
    80005878:	ff249be3          	bne	s1,s2,8000586e <printint+0x70>
    8000587c:	64e2                	ld	s1,24(sp)
    8000587e:	6942                	ld	s2,16(sp)
}
    80005880:	70a2                	ld	ra,40(sp)
    80005882:	7402                	ld	s0,32(sp)
    80005884:	6145                	addi	sp,sp,48
    80005886:	8082                	ret
    x = -xx;
    80005888:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000588c:	4885                	li	a7,1
    x = -xx;
    8000588e:	b741                	j	8000580e <printint+0x10>

0000000080005890 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005890:	7155                	addi	sp,sp,-208
    80005892:	e506                	sd	ra,136(sp)
    80005894:	e122                	sd	s0,128(sp)
    80005896:	f0d2                	sd	s4,96(sp)
    80005898:	0900                	addi	s0,sp,144
    8000589a:	8a2a                	mv	s4,a0
    8000589c:	e40c                	sd	a1,8(s0)
    8000589e:	e810                	sd	a2,16(s0)
    800058a0:	ec14                	sd	a3,24(s0)
    800058a2:	f018                	sd	a4,32(s0)
    800058a4:	f41c                	sd	a5,40(s0)
    800058a6:	03043823          	sd	a6,48(s0)
    800058aa:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800058ae:	00023797          	auipc	a5,0x23
    800058b2:	3827a783          	lw	a5,898(a5) # 80028c30 <pr+0x18>
    800058b6:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800058ba:	e3a1                	bnez	a5,800058fa <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800058bc:	00840793          	addi	a5,s0,8
    800058c0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800058c4:	00054503          	lbu	a0,0(a0)
    800058c8:	26050763          	beqz	a0,80005b36 <printf+0x2a6>
    800058cc:	fca6                	sd	s1,120(sp)
    800058ce:	f8ca                	sd	s2,112(sp)
    800058d0:	f4ce                	sd	s3,104(sp)
    800058d2:	ecd6                	sd	s5,88(sp)
    800058d4:	e8da                	sd	s6,80(sp)
    800058d6:	e0e2                	sd	s8,64(sp)
    800058d8:	fc66                	sd	s9,56(sp)
    800058da:	f86a                	sd	s10,48(sp)
    800058dc:	f46e                	sd	s11,40(sp)
    800058de:	4981                	li	s3,0
    if(cx != '%'){
    800058e0:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800058e4:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800058e8:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800058ec:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800058f0:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800058f4:	07000d93          	li	s11,112
    800058f8:	a815                	j	8000592c <printf+0x9c>
    acquire(&pr.lock);
    800058fa:	00023517          	auipc	a0,0x23
    800058fe:	31e50513          	addi	a0,a0,798 # 80028c18 <pr>
    80005902:	58e000ef          	jal	80005e90 <acquire>
  va_start(ap, fmt);
    80005906:	00840793          	addi	a5,s0,8
    8000590a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000590e:	000a4503          	lbu	a0,0(s4)
    80005912:	fd4d                	bnez	a0,800058cc <printf+0x3c>
    80005914:	a481                	j	80005b54 <printf+0x2c4>
      consputc(cx);
    80005916:	cf9ff0ef          	jal	8000560e <consputc>
      continue;
    8000591a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000591c:	0014899b          	addiw	s3,s1,1
    80005920:	013a07b3          	add	a5,s4,s3
    80005924:	0007c503          	lbu	a0,0(a5)
    80005928:	1e050b63          	beqz	a0,80005b1e <printf+0x28e>
    if(cx != '%'){
    8000592c:	ff5515e3          	bne	a0,s5,80005916 <printf+0x86>
    i++;
    80005930:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005934:	009a07b3          	add	a5,s4,s1
    80005938:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000593c:	1e090163          	beqz	s2,80005b1e <printf+0x28e>
    80005940:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005944:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005946:	c789                	beqz	a5,80005950 <printf+0xc0>
    80005948:	009a0733          	add	a4,s4,s1
    8000594c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005950:	03690763          	beq	s2,s6,8000597e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005954:	05890163          	beq	s2,s8,80005996 <printf+0x106>
    } else if(c0 == 'u'){
    80005958:	0d990b63          	beq	s2,s9,80005a2e <printf+0x19e>
    } else if(c0 == 'x'){
    8000595c:	13a90163          	beq	s2,s10,80005a7e <printf+0x1ee>
    } else if(c0 == 'p'){
    80005960:	13b90b63          	beq	s2,s11,80005a96 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005964:	07300793          	li	a5,115
    80005968:	16f90a63          	beq	s2,a5,80005adc <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000596c:	1b590463          	beq	s2,s5,80005b14 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005970:	8556                	mv	a0,s5
    80005972:	c9dff0ef          	jal	8000560e <consputc>
      consputc(c0);
    80005976:	854a                	mv	a0,s2
    80005978:	c97ff0ef          	jal	8000560e <consputc>
    8000597c:	b745                	j	8000591c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000597e:	f8843783          	ld	a5,-120(s0)
    80005982:	00878713          	addi	a4,a5,8
    80005986:	f8e43423          	sd	a4,-120(s0)
    8000598a:	4605                	li	a2,1
    8000598c:	45a9                	li	a1,10
    8000598e:	4388                	lw	a0,0(a5)
    80005990:	e6fff0ef          	jal	800057fe <printint>
    80005994:	b761                	j	8000591c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005996:	03678663          	beq	a5,s6,800059c2 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000599a:	05878263          	beq	a5,s8,800059de <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000599e:	0b978463          	beq	a5,s9,80005a46 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800059a2:	fda797e3          	bne	a5,s10,80005970 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800059a6:	f8843783          	ld	a5,-120(s0)
    800059aa:	00878713          	addi	a4,a5,8
    800059ae:	f8e43423          	sd	a4,-120(s0)
    800059b2:	4601                	li	a2,0
    800059b4:	45c1                	li	a1,16
    800059b6:	6388                	ld	a0,0(a5)
    800059b8:	e47ff0ef          	jal	800057fe <printint>
      i += 1;
    800059bc:	0029849b          	addiw	s1,s3,2
    800059c0:	bfb1                	j	8000591c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800059c2:	f8843783          	ld	a5,-120(s0)
    800059c6:	00878713          	addi	a4,a5,8
    800059ca:	f8e43423          	sd	a4,-120(s0)
    800059ce:	4605                	li	a2,1
    800059d0:	45a9                	li	a1,10
    800059d2:	6388                	ld	a0,0(a5)
    800059d4:	e2bff0ef          	jal	800057fe <printint>
      i += 1;
    800059d8:	0029849b          	addiw	s1,s3,2
    800059dc:	b781                	j	8000591c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800059de:	06400793          	li	a5,100
    800059e2:	02f68863          	beq	a3,a5,80005a12 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800059e6:	07500793          	li	a5,117
    800059ea:	06f68c63          	beq	a3,a5,80005a62 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800059ee:	07800793          	li	a5,120
    800059f2:	f6f69fe3          	bne	a3,a5,80005970 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800059f6:	f8843783          	ld	a5,-120(s0)
    800059fa:	00878713          	addi	a4,a5,8
    800059fe:	f8e43423          	sd	a4,-120(s0)
    80005a02:	4601                	li	a2,0
    80005a04:	45c1                	li	a1,16
    80005a06:	6388                	ld	a0,0(a5)
    80005a08:	df7ff0ef          	jal	800057fe <printint>
      i += 2;
    80005a0c:	0039849b          	addiw	s1,s3,3
    80005a10:	b731                	j	8000591c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005a12:	f8843783          	ld	a5,-120(s0)
    80005a16:	00878713          	addi	a4,a5,8
    80005a1a:	f8e43423          	sd	a4,-120(s0)
    80005a1e:	4605                	li	a2,1
    80005a20:	45a9                	li	a1,10
    80005a22:	6388                	ld	a0,0(a5)
    80005a24:	ddbff0ef          	jal	800057fe <printint>
      i += 2;
    80005a28:	0039849b          	addiw	s1,s3,3
    80005a2c:	bdc5                	j	8000591c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80005a2e:	f8843783          	ld	a5,-120(s0)
    80005a32:	00878713          	addi	a4,a5,8
    80005a36:	f8e43423          	sd	a4,-120(s0)
    80005a3a:	4601                	li	a2,0
    80005a3c:	45a9                	li	a1,10
    80005a3e:	4388                	lw	a0,0(a5)
    80005a40:	dbfff0ef          	jal	800057fe <printint>
    80005a44:	bde1                	j	8000591c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005a46:	f8843783          	ld	a5,-120(s0)
    80005a4a:	00878713          	addi	a4,a5,8
    80005a4e:	f8e43423          	sd	a4,-120(s0)
    80005a52:	4601                	li	a2,0
    80005a54:	45a9                	li	a1,10
    80005a56:	6388                	ld	a0,0(a5)
    80005a58:	da7ff0ef          	jal	800057fe <printint>
      i += 1;
    80005a5c:	0029849b          	addiw	s1,s3,2
    80005a60:	bd75                	j	8000591c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005a62:	f8843783          	ld	a5,-120(s0)
    80005a66:	00878713          	addi	a4,a5,8
    80005a6a:	f8e43423          	sd	a4,-120(s0)
    80005a6e:	4601                	li	a2,0
    80005a70:	45a9                	li	a1,10
    80005a72:	6388                	ld	a0,0(a5)
    80005a74:	d8bff0ef          	jal	800057fe <printint>
      i += 2;
    80005a78:	0039849b          	addiw	s1,s3,3
    80005a7c:	b545                	j	8000591c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    80005a7e:	f8843783          	ld	a5,-120(s0)
    80005a82:	00878713          	addi	a4,a5,8
    80005a86:	f8e43423          	sd	a4,-120(s0)
    80005a8a:	4601                	li	a2,0
    80005a8c:	45c1                	li	a1,16
    80005a8e:	4388                	lw	a0,0(a5)
    80005a90:	d6fff0ef          	jal	800057fe <printint>
    80005a94:	b561                	j	8000591c <printf+0x8c>
    80005a96:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005a98:	f8843783          	ld	a5,-120(s0)
    80005a9c:	00878713          	addi	a4,a5,8
    80005aa0:	f8e43423          	sd	a4,-120(s0)
    80005aa4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005aa8:	03000513          	li	a0,48
    80005aac:	b63ff0ef          	jal	8000560e <consputc>
  consputc('x');
    80005ab0:	07800513          	li	a0,120
    80005ab4:	b5bff0ef          	jal	8000560e <consputc>
    80005ab8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005aba:	00002b97          	auipc	s7,0x2
    80005abe:	deeb8b93          	addi	s7,s7,-530 # 800078a8 <digits>
    80005ac2:	03c9d793          	srli	a5,s3,0x3c
    80005ac6:	97de                	add	a5,a5,s7
    80005ac8:	0007c503          	lbu	a0,0(a5)
    80005acc:	b43ff0ef          	jal	8000560e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ad0:	0992                	slli	s3,s3,0x4
    80005ad2:	397d                	addiw	s2,s2,-1
    80005ad4:	fe0917e3          	bnez	s2,80005ac2 <printf+0x232>
    80005ad8:	6ba6                	ld	s7,72(sp)
    80005ada:	b589                	j	8000591c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80005adc:	f8843783          	ld	a5,-120(s0)
    80005ae0:	00878713          	addi	a4,a5,8
    80005ae4:	f8e43423          	sd	a4,-120(s0)
    80005ae8:	0007b903          	ld	s2,0(a5)
    80005aec:	00090d63          	beqz	s2,80005b06 <printf+0x276>
      for(; *s; s++)
    80005af0:	00094503          	lbu	a0,0(s2)
    80005af4:	e20504e3          	beqz	a0,8000591c <printf+0x8c>
        consputc(*s);
    80005af8:	b17ff0ef          	jal	8000560e <consputc>
      for(; *s; s++)
    80005afc:	0905                	addi	s2,s2,1
    80005afe:	00094503          	lbu	a0,0(s2)
    80005b02:	f97d                	bnez	a0,80005af8 <printf+0x268>
    80005b04:	bd21                	j	8000591c <printf+0x8c>
        s = "(null)";
    80005b06:	00002917          	auipc	s2,0x2
    80005b0a:	c4290913          	addi	s2,s2,-958 # 80007748 <etext+0x748>
      for(; *s; s++)
    80005b0e:	02800513          	li	a0,40
    80005b12:	b7dd                	j	80005af8 <printf+0x268>
      consputc('%');
    80005b14:	02500513          	li	a0,37
    80005b18:	af7ff0ef          	jal	8000560e <consputc>
    80005b1c:	b501                	j	8000591c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80005b1e:	f7843783          	ld	a5,-136(s0)
    80005b22:	e385                	bnez	a5,80005b42 <printf+0x2b2>
    80005b24:	74e6                	ld	s1,120(sp)
    80005b26:	7946                	ld	s2,112(sp)
    80005b28:	79a6                	ld	s3,104(sp)
    80005b2a:	6ae6                	ld	s5,88(sp)
    80005b2c:	6b46                	ld	s6,80(sp)
    80005b2e:	6c06                	ld	s8,64(sp)
    80005b30:	7ce2                	ld	s9,56(sp)
    80005b32:	7d42                	ld	s10,48(sp)
    80005b34:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80005b36:	4501                	li	a0,0
    80005b38:	60aa                	ld	ra,136(sp)
    80005b3a:	640a                	ld	s0,128(sp)
    80005b3c:	7a06                	ld	s4,96(sp)
    80005b3e:	6169                	addi	sp,sp,208
    80005b40:	8082                	ret
    80005b42:	74e6                	ld	s1,120(sp)
    80005b44:	7946                	ld	s2,112(sp)
    80005b46:	79a6                	ld	s3,104(sp)
    80005b48:	6ae6                	ld	s5,88(sp)
    80005b4a:	6b46                	ld	s6,80(sp)
    80005b4c:	6c06                	ld	s8,64(sp)
    80005b4e:	7ce2                	ld	s9,56(sp)
    80005b50:	7d42                	ld	s10,48(sp)
    80005b52:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005b54:	00023517          	auipc	a0,0x23
    80005b58:	0c450513          	addi	a0,a0,196 # 80028c18 <pr>
    80005b5c:	3cc000ef          	jal	80005f28 <release>
    80005b60:	bfd9                	j	80005b36 <printf+0x2a6>

0000000080005b62 <panic>:

void
panic(char *s)
{
    80005b62:	1101                	addi	sp,sp,-32
    80005b64:	ec06                	sd	ra,24(sp)
    80005b66:	e822                	sd	s0,16(sp)
    80005b68:	e426                	sd	s1,8(sp)
    80005b6a:	1000                	addi	s0,sp,32
    80005b6c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005b6e:	00023797          	auipc	a5,0x23
    80005b72:	0c07a123          	sw	zero,194(a5) # 80028c30 <pr+0x18>
  printf("panic: ");
    80005b76:	00002517          	auipc	a0,0x2
    80005b7a:	bda50513          	addi	a0,a0,-1062 # 80007750 <etext+0x750>
    80005b7e:	d13ff0ef          	jal	80005890 <printf>
  printf("%s\n", s);
    80005b82:	85a6                	mv	a1,s1
    80005b84:	00002517          	auipc	a0,0x2
    80005b88:	bd450513          	addi	a0,a0,-1068 # 80007758 <etext+0x758>
    80005b8c:	d05ff0ef          	jal	80005890 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005b90:	4785                	li	a5,1
    80005b92:	00002717          	auipc	a4,0x2
    80005b96:	d8f72d23          	sw	a5,-614(a4) # 8000792c <panicked>
  for(;;)
    80005b9a:	a001                	j	80005b9a <panic+0x38>

0000000080005b9c <printfinit>:
    ;
}

void
printfinit(void)
{
    80005b9c:	1101                	addi	sp,sp,-32
    80005b9e:	ec06                	sd	ra,24(sp)
    80005ba0:	e822                	sd	s0,16(sp)
    80005ba2:	e426                	sd	s1,8(sp)
    80005ba4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ba6:	00023497          	auipc	s1,0x23
    80005baa:	07248493          	addi	s1,s1,114 # 80028c18 <pr>
    80005bae:	00002597          	auipc	a1,0x2
    80005bb2:	bb258593          	addi	a1,a1,-1102 # 80007760 <etext+0x760>
    80005bb6:	8526                	mv	a0,s1
    80005bb8:	258000ef          	jal	80005e10 <initlock>
  pr.locking = 1;
    80005bbc:	4785                	li	a5,1
    80005bbe:	cc9c                	sw	a5,24(s1)
}
    80005bc0:	60e2                	ld	ra,24(sp)
    80005bc2:	6442                	ld	s0,16(sp)
    80005bc4:	64a2                	ld	s1,8(sp)
    80005bc6:	6105                	addi	sp,sp,32
    80005bc8:	8082                	ret

0000000080005bca <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005bca:	1141                	addi	sp,sp,-16
    80005bcc:	e406                	sd	ra,8(sp)
    80005bce:	e022                	sd	s0,0(sp)
    80005bd0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005bd2:	100007b7          	lui	a5,0x10000
    80005bd6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005bda:	10000737          	lui	a4,0x10000
    80005bde:	f8000693          	li	a3,-128
    80005be2:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005be6:	468d                	li	a3,3
    80005be8:	10000637          	lui	a2,0x10000
    80005bec:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005bf0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005bf4:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005bf8:	10000737          	lui	a4,0x10000
    80005bfc:	461d                	li	a2,7
    80005bfe:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005c02:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005c06:	00002597          	auipc	a1,0x2
    80005c0a:	b6258593          	addi	a1,a1,-1182 # 80007768 <etext+0x768>
    80005c0e:	00023517          	auipc	a0,0x23
    80005c12:	02a50513          	addi	a0,a0,42 # 80028c38 <uart_tx_lock>
    80005c16:	1fa000ef          	jal	80005e10 <initlock>
}
    80005c1a:	60a2                	ld	ra,8(sp)
    80005c1c:	6402                	ld	s0,0(sp)
    80005c1e:	0141                	addi	sp,sp,16
    80005c20:	8082                	ret

0000000080005c22 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005c22:	1101                	addi	sp,sp,-32
    80005c24:	ec06                	sd	ra,24(sp)
    80005c26:	e822                	sd	s0,16(sp)
    80005c28:	e426                	sd	s1,8(sp)
    80005c2a:	1000                	addi	s0,sp,32
    80005c2c:	84aa                	mv	s1,a0
  push_off();
    80005c2e:	222000ef          	jal	80005e50 <push_off>

  if(panicked){
    80005c32:	00002797          	auipc	a5,0x2
    80005c36:	cfa7a783          	lw	a5,-774(a5) # 8000792c <panicked>
    80005c3a:	e795                	bnez	a5,80005c66 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005c3c:	10000737          	lui	a4,0x10000
    80005c40:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005c42:	00074783          	lbu	a5,0(a4)
    80005c46:	0207f793          	andi	a5,a5,32
    80005c4a:	dfe5                	beqz	a5,80005c42 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80005c4c:	0ff4f513          	zext.b	a0,s1
    80005c50:	100007b7          	lui	a5,0x10000
    80005c54:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005c58:	27c000ef          	jal	80005ed4 <pop_off>
}
    80005c5c:	60e2                	ld	ra,24(sp)
    80005c5e:	6442                	ld	s0,16(sp)
    80005c60:	64a2                	ld	s1,8(sp)
    80005c62:	6105                	addi	sp,sp,32
    80005c64:	8082                	ret
    for(;;)
    80005c66:	a001                	j	80005c66 <uartputc_sync+0x44>

0000000080005c68 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005c68:	00002797          	auipc	a5,0x2
    80005c6c:	cc87b783          	ld	a5,-824(a5) # 80007930 <uart_tx_r>
    80005c70:	00002717          	auipc	a4,0x2
    80005c74:	cc873703          	ld	a4,-824(a4) # 80007938 <uart_tx_w>
    80005c78:	08f70263          	beq	a4,a5,80005cfc <uartstart+0x94>
{
    80005c7c:	7139                	addi	sp,sp,-64
    80005c7e:	fc06                	sd	ra,56(sp)
    80005c80:	f822                	sd	s0,48(sp)
    80005c82:	f426                	sd	s1,40(sp)
    80005c84:	f04a                	sd	s2,32(sp)
    80005c86:	ec4e                	sd	s3,24(sp)
    80005c88:	e852                	sd	s4,16(sp)
    80005c8a:	e456                	sd	s5,8(sp)
    80005c8c:	e05a                	sd	s6,0(sp)
    80005c8e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005c90:	10000937          	lui	s2,0x10000
    80005c94:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005c96:	00023a97          	auipc	s5,0x23
    80005c9a:	fa2a8a93          	addi	s5,s5,-94 # 80028c38 <uart_tx_lock>
    uart_tx_r += 1;
    80005c9e:	00002497          	auipc	s1,0x2
    80005ca2:	c9248493          	addi	s1,s1,-878 # 80007930 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005ca6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80005caa:	00002997          	auipc	s3,0x2
    80005cae:	c8e98993          	addi	s3,s3,-882 # 80007938 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005cb2:	00094703          	lbu	a4,0(s2)
    80005cb6:	02077713          	andi	a4,a4,32
    80005cba:	c71d                	beqz	a4,80005ce8 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005cbc:	01f7f713          	andi	a4,a5,31
    80005cc0:	9756                	add	a4,a4,s5
    80005cc2:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005cc6:	0785                	addi	a5,a5,1
    80005cc8:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80005cca:	8526                	mv	a0,s1
    80005ccc:	9edfb0ef          	jal	800016b8 <wakeup>
    WriteReg(THR, c);
    80005cd0:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005cd4:	609c                	ld	a5,0(s1)
    80005cd6:	0009b703          	ld	a4,0(s3)
    80005cda:	fcf71ce3          	bne	a4,a5,80005cb2 <uartstart+0x4a>
      ReadReg(ISR);
    80005cde:	100007b7          	lui	a5,0x10000
    80005ce2:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005ce4:	0007c783          	lbu	a5,0(a5)
  }
}
    80005ce8:	70e2                	ld	ra,56(sp)
    80005cea:	7442                	ld	s0,48(sp)
    80005cec:	74a2                	ld	s1,40(sp)
    80005cee:	7902                	ld	s2,32(sp)
    80005cf0:	69e2                	ld	s3,24(sp)
    80005cf2:	6a42                	ld	s4,16(sp)
    80005cf4:	6aa2                	ld	s5,8(sp)
    80005cf6:	6b02                	ld	s6,0(sp)
    80005cf8:	6121                	addi	sp,sp,64
    80005cfa:	8082                	ret
      ReadReg(ISR);
    80005cfc:	100007b7          	lui	a5,0x10000
    80005d00:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005d02:	0007c783          	lbu	a5,0(a5)
      return;
    80005d06:	8082                	ret

0000000080005d08 <uartputc>:
{
    80005d08:	7179                	addi	sp,sp,-48
    80005d0a:	f406                	sd	ra,40(sp)
    80005d0c:	f022                	sd	s0,32(sp)
    80005d0e:	ec26                	sd	s1,24(sp)
    80005d10:	e84a                	sd	s2,16(sp)
    80005d12:	e44e                	sd	s3,8(sp)
    80005d14:	e052                	sd	s4,0(sp)
    80005d16:	1800                	addi	s0,sp,48
    80005d18:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005d1a:	00023517          	auipc	a0,0x23
    80005d1e:	f1e50513          	addi	a0,a0,-226 # 80028c38 <uart_tx_lock>
    80005d22:	16e000ef          	jal	80005e90 <acquire>
  if(panicked){
    80005d26:	00002797          	auipc	a5,0x2
    80005d2a:	c067a783          	lw	a5,-1018(a5) # 8000792c <panicked>
    80005d2e:	efbd                	bnez	a5,80005dac <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005d30:	00002717          	auipc	a4,0x2
    80005d34:	c0873703          	ld	a4,-1016(a4) # 80007938 <uart_tx_w>
    80005d38:	00002797          	auipc	a5,0x2
    80005d3c:	bf87b783          	ld	a5,-1032(a5) # 80007930 <uart_tx_r>
    80005d40:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005d44:	00023997          	auipc	s3,0x23
    80005d48:	ef498993          	addi	s3,s3,-268 # 80028c38 <uart_tx_lock>
    80005d4c:	00002497          	auipc	s1,0x2
    80005d50:	be448493          	addi	s1,s1,-1052 # 80007930 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005d54:	00002917          	auipc	s2,0x2
    80005d58:	be490913          	addi	s2,s2,-1052 # 80007938 <uart_tx_w>
    80005d5c:	00e79d63          	bne	a5,a4,80005d76 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005d60:	85ce                	mv	a1,s3
    80005d62:	8526                	mv	a0,s1
    80005d64:	905fb0ef          	jal	80001668 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005d68:	00093703          	ld	a4,0(s2)
    80005d6c:	609c                	ld	a5,0(s1)
    80005d6e:	02078793          	addi	a5,a5,32
    80005d72:	fee787e3          	beq	a5,a4,80005d60 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005d76:	00023497          	auipc	s1,0x23
    80005d7a:	ec248493          	addi	s1,s1,-318 # 80028c38 <uart_tx_lock>
    80005d7e:	01f77793          	andi	a5,a4,31
    80005d82:	97a6                	add	a5,a5,s1
    80005d84:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005d88:	0705                	addi	a4,a4,1
    80005d8a:	00002797          	auipc	a5,0x2
    80005d8e:	bae7b723          	sd	a4,-1106(a5) # 80007938 <uart_tx_w>
  uartstart();
    80005d92:	ed7ff0ef          	jal	80005c68 <uartstart>
  release(&uart_tx_lock);
    80005d96:	8526                	mv	a0,s1
    80005d98:	190000ef          	jal	80005f28 <release>
}
    80005d9c:	70a2                	ld	ra,40(sp)
    80005d9e:	7402                	ld	s0,32(sp)
    80005da0:	64e2                	ld	s1,24(sp)
    80005da2:	6942                	ld	s2,16(sp)
    80005da4:	69a2                	ld	s3,8(sp)
    80005da6:	6a02                	ld	s4,0(sp)
    80005da8:	6145                	addi	sp,sp,48
    80005daa:	8082                	ret
    for(;;)
    80005dac:	a001                	j	80005dac <uartputc+0xa4>

0000000080005dae <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005dae:	1141                	addi	sp,sp,-16
    80005db0:	e422                	sd	s0,8(sp)
    80005db2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005db4:	100007b7          	lui	a5,0x10000
    80005db8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005dba:	0007c783          	lbu	a5,0(a5)
    80005dbe:	8b85                	andi	a5,a5,1
    80005dc0:	cb81                	beqz	a5,80005dd0 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005dc2:	100007b7          	lui	a5,0x10000
    80005dc6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005dca:	6422                	ld	s0,8(sp)
    80005dcc:	0141                	addi	sp,sp,16
    80005dce:	8082                	ret
    return -1;
    80005dd0:	557d                	li	a0,-1
    80005dd2:	bfe5                	j	80005dca <uartgetc+0x1c>

0000000080005dd4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005dd4:	1101                	addi	sp,sp,-32
    80005dd6:	ec06                	sd	ra,24(sp)
    80005dd8:	e822                	sd	s0,16(sp)
    80005dda:	e426                	sd	s1,8(sp)
    80005ddc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005dde:	54fd                	li	s1,-1
    80005de0:	a019                	j	80005de6 <uartintr+0x12>
      break;
    consoleintr(c);
    80005de2:	85fff0ef          	jal	80005640 <consoleintr>
    int c = uartgetc();
    80005de6:	fc9ff0ef          	jal	80005dae <uartgetc>
    if(c == -1)
    80005dea:	fe951ce3          	bne	a0,s1,80005de2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005dee:	00023497          	auipc	s1,0x23
    80005df2:	e4a48493          	addi	s1,s1,-438 # 80028c38 <uart_tx_lock>
    80005df6:	8526                	mv	a0,s1
    80005df8:	098000ef          	jal	80005e90 <acquire>
  uartstart();
    80005dfc:	e6dff0ef          	jal	80005c68 <uartstart>
  release(&uart_tx_lock);
    80005e00:	8526                	mv	a0,s1
    80005e02:	126000ef          	jal	80005f28 <release>
}
    80005e06:	60e2                	ld	ra,24(sp)
    80005e08:	6442                	ld	s0,16(sp)
    80005e0a:	64a2                	ld	s1,8(sp)
    80005e0c:	6105                	addi	sp,sp,32
    80005e0e:	8082                	ret

0000000080005e10 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005e10:	1141                	addi	sp,sp,-16
    80005e12:	e422                	sd	s0,8(sp)
    80005e14:	0800                	addi	s0,sp,16
  lk->name = name;
    80005e16:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005e18:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005e1c:	00053823          	sd	zero,16(a0)
}
    80005e20:	6422                	ld	s0,8(sp)
    80005e22:	0141                	addi	sp,sp,16
    80005e24:	8082                	ret

0000000080005e26 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005e26:	411c                	lw	a5,0(a0)
    80005e28:	e399                	bnez	a5,80005e2e <holding+0x8>
    80005e2a:	4501                	li	a0,0
  return r;
}
    80005e2c:	8082                	ret
{
    80005e2e:	1101                	addi	sp,sp,-32
    80005e30:	ec06                	sd	ra,24(sp)
    80005e32:	e822                	sd	s0,16(sp)
    80005e34:	e426                	sd	s1,8(sp)
    80005e36:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005e38:	6904                	ld	s1,16(a0)
    80005e3a:	f7ffa0ef          	jal	80000db8 <mycpu>
    80005e3e:	40a48533          	sub	a0,s1,a0
    80005e42:	00153513          	seqz	a0,a0
}
    80005e46:	60e2                	ld	ra,24(sp)
    80005e48:	6442                	ld	s0,16(sp)
    80005e4a:	64a2                	ld	s1,8(sp)
    80005e4c:	6105                	addi	sp,sp,32
    80005e4e:	8082                	ret

0000000080005e50 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005e50:	1101                	addi	sp,sp,-32
    80005e52:	ec06                	sd	ra,24(sp)
    80005e54:	e822                	sd	s0,16(sp)
    80005e56:	e426                	sd	s1,8(sp)
    80005e58:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005e5a:	100024f3          	csrr	s1,sstatus
    80005e5e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005e62:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005e64:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005e68:	f51fa0ef          	jal	80000db8 <mycpu>
    80005e6c:	5d3c                	lw	a5,120(a0)
    80005e6e:	cb99                	beqz	a5,80005e84 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005e70:	f49fa0ef          	jal	80000db8 <mycpu>
    80005e74:	5d3c                	lw	a5,120(a0)
    80005e76:	2785                	addiw	a5,a5,1
    80005e78:	dd3c                	sw	a5,120(a0)
}
    80005e7a:	60e2                	ld	ra,24(sp)
    80005e7c:	6442                	ld	s0,16(sp)
    80005e7e:	64a2                	ld	s1,8(sp)
    80005e80:	6105                	addi	sp,sp,32
    80005e82:	8082                	ret
    mycpu()->intena = old;
    80005e84:	f35fa0ef          	jal	80000db8 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005e88:	8085                	srli	s1,s1,0x1
    80005e8a:	8885                	andi	s1,s1,1
    80005e8c:	dd64                	sw	s1,124(a0)
    80005e8e:	b7cd                	j	80005e70 <push_off+0x20>

0000000080005e90 <acquire>:
{
    80005e90:	1101                	addi	sp,sp,-32
    80005e92:	ec06                	sd	ra,24(sp)
    80005e94:	e822                	sd	s0,16(sp)
    80005e96:	e426                	sd	s1,8(sp)
    80005e98:	1000                	addi	s0,sp,32
    80005e9a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005e9c:	fb5ff0ef          	jal	80005e50 <push_off>
  if(holding(lk))
    80005ea0:	8526                	mv	a0,s1
    80005ea2:	f85ff0ef          	jal	80005e26 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005ea6:	4705                	li	a4,1
  if(holding(lk))
    80005ea8:	e105                	bnez	a0,80005ec8 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005eaa:	87ba                	mv	a5,a4
    80005eac:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005eb0:	2781                	sext.w	a5,a5
    80005eb2:	ffe5                	bnez	a5,80005eaa <acquire+0x1a>
  __sync_synchronize();
    80005eb4:	0ff0000f          	fence
  lk->cpu = mycpu();
    80005eb8:	f01fa0ef          	jal	80000db8 <mycpu>
    80005ebc:	e888                	sd	a0,16(s1)
}
    80005ebe:	60e2                	ld	ra,24(sp)
    80005ec0:	6442                	ld	s0,16(sp)
    80005ec2:	64a2                	ld	s1,8(sp)
    80005ec4:	6105                	addi	sp,sp,32
    80005ec6:	8082                	ret
    panic("acquire");
    80005ec8:	00002517          	auipc	a0,0x2
    80005ecc:	8a850513          	addi	a0,a0,-1880 # 80007770 <etext+0x770>
    80005ed0:	c93ff0ef          	jal	80005b62 <panic>

0000000080005ed4 <pop_off>:

void
pop_off(void)
{
    80005ed4:	1141                	addi	sp,sp,-16
    80005ed6:	e406                	sd	ra,8(sp)
    80005ed8:	e022                	sd	s0,0(sp)
    80005eda:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005edc:	eddfa0ef          	jal	80000db8 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005ee0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005ee4:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005ee6:	e78d                	bnez	a5,80005f10 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005ee8:	5d3c                	lw	a5,120(a0)
    80005eea:	02f05963          	blez	a5,80005f1c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005eee:	37fd                	addiw	a5,a5,-1
    80005ef0:	0007871b          	sext.w	a4,a5
    80005ef4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005ef6:	eb09                	bnez	a4,80005f08 <pop_off+0x34>
    80005ef8:	5d7c                	lw	a5,124(a0)
    80005efa:	c799                	beqz	a5,80005f08 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005efc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005f00:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005f04:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005f08:	60a2                	ld	ra,8(sp)
    80005f0a:	6402                	ld	s0,0(sp)
    80005f0c:	0141                	addi	sp,sp,16
    80005f0e:	8082                	ret
    panic("pop_off - interruptible");
    80005f10:	00002517          	auipc	a0,0x2
    80005f14:	86850513          	addi	a0,a0,-1944 # 80007778 <etext+0x778>
    80005f18:	c4bff0ef          	jal	80005b62 <panic>
    panic("pop_off");
    80005f1c:	00002517          	auipc	a0,0x2
    80005f20:	87450513          	addi	a0,a0,-1932 # 80007790 <etext+0x790>
    80005f24:	c3fff0ef          	jal	80005b62 <panic>

0000000080005f28 <release>:
{
    80005f28:	1101                	addi	sp,sp,-32
    80005f2a:	ec06                	sd	ra,24(sp)
    80005f2c:	e822                	sd	s0,16(sp)
    80005f2e:	e426                	sd	s1,8(sp)
    80005f30:	1000                	addi	s0,sp,32
    80005f32:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005f34:	ef3ff0ef          	jal	80005e26 <holding>
    80005f38:	c105                	beqz	a0,80005f58 <release+0x30>
  lk->cpu = 0;
    80005f3a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005f3e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80005f42:	0f50000f          	fence	iorw,ow
    80005f46:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80005f4a:	f8bff0ef          	jal	80005ed4 <pop_off>
}
    80005f4e:	60e2                	ld	ra,24(sp)
    80005f50:	6442                	ld	s0,16(sp)
    80005f52:	64a2                	ld	s1,8(sp)
    80005f54:	6105                	addi	sp,sp,32
    80005f56:	8082                	ret
    panic("release");
    80005f58:	00002517          	auipc	a0,0x2
    80005f5c:	84050513          	addi	a0,a0,-1984 # 80007798 <etext+0x798>
    80005f60:	c03ff0ef          	jal	80005b62 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
