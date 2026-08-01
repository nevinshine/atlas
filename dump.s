
atlas.bin:     file format elf32-i386


Disassembly of section .text:

c0100000 <kernel_start>:
c0100000:	02 b0 ad 1b 03 00    	add    0x31bad(%eax),%dh
c0100006:	00 00                	add    %al,(%eax)
c0100008:	fb                   	sti
c0100009:	4f                   	dec    %edi
c010000a:	52                   	push   %edx
c010000b:	e4                   	.byte 0xe4

c010000c <_start>:
c010000c:	bc 00 00 11 00       	mov    $0x110000,%esp
c0100011:	50                   	push   %eax
c0100012:	53                   	push   %ebx
c0100013:	b8 03 10 11 00       	mov    $0x111003,%eax
c0100018:	bf 00 00 11 00       	mov    $0x110000,%edi
c010001d:	89 07                	mov    %eax,(%edi)
c010001f:	89 87 00 0c 00 00    	mov    %eax,0xc00(%edi)
c0100025:	b8 03 00 11 00       	mov    $0x110003,%eax
c010002a:	89 87 fc 0f 00 00    	mov    %eax,0xffc(%edi)
c0100030:	b9 00 00 00 00       	mov    $0x0,%ecx
c0100035:	bf 00 10 11 00       	mov    $0x111000,%edi

c010003a <.fill_table>:
c010003a:	89 c8                	mov    %ecx,%eax
c010003c:	c1 e0 0c             	shl    $0xc,%eax
c010003f:	83 c8 03             	or     $0x3,%eax
c0100042:	89 04 8f             	mov    %eax,(%edi,%ecx,4)
c0100045:	41                   	inc    %ecx
c0100046:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
c010004c:	75 ec                	jne    c010003a <.fill_table>
c010004e:	b8 00 00 11 00       	mov    $0x110000,%eax
c0100053:	0f 22 d8             	mov    %eax,%cr3
c0100056:	0f 20 c0             	mov    %cr0,%eax
c0100059:	0d 00 00 00 80       	or     $0x80000000,%eax
c010005e:	0f 22 c0             	mov    %eax,%cr0
c0100061:	8d 0d 69 00 10 c0    	lea    0xc0100069,%ecx
c0100067:	ff e1                	jmp    *%ecx

c0100069 <higher_half>:
c0100069:	81 c4 00 00 00 c0    	add    $0xc0000000,%esp
c010006f:	5b                   	pop    %ebx
c0100070:	58                   	pop    %eax
c0100071:	81 c3 00 00 00 c0    	add    $0xc0000000,%ebx
c0100077:	50                   	push   %eax
c0100078:	53                   	push   %ebx
c0100079:	e8 82 52 00 00       	call   c0105300 <kernel_main>
c010007e:	fa                   	cli
c010007f:	f4                   	hlt
c0100080:	eb fd                	jmp    c010007f <higher_half+0x16>

c0100082 <gdt_flush>:
c0100082:	8b 44 24 04          	mov    0x4(%esp),%eax
c0100086:	0f 01 10             	lgdtl  (%eax)
c0100089:	66 b8 10 00          	mov    $0x10,%ax
c010008d:	8e d8                	mov    %eax,%ds
c010008f:	8e c0                	mov    %eax,%es
c0100091:	8e e0                	mov    %eax,%fs
c0100093:	8e e8                	mov    %eax,%gs
c0100095:	8e d0                	mov    %eax,%ss
c0100097:	ea 9e 00 10 c0 08 00 	ljmp   $0x8,$0xc010009e

c010009e <.flush>:
c010009e:	c3                   	ret

c010009f <isr0>:
c010009f:	fa                   	cli
c01000a0:	6a 00                	push   $0x0
c01000a2:	6a 00                	push   $0x0
c01000a4:	e9 a1 01 00 00       	jmp    c010024a <isr_common_stub>

c01000a9 <isr1>:
c01000a9:	fa                   	cli
c01000aa:	6a 00                	push   $0x0
c01000ac:	6a 01                	push   $0x1
c01000ae:	e9 97 01 00 00       	jmp    c010024a <isr_common_stub>

c01000b3 <isr2>:
c01000b3:	fa                   	cli
c01000b4:	6a 00                	push   $0x0
c01000b6:	6a 02                	push   $0x2
c01000b8:	e9 8d 01 00 00       	jmp    c010024a <isr_common_stub>

c01000bd <isr3>:
c01000bd:	fa                   	cli
c01000be:	6a 00                	push   $0x0
c01000c0:	6a 03                	push   $0x3
c01000c2:	e9 83 01 00 00       	jmp    c010024a <isr_common_stub>

c01000c7 <isr4>:
c01000c7:	fa                   	cli
c01000c8:	6a 00                	push   $0x0
c01000ca:	6a 04                	push   $0x4
c01000cc:	e9 79 01 00 00       	jmp    c010024a <isr_common_stub>

c01000d1 <isr5>:
c01000d1:	fa                   	cli
c01000d2:	6a 00                	push   $0x0
c01000d4:	6a 05                	push   $0x5
c01000d6:	e9 6f 01 00 00       	jmp    c010024a <isr_common_stub>

c01000db <isr6>:
c01000db:	fa                   	cli
c01000dc:	6a 00                	push   $0x0
c01000de:	6a 06                	push   $0x6
c01000e0:	e9 65 01 00 00       	jmp    c010024a <isr_common_stub>

c01000e5 <isr7>:
c01000e5:	fa                   	cli
c01000e6:	6a 00                	push   $0x0
c01000e8:	6a 07                	push   $0x7
c01000ea:	e9 5b 01 00 00       	jmp    c010024a <isr_common_stub>

c01000ef <isr8>:
c01000ef:	fa                   	cli
c01000f0:	6a 08                	push   $0x8
c01000f2:	e9 53 01 00 00       	jmp    c010024a <isr_common_stub>

c01000f7 <isr9>:
c01000f7:	fa                   	cli
c01000f8:	6a 00                	push   $0x0
c01000fa:	6a 09                	push   $0x9
c01000fc:	e9 49 01 00 00       	jmp    c010024a <isr_common_stub>

c0100101 <isr10>:
c0100101:	fa                   	cli
c0100102:	6a 0a                	push   $0xa
c0100104:	e9 41 01 00 00       	jmp    c010024a <isr_common_stub>

c0100109 <isr11>:
c0100109:	fa                   	cli
c010010a:	6a 0b                	push   $0xb
c010010c:	e9 39 01 00 00       	jmp    c010024a <isr_common_stub>

c0100111 <isr12>:
c0100111:	fa                   	cli
c0100112:	6a 0c                	push   $0xc
c0100114:	e9 31 01 00 00       	jmp    c010024a <isr_common_stub>

c0100119 <isr13>:
c0100119:	fa                   	cli
c010011a:	6a 0d                	push   $0xd
c010011c:	e9 29 01 00 00       	jmp    c010024a <isr_common_stub>

c0100121 <isr14>:
c0100121:	fa                   	cli
c0100122:	6a 0e                	push   $0xe
c0100124:	e9 21 01 00 00       	jmp    c010024a <isr_common_stub>

c0100129 <isr15>:
c0100129:	fa                   	cli
c010012a:	6a 00                	push   $0x0
c010012c:	6a 0f                	push   $0xf
c010012e:	e9 17 01 00 00       	jmp    c010024a <isr_common_stub>

c0100133 <isr16>:
c0100133:	fa                   	cli
c0100134:	6a 00                	push   $0x0
c0100136:	6a 10                	push   $0x10
c0100138:	e9 0d 01 00 00       	jmp    c010024a <isr_common_stub>

c010013d <isr17>:
c010013d:	fa                   	cli
c010013e:	6a 00                	push   $0x0
c0100140:	6a 11                	push   $0x11
c0100142:	e9 03 01 00 00       	jmp    c010024a <isr_common_stub>

c0100147 <isr18>:
c0100147:	fa                   	cli
c0100148:	6a 00                	push   $0x0
c010014a:	6a 12                	push   $0x12
c010014c:	e9 f9 00 00 00       	jmp    c010024a <isr_common_stub>

c0100151 <isr19>:
c0100151:	fa                   	cli
c0100152:	6a 00                	push   $0x0
c0100154:	6a 13                	push   $0x13
c0100156:	e9 ef 00 00 00       	jmp    c010024a <isr_common_stub>

c010015b <isr20>:
c010015b:	fa                   	cli
c010015c:	6a 00                	push   $0x0
c010015e:	6a 14                	push   $0x14
c0100160:	e9 e5 00 00 00       	jmp    c010024a <isr_common_stub>

c0100165 <isr21>:
c0100165:	fa                   	cli
c0100166:	6a 00                	push   $0x0
c0100168:	6a 15                	push   $0x15
c010016a:	e9 db 00 00 00       	jmp    c010024a <isr_common_stub>

c010016f <isr22>:
c010016f:	fa                   	cli
c0100170:	6a 00                	push   $0x0
c0100172:	6a 16                	push   $0x16
c0100174:	e9 d1 00 00 00       	jmp    c010024a <isr_common_stub>

c0100179 <isr23>:
c0100179:	fa                   	cli
c010017a:	6a 00                	push   $0x0
c010017c:	6a 17                	push   $0x17
c010017e:	e9 c7 00 00 00       	jmp    c010024a <isr_common_stub>

c0100183 <isr24>:
c0100183:	fa                   	cli
c0100184:	6a 00                	push   $0x0
c0100186:	6a 18                	push   $0x18
c0100188:	e9 bd 00 00 00       	jmp    c010024a <isr_common_stub>

c010018d <isr25>:
c010018d:	fa                   	cli
c010018e:	6a 00                	push   $0x0
c0100190:	6a 19                	push   $0x19
c0100192:	e9 b3 00 00 00       	jmp    c010024a <isr_common_stub>

c0100197 <isr26>:
c0100197:	fa                   	cli
c0100198:	6a 00                	push   $0x0
c010019a:	6a 1a                	push   $0x1a
c010019c:	e9 a9 00 00 00       	jmp    c010024a <isr_common_stub>

c01001a1 <isr27>:
c01001a1:	fa                   	cli
c01001a2:	6a 00                	push   $0x0
c01001a4:	6a 1b                	push   $0x1b
c01001a6:	e9 9f 00 00 00       	jmp    c010024a <isr_common_stub>

c01001ab <isr28>:
c01001ab:	fa                   	cli
c01001ac:	6a 00                	push   $0x0
c01001ae:	6a 1c                	push   $0x1c
c01001b0:	e9 95 00 00 00       	jmp    c010024a <isr_common_stub>

c01001b5 <isr29>:
c01001b5:	fa                   	cli
c01001b6:	6a 00                	push   $0x0
c01001b8:	6a 1d                	push   $0x1d
c01001ba:	e9 8b 00 00 00       	jmp    c010024a <isr_common_stub>

c01001bf <isr30>:
c01001bf:	fa                   	cli
c01001c0:	6a 00                	push   $0x0
c01001c2:	6a 1e                	push   $0x1e
c01001c4:	e9 81 00 00 00       	jmp    c010024a <isr_common_stub>

c01001c9 <isr31>:
c01001c9:	fa                   	cli
c01001ca:	6a 00                	push   $0x0
c01001cc:	6a 1f                	push   $0x1f
c01001ce:	eb 7a                	jmp    c010024a <isr_common_stub>

c01001d0 <irq0>:
c01001d0:	fa                   	cli
c01001d1:	6a 00                	push   $0x0
c01001d3:	6a 20                	push   $0x20
c01001d5:	eb 73                	jmp    c010024a <isr_common_stub>

c01001d7 <irq1>:
c01001d7:	fa                   	cli
c01001d8:	6a 00                	push   $0x0
c01001da:	6a 21                	push   $0x21
c01001dc:	eb 6c                	jmp    c010024a <isr_common_stub>

c01001de <irq2>:
c01001de:	fa                   	cli
c01001df:	6a 00                	push   $0x0
c01001e1:	6a 22                	push   $0x22
c01001e3:	eb 65                	jmp    c010024a <isr_common_stub>

c01001e5 <irq3>:
c01001e5:	fa                   	cli
c01001e6:	6a 00                	push   $0x0
c01001e8:	6a 23                	push   $0x23
c01001ea:	eb 5e                	jmp    c010024a <isr_common_stub>

c01001ec <irq4>:
c01001ec:	fa                   	cli
c01001ed:	6a 00                	push   $0x0
c01001ef:	6a 24                	push   $0x24
c01001f1:	eb 57                	jmp    c010024a <isr_common_stub>

c01001f3 <irq5>:
c01001f3:	fa                   	cli
c01001f4:	6a 00                	push   $0x0
c01001f6:	6a 25                	push   $0x25
c01001f8:	eb 50                	jmp    c010024a <isr_common_stub>

c01001fa <irq6>:
c01001fa:	fa                   	cli
c01001fb:	6a 00                	push   $0x0
c01001fd:	6a 26                	push   $0x26
c01001ff:	eb 49                	jmp    c010024a <isr_common_stub>

c0100201 <irq7>:
c0100201:	fa                   	cli
c0100202:	6a 00                	push   $0x0
c0100204:	6a 27                	push   $0x27
c0100206:	eb 42                	jmp    c010024a <isr_common_stub>

c0100208 <irq8>:
c0100208:	fa                   	cli
c0100209:	6a 00                	push   $0x0
c010020b:	6a 28                	push   $0x28
c010020d:	eb 3b                	jmp    c010024a <isr_common_stub>

c010020f <irq9>:
c010020f:	fa                   	cli
c0100210:	6a 00                	push   $0x0
c0100212:	6a 29                	push   $0x29
c0100214:	eb 34                	jmp    c010024a <isr_common_stub>

c0100216 <irq10>:
c0100216:	fa                   	cli
c0100217:	6a 00                	push   $0x0
c0100219:	6a 2a                	push   $0x2a
c010021b:	eb 2d                	jmp    c010024a <isr_common_stub>

c010021d <irq11>:
c010021d:	fa                   	cli
c010021e:	6a 00                	push   $0x0
c0100220:	6a 2b                	push   $0x2b
c0100222:	eb 26                	jmp    c010024a <isr_common_stub>

c0100224 <irq12>:
c0100224:	fa                   	cli
c0100225:	6a 00                	push   $0x0
c0100227:	6a 2c                	push   $0x2c
c0100229:	eb 1f                	jmp    c010024a <isr_common_stub>

c010022b <irq13>:
c010022b:	fa                   	cli
c010022c:	6a 00                	push   $0x0
c010022e:	6a 2d                	push   $0x2d
c0100230:	eb 18                	jmp    c010024a <isr_common_stub>

c0100232 <irq14>:
c0100232:	fa                   	cli
c0100233:	6a 00                	push   $0x0
c0100235:	6a 2e                	push   $0x2e
c0100237:	eb 11                	jmp    c010024a <isr_common_stub>

c0100239 <irq15>:
c0100239:	fa                   	cli
c010023a:	6a 00                	push   $0x0
c010023c:	6a 2f                	push   $0x2f
c010023e:	eb 0a                	jmp    c010024a <isr_common_stub>

c0100240 <isr128>:
c0100240:	fa                   	cli
c0100241:	6a 00                	push   $0x0
c0100243:	68 80 00 00 00       	push   $0x80
c0100248:	eb 00                	jmp    c010024a <isr_common_stub>

c010024a <isr_common_stub>:
c010024a:	60                   	pusha
c010024b:	66 8c d8             	mov    %ds,%ax
c010024e:	50                   	push   %eax
c010024f:	66 b8 10 00          	mov    $0x10,%ax
c0100253:	8e d8                	mov    %eax,%ds
c0100255:	8e c0                	mov    %eax,%es
c0100257:	8e e0                	mov    %eax,%fs
c0100259:	8e e8                	mov    %eax,%gs
c010025b:	54                   	push   %esp
c010025c:	e8 5f 16 00 00       	call   c01018c0 <interrupt_dispatch>
c0100261:	83 c4 04             	add    $0x4,%esp
c0100264:	58                   	pop    %eax
c0100265:	8e d8                	mov    %eax,%ds
c0100267:	8e c0                	mov    %eax,%es
c0100269:	8e e0                	mov    %eax,%fs
c010026b:	8e e8                	mov    %eax,%gs
c010026d:	61                   	popa
c010026e:	83 c4 08             	add    $0x8,%esp
c0100271:	fb                   	sti
c0100272:	cf                   	iret

c0100273 <context_switch>:
c0100273:	8b 44 24 04          	mov    0x4(%esp),%eax
c0100277:	8b 54 24 08          	mov    0x8(%esp),%edx
c010027b:	9c                   	pushf
c010027c:	55                   	push   %ebp
c010027d:	53                   	push   %ebx
c010027e:	56                   	push   %esi
c010027f:	57                   	push   %edi
c0100280:	89 60 24             	mov    %esp,0x24(%eax)
c0100283:	8b 62 24             	mov    0x24(%edx),%esp
c0100286:	5f                   	pop    %edi
c0100287:	5e                   	pop    %esi
c0100288:	5b                   	pop    %ebx
c0100289:	5d                   	pop    %ebp
c010028a:	9d                   	popf
c010028b:	c3                   	ret

c010028c <jump_to_usermode>:
c010028c:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c0100290:	8b 4c 24 08          	mov    0x8(%esp),%ecx
c0100294:	66 b8 23 00          	mov    $0x23,%ax
c0100298:	8e d8                	mov    %eax,%ds
c010029a:	8e c0                	mov    %eax,%es
c010029c:	8e e0                	mov    %eax,%fs
c010029e:	8e e8                	mov    %eax,%gs
c01002a0:	6a 23                	push   $0x23
c01002a2:	51                   	push   %ecx
c01002a3:	9c                   	pushf
c01002a4:	58                   	pop    %eax
c01002a5:	0d 00 02 00 00       	or     $0x200,%eax
c01002aa:	50                   	push   %eax
c01002ab:	6a 1b                	push   $0x1b
c01002ad:	53                   	push   %ebx
c01002ae:	cf                   	iret
c01002af:	90                   	nop

c01002b0 <gdt_init>:
c01002b0:	83 ec 0c             	sub    $0xc,%esp
c01002b3:	b8 2f 00 00 00       	mov    $0x2f,%eax
c01002b8:	ba 00 20 11 c0       	mov    $0xc0112000,%edx
c01002bd:	31 c9                	xor    %ecx,%ecx
c01002bf:	c7 05 6a 20 11 c0 80 	movl   $0xc0112080,0xc011206a
c01002c6:	20 11 c0 
c01002c9:	c7 05 80 20 11 c0 00 	movl   $0x0,0xc0112080
c01002d0:	00 00 00 
c01002d3:	c7 05 84 20 11 c0 00 	movl   $0x0,0xc0112084
c01002da:	00 00 00 
c01002dd:	c7 05 88 20 11 c0 ff 	movl   $0xffff,0xc0112088
c01002e4:	ff 00 00 
c01002e7:	c7 05 8c 20 11 c0 00 	movl   $0xcf9a00,0xc011208c
c01002ee:	9a cf 00 
c01002f1:	c7 05 90 20 11 c0 ff 	movl   $0xffff,0xc0112090
c01002f8:	ff 00 00 
c01002fb:	c7 05 94 20 11 c0 00 	movl   $0xcf9200,0xc0112094
c0100302:	92 cf 00 
c0100305:	c7 05 98 20 11 c0 ff 	movl   $0xffff,0xc0112098
c010030c:	ff 00 00 
c010030f:	c7 05 9c 20 11 c0 00 	movl   $0xcffa00,0xc011209c
c0100316:	fa cf 00 
c0100319:	c7 05 a0 20 11 c0 ff 	movl   $0xffff,0xc01120a0
c0100320:	ff 00 00 
c0100323:	c7 05 a4 20 11 c0 00 	movl   $0xcff200,0xc01120a4
c010032a:	f2 cf 00 
c010032d:	66 a3 68 20 11 c0    	mov    %ax,0xc0112068
c0100333:	b8 67 20 11 c0       	mov    $0xc0112067,%eax
c0100338:	c7 81 00 20 11 c0 00 	movl   $0x0,-0x3feee000(%ecx)
c010033f:	00 00 00 
c0100342:	83 c1 08             	add    $0x8,%ecx
c0100345:	c7 81 fc 1f 11 c0 00 	movl   $0x0,-0x3feee004(%ecx)
c010034c:	00 00 00 
c010034f:	83 f9 68             	cmp    $0x68,%ecx
c0100352:	72 e4                	jb     c0100338 <gdt_init+0x88>
c0100354:	83 ec 0c             	sub    $0xc,%esp
c0100357:	b9 68 00 00 00       	mov    $0x68,%ecx
c010035c:	66 a3 a8 20 11 c0    	mov    %ax,0xc01120a8
c0100362:	c1 e8 10             	shr    $0x10,%eax
c0100365:	68 68 20 11 c0       	push   $0xc0112068
c010036a:	83 e0 0f             	and    $0xf,%eax
c010036d:	66 89 0d 66 20 11 c0 	mov    %cx,0xc0112066
c0100374:	89 d1                	mov    %edx,%ecx
c0100376:	c1 e9 10             	shr    $0x10,%ecx
c0100379:	66 89 15 aa 20 11 c0 	mov    %dx,0xc01120aa
c0100380:	c1 ea 18             	shr    $0x18,%edx
c0100383:	88 0d ac 20 11 c0    	mov    %cl,0xc01120ac
c0100389:	88 15 af 20 11 c0    	mov    %dl,0xc01120af
c010038f:	a2 ae 20 11 c0       	mov    %al,0xc01120ae
c0100394:	c7 05 08 20 11 c0 10 	movl   $0x10,0xc0112008
c010039b:	00 00 00 
c010039e:	c6 05 ad 20 11 c0 89 	movb   $0x89,0xc01120ad
c01003a5:	e8 d8 fc ff ff       	call   c0100082 <gdt_flush>
c01003aa:	66 b8 2b 00          	mov    $0x2b,%ax
c01003ae:	0f 00 d8             	ltr    %eax
c01003b1:	c7 04 24 14 76 10 c0 	movl   $0xc0107614,(%esp)
c01003b8:	e8 93 16 00 00       	call   c0101a50 <log_info>
c01003bd:	83 c4 1c             	add    $0x1c,%esp
c01003c0:	c3                   	ret
c01003c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c01003c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01003cf:	00 

c01003d0 <tss_prepare>:
c01003d0:	8b 44 24 04          	mov    0x4(%esp),%eax
c01003d4:	85 c0                	test   %eax,%eax
c01003d6:	74 0c                	je     c01003e4 <tss_prepare+0x14>
c01003d8:	8b 50 2c             	mov    0x2c(%eax),%edx
c01003db:	03 50 28             	add    0x28(%eax),%edx
c01003de:	89 15 04 20 11 c0    	mov    %edx,0xc0112004
c01003e4:	c3                   	ret
c01003e5:	66 90                	xchg   %ax,%ax
c01003e7:	66 90                	xchg   %ax,%ax
c01003e9:	66 90                	xchg   %ax,%ax
c01003eb:	66 90                	xchg   %ax,%ax
c01003ed:	66 90                	xchg   %ax,%ax
c01003ef:	90                   	nop

c01003f0 <idt_init>:
c01003f0:	83 ec 10             	sub    $0x10,%esp
c01003f3:	b8 ff 07 00 00       	mov    $0x7ff,%eax
c01003f8:	c7 05 c2 20 11 c0 e0 	movl   $0xc01120e0,0xc01120c2
c01003ff:	20 11 c0 
c0100402:	68 00 08 00 00       	push   $0x800
c0100407:	6a 00                	push   $0x0
c0100409:	68 e0 20 11 c0       	push   $0xc01120e0
c010040e:	66 a3 c0 20 11 c0    	mov    %ax,0xc01120c0
c0100414:	e8 07 0d 00 00       	call   c0101120 <memset>
c0100419:	5a                   	pop    %edx
c010041a:	59                   	pop    %ecx
c010041b:	6a 28                	push   $0x28
c010041d:	6a 20                	push   $0x20
c010041f:	e8 fc 05 00 00       	call   c0100a20 <pic_remap>
c0100424:	b8 9f 00 10 c0       	mov    $0xc010009f,%eax
c0100429:	c7 05 e2 20 11 c0 08 	movl   $0x8e000008,0xc01120e2
c0100430:	00 00 8e 
c0100433:	66 a3 e0 20 11 c0    	mov    %ax,0xc01120e0
c0100439:	c1 e8 10             	shr    $0x10,%eax
c010043c:	66 a3 e6 20 11 c0    	mov    %ax,0xc01120e6
c0100442:	b8 a9 00 10 c0       	mov    $0xc01000a9,%eax
c0100447:	66 a3 e8 20 11 c0    	mov    %ax,0xc01120e8
c010044d:	c1 e8 10             	shr    $0x10,%eax
c0100450:	66 a3 ee 20 11 c0    	mov    %ax,0xc01120ee
c0100456:	b8 b3 00 10 c0       	mov    $0xc01000b3,%eax
c010045b:	66 a3 f0 20 11 c0    	mov    %ax,0xc01120f0
c0100461:	c1 e8 10             	shr    $0x10,%eax
c0100464:	66 a3 f6 20 11 c0    	mov    %ax,0xc01120f6
c010046a:	b8 bd 00 10 c0       	mov    $0xc01000bd,%eax
c010046f:	66 a3 f8 20 11 c0    	mov    %ax,0xc01120f8
c0100475:	c1 e8 10             	shr    $0x10,%eax
c0100478:	66 a3 fe 20 11 c0    	mov    %ax,0xc01120fe
c010047e:	b8 c7 00 10 c0       	mov    $0xc01000c7,%eax
c0100483:	66 a3 00 21 11 c0    	mov    %ax,0xc0112100
c0100489:	c1 e8 10             	shr    $0x10,%eax
c010048c:	66 a3 06 21 11 c0    	mov    %ax,0xc0112106
c0100492:	b8 d1 00 10 c0       	mov    $0xc01000d1,%eax
c0100497:	66 a3 08 21 11 c0    	mov    %ax,0xc0112108
c010049d:	c1 e8 10             	shr    $0x10,%eax
c01004a0:	66 a3 0e 21 11 c0    	mov    %ax,0xc011210e
c01004a6:	b8 db 00 10 c0       	mov    $0xc01000db,%eax
c01004ab:	66 a3 10 21 11 c0    	mov    %ax,0xc0112110
c01004b1:	c1 e8 10             	shr    $0x10,%eax
c01004b4:	66 a3 16 21 11 c0    	mov    %ax,0xc0112116
c01004ba:	b8 e5 00 10 c0       	mov    $0xc01000e5,%eax
c01004bf:	66 a3 18 21 11 c0    	mov    %ax,0xc0112118
c01004c5:	c1 e8 10             	shr    $0x10,%eax
c01004c8:	66 a3 1e 21 11 c0    	mov    %ax,0xc011211e
c01004ce:	b8 ef 00 10 c0       	mov    $0xc01000ef,%eax
c01004d3:	66 a3 20 21 11 c0    	mov    %ax,0xc0112120
c01004d9:	c1 e8 10             	shr    $0x10,%eax
c01004dc:	66 a3 26 21 11 c0    	mov    %ax,0xc0112126
c01004e2:	b8 f7 00 10 c0       	mov    $0xc01000f7,%eax
c01004e7:	66 a3 28 21 11 c0    	mov    %ax,0xc0112128
c01004ed:	c1 e8 10             	shr    $0x10,%eax
c01004f0:	66 a3 2e 21 11 c0    	mov    %ax,0xc011212e
c01004f6:	b8 01 01 10 c0       	mov    $0xc0100101,%eax
c01004fb:	66 a3 30 21 11 c0    	mov    %ax,0xc0112130
c0100501:	c1 e8 10             	shr    $0x10,%eax
c0100504:	66 a3 36 21 11 c0    	mov    %ax,0xc0112136
c010050a:	b8 09 01 10 c0       	mov    $0xc0100109,%eax
c010050f:	c7 05 ea 20 11 c0 08 	movl   $0x8e000008,0xc01120ea
c0100516:	00 00 8e 
c0100519:	c7 05 f2 20 11 c0 08 	movl   $0x8e000008,0xc01120f2
c0100520:	00 00 8e 
c0100523:	c7 05 fa 20 11 c0 08 	movl   $0x8e000008,0xc01120fa
c010052a:	00 00 8e 
c010052d:	c7 05 02 21 11 c0 08 	movl   $0x8e000008,0xc0112102
c0100534:	00 00 8e 
c0100537:	c7 05 0a 21 11 c0 08 	movl   $0x8e000008,0xc011210a
c010053e:	00 00 8e 
c0100541:	c7 05 12 21 11 c0 08 	movl   $0x8e000008,0xc0112112
c0100548:	00 00 8e 
c010054b:	c7 05 1a 21 11 c0 08 	movl   $0x8e000008,0xc011211a
c0100552:	00 00 8e 
c0100555:	c7 05 22 21 11 c0 08 	movl   $0x8e000008,0xc0112122
c010055c:	00 00 8e 
c010055f:	c7 05 2a 21 11 c0 08 	movl   $0x8e000008,0xc011212a
c0100566:	00 00 8e 
c0100569:	c7 05 32 21 11 c0 08 	movl   $0x8e000008,0xc0112132
c0100570:	00 00 8e 
c0100573:	66 a3 38 21 11 c0    	mov    %ax,0xc0112138
c0100579:	c1 e8 10             	shr    $0x10,%eax
c010057c:	66 a3 3e 21 11 c0    	mov    %ax,0xc011213e
c0100582:	b8 11 01 10 c0       	mov    $0xc0100111,%eax
c0100587:	66 a3 40 21 11 c0    	mov    %ax,0xc0112140
c010058d:	c1 e8 10             	shr    $0x10,%eax
c0100590:	66 a3 46 21 11 c0    	mov    %ax,0xc0112146
c0100596:	b8 19 01 10 c0       	mov    $0xc0100119,%eax
c010059b:	66 a3 48 21 11 c0    	mov    %ax,0xc0112148
c01005a1:	c1 e8 10             	shr    $0x10,%eax
c01005a4:	66 a3 4e 21 11 c0    	mov    %ax,0xc011214e
c01005aa:	b8 21 01 10 c0       	mov    $0xc0100121,%eax
c01005af:	66 a3 50 21 11 c0    	mov    %ax,0xc0112150
c01005b5:	c1 e8 10             	shr    $0x10,%eax
c01005b8:	66 a3 56 21 11 c0    	mov    %ax,0xc0112156
c01005be:	b8 29 01 10 c0       	mov    $0xc0100129,%eax
c01005c3:	66 a3 58 21 11 c0    	mov    %ax,0xc0112158
c01005c9:	c1 e8 10             	shr    $0x10,%eax
c01005cc:	66 a3 5e 21 11 c0    	mov    %ax,0xc011215e
c01005d2:	b8 33 01 10 c0       	mov    $0xc0100133,%eax
c01005d7:	66 a3 60 21 11 c0    	mov    %ax,0xc0112160
c01005dd:	c1 e8 10             	shr    $0x10,%eax
c01005e0:	66 a3 66 21 11 c0    	mov    %ax,0xc0112166
c01005e6:	b8 3d 01 10 c0       	mov    $0xc010013d,%eax
c01005eb:	66 a3 68 21 11 c0    	mov    %ax,0xc0112168
c01005f1:	c1 e8 10             	shr    $0x10,%eax
c01005f4:	66 a3 6e 21 11 c0    	mov    %ax,0xc011216e
c01005fa:	b8 47 01 10 c0       	mov    $0xc0100147,%eax
c01005ff:	66 a3 70 21 11 c0    	mov    %ax,0xc0112170
c0100605:	c1 e8 10             	shr    $0x10,%eax
c0100608:	66 a3 76 21 11 c0    	mov    %ax,0xc0112176
c010060e:	b8 51 01 10 c0       	mov    $0xc0100151,%eax
c0100613:	66 a3 78 21 11 c0    	mov    %ax,0xc0112178
c0100619:	c1 e8 10             	shr    $0x10,%eax
c010061c:	66 a3 7e 21 11 c0    	mov    %ax,0xc011217e
c0100622:	b8 5b 01 10 c0       	mov    $0xc010015b,%eax
c0100627:	66 a3 80 21 11 c0    	mov    %ax,0xc0112180
c010062d:	c1 e8 10             	shr    $0x10,%eax
c0100630:	66 a3 86 21 11 c0    	mov    %ax,0xc0112186
c0100636:	b8 65 01 10 c0       	mov    $0xc0100165,%eax
c010063b:	66 a3 88 21 11 c0    	mov    %ax,0xc0112188
c0100641:	c1 e8 10             	shr    $0x10,%eax
c0100644:	66 a3 8e 21 11 c0    	mov    %ax,0xc011218e
c010064a:	b8 6f 01 10 c0       	mov    $0xc010016f,%eax
c010064f:	c7 05 3a 21 11 c0 08 	movl   $0x8e000008,0xc011213a
c0100656:	00 00 8e 
c0100659:	c7 05 42 21 11 c0 08 	movl   $0x8e000008,0xc0112142
c0100660:	00 00 8e 
c0100663:	c7 05 4a 21 11 c0 08 	movl   $0x8e000008,0xc011214a
c010066a:	00 00 8e 
c010066d:	c7 05 52 21 11 c0 08 	movl   $0x8e000008,0xc0112152
c0100674:	00 00 8e 
c0100677:	c7 05 5a 21 11 c0 08 	movl   $0x8e000008,0xc011215a
c010067e:	00 00 8e 
c0100681:	c7 05 62 21 11 c0 08 	movl   $0x8e000008,0xc0112162
c0100688:	00 00 8e 
c010068b:	c7 05 6a 21 11 c0 08 	movl   $0x8e000008,0xc011216a
c0100692:	00 00 8e 
c0100695:	c7 05 72 21 11 c0 08 	movl   $0x8e000008,0xc0112172
c010069c:	00 00 8e 
c010069f:	c7 05 7a 21 11 c0 08 	movl   $0x8e000008,0xc011217a
c01006a6:	00 00 8e 
c01006a9:	c7 05 82 21 11 c0 08 	movl   $0x8e000008,0xc0112182
c01006b0:	00 00 8e 
c01006b3:	c7 05 8a 21 11 c0 08 	movl   $0x8e000008,0xc011218a
c01006ba:	00 00 8e 
c01006bd:	66 a3 90 21 11 c0    	mov    %ax,0xc0112190
c01006c3:	c1 e8 10             	shr    $0x10,%eax
c01006c6:	66 a3 96 21 11 c0    	mov    %ax,0xc0112196
c01006cc:	b8 79 01 10 c0       	mov    $0xc0100179,%eax
c01006d1:	66 a3 98 21 11 c0    	mov    %ax,0xc0112198
c01006d7:	c1 e8 10             	shr    $0x10,%eax
c01006da:	66 a3 9e 21 11 c0    	mov    %ax,0xc011219e
c01006e0:	b8 83 01 10 c0       	mov    $0xc0100183,%eax
c01006e5:	66 a3 a0 21 11 c0    	mov    %ax,0xc01121a0
c01006eb:	c1 e8 10             	shr    $0x10,%eax
c01006ee:	66 a3 a6 21 11 c0    	mov    %ax,0xc01121a6
c01006f4:	b8 8d 01 10 c0       	mov    $0xc010018d,%eax
c01006f9:	66 a3 a8 21 11 c0    	mov    %ax,0xc01121a8
c01006ff:	c1 e8 10             	shr    $0x10,%eax
c0100702:	66 a3 ae 21 11 c0    	mov    %ax,0xc01121ae
c0100708:	b8 97 01 10 c0       	mov    $0xc0100197,%eax
c010070d:	66 a3 b0 21 11 c0    	mov    %ax,0xc01121b0
c0100713:	c1 e8 10             	shr    $0x10,%eax
c0100716:	66 a3 b6 21 11 c0    	mov    %ax,0xc01121b6
c010071c:	b8 a1 01 10 c0       	mov    $0xc01001a1,%eax
c0100721:	66 a3 b8 21 11 c0    	mov    %ax,0xc01121b8
c0100727:	c1 e8 10             	shr    $0x10,%eax
c010072a:	66 a3 be 21 11 c0    	mov    %ax,0xc01121be
c0100730:	b8 ab 01 10 c0       	mov    $0xc01001ab,%eax
c0100735:	66 a3 c0 21 11 c0    	mov    %ax,0xc01121c0
c010073b:	c1 e8 10             	shr    $0x10,%eax
c010073e:	66 a3 c6 21 11 c0    	mov    %ax,0xc01121c6
c0100744:	b8 b5 01 10 c0       	mov    $0xc01001b5,%eax
c0100749:	66 a3 c8 21 11 c0    	mov    %ax,0xc01121c8
c010074f:	c1 e8 10             	shr    $0x10,%eax
c0100752:	66 a3 ce 21 11 c0    	mov    %ax,0xc01121ce
c0100758:	b8 bf 01 10 c0       	mov    $0xc01001bf,%eax
c010075d:	66 a3 d0 21 11 c0    	mov    %ax,0xc01121d0
c0100763:	c1 e8 10             	shr    $0x10,%eax
c0100766:	66 a3 d6 21 11 c0    	mov    %ax,0xc01121d6
c010076c:	b8 c9 01 10 c0       	mov    $0xc01001c9,%eax
c0100771:	66 a3 d8 21 11 c0    	mov    %ax,0xc01121d8
c0100777:	c1 e8 10             	shr    $0x10,%eax
c010077a:	66 a3 de 21 11 c0    	mov    %ax,0xc01121de
c0100780:	b8 d0 01 10 c0       	mov    $0xc01001d0,%eax
c0100785:	66 a3 e0 21 11 c0    	mov    %ax,0xc01121e0
c010078b:	c1 e8 10             	shr    $0x10,%eax
c010078e:	66 a3 e6 21 11 c0    	mov    %ax,0xc01121e6
c0100794:	b8 d7 01 10 c0       	mov    $0xc01001d7,%eax
c0100799:	c7 05 92 21 11 c0 08 	movl   $0x8e000008,0xc0112192
c01007a0:	00 00 8e 
c01007a3:	c7 05 9a 21 11 c0 08 	movl   $0x8e000008,0xc011219a
c01007aa:	00 00 8e 
c01007ad:	c7 05 a2 21 11 c0 08 	movl   $0x8e000008,0xc01121a2
c01007b4:	00 00 8e 
c01007b7:	c7 05 aa 21 11 c0 08 	movl   $0x8e000008,0xc01121aa
c01007be:	00 00 8e 
c01007c1:	c7 05 b2 21 11 c0 08 	movl   $0x8e000008,0xc01121b2
c01007c8:	00 00 8e 
c01007cb:	c7 05 ba 21 11 c0 08 	movl   $0x8e000008,0xc01121ba
c01007d2:	00 00 8e 
c01007d5:	c7 05 c2 21 11 c0 08 	movl   $0x8e000008,0xc01121c2
c01007dc:	00 00 8e 
c01007df:	c7 05 ca 21 11 c0 08 	movl   $0x8e000008,0xc01121ca
c01007e6:	00 00 8e 
c01007e9:	c7 05 d2 21 11 c0 08 	movl   $0x8e000008,0xc01121d2
c01007f0:	00 00 8e 
c01007f3:	c7 05 da 21 11 c0 08 	movl   $0x8e000008,0xc01121da
c01007fa:	00 00 8e 
c01007fd:	c7 05 e2 21 11 c0 08 	movl   $0x8e000008,0xc01121e2
c0100804:	00 00 8e 
c0100807:	66 a3 e8 21 11 c0    	mov    %ax,0xc01121e8
c010080d:	c1 e8 10             	shr    $0x10,%eax
c0100810:	66 a3 ee 21 11 c0    	mov    %ax,0xc01121ee
c0100816:	b8 de 01 10 c0       	mov    $0xc01001de,%eax
c010081b:	66 a3 f0 21 11 c0    	mov    %ax,0xc01121f0
c0100821:	c1 e8 10             	shr    $0x10,%eax
c0100824:	66 a3 f6 21 11 c0    	mov    %ax,0xc01121f6
c010082a:	b8 e5 01 10 c0       	mov    $0xc01001e5,%eax
c010082f:	66 a3 f8 21 11 c0    	mov    %ax,0xc01121f8
c0100835:	c1 e8 10             	shr    $0x10,%eax
c0100838:	66 a3 fe 21 11 c0    	mov    %ax,0xc01121fe
c010083e:	b8 ec 01 10 c0       	mov    $0xc01001ec,%eax
c0100843:	66 a3 00 22 11 c0    	mov    %ax,0xc0112200
c0100849:	c1 e8 10             	shr    $0x10,%eax
c010084c:	66 a3 06 22 11 c0    	mov    %ax,0xc0112206
c0100852:	b8 f3 01 10 c0       	mov    $0xc01001f3,%eax
c0100857:	66 a3 08 22 11 c0    	mov    %ax,0xc0112208
c010085d:	c1 e8 10             	shr    $0x10,%eax
c0100860:	66 a3 0e 22 11 c0    	mov    %ax,0xc011220e
c0100866:	b8 fa 01 10 c0       	mov    $0xc01001fa,%eax
c010086b:	66 a3 10 22 11 c0    	mov    %ax,0xc0112210
c0100871:	c1 e8 10             	shr    $0x10,%eax
c0100874:	66 a3 16 22 11 c0    	mov    %ax,0xc0112216
c010087a:	b8 01 02 10 c0       	mov    $0xc0100201,%eax
c010087f:	66 a3 18 22 11 c0    	mov    %ax,0xc0112218
c0100885:	c1 e8 10             	shr    $0x10,%eax
c0100888:	66 a3 1e 22 11 c0    	mov    %ax,0xc011221e
c010088e:	b8 08 02 10 c0       	mov    $0xc0100208,%eax
c0100893:	66 a3 20 22 11 c0    	mov    %ax,0xc0112220
c0100899:	c1 e8 10             	shr    $0x10,%eax
c010089c:	66 a3 26 22 11 c0    	mov    %ax,0xc0112226
c01008a2:	b8 0f 02 10 c0       	mov    $0xc010020f,%eax
c01008a7:	66 a3 28 22 11 c0    	mov    %ax,0xc0112228
c01008ad:	c1 e8 10             	shr    $0x10,%eax
c01008b0:	66 a3 2e 22 11 c0    	mov    %ax,0xc011222e
c01008b6:	b8 16 02 10 c0       	mov    $0xc0100216,%eax
c01008bb:	66 a3 30 22 11 c0    	mov    %ax,0xc0112230
c01008c1:	c1 e8 10             	shr    $0x10,%eax
c01008c4:	66 a3 36 22 11 c0    	mov    %ax,0xc0112236
c01008ca:	b8 1d 02 10 c0       	mov    $0xc010021d,%eax
c01008cf:	66 a3 38 22 11 c0    	mov    %ax,0xc0112238
c01008d5:	c1 e8 10             	shr    $0x10,%eax
c01008d8:	66 a3 3e 22 11 c0    	mov    %ax,0xc011223e
c01008de:	b8 24 02 10 c0       	mov    $0xc0100224,%eax
c01008e3:	c7 05 ea 21 11 c0 08 	movl   $0x8e000008,0xc01121ea
c01008ea:	00 00 8e 
c01008ed:	c7 05 f2 21 11 c0 08 	movl   $0x8e000008,0xc01121f2
c01008f4:	00 00 8e 
c01008f7:	c7 05 fa 21 11 c0 08 	movl   $0x8e000008,0xc01121fa
c01008fe:	00 00 8e 
c0100901:	c7 05 02 22 11 c0 08 	movl   $0x8e000008,0xc0112202
c0100908:	00 00 8e 
c010090b:	c7 05 0a 22 11 c0 08 	movl   $0x8e000008,0xc011220a
c0100912:	00 00 8e 
c0100915:	c7 05 12 22 11 c0 08 	movl   $0x8e000008,0xc0112212
c010091c:	00 00 8e 
c010091f:	c7 05 1a 22 11 c0 08 	movl   $0x8e000008,0xc011221a
c0100926:	00 00 8e 
c0100929:	c7 05 22 22 11 c0 08 	movl   $0x8e000008,0xc0112222
c0100930:	00 00 8e 
c0100933:	c7 05 2a 22 11 c0 08 	movl   $0x8e000008,0xc011222a
c010093a:	00 00 8e 
c010093d:	c7 05 32 22 11 c0 08 	movl   $0x8e000008,0xc0112232
c0100944:	00 00 8e 
c0100947:	c7 05 3a 22 11 c0 08 	movl   $0x8e000008,0xc011223a
c010094e:	00 00 8e 
c0100951:	66 a3 40 22 11 c0    	mov    %ax,0xc0112240
c0100957:	c1 e8 10             	shr    $0x10,%eax
c010095a:	66 a3 46 22 11 c0    	mov    %ax,0xc0112246
c0100960:	b8 2b 02 10 c0       	mov    $0xc010022b,%eax
c0100965:	66 a3 48 22 11 c0    	mov    %ax,0xc0112248
c010096b:	c1 e8 10             	shr    $0x10,%eax
c010096e:	66 a3 4e 22 11 c0    	mov    %ax,0xc011224e
c0100974:	b8 32 02 10 c0       	mov    $0xc0100232,%eax
c0100979:	66 a3 50 22 11 c0    	mov    %ax,0xc0112250
c010097f:	c1 e8 10             	shr    $0x10,%eax
c0100982:	66 a3 56 22 11 c0    	mov    %ax,0xc0112256
c0100988:	b8 39 02 10 c0       	mov    $0xc0100239,%eax
c010098d:	66 a3 58 22 11 c0    	mov    %ax,0xc0112258
c0100993:	c1 e8 10             	shr    $0x10,%eax
c0100996:	66 a3 5e 22 11 c0    	mov    %ax,0xc011225e
c010099c:	b8 40 02 10 c0       	mov    $0xc0100240,%eax
c01009a1:	66 a3 e0 24 11 c0    	mov    %ax,0xc01124e0
c01009a7:	c1 e8 10             	shr    $0x10,%eax
c01009aa:	c7 05 42 22 11 c0 08 	movl   $0x8e000008,0xc0112242
c01009b1:	00 00 8e 
c01009b4:	c7 05 4a 22 11 c0 08 	movl   $0x8e000008,0xc011224a
c01009bb:	00 00 8e 
c01009be:	c7 05 52 22 11 c0 08 	movl   $0x8e000008,0xc0112252
c01009c5:	00 00 8e 
c01009c8:	c7 05 5a 22 11 c0 08 	movl   $0x8e000008,0xc011225a
c01009cf:	00 00 8e 
c01009d2:	66 a3 e6 24 11 c0    	mov    %ax,0xc01124e6
c01009d8:	c7 05 e2 24 11 c0 08 	movl   $0xee000008,0xc01124e2
c01009df:	00 00 ee 
c01009e2:	0f 01 1d c0 20 11 c0 	lidtl  0xc01120c0
c01009e9:	fb                   	sti
c01009ea:	c7 04 24 30 76 10 c0 	movl   $0xc0107630,(%esp)
c01009f1:	e8 5a 10 00 00       	call   c0101a50 <log_info>
c01009f6:	83 c4 1c             	add    $0x1c,%esp
c01009f9:	c3                   	ret
c01009fa:	66 90                	xchg   %ax,%ax
c01009fc:	66 90                	xchg   %ax,%ax
c01009fe:	66 90                	xchg   %ax,%ax

c0100a00 <pic_send_eoi>:
c0100a00:	80 7c 24 04 07       	cmpb   $0x7,0x4(%esp)
c0100a05:	76 07                	jbe    c0100a0e <pic_send_eoi+0xe>
c0100a07:	b8 20 00 00 00       	mov    $0x20,%eax
c0100a0c:	e6 a0                	out    %al,$0xa0
c0100a0e:	b8 20 00 00 00       	mov    $0x20,%eax
c0100a13:	e6 20                	out    %al,$0x20
c0100a15:	c3                   	ret
c0100a16:	66 90                	xchg   %ax,%ax
c0100a18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100a1f:	00 

c0100a20 <pic_remap>:
c0100a20:	53                   	push   %ebx
c0100a21:	83 ec 04             	sub    $0x4,%esp
c0100a24:	e4 21                	in     $0x21,%al
c0100a26:	88 44 24 03          	mov    %al,0x3(%esp)
c0100a2a:	e4 a1                	in     $0xa1,%al
c0100a2c:	89 c3                	mov    %eax,%ebx
c0100a2e:	b8 11 00 00 00       	mov    $0x11,%eax
c0100a33:	e6 20                	out    %al,$0x20
c0100a35:	31 c0                	xor    %eax,%eax
c0100a37:	e6 80                	out    %al,$0x80
c0100a39:	b8 11 00 00 00       	mov    $0x11,%eax
c0100a3e:	e6 a0                	out    %al,$0xa0
c0100a40:	31 c0                	xor    %eax,%eax
c0100a42:	e6 80                	out    %al,$0x80
c0100a44:	8b 44 24 0c          	mov    0xc(%esp),%eax
c0100a48:	e6 21                	out    %al,$0x21
c0100a4a:	31 c0                	xor    %eax,%eax
c0100a4c:	e6 80                	out    %al,$0x80
c0100a4e:	8b 44 24 10          	mov    0x10(%esp),%eax
c0100a52:	e6 a1                	out    %al,$0xa1
c0100a54:	31 c0                	xor    %eax,%eax
c0100a56:	e6 80                	out    %al,$0x80
c0100a58:	b8 04 00 00 00       	mov    $0x4,%eax
c0100a5d:	e6 21                	out    %al,$0x21
c0100a5f:	31 c0                	xor    %eax,%eax
c0100a61:	e6 80                	out    %al,$0x80
c0100a63:	b8 02 00 00 00       	mov    $0x2,%eax
c0100a68:	e6 a1                	out    %al,$0xa1
c0100a6a:	31 c0                	xor    %eax,%eax
c0100a6c:	e6 80                	out    %al,$0x80
c0100a6e:	b8 01 00 00 00       	mov    $0x1,%eax
c0100a73:	e6 21                	out    %al,$0x21
c0100a75:	31 c0                	xor    %eax,%eax
c0100a77:	e6 80                	out    %al,$0x80
c0100a79:	b8 01 00 00 00       	mov    $0x1,%eax
c0100a7e:	e6 a1                	out    %al,$0xa1
c0100a80:	31 c0                	xor    %eax,%eax
c0100a82:	e6 80                	out    %al,$0x80
c0100a84:	0f b6 44 24 03       	movzbl 0x3(%esp),%eax
c0100a89:	e6 21                	out    %al,$0x21
c0100a8b:	89 d8                	mov    %ebx,%eax
c0100a8d:	e6 a1                	out    %al,$0xa1
c0100a8f:	83 c4 04             	add    $0x4,%esp
c0100a92:	5b                   	pop    %ebx
c0100a93:	c3                   	ret
c0100a94:	66 90                	xchg   %ax,%ax
c0100a96:	66 90                	xchg   %ax,%ax
c0100a98:	66 90                	xchg   %ax,%ax
c0100a9a:	66 90                	xchg   %ax,%ax
c0100a9c:	66 90                	xchg   %ax,%ax
c0100a9e:	66 90                	xchg   %ax,%ax

c0100aa0 <console_dev_ioctl>:
c0100aa0:	b8 da ff ff ff       	mov    $0xffffffda,%eax
c0100aa5:	c3                   	ret
c0100aa6:	66 90                	xchg   %ax,%ax
c0100aa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100aaf:	00 

c0100ab0 <console_init>:
c0100ab0:	c7 05 1c 29 11 c0 00 	movl   $0x0,0xc011291c
c0100ab7:	00 00 00 
c0100aba:	ba a0 80 0b c0       	mov    $0xc00b80a0,%edx
c0100abf:	c7 05 18 29 11 c0 00 	movl   $0x0,0xc0112918
c0100ac6:	00 00 00 
c0100ac9:	c6 05 14 29 11 c0 07 	movb   $0x7,0xc0112914
c0100ad0:	c7 05 10 29 11 c0 00 	movl   $0xc00b8000,0xc0112910
c0100ad7:	80 0b c0 
c0100ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0100ae0:	8d 82 60 ff ff ff    	lea    -0xa0(%edx),%eax
c0100ae6:	eb 18                	jmp    c0100b00 <console_init+0x50>
c0100ae8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100aef:	00 
c0100af0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100af7:	00 
c0100af8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100aff:	00 
c0100b00:	b9 20 07 00 00       	mov    $0x720,%ecx
c0100b05:	83 c0 04             	add    $0x4,%eax
c0100b08:	66 89 48 fc          	mov    %cx,-0x4(%eax)
c0100b0c:	b9 20 07 00 00       	mov    $0x720,%ecx
c0100b11:	66 89 48 fe          	mov    %cx,-0x2(%eax)
c0100b15:	39 d0                	cmp    %edx,%eax
c0100b17:	75 e7                	jne    c0100b00 <console_init+0x50>
c0100b19:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0100b1f:	3d a0 8f 0b c0       	cmp    $0xc00b8fa0,%eax
c0100b24:	75 ba                	jne    c0100ae0 <console_init+0x30>
c0100b26:	c3                   	ret
c0100b27:	90                   	nop
c0100b28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100b2f:	00 

c0100b30 <console_set_color>:
c0100b30:	0f b6 44 24 08       	movzbl 0x8(%esp),%eax
c0100b35:	c1 e0 04             	shl    $0x4,%eax
c0100b38:	0a 44 24 04          	or     0x4(%esp),%al
c0100b3c:	a2 14 29 11 c0       	mov    %al,0xc0112914
c0100b41:	c3                   	ret
c0100b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0100b48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100b4f:	00 

c0100b50 <console_putchar>:
c0100b50:	83 ec 08             	sub    $0x8,%esp
c0100b53:	89 1c 24             	mov    %ebx,(%esp)
c0100b56:	8b 1d 1c 29 11 c0    	mov    0xc011291c,%ebx
c0100b5c:	80 7c 24 0c 0a       	cmpb   $0xa,0xc(%esp)
c0100b61:	74 4d                	je     c0100bb0 <console_putchar+0x60>
c0100b63:	0f b6 0d 14 29 11 c0 	movzbl 0xc0112914,%ecx
c0100b6a:	a1 18 29 11 c0       	mov    0xc0112918,%eax
c0100b6f:	89 74 24 04          	mov    %esi,0x4(%esp)
c0100b73:	8d 14 9b             	lea    (%ebx,%ebx,4),%edx
c0100b76:	66 0f be 74 24 0c    	movsbw 0xc(%esp),%si
c0100b7c:	c1 e2 04             	shl    $0x4,%edx
c0100b7f:	c1 e1 08             	shl    $0x8,%ecx
c0100b82:	01 c2                	add    %eax,%edx
c0100b84:	83 c0 01             	add    $0x1,%eax
c0100b87:	09 f1                	or     %esi,%ecx
c0100b89:	8b 35 10 29 11 c0    	mov    0xc0112910,%esi
c0100b8f:	a3 18 29 11 c0       	mov    %eax,0xc0112918
c0100b94:	66 89 0c 56          	mov    %cx,(%esi,%edx,2)
c0100b98:	8b 74 24 04          	mov    0x4(%esp),%esi
c0100b9c:	83 f8 50             	cmp    $0x50,%eax
c0100b9f:	74 0f                	je     c0100bb0 <console_putchar+0x60>
c0100ba1:	8b 1c 24             	mov    (%esp),%ebx
c0100ba4:	83 c4 08             	add    $0x8,%esp
c0100ba7:	c3                   	ret
c0100ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100baf:	00 
c0100bb0:	c7 05 18 29 11 c0 00 	movl   $0x0,0xc0112918
c0100bb7:	00 00 00 
c0100bba:	8d 43 01             	lea    0x1(%ebx),%eax
c0100bbd:	31 d2                	xor    %edx,%edx
c0100bbf:	83 fb 18             	cmp    $0x18,%ebx
c0100bc2:	0f 44 c2             	cmove  %edx,%eax
c0100bc5:	8b 1c 24             	mov    (%esp),%ebx
c0100bc8:	a3 1c 29 11 c0       	mov    %eax,0xc011291c
c0100bcd:	83 c4 08             	add    $0x8,%esp
c0100bd0:	c3                   	ret
c0100bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0100bd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100bdf:	00 

c0100be0 <console_dev_write>:
c0100be0:	83 ec 0c             	sub    $0xc,%esp
c0100be3:	89 7c 24 08          	mov    %edi,0x8(%esp)
c0100be7:	8b 7c 24 18          	mov    0x18(%esp),%edi
c0100beb:	85 ff                	test   %edi,%edi
c0100bed:	74 38                	je     c0100c27 <console_dev_write+0x47>
c0100bef:	89 1c 24             	mov    %ebx,(%esp)
c0100bf2:	8b 5c 24 14          	mov    0x14(%esp),%ebx
c0100bf6:	89 74 24 04          	mov    %esi,0x4(%esp)
c0100bfa:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
c0100bfd:	8d 76 00             	lea    0x0(%esi),%esi
c0100c00:	0f be 03             	movsbl (%ebx),%eax
c0100c03:	83 c3 01             	add    $0x1,%ebx
c0100c06:	50                   	push   %eax
c0100c07:	e8 44 ff ff ff       	call   c0100b50 <console_putchar>
c0100c0c:	0f be 43 ff          	movsbl -0x1(%ebx),%eax
c0100c10:	83 ec 08             	sub    $0x8,%esp
c0100c13:	50                   	push   %eax
c0100c14:	e8 47 02 00 00       	call   c0100e60 <serial_putchar>
c0100c19:	83 c4 10             	add    $0x10,%esp
c0100c1c:	39 f3                	cmp    %esi,%ebx
c0100c1e:	75 e0                	jne    c0100c00 <console_dev_write+0x20>
c0100c20:	8b 1c 24             	mov    (%esp),%ebx
c0100c23:	8b 74 24 04          	mov    0x4(%esp),%esi
c0100c27:	89 f8                	mov    %edi,%eax
c0100c29:	8b 7c 24 08          	mov    0x8(%esp),%edi
c0100c2d:	83 c4 0c             	add    $0xc,%esp
c0100c30:	c3                   	ret
c0100c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0100c38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100c3f:	00 

c0100c40 <console_puts>:
c0100c40:	83 ec 14             	sub    $0x14,%esp
c0100c43:	89 74 24 08          	mov    %esi,0x8(%esp)
c0100c47:	8b 74 24 18          	mov    0x18(%esp),%esi
c0100c4b:	66 0f be 06          	movsbw (%esi),%ax
c0100c4f:	84 c0                	test   %al,%al
c0100c51:	0f 84 98 00 00 00    	je     c0100cef <console_puts+0xaf>
c0100c57:	89 7c 24 0c          	mov    %edi,0xc(%esp)
c0100c5b:	0f b6 3d 14 29 11 c0 	movzbl 0xc0112914,%edi
c0100c62:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0100c66:	8b 0d 18 29 11 c0    	mov    0xc0112918,%ecx
c0100c6c:	89 6c 24 10          	mov    %ebp,0x10(%esp)
c0100c70:	8b 1d 1c 29 11 c0    	mov    0xc011291c,%ebx
c0100c76:	c1 e7 08             	shl    $0x8,%edi
c0100c79:	c6 44 24 03 00       	movb   $0x0,0x3(%esp)
c0100c7e:	8b 2d 10 29 11 c0    	mov    0xc0112910,%ebp
c0100c84:	eb 12                	jmp    c0100c98 <console_puts+0x58>
c0100c86:	66 90                	xchg   %ax,%ax
c0100c88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100c8f:	00 
c0100c90:	66 0f be 06          	movsbw (%esi),%ax
c0100c94:	84 c0                	test   %al,%al
c0100c96:	74 38                	je     c0100cd0 <console_puts+0x90>
c0100c98:	83 c6 01             	add    $0x1,%esi
c0100c9b:	3c 0a                	cmp    $0xa,%al
c0100c9d:	74 61                	je     c0100d00 <console_puts+0xc0>
c0100c9f:	8d 14 9b             	lea    (%ebx,%ebx,4),%edx
c0100ca2:	09 f8                	or     %edi,%eax
c0100ca4:	c1 e2 04             	shl    $0x4,%edx
c0100ca7:	01 ca                	add    %ecx,%edx
c0100ca9:	83 c1 01             	add    $0x1,%ecx
c0100cac:	66 89 44 55 00       	mov    %ax,0x0(%ebp,%edx,2)
c0100cb1:	83 f9 50             	cmp    $0x50,%ecx
c0100cb4:	75 da                	jne    c0100c90 <console_puts+0x50>
c0100cb6:	83 c3 01             	add    $0x1,%ebx
c0100cb9:	83 fb 19             	cmp    $0x19,%ebx
c0100cbc:	74 6a                	je     c0100d28 <console_puts+0xe8>
c0100cbe:	66 0f be 06          	movsbw (%esi),%ax
c0100cc2:	c6 44 24 03 01       	movb   $0x1,0x3(%esp)
c0100cc7:	31 c9                	xor    %ecx,%ecx
c0100cc9:	84 c0                	test   %al,%al
c0100ccb:	75 cb                	jne    c0100c98 <console_puts+0x58>
c0100ccd:	8d 76 00             	lea    0x0(%esi),%esi
c0100cd0:	80 7c 24 03 00       	cmpb   $0x0,0x3(%esp)
c0100cd5:	74 06                	je     c0100cdd <console_puts+0x9d>
c0100cd7:	89 1d 1c 29 11 c0    	mov    %ebx,0xc011291c
c0100cdd:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c0100ce1:	8b 7c 24 0c          	mov    0xc(%esp),%edi
c0100ce5:	89 0d 18 29 11 c0    	mov    %ecx,0xc0112918
c0100ceb:	8b 6c 24 10          	mov    0x10(%esp),%ebp
c0100cef:	8b 74 24 08          	mov    0x8(%esp),%esi
c0100cf3:	83 c4 14             	add    $0x14,%esp
c0100cf6:	c3                   	ret
c0100cf7:	90                   	nop
c0100cf8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100cff:	00 
c0100d00:	83 c3 01             	add    $0x1,%ebx
c0100d03:	c6 44 24 03 01       	movb   $0x1,0x3(%esp)
c0100d08:	83 fb 19             	cmp    $0x19,%ebx
c0100d0b:	74 0b                	je     c0100d18 <console_puts+0xd8>
c0100d0d:	31 c9                	xor    %ecx,%ecx
c0100d0f:	e9 7c ff ff ff       	jmp    c0100c90 <console_puts+0x50>
c0100d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0100d18:	31 db                	xor    %ebx,%ebx
c0100d1a:	31 c9                	xor    %ecx,%ecx
c0100d1c:	e9 6f ff ff ff       	jmp    c0100c90 <console_puts+0x50>
c0100d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0100d28:	66 0f be 06          	movsbw (%esi),%ax
c0100d2c:	84 c0                	test   %al,%al
c0100d2e:	74 3b                	je     c0100d6b <console_puts+0x12b>
c0100d30:	c6 44 24 03 01       	movb   $0x1,0x3(%esp)
c0100d35:	31 c9                	xor    %ecx,%ecx
c0100d37:	31 db                	xor    %ebx,%ebx
c0100d39:	3c 0a                	cmp    $0xa,%al
c0100d3b:	74 0b                	je     c0100d48 <console_puts+0x108>
c0100d3d:	83 c6 01             	add    $0x1,%esi
c0100d40:	e9 5a ff ff ff       	jmp    c0100c9f <console_puts+0x5f>
c0100d45:	8d 76 00             	lea    0x0(%esi),%esi
c0100d48:	66 0f be 46 01       	movsbw 0x1(%esi),%ax
c0100d4d:	84 c0                	test   %al,%al
c0100d4f:	74 23                	je     c0100d74 <console_puts+0x134>
c0100d51:	83 c6 02             	add    $0x2,%esi
c0100d54:	bb 01 00 00 00       	mov    $0x1,%ebx
c0100d59:	3c 0a                	cmp    $0xa,%al
c0100d5b:	0f 85 3e ff ff ff    	jne    c0100c9f <console_puts+0x5f>
c0100d61:	bb 02 00 00 00       	mov    $0x2,%ebx
c0100d66:	e9 25 ff ff ff       	jmp    c0100c90 <console_puts+0x50>
c0100d6b:	31 db                	xor    %ebx,%ebx
c0100d6d:	31 c9                	xor    %ecx,%ecx
c0100d6f:	e9 63 ff ff ff       	jmp    c0100cd7 <console_puts+0x97>
c0100d74:	bb 01 00 00 00       	mov    $0x1,%ebx
c0100d79:	e9 59 ff ff ff       	jmp    c0100cd7 <console_puts+0x97>
c0100d7e:	66 90                	xchg   %ax,%ax

c0100d80 <console_write>:
c0100d80:	83 ec 0c             	sub    $0xc,%esp
c0100d83:	89 74 24 08          	mov    %esi,0x8(%esp)
c0100d87:	8b 74 24 14          	mov    0x14(%esp),%esi
c0100d8b:	85 f6                	test   %esi,%esi
c0100d8d:	74 35                	je     c0100dc4 <console_write+0x44>
c0100d8f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0100d93:	8b 5c 24 10          	mov    0x10(%esp),%ebx
c0100d97:	01 de                	add    %ebx,%esi
c0100d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0100da0:	0f be 03             	movsbl (%ebx),%eax
c0100da3:	83 c3 01             	add    $0x1,%ebx
c0100da6:	50                   	push   %eax
c0100da7:	e8 a4 fd ff ff       	call   c0100b50 <console_putchar>
c0100dac:	0f be 43 ff          	movsbl -0x1(%ebx),%eax
c0100db0:	83 ec 08             	sub    $0x8,%esp
c0100db3:	50                   	push   %eax
c0100db4:	e8 a7 00 00 00       	call   c0100e60 <serial_putchar>
c0100db9:	83 c4 10             	add    $0x10,%esp
c0100dbc:	39 f3                	cmp    %esi,%ebx
c0100dbe:	75 e0                	jne    c0100da0 <console_write+0x20>
c0100dc0:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c0100dc4:	8b 74 24 08          	mov    0x8(%esp),%esi
c0100dc8:	83 c4 0c             	add    $0xc,%esp
c0100dcb:	c3                   	ret
c0100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

c0100dd0 <console_dev_init>:
c0100dd0:	83 ec 14             	sub    $0x14,%esp
c0100dd3:	68 41 76 10 c0       	push   $0xc0107641
c0100dd8:	68 e0 28 11 c0       	push   $0xc01128e0
c0100ddd:	e8 ae 01 00 00       	call   c0100f90 <strcpy>
c0100de2:	c7 04 24 e0 28 11 c0 	movl   $0xc01128e0,(%esp)
c0100de9:	c7 05 00 29 11 c0 00 	movl   $0x0,0xc0112900
c0100df0:	00 00 00 
c0100df3:	c7 05 04 29 11 c0 00 	movl   $0xc010b000,0xc0112904
c0100dfa:	b0 10 c0 
c0100dfd:	c7 05 08 29 11 c0 00 	movl   $0x0,0xc0112908
c0100e04:	00 00 00 
c0100e07:	e8 94 38 00 00       	call   c01046a0 <device_register>
c0100e0c:	83 c4 1c             	add    $0x1c,%esp
c0100e0f:	c3                   	ret

c0100e10 <serial_init>:
c0100e10:	53                   	push   %ebx
c0100e11:	31 c0                	xor    %eax,%eax
c0100e13:	ba f9 03 00 00       	mov    $0x3f9,%edx
c0100e18:	ee                   	out    %al,(%dx)
c0100e19:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
c0100e1e:	ba fb 03 00 00       	mov    $0x3fb,%edx
c0100e23:	ee                   	out    %al,(%dx)
c0100e24:	ba f8 03 00 00       	mov    $0x3f8,%edx
c0100e29:	b8 03 00 00 00       	mov    $0x3,%eax
c0100e2e:	ee                   	out    %al,(%dx)
c0100e2f:	31 c0                	xor    %eax,%eax
c0100e31:	ba f9 03 00 00       	mov    $0x3f9,%edx
c0100e36:	ee                   	out    %al,(%dx)
c0100e37:	b8 03 00 00 00       	mov    $0x3,%eax
c0100e3c:	ba fb 03 00 00       	mov    $0x3fb,%edx
c0100e41:	ee                   	out    %al,(%dx)
c0100e42:	b8 c7 ff ff ff       	mov    $0xffffffc7,%eax
c0100e47:	ba fa 03 00 00       	mov    $0x3fa,%edx
c0100e4c:	ee                   	out    %al,(%dx)
c0100e4d:	b8 0b 00 00 00       	mov    $0xb,%eax
c0100e52:	ba fc 03 00 00       	mov    $0x3fc,%edx
c0100e57:	ee                   	out    %al,(%dx)
c0100e58:	5b                   	pop    %ebx
c0100e59:	c3                   	ret
c0100e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

c0100e60 <serial_putchar>:
c0100e60:	ba fd 03 00 00       	mov    $0x3fd,%edx
c0100e65:	8d 76 00             	lea    0x0(%esi),%esi
c0100e68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100e6f:	00 
c0100e70:	ec                   	in     (%dx),%al
c0100e71:	a8 20                	test   $0x20,%al
c0100e73:	74 fb                	je     c0100e70 <serial_putchar+0x10>
c0100e75:	0f b6 44 24 04       	movzbl 0x4(%esp),%eax
c0100e7a:	ba f8 03 00 00       	mov    $0x3f8,%edx
c0100e7f:	ee                   	out    %al,(%dx)
c0100e80:	c3                   	ret
c0100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0100e88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100e8f:	00 

c0100e90 <serial_puts>:
c0100e90:	83 ec 0c             	sub    $0xc,%esp
c0100e93:	89 74 24 04          	mov    %esi,0x4(%esp)
c0100e97:	8b 74 24 10          	mov    0x10(%esp),%esi
c0100e9b:	89 1c 24             	mov    %ebx,(%esp)
c0100e9e:	0f b6 1e             	movzbl (%esi),%ebx
c0100ea1:	84 db                	test   %bl,%bl
c0100ea3:	74 34                	je     c0100ed9 <serial_puts+0x49>
c0100ea5:	8d 76 00             	lea    0x0(%esi),%esi
c0100ea8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100eaf:	00 
c0100eb0:	83 c6 01             	add    $0x1,%esi
c0100eb3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100eb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100ebf:	00 
c0100ec0:	ba fd 03 00 00       	mov    $0x3fd,%edx
c0100ec5:	ec                   	in     (%dx),%al
c0100ec6:	a8 20                	test   $0x20,%al
c0100ec8:	74 f6                	je     c0100ec0 <serial_puts+0x30>
c0100eca:	89 d8                	mov    %ebx,%eax
c0100ecc:	ba f8 03 00 00       	mov    $0x3f8,%edx
c0100ed1:	ee                   	out    %al,(%dx)
c0100ed2:	0f b6 1e             	movzbl (%esi),%ebx
c0100ed5:	84 db                	test   %bl,%bl
c0100ed7:	75 d7                	jne    c0100eb0 <serial_puts+0x20>
c0100ed9:	8b 1c 24             	mov    (%esp),%ebx
c0100edc:	8b 74 24 04          	mov    0x4(%esp),%esi
c0100ee0:	83 c4 0c             	add    $0xc,%esp
c0100ee3:	c3                   	ret
c0100ee4:	66 90                	xchg   %ax,%ax
c0100ee6:	66 90                	xchg   %ax,%ax
c0100ee8:	66 90                	xchg   %ax,%ax
c0100eea:	66 90                	xchg   %ax,%ax
c0100eec:	66 90                	xchg   %ax,%ax
c0100eee:	66 90                	xchg   %ax,%ax

c0100ef0 <timer_callback>:
c0100ef0:	83 05 20 29 11 c0 01 	addl   $0x1,0xc0112920
c0100ef7:	e9 b4 3e 00 00       	jmp    c0104db0 <scheduler_tick>
c0100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

c0100f00 <timer_init>:
c0100f00:	83 ec 14             	sub    $0x14,%esp
c0100f03:	68 f0 0e 10 c0       	push   $0xc0100ef0
c0100f08:	6a 20                	push   $0x20
c0100f0a:	e8 91 09 00 00       	call   c01018a0 <register_interrupt_handler>
c0100f0f:	31 d2                	xor    %edx,%edx
c0100f11:	b8 dc 34 12 00       	mov    $0x1234dc,%eax
c0100f16:	f7 74 24 20          	divl   0x20(%esp)
c0100f1a:	89 c1                	mov    %eax,%ecx
c0100f1c:	b8 36 00 00 00       	mov    $0x36,%eax
c0100f21:	e6 43                	out    %al,$0x43
c0100f23:	89 c8                	mov    %ecx,%eax
c0100f25:	e6 40                	out    %al,$0x40
c0100f27:	89 c8                	mov    %ecx,%eax
c0100f29:	c1 e8 08             	shr    $0x8,%eax
c0100f2c:	e6 40                	out    %al,$0x40
c0100f2e:	83 c4 0c             	add    $0xc,%esp
c0100f31:	51                   	push   %ecx
c0100f32:	ff 74 24 18          	push   0x18(%esp)
c0100f36:	68 7c a2 10 c0       	push   $0xc010a27c
c0100f3b:	e8 10 0b 00 00       	call   c0101a50 <log_info>
c0100f40:	83 c4 1c             	add    $0x1c,%esp
c0100f43:	c3                   	ret
c0100f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0100f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100f4f:	00 

c0100f50 <timer_get_ticks>:
c0100f50:	a1 20 29 11 c0       	mov    0xc0112920,%eax
c0100f55:	c3                   	ret
c0100f56:	66 90                	xchg   %ax,%ax
c0100f58:	66 90                	xchg   %ax,%ax
c0100f5a:	66 90                	xchg   %ax,%ax
c0100f5c:	66 90                	xchg   %ax,%ax
c0100f5e:	66 90                	xchg   %ax,%ax

c0100f60 <strlen>:
c0100f60:	8b 54 24 04          	mov    0x4(%esp),%edx
c0100f64:	31 c0                	xor    %eax,%eax
c0100f66:	80 3a 00             	cmpb   $0x0,(%edx)
c0100f69:	74 15                	je     c0100f80 <strlen+0x20>
c0100f6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100f70:	83 c0 01             	add    $0x1,%eax
c0100f73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
c0100f77:	75 f7                	jne    c0100f70 <strlen+0x10>
c0100f79:	c3                   	ret
c0100f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0100f80:	c3                   	ret
c0100f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0100f88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100f8f:	00 

c0100f90 <strcpy>:
c0100f90:	53                   	push   %ebx
c0100f91:	8b 4c 24 08          	mov    0x8(%esp),%ecx
c0100f95:	31 c0                	xor    %eax,%eax
c0100f97:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
c0100f9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100fa0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
c0100fa4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
c0100fa7:	83 c0 01             	add    $0x1,%eax
c0100faa:	84 d2                	test   %dl,%dl
c0100fac:	75 f2                	jne    c0100fa0 <strcpy+0x10>
c0100fae:	89 c8                	mov    %ecx,%eax
c0100fb0:	5b                   	pop    %ebx
c0100fb1:	c3                   	ret
c0100fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0100fb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100fbf:	00 

c0100fc0 <strncpy>:
c0100fc0:	56                   	push   %esi
c0100fc1:	31 c0                	xor    %eax,%eax
c0100fc3:	53                   	push   %ebx
c0100fc4:	8b 4c 24 14          	mov    0x14(%esp),%ecx
c0100fc8:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
c0100fcc:	8b 74 24 10          	mov    0x10(%esp),%esi
c0100fd0:	85 c9                	test   %ecx,%ecx
c0100fd2:	75 16                	jne    c0100fea <strncpy+0x2a>
c0100fd4:	eb 48                	jmp    c010101e <strncpy+0x5e>
c0100fd6:	66 90                	xchg   %ax,%ax
c0100fd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0100fdf:	00 
c0100fe0:	88 14 03             	mov    %dl,(%ebx,%eax,1)
c0100fe3:	83 c0 01             	add    $0x1,%eax
c0100fe6:	39 c1                	cmp    %eax,%ecx
c0100fe8:	74 34                	je     c010101e <strncpy+0x5e>
c0100fea:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
c0100fee:	84 d2                	test   %dl,%dl
c0100ff0:	75 ee                	jne    c0100fe0 <strncpy+0x20>
c0100ff2:	39 c8                	cmp    %ecx,%eax
c0100ff4:	73 28                	jae    c010101e <strncpy+0x5e>
c0100ff6:	01 d9                	add    %ebx,%ecx
c0100ff8:	01 d8                	add    %ebx,%eax
c0100ffa:	89 ca                	mov    %ecx,%edx
c0100ffc:	29 c2                	sub    %eax,%edx
c0100ffe:	83 e2 01             	and    $0x1,%edx
c0101001:	74 0d                	je     c0101010 <strncpy+0x50>
c0101003:	c6 00 00             	movb   $0x0,(%eax)
c0101006:	83 c0 01             	add    $0x1,%eax
c0101009:	39 c8                	cmp    %ecx,%eax
c010100b:	74 11                	je     c010101e <strncpy+0x5e>
c010100d:	8d 76 00             	lea    0x0(%esi),%esi
c0101010:	c6 00 00             	movb   $0x0,(%eax)
c0101013:	83 c0 02             	add    $0x2,%eax
c0101016:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
c010101a:	39 c8                	cmp    %ecx,%eax
c010101c:	75 f2                	jne    c0101010 <strncpy+0x50>
c010101e:	89 d8                	mov    %ebx,%eax
c0101020:	5b                   	pop    %ebx
c0101021:	5e                   	pop    %esi
c0101022:	c3                   	ret
c0101023:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101028:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010102f:	00 

c0101030 <strcmp>:
c0101030:	8b 4c 24 04          	mov    0x4(%esp),%ecx
c0101034:	8b 54 24 08          	mov    0x8(%esp),%edx
c0101038:	0f b6 01             	movzbl (%ecx),%eax
c010103b:	84 c0                	test   %al,%al
c010103d:	75 2f                	jne    c010106e <strcmp+0x3e>
c010103f:	eb 3f                	jmp    c0101080 <strcmp+0x50>
c0101041:	eb 1d                	jmp    c0101060 <strcmp+0x30>
c0101043:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101048:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010104f:	00 
c0101050:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101057:	00 
c0101058:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010105f:	00 
c0101060:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
c0101064:	83 c1 01             	add    $0x1,%ecx
c0101067:	83 c2 01             	add    $0x1,%edx
c010106a:	84 c0                	test   %al,%al
c010106c:	74 12                	je     c0101080 <strcmp+0x50>
c010106e:	38 02                	cmp    %al,(%edx)
c0101070:	74 ee                	je     c0101060 <strcmp+0x30>
c0101072:	0f b6 12             	movzbl (%edx),%edx
c0101075:	29 d0                	sub    %edx,%eax
c0101077:	c3                   	ret
c0101078:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010107f:	00 
c0101080:	0f b6 12             	movzbl (%edx),%edx
c0101083:	31 c0                	xor    %eax,%eax
c0101085:	29 d0                	sub    %edx,%eax
c0101087:	c3                   	ret
c0101088:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010108f:	00 

c0101090 <strncmp>:
c0101090:	53                   	push   %ebx
c0101091:	8b 54 24 10          	mov    0x10(%esp),%edx
c0101095:	8b 44 24 08          	mov    0x8(%esp),%eax
c0101099:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
c010109d:	85 d2                	test   %edx,%edx
c010109f:	75 16                	jne    c01010b7 <strncmp+0x27>
c01010a1:	eb 2d                	jmp    c01010d0 <strncmp+0x40>
c01010a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c01010a8:	3a 19                	cmp    (%ecx),%bl
c01010aa:	75 12                	jne    c01010be <strncmp+0x2e>
c01010ac:	83 c0 01             	add    $0x1,%eax
c01010af:	83 c1 01             	add    $0x1,%ecx
c01010b2:	83 ea 01             	sub    $0x1,%edx
c01010b5:	74 19                	je     c01010d0 <strncmp+0x40>
c01010b7:	0f b6 18             	movzbl (%eax),%ebx
c01010ba:	84 db                	test   %bl,%bl
c01010bc:	75 ea                	jne    c01010a8 <strncmp+0x18>
c01010be:	0f b6 00             	movzbl (%eax),%eax
c01010c1:	0f b6 11             	movzbl (%ecx),%edx
c01010c4:	5b                   	pop    %ebx
c01010c5:	29 d0                	sub    %edx,%eax
c01010c7:	c3                   	ret
c01010c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01010cf:	00 
c01010d0:	31 c0                	xor    %eax,%eax
c01010d2:	5b                   	pop    %ebx
c01010d3:	c3                   	ret
c01010d4:	66 90                	xchg   %ax,%ax
c01010d6:	66 90                	xchg   %ax,%ax
c01010d8:	66 90                	xchg   %ax,%ax
c01010da:	66 90                	xchg   %ax,%ax
c01010dc:	66 90                	xchg   %ax,%ax
c01010de:	66 90                	xchg   %ax,%ax

c01010e0 <memcpy>:
c01010e0:	83 ec 08             	sub    $0x8,%esp
c01010e3:	8b 44 24 14          	mov    0x14(%esp),%eax
c01010e7:	8b 54 24 0c          	mov    0xc(%esp),%edx
c01010eb:	89 34 24             	mov    %esi,(%esp)
c01010ee:	8b 74 24 10          	mov    0x10(%esp),%esi
c01010f2:	85 c0                	test   %eax,%eax
c01010f4:	74 13                	je     c0101109 <memcpy+0x29>
c01010f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
c01010fa:	01 d0                	add    %edx,%eax
c01010fc:	89 d7                	mov    %edx,%edi
c01010fe:	66 90                	xchg   %ax,%ax
c0101100:	a4                   	movsb  %ds:(%esi),%es:(%edi)
c0101101:	39 f8                	cmp    %edi,%eax
c0101103:	75 fb                	jne    c0101100 <memcpy+0x20>
c0101105:	8b 7c 24 04          	mov    0x4(%esp),%edi
c0101109:	8b 34 24             	mov    (%esp),%esi
c010110c:	89 d0                	mov    %edx,%eax
c010110e:	83 c4 08             	add    $0x8,%esp
c0101111:	c3                   	ret
c0101112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0101118:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010111f:	00 

c0101120 <memset>:
c0101120:	56                   	push   %esi
c0101121:	53                   	push   %ebx
c0101122:	8b 74 24 14          	mov    0x14(%esp),%esi
c0101126:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
c010112a:	8b 54 24 10          	mov    0x10(%esp),%edx
c010112e:	85 f6                	test   %esi,%esi
c0101130:	74 2a                	je     c010115c <memset+0x3c>
c0101132:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
c0101135:	83 e6 01             	and    $0x1,%esi
c0101138:	89 d8                	mov    %ebx,%eax
c010113a:	74 14                	je     c0101150 <memset+0x30>
c010113c:	8d 43 01             	lea    0x1(%ebx),%eax
c010113f:	88 50 ff             	mov    %dl,-0x1(%eax)
c0101142:	39 c1                	cmp    %eax,%ecx
c0101144:	74 16                	je     c010115c <memset+0x3c>
c0101146:	66 90                	xchg   %ax,%ax
c0101148:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010114f:	00 
c0101150:	88 10                	mov    %dl,(%eax)
c0101152:	83 c0 02             	add    $0x2,%eax
c0101155:	88 50 ff             	mov    %dl,-0x1(%eax)
c0101158:	39 c1                	cmp    %eax,%ecx
c010115a:	75 f4                	jne    c0101150 <memset+0x30>
c010115c:	89 d8                	mov    %ebx,%eax
c010115e:	5b                   	pop    %ebx
c010115f:	5e                   	pop    %esi
c0101160:	c3                   	ret
c0101161:	66 90                	xchg   %ax,%ax
c0101163:	66 90                	xchg   %ax,%ax
c0101165:	66 90                	xchg   %ax,%ax
c0101167:	66 90                	xchg   %ax,%ax
c0101169:	66 90                	xchg   %ax,%ax
c010116b:	66 90                	xchg   %ax,%ax
c010116d:	66 90                	xchg   %ax,%ax
c010116f:	66 90                	xchg   %ax,%ax
c0101171:	66 90                	xchg   %ax,%ax
c0101173:	66 90                	xchg   %ax,%ax
c0101175:	66 90                	xchg   %ax,%ax
c0101177:	66 90                	xchg   %ax,%ax
c0101179:	66 90                	xchg   %ax,%ax
c010117b:	66 90                	xchg   %ax,%ax
c010117d:	66 90                	xchg   %ax,%ax
c010117f:	90                   	nop

c0101180 <vsprintf>:
c0101180:	83 ec 40             	sub    $0x40,%esp
c0101183:	89 74 24 34          	mov    %esi,0x34(%esp)
c0101187:	8b 74 24 48          	mov    0x48(%esp),%esi
c010118b:	89 6c 24 3c          	mov    %ebp,0x3c(%esp)
c010118f:	8b 44 24 4c          	mov    0x4c(%esp),%eax
c0101193:	89 5c 24 30          	mov    %ebx,0x30(%esp)
c0101197:	0f b6 1e             	movzbl (%esi),%ebx
c010119a:	8b 6c 24 44          	mov    0x44(%esp),%ebp
c010119e:	84 db                	test   %bl,%bl
c01011a0:	0f 84 1a 04 00 00    	je     c01015c0 <vsprintf+0x440>
c01011a6:	89 7c 24 38          	mov    %edi,0x38(%esp)
c01011aa:	31 c9                	xor    %ecx,%ecx
c01011ac:	eb 2c                	jmp    c01011da <vsprintf+0x5a>
c01011ae:	66 90                	xchg   %ax,%ax
c01011b0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01011b7:	00 
c01011b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01011bf:	00 
c01011c0:	89 f7                	mov    %esi,%edi
c01011c2:	8b 74 24 44          	mov    0x44(%esp),%esi
c01011c6:	83 c1 01             	add    $0x1,%ecx
c01011c9:	88 5d 00             	mov    %bl,0x0(%ebp)
c01011cc:	8d 2c 0e             	lea    (%esi,%ecx,1),%ebp
c01011cf:	0f b6 5f 01          	movzbl 0x1(%edi),%ebx
c01011d3:	8d 77 01             	lea    0x1(%edi),%esi
c01011d6:	84 db                	test   %bl,%bl
c01011d8:	74 2e                	je     c0101208 <vsprintf+0x88>
c01011da:	8d 7e 01             	lea    0x1(%esi),%edi
c01011dd:	80 fb 25             	cmp    $0x25,%bl
c01011e0:	75 de                	jne    c01011c0 <vsprintf+0x40>
c01011e2:	0f b6 56 01          	movzbl 0x1(%esi),%edx
c01011e6:	80 fa 25             	cmp    $0x25,%dl
c01011e9:	0f 84 c1 02 00 00    	je     c01014b0 <vsprintf+0x330>
c01011ef:	83 ea 63             	sub    $0x63,%edx
c01011f2:	80 fa 15             	cmp    $0x15,%dl
c01011f5:	77 d8                	ja     c01011cf <vsprintf+0x4f>
c01011f7:	0f b6 d2             	movzbl %dl,%edx
c01011fa:	ff 24 95 00 60 10 c0 	jmp    *-0x3fefa000(,%edx,4)
c0101201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0101208:	8b 7c 24 38          	mov    0x38(%esp),%edi
c010120c:	89 ca                	mov    %ecx,%edx
c010120e:	c6 45 00 00          	movb   $0x0,0x0(%ebp)
c0101212:	89 d0                	mov    %edx,%eax
c0101214:	8b 5c 24 30          	mov    0x30(%esp),%ebx
c0101218:	8b 74 24 34          	mov    0x34(%esp),%esi
c010121c:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
c0101220:	83 c4 40             	add    $0x40,%esp
c0101223:	c3                   	ret
c0101224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0101228:	8b 10                	mov    (%eax),%edx
c010122a:	8d 5c 24 10          	lea    0x10(%esp),%ebx
c010122e:	8d 70 04             	lea    0x4(%eax),%esi
c0101231:	89 1c 24             	mov    %ebx,(%esp)
c0101234:	85 d2                	test   %edx,%edx
c0101236:	0f 84 4c 03 00 00    	je     c0101588 <vsprintf+0x408>
c010123c:	89 7c 24 04          	mov    %edi,0x4(%esp)
c0101240:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0101244:	eb 1a                	jmp    c0101260 <vsprintf+0xe0>
c0101246:	66 90                	xchg   %ax,%ax
c0101248:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010124f:	00 
c0101250:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101257:	00 
c0101258:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010125f:	00 
c0101260:	89 d7                	mov    %edx,%edi
c0101262:	89 d8                	mov    %ebx,%eax
c0101264:	8d 5b 01             	lea    0x1(%ebx),%ebx
c0101267:	83 e7 0f             	and    $0xf,%edi
c010126a:	c1 ea 04             	shr    $0x4,%edx
c010126d:	0f b6 8f 50 76 10 c0 	movzbl -0x3fef89b0(%edi),%ecx
c0101274:	88 4b ff             	mov    %cl,-0x1(%ebx)
c0101277:	75 e7                	jne    c0101260 <vsprintf+0xe0>
c0101279:	8b 14 24             	mov    (%esp),%edx
c010127c:	8b 7c 24 04          	mov    0x4(%esp),%edi
c0101280:	c6 40 01 00          	movb   $0x0,0x1(%eax)
c0101284:	8b 4c 24 08          	mov    0x8(%esp),%ecx
c0101288:	39 c2                	cmp    %eax,%edx
c010128a:	0f 83 3e 03 00 00    	jae    c01015ce <vsprintf+0x44e>
c0101290:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0101294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0101298:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010129f:	00 
c01012a0:	0f b6 18             	movzbl (%eax),%ebx
c01012a3:	0f b6 0a             	movzbl (%edx),%ecx
c01012a6:	83 e8 01             	sub    $0x1,%eax
c01012a9:	83 c2 01             	add    $0x1,%edx
c01012ac:	88 48 01             	mov    %cl,0x1(%eax)
c01012af:	88 5a ff             	mov    %bl,-0x1(%edx)
c01012b2:	39 c2                	cmp    %eax,%edx
c01012b4:	72 ea                	jb     c01012a0 <vsprintf+0x120>
c01012b6:	8b 4c 24 04          	mov    0x4(%esp),%ecx
c01012ba:	0f b6 44 24 10       	movzbl 0x10(%esp),%eax
c01012bf:	84 c0                	test   %al,%al
c01012c1:	74 23                	je     c01012e6 <vsprintf+0x166>
c01012c3:	8b 14 24             	mov    (%esp),%edx
c01012c6:	8b 5c 24 44          	mov    0x44(%esp),%ebx
c01012ca:	29 ca                	sub    %ecx,%edx
c01012cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c01012d0:	83 c1 01             	add    $0x1,%ecx
c01012d3:	88 44 0b ff          	mov    %al,-0x1(%ebx,%ecx,1)
c01012d7:	0f b6 04 0a          	movzbl (%edx,%ecx,1),%eax
c01012db:	84 c0                	test   %al,%al
c01012dd:	75 f1                	jne    c01012d0 <vsprintf+0x150>
c01012df:	8b 44 24 44          	mov    0x44(%esp),%eax
c01012e3:	8d 2c 08             	lea    (%eax,%ecx,1),%ebp
c01012e6:	89 f0                	mov    %esi,%eax
c01012e8:	e9 e2 fe ff ff       	jmp    c01011cf <vsprintf+0x4f>
c01012ed:	8d 76 00             	lea    0x0(%esi),%esi
c01012f0:	8d 70 04             	lea    0x4(%eax),%esi
c01012f3:	89 74 24 04          	mov    %esi,0x4(%esp)
c01012f7:	8b 30                	mov    (%eax),%esi
c01012f9:	8d 44 24 10          	lea    0x10(%esp),%eax
c01012fd:	89 04 24             	mov    %eax,(%esp)
c0101300:	85 f6                	test   %esi,%esi
c0101302:	0f 84 98 02 00 00    	je     c01015a0 <vsprintf+0x420>
c0101308:	89 7c 24 08          	mov    %edi,0x8(%esp)
c010130c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0101310:	89 c1                	mov    %eax,%ecx
c0101312:	eb 2c                	jmp    c0101340 <vsprintf+0x1c0>
c0101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0101318:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010131f:	00 
c0101320:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101327:	00 
c0101328:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010132f:	00 
c0101330:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101337:	00 
c0101338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010133f:	00 
c0101340:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
c0101345:	89 f7                	mov    %esi,%edi
c0101347:	89 cb                	mov    %ecx,%ebx
c0101349:	f7 e6                	mul    %esi
c010134b:	8d 49 01             	lea    0x1(%ecx),%ecx
c010134e:	c1 ea 03             	shr    $0x3,%edx
c0101351:	8d 04 92             	lea    (%edx,%edx,4),%eax
c0101354:	01 c0                	add    %eax,%eax
c0101356:	29 c7                	sub    %eax,%edi
c0101358:	83 fe 09             	cmp    $0x9,%esi
c010135b:	89 d6                	mov    %edx,%esi
c010135d:	0f b6 87 50 76 10 c0 	movzbl -0x3fef89b0(%edi),%eax
c0101364:	88 41 ff             	mov    %al,-0x1(%ecx)
c0101367:	77 d7                	ja     c0101340 <vsprintf+0x1c0>
c0101369:	8b 04 24             	mov    (%esp),%eax
c010136c:	8b 7c 24 08          	mov    0x8(%esp),%edi
c0101370:	c6 43 01 00          	movb   $0x0,0x1(%ebx)
c0101374:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
c0101378:	39 d8                	cmp    %ebx,%eax
c010137a:	0f 83 62 02 00 00    	jae    c01015e2 <vsprintf+0x462>
c0101380:	89 ce                	mov    %ecx,%esi
c0101382:	eb 1c                	jmp    c01013a0 <vsprintf+0x220>
c0101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0101388:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010138f:	00 
c0101390:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101397:	00 
c0101398:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010139f:	00 
c01013a0:	0f b6 13             	movzbl (%ebx),%edx
c01013a3:	0f b6 08             	movzbl (%eax),%ecx
c01013a6:	83 eb 01             	sub    $0x1,%ebx
c01013a9:	83 c0 01             	add    $0x1,%eax
c01013ac:	88 4b 01             	mov    %cl,0x1(%ebx)
c01013af:	88 50 ff             	mov    %dl,-0x1(%eax)
c01013b2:	39 d8                	cmp    %ebx,%eax
c01013b4:	72 ea                	jb     c01013a0 <vsprintf+0x220>
c01013b6:	0f b6 44 24 10       	movzbl 0x10(%esp),%eax
c01013bb:	89 f1                	mov    %esi,%ecx
c01013bd:	84 c0                	test   %al,%al
c01013bf:	74 25                	je     c01013e6 <vsprintf+0x266>
c01013c1:	8b 14 24             	mov    (%esp),%edx
c01013c4:	8b 5c 24 44          	mov    0x44(%esp),%ebx
c01013c8:	29 ca                	sub    %ecx,%edx
c01013ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c01013d0:	83 c1 01             	add    $0x1,%ecx
c01013d3:	88 44 0b ff          	mov    %al,-0x1(%ebx,%ecx,1)
c01013d7:	0f b6 04 0a          	movzbl (%edx,%ecx,1),%eax
c01013db:	84 c0                	test   %al,%al
c01013dd:	75 f1                	jne    c01013d0 <vsprintf+0x250>
c01013df:	8b 44 24 44          	mov    0x44(%esp),%eax
c01013e3:	8d 2c 08             	lea    (%eax,%ecx,1),%ebp
c01013e6:	8b 44 24 04          	mov    0x4(%esp),%eax
c01013ea:	e9 e0 fd ff ff       	jmp    c01011cf <vsprintf+0x4f>
c01013ef:	90                   	nop
c01013f0:	8b 18                	mov    (%eax),%ebx
c01013f2:	8d 50 04             	lea    0x4(%eax),%edx
c01013f5:	85 db                	test   %ebx,%ebx
c01013f7:	0f 84 b3 01 00 00    	je     c01015b0 <vsprintf+0x430>
c01013fd:	0f b6 03             	movzbl (%ebx),%eax
c0101400:	84 c0                	test   %al,%al
c0101402:	0f 84 bf 01 00 00    	je     c01015c7 <vsprintf+0x447>
c0101408:	8b 74 24 44          	mov    0x44(%esp),%esi
c010140c:	29 cb                	sub    %ecx,%ebx
c010140e:	66 90                	xchg   %ax,%ax
c0101410:	83 c1 01             	add    $0x1,%ecx
c0101413:	88 44 0e ff          	mov    %al,-0x1(%esi,%ecx,1)
c0101417:	0f b6 04 0b          	movzbl (%ebx,%ecx,1),%eax
c010141b:	84 c0                	test   %al,%al
c010141d:	75 f1                	jne    c0101410 <vsprintf+0x290>
c010141f:	8b 74 24 44          	mov    0x44(%esp),%esi
c0101423:	89 d0                	mov    %edx,%eax
c0101425:	8d 2c 0e             	lea    (%esi,%ecx,1),%ebp
c0101428:	e9 a2 fd ff ff       	jmp    c01011cf <vsprintf+0x4f>
c010142d:	8d 76 00             	lea    0x0(%esi),%esi
c0101430:	8b 18                	mov    (%eax),%ebx
c0101432:	8d 50 04             	lea    0x4(%eax),%edx
c0101435:	85 db                	test   %ebx,%ebx
c0101437:	0f 88 33 01 00 00    	js     c0101570 <vsprintf+0x3f0>
c010143d:	0f 85 85 00 00 00    	jne    c01014c8 <vsprintf+0x348>
c0101443:	8d 74 24 10          	lea    0x10(%esp),%esi
c0101447:	c6 44 24 11 00       	movb   $0x0,0x11(%esp)
c010144c:	b8 30 00 00 00       	mov    $0x30,%eax
c0101451:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0101455:	89 34 24             	mov    %esi,(%esp)
c0101458:	8b 4c 24 04          	mov    0x4(%esp),%ecx
c010145c:	8b 1c 24             	mov    (%esp),%ebx
c010145f:	8b 74 24 44          	mov    0x44(%esp),%esi
c0101463:	29 cb                	sub    %ecx,%ebx
c0101465:	8d 76 00             	lea    0x0(%esi),%esi
c0101468:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010146f:	00 
c0101470:	83 c1 01             	add    $0x1,%ecx
c0101473:	88 44 0e ff          	mov    %al,-0x1(%esi,%ecx,1)
c0101477:	0f b6 04 0b          	movzbl (%ebx,%ecx,1),%eax
c010147b:	84 c0                	test   %al,%al
c010147d:	75 f1                	jne    c0101470 <vsprintf+0x2f0>
c010147f:	8b 74 24 44          	mov    0x44(%esp),%esi
c0101483:	89 d0                	mov    %edx,%eax
c0101485:	8d 2c 0e             	lea    (%esi,%ecx,1),%ebp
c0101488:	e9 42 fd ff ff       	jmp    c01011cf <vsprintf+0x4f>
c010148d:	8d 76 00             	lea    0x0(%esi),%esi
c0101490:	8b 10                	mov    (%eax),%edx
c0101492:	8b 74 24 44          	mov    0x44(%esp),%esi
c0101496:	83 c1 01             	add    $0x1,%ecx
c0101499:	83 c0 04             	add    $0x4,%eax
c010149c:	88 55 00             	mov    %dl,0x0(%ebp)
c010149f:	8d 2c 0e             	lea    (%esi,%ecx,1),%ebp
c01014a2:	e9 28 fd ff ff       	jmp    c01011cf <vsprintf+0x4f>
c01014a7:	90                   	nop
c01014a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01014af:	00 
c01014b0:	8b 74 24 44          	mov    0x44(%esp),%esi
c01014b4:	83 c1 01             	add    $0x1,%ecx
c01014b7:	c6 45 00 25          	movb   $0x25,0x0(%ebp)
c01014bb:	8d 2c 0e             	lea    (%esi,%ecx,1),%ebp
c01014be:	e9 0c fd ff ff       	jmp    c01011cf <vsprintf+0x4f>
c01014c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c01014c8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01014cc:	8d 74 24 10          	lea    0x10(%esp),%esi
c01014d0:	89 7c 24 08          	mov    %edi,0x8(%esp)
c01014d4:	89 d7                	mov    %edx,%edi
c01014d6:	89 34 24             	mov    %esi,(%esp)
c01014d9:	eb 25                	jmp    c0101500 <vsprintf+0x380>
c01014db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c01014e0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01014e7:	00 
c01014e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01014ef:	00 
c01014f0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01014f7:	00 
c01014f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01014ff:	00 
c0101500:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
c0101505:	89 dd                	mov    %ebx,%ebp
c0101507:	89 f1                	mov    %esi,%ecx
c0101509:	f7 e3                	mul    %ebx
c010150b:	8d 76 01             	lea    0x1(%esi),%esi
c010150e:	c1 ea 03             	shr    $0x3,%edx
c0101511:	8d 04 92             	lea    (%edx,%edx,4),%eax
c0101514:	01 c0                	add    %eax,%eax
c0101516:	29 c5                	sub    %eax,%ebp
c0101518:	83 fb 09             	cmp    $0x9,%ebx
c010151b:	89 d3                	mov    %edx,%ebx
c010151d:	0f b6 85 50 76 10 c0 	movzbl -0x3fef89b0(%ebp),%eax
c0101524:	88 46 ff             	mov    %al,-0x1(%esi)
c0101527:	77 d7                	ja     c0101500 <vsprintf+0x380>
c0101529:	8b 04 24             	mov    (%esp),%eax
c010152c:	89 fa                	mov    %edi,%edx
c010152e:	8b 7c 24 08          	mov    0x8(%esp),%edi
c0101532:	c6 41 01 00          	movb   $0x0,0x1(%ecx)
c0101536:	39 c8                	cmp    %ecx,%eax
c0101538:	0f 83 9a 00 00 00    	jae    c01015d8 <vsprintf+0x458>
c010153e:	89 d6                	mov    %edx,%esi
c0101540:	0f b6 19             	movzbl (%ecx),%ebx
c0101543:	0f b6 10             	movzbl (%eax),%edx
c0101546:	83 e9 01             	sub    $0x1,%ecx
c0101549:	83 c0 01             	add    $0x1,%eax
c010154c:	88 51 01             	mov    %dl,0x1(%ecx)
c010154f:	88 58 ff             	mov    %bl,-0x1(%eax)
c0101552:	39 c8                	cmp    %ecx,%eax
c0101554:	72 ea                	jb     c0101540 <vsprintf+0x3c0>
c0101556:	0f b6 44 24 10       	movzbl 0x10(%esp),%eax
c010155b:	89 f2                	mov    %esi,%edx
c010155d:	84 c0                	test   %al,%al
c010155f:	0f 85 f3 fe ff ff    	jne    c0101458 <vsprintf+0x2d8>
c0101565:	8b 4c 24 04          	mov    0x4(%esp),%ecx
c0101569:	e9 b1 fe ff ff       	jmp    c010141f <vsprintf+0x29f>
c010156e:	66 90                	xchg   %ax,%ax
c0101570:	8d 41 01             	lea    0x1(%ecx),%eax
c0101573:	c6 45 00 2d          	movb   $0x2d,0x0(%ebp)
c0101577:	f7 db                	neg    %ebx
c0101579:	89 44 24 04          	mov    %eax,0x4(%esp)
c010157d:	e9 4a ff ff ff       	jmp    c01014cc <vsprintf+0x34c>
c0101582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0101588:	c6 44 24 11 00       	movb   $0x0,0x11(%esp)
c010158d:	b8 30 00 00 00       	mov    $0x30,%eax
c0101592:	e9 2c fd ff ff       	jmp    c01012c3 <vsprintf+0x143>
c0101597:	90                   	nop
c0101598:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010159f:	00 
c01015a0:	c6 44 24 11 00       	movb   $0x0,0x11(%esp)
c01015a5:	b8 30 00 00 00       	mov    $0x30,%eax
c01015aa:	e9 12 fe ff ff       	jmp    c01013c1 <vsprintf+0x241>
c01015af:	90                   	nop
c01015b0:	bb 49 76 10 c0       	mov    $0xc0107649,%ebx
c01015b5:	b8 28 00 00 00       	mov    $0x28,%eax
c01015ba:	e9 49 fe ff ff       	jmp    c0101408 <vsprintf+0x288>
c01015bf:	90                   	nop
c01015c0:	31 d2                	xor    %edx,%edx
c01015c2:	e9 47 fc ff ff       	jmp    c010120e <vsprintf+0x8e>
c01015c7:	89 d0                	mov    %edx,%eax
c01015c9:	e9 01 fc ff ff       	jmp    c01011cf <vsprintf+0x4f>
c01015ce:	0f b6 44 24 10       	movzbl 0x10(%esp),%eax
c01015d3:	e9 e7 fc ff ff       	jmp    c01012bf <vsprintf+0x13f>
c01015d8:	0f b6 44 24 10       	movzbl 0x10(%esp),%eax
c01015dd:	e9 7b ff ff ff       	jmp    c010155d <vsprintf+0x3dd>
c01015e2:	0f b6 44 24 10       	movzbl 0x10(%esp),%eax
c01015e7:	e9 d1 fd ff ff       	jmp    c01013bd <vsprintf+0x23d>
c01015ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

c01015f0 <sprintf>:
c01015f0:	8d 44 24 0c          	lea    0xc(%esp),%eax
c01015f4:	50                   	push   %eax
c01015f5:	ff 74 24 0c          	push   0xc(%esp)
c01015f9:	ff 74 24 0c          	push   0xc(%esp)
c01015fd:	e8 7e fb ff ff       	call   c0101180 <vsprintf>
c0101602:	83 c4 0c             	add    $0xc,%esp
c0101605:	c3                   	ret
c0101606:	66 90                	xchg   %ax,%ax
c0101608:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010160f:	00 

c0101610 <printf>:
c0101610:	53                   	push   %ebx
c0101611:	81 ec 18 04 00 00    	sub    $0x418,%esp
c0101617:	8d 84 24 24 04 00 00 	lea    0x424(%esp),%eax
c010161e:	50                   	push   %eax
c010161f:	ff b4 24 24 04 00 00 	push   0x424(%esp)
c0101626:	8d 5c 24 18          	lea    0x18(%esp),%ebx
c010162a:	53                   	push   %ebx
c010162b:	e8 50 fb ff ff       	call   c0101180 <vsprintf>
c0101630:	89 44 24 18          	mov    %eax,0x18(%esp)
c0101634:	53                   	push   %ebx
c0101635:	e8 06 f6 ff ff       	call   c0100c40 <console_puts>
c010163a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
c010163e:	81 c4 28 04 00 00    	add    $0x428,%esp
c0101644:	5b                   	pop    %ebx
c0101645:	c3                   	ret
c0101646:	66 90                	xchg   %ax,%ax
c0101648:	66 90                	xchg   %ax,%ax
c010164a:	66 90                	xchg   %ax,%ax
c010164c:	66 90                	xchg   %ax,%ax
c010164e:	66 90                	xchg   %ax,%ax

c0101650 <list_init>:
c0101650:	8b 44 24 04          	mov    0x4(%esp),%eax
c0101654:	85 c0                	test   %eax,%eax
c0101656:	74 14                	je     c010166c <list_init+0x1c>
c0101658:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
c010165e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
c0101665:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010166c:	c3                   	ret
c010166d:	8d 76 00             	lea    0x0(%esi),%esi

c0101670 <list_push_back>:
c0101670:	53                   	push   %ebx
c0101671:	83 ec 08             	sub    $0x8,%esp
c0101674:	8b 5c 24 10          	mov    0x10(%esp),%ebx
c0101678:	85 db                	test   %ebx,%ebx
c010167a:	74 34                	je     c01016b0 <list_push_back+0x40>
c010167c:	83 ec 08             	sub    $0x8,%esp
c010167f:	6a 00                	push   $0x0
c0101681:	6a 0c                	push   $0xc
c0101683:	e8 98 10 00 00       	call   c0102720 <kmalloc>
c0101688:	83 c4 10             	add    $0x10,%esp
c010168b:	85 c0                	test   %eax,%eax
c010168d:	74 21                	je     c01016b0 <list_push_back+0x40>
c010168f:	8b 54 24 14          	mov    0x14(%esp),%edx
c0101693:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
c010169a:	89 50 08             	mov    %edx,0x8(%eax)
c010169d:	8b 53 04             	mov    0x4(%ebx),%edx
c01016a0:	89 10                	mov    %edx,(%eax)
c01016a2:	85 d2                	test   %edx,%edx
c01016a4:	74 12                	je     c01016b8 <list_push_back+0x48>
c01016a6:	89 42 04             	mov    %eax,0x4(%edx)
c01016a9:	83 43 08 01          	addl   $0x1,0x8(%ebx)
c01016ad:	89 43 04             	mov    %eax,0x4(%ebx)
c01016b0:	83 c4 08             	add    $0x8,%esp
c01016b3:	5b                   	pop    %ebx
c01016b4:	c3                   	ret
c01016b5:	8d 76 00             	lea    0x0(%esi),%esi
c01016b8:	89 03                	mov    %eax,(%ebx)
c01016ba:	eb ed                	jmp    c01016a9 <list_push_back+0x39>
c01016bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

c01016c0 <list_pop_front>:
c01016c0:	53                   	push   %ebx
c01016c1:	83 ec 08             	sub    $0x8,%esp
c01016c4:	8b 44 24 10          	mov    0x10(%esp),%eax
c01016c8:	85 c0                	test   %eax,%eax
c01016ca:	74 44                	je     c0101710 <list_pop_front+0x50>
c01016cc:	8b 10                	mov    (%eax),%edx
c01016ce:	85 d2                	test   %edx,%edx
c01016d0:	74 3e                	je     c0101710 <list_pop_front+0x50>
c01016d2:	8b 4a 04             	mov    0x4(%edx),%ecx
c01016d5:	8b 5a 08             	mov    0x8(%edx),%ebx
c01016d8:	89 08                	mov    %ecx,(%eax)
c01016da:	85 c9                	test   %ecx,%ecx
c01016dc:	74 22                	je     c0101700 <list_pop_front+0x40>
c01016de:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
c01016e4:	83 68 08 01          	subl   $0x1,0x8(%eax)
c01016e8:	83 ec 0c             	sub    $0xc,%esp
c01016eb:	52                   	push   %edx
c01016ec:	e8 4f 11 00 00       	call   c0102840 <kfree>
c01016f1:	83 c4 10             	add    $0x10,%esp
c01016f4:	89 d8                	mov    %ebx,%eax
c01016f6:	83 c4 08             	add    $0x8,%esp
c01016f9:	5b                   	pop    %ebx
c01016fa:	c3                   	ret
c01016fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101700:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
c0101707:	eb db                	jmp    c01016e4 <list_pop_front+0x24>
c0101709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0101710:	31 db                	xor    %ebx,%ebx
c0101712:	83 c4 08             	add    $0x8,%esp
c0101715:	89 d8                	mov    %ebx,%eax
c0101717:	5b                   	pop    %ebx
c0101718:	c3                   	ret
c0101719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

c0101720 <list_remove>:
c0101720:	53                   	push   %ebx
c0101721:	8b 54 24 08          	mov    0x8(%esp),%edx
c0101725:	8b 44 24 0c          	mov    0xc(%esp),%eax
c0101729:	85 d2                	test   %edx,%edx
c010172b:	74 2b                	je     c0101758 <list_remove+0x38>
c010172d:	85 c0                	test   %eax,%eax
c010172f:	74 27                	je     c0101758 <list_remove+0x38>
c0101731:	8b 08                	mov    (%eax),%ecx
c0101733:	8b 58 04             	mov    0x4(%eax),%ebx
c0101736:	85 c9                	test   %ecx,%ecx
c0101738:	74 26                	je     c0101760 <list_remove+0x40>
c010173a:	89 59 04             	mov    %ebx,0x4(%ecx)
c010173d:	85 db                	test   %ebx,%ebx
c010173f:	74 25                	je     c0101766 <list_remove+0x46>
c0101741:	89 0b                	mov    %ecx,(%ebx)
c0101743:	83 6a 08 01          	subl   $0x1,0x8(%edx)
c0101747:	89 44 24 08          	mov    %eax,0x8(%esp)
c010174b:	5b                   	pop    %ebx
c010174c:	e9 ef 10 00 00       	jmp    c0102840 <kfree>
c0101751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0101758:	5b                   	pop    %ebx
c0101759:	c3                   	ret
c010175a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0101760:	89 1a                	mov    %ebx,(%edx)
c0101762:	85 db                	test   %ebx,%ebx
c0101764:	75 db                	jne    c0101741 <list_remove+0x21>
c0101766:	83 6a 08 01          	subl   $0x1,0x8(%edx)
c010176a:	89 4a 04             	mov    %ecx,0x4(%edx)
c010176d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101771:	5b                   	pop    %ebx
c0101772:	e9 c9 10 00 00       	jmp    c0102840 <kfree>
c0101777:	90                   	nop
c0101778:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010177f:	00 

c0101780 <list_find>:
c0101780:	8b 44 24 04          	mov    0x4(%esp),%eax
c0101784:	8b 54 24 08          	mov    0x8(%esp),%edx
c0101788:	85 c0                	test   %eax,%eax
c010178a:	74 25                	je     c01017b1 <list_find+0x31>
c010178c:	8b 00                	mov    (%eax),%eax
c010178e:	85 c0                	test   %eax,%eax
c0101790:	75 15                	jne    c01017a7 <list_find+0x27>
c0101792:	c3                   	ret
c0101793:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101798:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010179f:	00 
c01017a0:	8b 40 04             	mov    0x4(%eax),%eax
c01017a3:	85 c0                	test   %eax,%eax
c01017a5:	74 09                	je     c01017b0 <list_find+0x30>
c01017a7:	39 50 08             	cmp    %edx,0x8(%eax)
c01017aa:	75 f4                	jne    c01017a0 <list_find+0x20>
c01017ac:	c3                   	ret
c01017ad:	8d 76 00             	lea    0x0(%esi),%esi
c01017b0:	c3                   	ret
c01017b1:	31 c0                	xor    %eax,%eax
c01017b3:	c3                   	ret
c01017b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c01017b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01017bf:	00 

c01017c0 <list_insert_sorted>:
c01017c0:	83 ec 1c             	sub    $0x1c,%esp
c01017c3:	8b 44 24 20          	mov    0x20(%esp),%eax
c01017c7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01017cb:	89 74 24 10          	mov    %esi,0x10(%esp)
c01017cf:	8b 5c 24 24          	mov    0x24(%esp),%ebx
c01017d3:	8b 74 24 28          	mov    0x28(%esp),%esi
c01017d7:	85 c0                	test   %eax,%eax
c01017d9:	74 6d                	je     c0101848 <list_insert_sorted+0x88>
c01017db:	89 6c 24 18          	mov    %ebp,0x18(%esp)
c01017df:	83 ec 08             	sub    $0x8,%esp
c01017e2:	6a 00                	push   $0x0
c01017e4:	6a 0c                	push   $0xc
c01017e6:	e8 35 0f 00 00       	call   c0102720 <kmalloc>
c01017eb:	83 c4 10             	add    $0x10,%esp
c01017ee:	89 c5                	mov    %eax,%ebp
c01017f0:	85 c0                	test   %eax,%eax
c01017f2:	0f 84 88 00 00 00    	je     c0101880 <list_insert_sorted+0xc0>
c01017f8:	89 7c 24 14          	mov    %edi,0x14(%esp)
c01017fc:	89 58 08             	mov    %ebx,0x8(%eax)
c01017ff:	8b 44 24 20          	mov    0x20(%esp),%eax
c0101803:	8b 38                	mov    (%eax),%edi
c0101805:	85 ff                	test   %edi,%edi
c0101807:	75 0e                	jne    c0101817 <list_insert_sorted+0x57>
c0101809:	eb 4d                	jmp    c0101858 <list_insert_sorted+0x98>
c010180b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101810:	8b 7f 04             	mov    0x4(%edi),%edi
c0101813:	85 ff                	test   %edi,%edi
c0101815:	74 41                	je     c0101858 <list_insert_sorted+0x98>
c0101817:	83 ec 08             	sub    $0x8,%esp
c010181a:	ff 77 08             	push   0x8(%edi)
c010181d:	53                   	push   %ebx
c010181e:	ff d6                	call   *%esi
c0101820:	83 c4 10             	add    $0x10,%esp
c0101823:	84 c0                	test   %al,%al
c0101825:	74 e9                	je     c0101810 <list_insert_sorted+0x50>
c0101827:	8b 07                	mov    (%edi),%eax
c0101829:	89 7d 04             	mov    %edi,0x4(%ebp)
c010182c:	89 45 00             	mov    %eax,0x0(%ebp)
c010182f:	85 c0                	test   %eax,%eax
c0101831:	74 5d                	je     c0101890 <list_insert_sorted+0xd0>
c0101833:	89 68 04             	mov    %ebp,0x4(%eax)
c0101836:	89 2f                	mov    %ebp,(%edi)
c0101838:	8b 44 24 20          	mov    0x20(%esp),%eax
c010183c:	8b 7c 24 14          	mov    0x14(%esp),%edi
c0101840:	8b 6c 24 18          	mov    0x18(%esp),%ebp
c0101844:	83 40 08 01          	addl   $0x1,0x8(%eax)
c0101848:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
c010184c:	8b 74 24 10          	mov    0x10(%esp),%esi
c0101850:	83 c4 1c             	add    $0x1c,%esp
c0101853:	c3                   	ret
c0101854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0101858:	8b 44 24 20          	mov    0x20(%esp),%eax
c010185c:	c7 45 04 00 00 00 00 	movl   $0x0,0x4(%ebp)
c0101863:	8b 40 04             	mov    0x4(%eax),%eax
c0101866:	89 45 00             	mov    %eax,0x0(%ebp)
c0101869:	85 c0                	test   %eax,%eax
c010186b:	74 2b                	je     c0101898 <list_insert_sorted+0xd8>
c010186d:	89 68 04             	mov    %ebp,0x4(%eax)
c0101870:	8b 44 24 20          	mov    0x20(%esp),%eax
c0101874:	89 68 04             	mov    %ebp,0x4(%eax)
c0101877:	eb bf                	jmp    c0101838 <list_insert_sorted+0x78>
c0101879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0101880:	8b 6c 24 18          	mov    0x18(%esp),%ebp
c0101884:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
c0101888:	8b 74 24 10          	mov    0x10(%esp),%esi
c010188c:	83 c4 1c             	add    $0x1c,%esp
c010188f:	c3                   	ret
c0101890:	8b 44 24 20          	mov    0x20(%esp),%eax
c0101894:	89 28                	mov    %ebp,(%eax)
c0101896:	eb 9e                	jmp    c0101836 <list_insert_sorted+0x76>
c0101898:	8b 44 24 20          	mov    0x20(%esp),%eax
c010189c:	89 28                	mov    %ebp,(%eax)
c010189e:	eb d0                	jmp    c0101870 <list_insert_sorted+0xb0>

c01018a0 <register_interrupt_handler>:
c01018a0:	0f b6 44 24 04       	movzbl 0x4(%esp),%eax
c01018a5:	8b 54 24 08          	mov    0x8(%esp),%edx
c01018a9:	89 14 85 40 29 11 c0 	mov    %edx,-0x3feed6c0(,%eax,4)
c01018b0:	c3                   	ret
c01018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c01018b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01018bf:	00 

c01018c0 <interrupt_dispatch>:
c01018c0:	83 ec 1c             	sub    $0x1c,%esp
c01018c3:	8b 54 24 20          	mov    0x20(%esp),%edx
c01018c7:	8b 42 24             	mov    0x24(%edx),%eax
c01018ca:	8d 48 e0             	lea    -0x20(%eax),%ecx
c01018cd:	83 f9 0f             	cmp    $0xf,%ecx
c01018d0:	76 1e                	jbe    c01018f0 <interrupt_dispatch+0x30>
c01018d2:	8b 0c 85 40 29 11 c0 	mov    -0x3feed6c0(,%eax,4),%ecx
c01018d9:	85 c9                	test   %ecx,%ecx
c01018db:	74 3b                	je     c0101918 <interrupt_dispatch+0x58>
c01018dd:	89 54 24 20          	mov    %edx,0x20(%esp)
c01018e1:	83 c4 1c             	add    $0x1c,%esp
c01018e4:	ff e1                	jmp    *%ecx
c01018e6:	66 90                	xchg   %ax,%ax
c01018e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01018ef:	00 
c01018f0:	83 e8 20             	sub    $0x20,%eax
c01018f3:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01018f7:	83 ec 0c             	sub    $0xc,%esp
c01018fa:	0f b6 c0             	movzbl %al,%eax
c01018fd:	50                   	push   %eax
c01018fe:	e8 fd f0 ff ff       	call   c0100a00 <pic_send_eoi>
c0101903:	8b 54 24 1c          	mov    0x1c(%esp),%edx
c0101907:	83 c4 10             	add    $0x10,%esp
c010190a:	8b 42 24             	mov    0x24(%edx),%eax
c010190d:	8b 0c 85 40 29 11 c0 	mov    -0x3feed6c0(,%eax,4),%ecx
c0101914:	85 c9                	test   %ecx,%ecx
c0101916:	75 c5                	jne    c01018dd <interrupt_dispatch+0x1d>
c0101918:	83 f8 1f             	cmp    $0x1f,%eax
c010191b:	76 12                	jbe    c010192f <interrupt_dispatch+0x6f>
c010191d:	83 ec 08             	sub    $0x8,%esp
c0101920:	50                   	push   %eax
c0101921:	68 ec a2 10 c0       	push   $0xc010a2ec
c0101926:	e8 55 01 00 00       	call   c0101a80 <log_warn>
c010192b:	83 c4 2c             	add    $0x2c,%esp
c010192e:	c3                   	ret
c010192f:	83 ec 0c             	sub    $0xc,%esp
c0101932:	ff 72 34             	push   0x34(%edx)
c0101935:	ff 72 30             	push   0x30(%edx)
c0101938:	ff 72 2c             	push   0x2c(%edx)
c010193b:	50                   	push   %eax
c010193c:	68 a4 a2 10 c0       	push   $0xc010a2a4
c0101941:	e8 9a 01 00 00       	call   c0101ae0 <panic>
c0101946:	66 90                	xchg   %ax,%ax
c0101948:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010194f:	00 

c0101950 <irq_save>:
c0101950:	9c                   	pushf
c0101951:	58                   	pop    %eax
c0101952:	fa                   	cli
c0101953:	c3                   	ret
c0101954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0101958:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010195f:	00 

c0101960 <irq_restore>:
c0101960:	8b 44 24 04          	mov    0x4(%esp),%eax
c0101964:	50                   	push   %eax
c0101965:	9d                   	popf
c0101966:	c3                   	ret
c0101967:	66 90                	xchg   %ax,%ax
c0101969:	66 90                	xchg   %ax,%ax
c010196b:	66 90                	xchg   %ax,%ax
c010196d:	66 90                	xchg   %ax,%ax
c010196f:	90                   	nop

c0101970 <log_internal>:
c0101970:	57                   	push   %edi
c0101971:	89 d7                	mov    %edx,%edi
c0101973:	56                   	push   %esi
c0101974:	53                   	push   %ebx
c0101975:	89 c3                	mov    %eax,%ebx
c0101977:	81 ec 04 04 00 00    	sub    $0x404,%esp
c010197d:	ff b4 24 14 04 00 00 	push   0x414(%esp)
c0101984:	51                   	push   %ecx
c0101985:	8d 74 24 0c          	lea    0xc(%esp),%esi
c0101989:	56                   	push   %esi
c010198a:	e8 f1 f7 ff ff       	call   c0101180 <vsprintf>
c010198f:	c7 04 24 61 76 10 c0 	movl   $0xc0107661,(%esp)
c0101996:	e8 f5 f4 ff ff       	call   c0100e90 <serial_puts>
c010199b:	89 1c 24             	mov    %ebx,(%esp)
c010199e:	e8 ed f4 ff ff       	call   c0100e90 <serial_puts>
c01019a3:	c7 04 24 63 76 10 c0 	movl   $0xc0107663,(%esp)
c01019aa:	e8 e1 f4 ff ff       	call   c0100e90 <serial_puts>
c01019af:	89 34 24             	mov    %esi,(%esp)
c01019b2:	e8 d9 f4 ff ff       	call   c0100e90 <serial_puts>
c01019b7:	c7 04 24 91 76 10 c0 	movl   $0xc0107691,(%esp)
c01019be:	e8 cd f4 ff ff       	call   c0100e90 <serial_puts>
c01019c3:	58                   	pop    %eax
c01019c4:	89 f8                	mov    %edi,%eax
c01019c6:	5a                   	pop    %edx
c01019c7:	0f b6 c0             	movzbl %al,%eax
c01019ca:	6a 00                	push   $0x0
c01019cc:	50                   	push   %eax
c01019cd:	e8 5e f1 ff ff       	call   c0100b30 <console_set_color>
c01019d2:	c7 04 24 61 76 10 c0 	movl   $0xc0107661,(%esp)
c01019d9:	e8 62 f2 ff ff       	call   c0100c40 <console_puts>
c01019de:	89 1c 24             	mov    %ebx,(%esp)
c01019e1:	e8 5a f2 ff ff       	call   c0100c40 <console_puts>
c01019e6:	c7 04 24 63 76 10 c0 	movl   $0xc0107663,(%esp)
c01019ed:	e8 4e f2 ff ff       	call   c0100c40 <console_puts>
c01019f2:	59                   	pop    %ecx
c01019f3:	5b                   	pop    %ebx
c01019f4:	6a 00                	push   $0x0
c01019f6:	6a 07                	push   $0x7
c01019f8:	e8 33 f1 ff ff       	call   c0100b30 <console_set_color>
c01019fd:	89 34 24             	mov    %esi,(%esp)
c0101a00:	e8 3b f2 ff ff       	call   c0100c40 <console_puts>
c0101a05:	c7 04 24 91 76 10 c0 	movl   $0xc0107691,(%esp)
c0101a0c:	e8 2f f2 ff ff       	call   c0100c40 <console_puts>
c0101a11:	81 c4 10 04 00 00    	add    $0x410,%esp
c0101a17:	5b                   	pop    %ebx
c0101a18:	5e                   	pop    %esi
c0101a19:	5f                   	pop    %edi
c0101a1a:	c3                   	ret
c0101a1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

c0101a20 <log_debug>:
c0101a20:	83 ec 0c             	sub    $0xc,%esp
c0101a23:	ba 09 00 00 00       	mov    $0x9,%edx
c0101a28:	8d 44 24 14          	lea    0x14(%esp),%eax
c0101a2c:	83 ec 0c             	sub    $0xc,%esp
c0101a2f:	50                   	push   %eax
c0101a30:	8b 4c 24 20          	mov    0x20(%esp),%ecx
c0101a34:	b8 66 76 10 c0       	mov    $0xc0107666,%eax
c0101a39:	e8 32 ff ff ff       	call   c0101970 <log_internal>
c0101a3e:	83 c4 1c             	add    $0x1c,%esp
c0101a41:	c3                   	ret
c0101a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0101a48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101a4f:	00 

c0101a50 <log_info>:
c0101a50:	83 ec 0c             	sub    $0xc,%esp
c0101a53:	ba 0a 00 00 00       	mov    $0xa,%edx
c0101a58:	8d 44 24 14          	lea    0x14(%esp),%eax
c0101a5c:	83 ec 0c             	sub    $0xc,%esp
c0101a5f:	50                   	push   %eax
c0101a60:	8b 4c 24 20          	mov    0x20(%esp),%ecx
c0101a64:	b8 6c 76 10 c0       	mov    $0xc010766c,%eax
c0101a69:	e8 02 ff ff ff       	call   c0101970 <log_internal>
c0101a6e:	83 c4 1c             	add    $0x1c,%esp
c0101a71:	c3                   	ret
c0101a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0101a78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101a7f:	00 

c0101a80 <log_warn>:
c0101a80:	83 ec 0c             	sub    $0xc,%esp
c0101a83:	ba 0e 00 00 00       	mov    $0xe,%edx
c0101a88:	8d 44 24 14          	lea    0x14(%esp),%eax
c0101a8c:	83 ec 0c             	sub    $0xc,%esp
c0101a8f:	50                   	push   %eax
c0101a90:	8b 4c 24 20          	mov    0x20(%esp),%ecx
c0101a94:	b8 71 76 10 c0       	mov    $0xc0107671,%eax
c0101a99:	e8 d2 fe ff ff       	call   c0101970 <log_internal>
c0101a9e:	83 c4 1c             	add    $0x1c,%esp
c0101aa1:	c3                   	ret
c0101aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0101aa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101aaf:	00 

c0101ab0 <log_error>:
c0101ab0:	83 ec 0c             	sub    $0xc,%esp
c0101ab3:	ba 0c 00 00 00       	mov    $0xc,%edx
c0101ab8:	8d 44 24 14          	lea    0x14(%esp),%eax
c0101abc:	83 ec 0c             	sub    $0xc,%esp
c0101abf:	50                   	push   %eax
c0101ac0:	8b 4c 24 20          	mov    0x20(%esp),%ecx
c0101ac4:	b8 76 76 10 c0       	mov    $0xc0107676,%eax
c0101ac9:	e8 a2 fe ff ff       	call   c0101970 <log_internal>
c0101ace:	83 c4 1c             	add    $0x1c,%esp
c0101ad1:	c3                   	ret
c0101ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0101ad8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101adf:	00 

c0101ae0 <panic>:
c0101ae0:	53                   	push   %ebx
c0101ae1:	81 ec 08 04 00 00    	sub    $0x408,%esp
c0101ae7:	8d 84 24 14 04 00 00 	lea    0x414(%esp),%eax
c0101aee:	83 ec 04             	sub    $0x4,%esp
c0101af1:	50                   	push   %eax
c0101af2:	ff b4 24 18 04 00 00 	push   0x418(%esp)
c0101af9:	8d 5c 24 0c          	lea    0xc(%esp),%ebx
c0101afd:	53                   	push   %ebx
c0101afe:	e8 7d f6 ff ff       	call   c0101180 <vsprintf>
c0101b03:	c7 04 24 7c 76 10 c0 	movl   $0xc010767c,(%esp)
c0101b0a:	e8 81 f3 ff ff       	call   c0100e90 <serial_puts>
c0101b0f:	89 1c 24             	mov    %ebx,(%esp)
c0101b12:	e8 79 f3 ff ff       	call   c0100e90 <serial_puts>
c0101b17:	c7 04 24 93 76 10 c0 	movl   $0xc0107693,(%esp)
c0101b1e:	e8 6d f3 ff ff       	call   c0100e90 <serial_puts>
c0101b23:	58                   	pop    %eax
c0101b24:	5a                   	pop    %edx
c0101b25:	6a 04                	push   $0x4
c0101b27:	6a 0f                	push   $0xf
c0101b29:	e8 02 f0 ff ff       	call   c0100b30 <console_set_color>
c0101b2e:	c7 04 24 7c 76 10 c0 	movl   $0xc010767c,(%esp)
c0101b35:	e8 06 f1 ff ff       	call   c0100c40 <console_puts>
c0101b3a:	89 1c 24             	mov    %ebx,(%esp)
c0101b3d:	e8 fe f0 ff ff       	call   c0100c40 <console_puts>
c0101b42:	c7 04 24 93 76 10 c0 	movl   $0xc0107693,(%esp)
c0101b49:	e8 f2 f0 ff ff       	call   c0100c40 <console_puts>
c0101b4e:	89 dc                	mov    %ebx,%esp
c0101b50:	fa                   	cli
c0101b51:	f4                   	hlt
c0101b52:	eb fc                	jmp    c0101b50 <panic+0x70>
c0101b54:	66 90                	xchg   %ax,%ax
c0101b56:	66 90                	xchg   %ax,%ax
c0101b58:	66 90                	xchg   %ax,%ax
c0101b5a:	66 90                	xchg   %ax,%ax
c0101b5c:	66 90                	xchg   %ax,%ax
c0101b5e:	66 90                	xchg   %ax,%ax
c0101b60:	66 90                	xchg   %ax,%ax
c0101b62:	66 90                	xchg   %ax,%ax
c0101b64:	66 90                	xchg   %ax,%ax
c0101b66:	66 90                	xchg   %ax,%ax
c0101b68:	66 90                	xchg   %ax,%ax
c0101b6a:	66 90                	xchg   %ax,%ax
c0101b6c:	66 90                	xchg   %ax,%ax
c0101b6e:	66 90                	xchg   %ax,%ax
c0101b70:	66 90                	xchg   %ax,%ax
c0101b72:	66 90                	xchg   %ax,%ax
c0101b74:	66 90                	xchg   %ax,%ax
c0101b76:	66 90                	xchg   %ax,%ax
c0101b78:	66 90                	xchg   %ax,%ax
c0101b7a:	66 90                	xchg   %ax,%ax
c0101b7c:	66 90                	xchg   %ax,%ax
c0101b7e:	66 90                	xchg   %ax,%ax

c0101b80 <pmm_reserve_region>:
c0101b80:	83 ec 14             	sub    $0x14,%esp
c0101b83:	89 c1                	mov    %eax,%ecx
c0101b85:	89 6c 24 10          	mov    %ebp,0x10(%esp)
c0101b89:	8d ac 10 ff 0f 00 00 	lea    0xfff(%eax,%edx,1),%ebp
c0101b90:	c1 e9 0c             	shr    $0xc,%ecx
c0101b93:	c1 ed 0c             	shr    $0xc,%ebp
c0101b96:	39 e9                	cmp    %ebp,%ecx
c0101b98:	73 67                	jae    c0101c01 <pmm_reserve_region+0x81>
c0101b9a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0101b9e:	c6 44 24 03 00       	movb   $0x0,0x3(%esp)
c0101ba3:	89 74 24 08          	mov    %esi,0x8(%esp)
c0101ba7:	8b 35 50 2d 11 c0    	mov    0xc0112d50,%esi
c0101bad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
c0101bb1:	8b 3d 58 2d 11 c0    	mov    0xc0112d58,%edi
c0101bb7:	90                   	nop
c0101bb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101bbf:	00 
c0101bc0:	89 c8                	mov    %ecx,%eax
c0101bc2:	bb 01 00 00 00       	mov    $0x1,%ebx
c0101bc7:	c1 e8 05             	shr    $0x5,%eax
c0101bca:	d3 e3                	shl    %cl,%ebx
c0101bcc:	8d 14 87             	lea    (%edi,%eax,4),%edx
c0101bcf:	8b 02                	mov    (%edx),%eax
c0101bd1:	85 d8                	test   %ebx,%eax
c0101bd3:	75 0c                	jne    c0101be1 <pmm_reserve_region+0x61>
c0101bd5:	09 d8                	or     %ebx,%eax
c0101bd7:	c6 44 24 03 01       	movb   $0x1,0x3(%esp)
c0101bdc:	83 c6 01             	add    $0x1,%esi
c0101bdf:	89 02                	mov    %eax,(%edx)
c0101be1:	83 c1 01             	add    $0x1,%ecx
c0101be4:	39 cd                	cmp    %ecx,%ebp
c0101be6:	75 d8                	jne    c0101bc0 <pmm_reserve_region+0x40>
c0101be8:	80 7c 24 03 00       	cmpb   $0x0,0x3(%esp)
c0101bed:	74 21                	je     c0101c10 <pmm_reserve_region+0x90>
c0101bef:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c0101bf3:	8b 7c 24 0c          	mov    0xc(%esp),%edi
c0101bf7:	89 35 50 2d 11 c0    	mov    %esi,0xc0112d50
c0101bfd:	8b 74 24 08          	mov    0x8(%esp),%esi
c0101c01:	8b 6c 24 10          	mov    0x10(%esp),%ebp
c0101c05:	83 c4 14             	add    $0x14,%esp
c0101c08:	c3                   	ret
c0101c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0101c10:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c0101c14:	8b 74 24 08          	mov    0x8(%esp),%esi
c0101c18:	8b 7c 24 0c          	mov    0xc(%esp),%edi
c0101c1c:	8b 6c 24 10          	mov    0x10(%esp),%ebp
c0101c20:	83 c4 14             	add    $0x14,%esp
c0101c23:	c3                   	ret
c0101c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0101c28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101c2f:	00 

c0101c30 <pmm_init>:
c0101c30:	55                   	push   %ebp
c0101c31:	57                   	push   %edi
c0101c32:	56                   	push   %esi
c0101c33:	53                   	push   %ebx
c0101c34:	83 ec 3c             	sub    $0x3c,%esp
c0101c37:	8b 74 24 50          	mov    0x50(%esp),%esi
c0101c3b:	f6 06 40             	testb  $0x40,(%esi)
c0101c3e:	0f 84 d4 02 00 00    	je     c0101f18 <pmm_init+0x2e8>
c0101c44:	8b 6e 30             	mov    0x30(%esi),%ebp
c0101c47:	8b 46 2c             	mov    0x2c(%esi),%eax
c0101c4a:	01 e8                	add    %ebp,%eax
c0101c4c:	89 44 24 28          	mov    %eax,0x28(%esp)
c0101c50:	39 c5                	cmp    %eax,%ebp
c0101c52:	0f 83 b7 02 00 00    	jae    c0101f0f <pmm_init+0x2df>
c0101c58:	a1 5c 2d 11 c0       	mov    0xc0112d5c,%eax
c0101c5d:	8b 15 48 2d 11 c0    	mov    0xc0112d48,%edx
c0101c63:	c6 44 24 2f 00       	movb   $0x0,0x2f(%esp)
c0101c68:	31 ff                	xor    %edi,%edi
c0101c6a:	c6 44 24 2e 00       	movb   $0x0,0x2e(%esp)
c0101c6f:	89 44 24 18          	mov    %eax,0x18(%esp)
c0101c73:	a1 4c 2d 11 c0       	mov    0xc0112d4c,%eax
c0101c78:	89 74 24 50          	mov    %esi,0x50(%esp)
c0101c7c:	89 44 24 24          	mov    %eax,0x24(%esp)
c0101c80:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0101c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0101c88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101c8f:	00 
c0101c90:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c93:	8b 45 04             	mov    0x4(%ebp),%eax
c0101c96:	8b 5d 0c             	mov    0xc(%ebp),%ebx
c0101c99:	8b 75 10             	mov    0x10(%ebp),%esi
c0101c9c:	8b 4c 24 18          	mov    0x18(%esp),%ecx
c0101ca0:	89 54 24 20          	mov    %edx,0x20(%esp)
c0101ca4:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0101ca8:	8b 55 14             	mov    0x14(%ebp),%edx
c0101cab:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0101caf:	89 74 24 14          	mov    %esi,0x14(%esp)
c0101cb3:	83 f9 1f             	cmp    $0x1f,%ecx
c0101cb6:	77 33                	ja     c0101ceb <pmm_init+0xbb>
c0101cb8:	8d 1c 89             	lea    (%ecx,%ecx,4),%ebx
c0101cbb:	8b 74 24 14          	mov    0x14(%esp),%esi
c0101cbf:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
c0101cc4:	8d 0c 9d 60 2d 11 c0 	lea    -0x3feed2a0(,%ebx,4),%ecx
c0101ccb:	89 04 9d 60 2d 11 c0 	mov    %eax,-0x3feed2a0(,%ebx,4)
c0101cd2:	8b 44 24 20          	mov    0x20(%esp),%eax
c0101cd6:	8b 5c 24 10          	mov    0x10(%esp),%ebx
c0101cda:	89 71 0c             	mov    %esi,0xc(%ecx)
c0101cdd:	89 41 04             	mov    %eax,0x4(%ecx)
c0101ce0:	89 59 08             	mov    %ebx,0x8(%ecx)
c0101ce3:	89 51 10             	mov    %edx,0x10(%ecx)
c0101ce6:	c6 44 24 2f 01       	movb   $0x1,0x2f(%esp)
c0101ceb:	8b 5c 24 10          	mov    0x10(%esp),%ebx
c0101cef:	8b 74 24 14          	mov    0x14(%esp),%esi
c0101cf3:	0f b6 44 24 2e       	movzbl 0x2e(%esp),%eax
c0101cf8:	89 d9                	mov    %ebx,%ecx
c0101cfa:	0f ac f1 0a          	shrd   $0xa,%esi,%ecx
c0101cfe:	01 4c 24 24          	add    %ecx,0x24(%esp)
c0101d02:	03 4c 24 0c          	add    0xc(%esp),%ecx
c0101d06:	83 fa 01             	cmp    $0x1,%edx
c0101d09:	0f 44 4c 24 0c       	cmove  0xc(%esp),%ecx
c0101d0e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0101d12:	b9 01 00 00 00       	mov    $0x1,%ecx
c0101d17:	0f 45 c1             	cmovne %ecx,%eax
c0101d1a:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
c0101d1e:	88 44 24 2e          	mov    %al,0x2e(%esp)
c0101d22:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
c0101d25:	39 c7                	cmp    %eax,%edi
c0101d27:	0f 42 f8             	cmovb  %eax,%edi
c0101d2a:	8b 45 00             	mov    0x0(%ebp),%eax
c0101d2d:	8d 6c 05 04          	lea    0x4(%ebp,%eax,1),%ebp
c0101d31:	3b 6c 24 28          	cmp    0x28(%esp),%ebp
c0101d35:	0f 82 55 ff ff ff    	jb     c0101c90 <pmm_init+0x60>
c0101d3b:	8b 4c 24 24          	mov    0x24(%esp),%ecx
c0101d3f:	80 7c 24 2e 00       	cmpb   $0x0,0x2e(%esp)
c0101d44:	8b 54 24 0c          	mov    0xc(%esp),%edx
c0101d48:	8b 74 24 50          	mov    0x50(%esp),%esi
c0101d4c:	89 0d 4c 2d 11 c0    	mov    %ecx,0xc0112d4c
c0101d52:	74 06                	je     c0101d5a <pmm_init+0x12a>
c0101d54:	89 15 48 2d 11 c0    	mov    %edx,0xc0112d48
c0101d5a:	80 7c 24 2f 00       	cmpb   $0x0,0x2f(%esp)
c0101d5f:	74 09                	je     c0101d6a <pmm_init+0x13a>
c0101d61:	8b 44 24 18          	mov    0x18(%esp),%eax
c0101d65:	a3 5c 2d 11 c0       	mov    %eax,0xc0112d5c
c0101d6a:	89 f9                	mov    %edi,%ecx
c0101d6c:	31 d2                	xor    %edx,%edx
c0101d6e:	89 f8                	mov    %edi,%eax
c0101d70:	c1 e9 0c             	shr    $0xc,%ecx
c0101d73:	f7 c7 00 70 00 00    	test   $0x7000,%edi
c0101d79:	0f 95 c2             	setne  %dl
c0101d7c:	c1 e8 0f             	shr    $0xf,%eax
c0101d7f:	01 d0                	add    %edx,%eax
c0101d81:	83 ec 04             	sub    $0x4,%esp
c0101d84:	89 0d 54 2d 11 c0    	mov    %ecx,0xc0112d54
c0101d8a:	50                   	push   %eax
c0101d8b:	68 ff 00 00 00       	push   $0xff
c0101d90:	68 f8 36 11 c0       	push   $0xc01136f8
c0101d95:	a3 40 2d 11 c0       	mov    %eax,0xc0112d40
c0101d9a:	c7 05 44 2d 11 c0 f8 	movl   $0x1136f8,0xc0112d44
c0101da1:	36 11 00 
c0101da4:	c7 05 58 2d 11 c0 f8 	movl   $0xc01136f8,0xc0112d58
c0101dab:	36 11 c0 
c0101dae:	e8 6d f3 ff ff       	call   c0101120 <memset>
c0101db3:	a1 54 2d 11 c0       	mov    0xc0112d54,%eax
c0101db8:	8b 15 5c 2d 11 c0    	mov    0xc0112d5c,%edx
c0101dbe:	8b 2d 58 2d 11 c0    	mov    0xc0112d58,%ebp
c0101dc4:	89 44 24 28          	mov    %eax,0x28(%esp)
c0101dc8:	83 c4 10             	add    $0x10,%esp
c0101dcb:	a3 50 2d 11 c0       	mov    %eax,0xc0112d50
c0101dd0:	85 d2                	test   %edx,%edx
c0101dd2:	0f 84 bc 00 00 00    	je     c0101e94 <pmm_init+0x264>
c0101dd8:	8d 14 92             	lea    (%edx,%edx,4),%edx
c0101ddb:	c6 44 24 2e 00       	movb   $0x0,0x2e(%esp)
c0101de0:	b8 60 2d 11 c0       	mov    $0xc0112d60,%eax
c0101de5:	8d 3c 95 60 2d 11 c0 	lea    -0x3feed2a0(,%edx,4),%edi
c0101dec:	89 74 24 50          	mov    %esi,0x50(%esp)
c0101df0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
c0101df4:	eb 13                	jmp    c0101e09 <pmm_init+0x1d9>
c0101df6:	66 90                	xchg   %ax,%ax
c0101df8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101dff:	00 
c0101e00:	83 c0 14             	add    $0x14,%eax
c0101e03:	39 44 24 0c          	cmp    %eax,0xc(%esp)
c0101e07:	74 77                	je     c0101e80 <pmm_init+0x250>
c0101e09:	83 78 10 01          	cmpl   $0x1,0x10(%eax)
c0101e0d:	75 f1                	jne    c0101e00 <pmm_init+0x1d0>
c0101e0f:	8b 30                	mov    (%eax),%esi
c0101e11:	8b 78 04             	mov    0x4(%eax),%edi
c0101e14:	89 f2                	mov    %esi,%edx
c0101e16:	89 f1                	mov    %esi,%ecx
c0101e18:	89 fb                	mov    %edi,%ebx
c0101e1a:	0f ac fa 0c          	shrd   $0xc,%edi,%edx
c0101e1e:	03 48 08             	add    0x8(%eax),%ecx
c0101e21:	13 58 0c             	adc    0xc(%eax),%ebx
c0101e24:	89 54 24 10          	mov    %edx,0x10(%esp)
c0101e28:	89 ca                	mov    %ecx,%edx
c0101e2a:	0f ac da 0c          	shrd   $0xc,%ebx,%edx
c0101e2e:	39 54 24 10          	cmp    %edx,0x10(%esp)
c0101e32:	73 cc                	jae    c0101e00 <pmm_init+0x1d0>
c0101e34:	89 f1                	mov    %esi,%ecx
c0101e36:	0f ac f9 0c          	shrd   $0xc,%edi,%ecx
c0101e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0101e40:	89 ce                	mov    %ecx,%esi
c0101e42:	bb 01 00 00 00       	mov    $0x1,%ebx
c0101e47:	d3 e3                	shl    %cl,%ebx
c0101e49:	c1 ee 05             	shr    $0x5,%esi
c0101e4c:	83 c1 01             	add    $0x1,%ecx
c0101e4f:	f7 d3                	not    %ebx
c0101e51:	21 5c b5 00          	and    %ebx,0x0(%ebp,%esi,4)
c0101e55:	39 ca                	cmp    %ecx,%edx
c0101e57:	75 e7                	jne    c0101e40 <pmm_init+0x210>
c0101e59:	8b 4c 24 18          	mov    0x18(%esp),%ecx
c0101e5d:	03 4c 24 10          	add    0x10(%esp),%ecx
c0101e61:	c6 44 24 2e 01       	movb   $0x1,0x2e(%esp)
c0101e66:	83 c0 14             	add    $0x14,%eax
c0101e69:	29 d1                	sub    %edx,%ecx
c0101e6b:	89 4c 24 18          	mov    %ecx,0x18(%esp)
c0101e6f:	39 44 24 0c          	cmp    %eax,0xc(%esp)
c0101e73:	75 94                	jne    c0101e09 <pmm_init+0x1d9>
c0101e75:	8d 76 00             	lea    0x0(%esi),%esi
c0101e78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101e7f:	00 
c0101e80:	8b 74 24 50          	mov    0x50(%esp),%esi
c0101e84:	80 7c 24 2e 00       	cmpb   $0x0,0x2e(%esp)
c0101e89:	74 09                	je     c0101e94 <pmm_init+0x264>
c0101e8b:	8b 44 24 18          	mov    0x18(%esp),%eax
c0101e8f:	a3 50 2d 11 c0       	mov    %eax,0xc0112d50
c0101e94:	ba f8 36 11 c0       	mov    $0xc01136f8,%edx
c0101e99:	b8 00 00 10 00       	mov    $0x100000,%eax
c0101e9e:	81 ea 00 00 10 c0    	sub    $0xc0100000,%edx
c0101ea4:	e8 d7 fc ff ff       	call   c0101b80 <pmm_reserve_region>
c0101ea9:	a1 44 2d 11 c0       	mov    0xc0112d44,%eax
c0101eae:	8b 15 40 2d 11 c0    	mov    0xc0112d40,%edx
c0101eb4:	e8 c7 fc ff ff       	call   c0101b80 <pmm_reserve_region>
c0101eb9:	8b 45 00             	mov    0x0(%ebp),%eax
c0101ebc:	a8 01                	test   $0x1,%al
c0101ebe:	75 0d                	jne    c0101ecd <pmm_init+0x29d>
c0101ec0:	83 c8 01             	or     $0x1,%eax
c0101ec3:	83 05 50 2d 11 c0 01 	addl   $0x1,0xc0112d50
c0101eca:	89 45 00             	mov    %eax,0x0(%ebp)
c0101ecd:	8d 86 00 00 00 40    	lea    0x40000000(%esi),%eax
c0101ed3:	ba 58 00 00 00       	mov    $0x58,%edx
c0101ed8:	e8 a3 fc ff ff       	call   c0101b80 <pmm_reserve_region>
c0101edd:	f6 06 08             	testb  $0x8,(%esi)
c0101ee0:	74 25                	je     c0101f07 <pmm_init+0x2d7>
c0101ee2:	8b 46 14             	mov    0x14(%esi),%eax
c0101ee5:	85 c0                	test   %eax,%eax
c0101ee7:	74 1e                	je     c0101f07 <pmm_init+0x2d7>
c0101ee9:	8b 5e 18             	mov    0x18(%esi),%ebx
c0101eec:	31 ff                	xor    %edi,%edi
c0101eee:	66 90                	xchg   %ax,%ax
c0101ef0:	8b 03                	mov    (%ebx),%eax
c0101ef2:	8b 53 04             	mov    0x4(%ebx),%edx
c0101ef5:	83 c7 01             	add    $0x1,%edi
c0101ef8:	83 c3 10             	add    $0x10,%ebx
c0101efb:	29 c2                	sub    %eax,%edx
c0101efd:	e8 7e fc ff ff       	call   c0101b80 <pmm_reserve_region>
c0101f02:	3b 7e 14             	cmp    0x14(%esi),%edi
c0101f05:	72 e9                	jb     c0101ef0 <pmm_init+0x2c0>
c0101f07:	83 c4 3c             	add    $0x3c,%esp
c0101f0a:	5b                   	pop    %ebx
c0101f0b:	5e                   	pop    %esi
c0101f0c:	5f                   	pop    %edi
c0101f0d:	5d                   	pop    %ebp
c0101f0e:	c3                   	ret
c0101f0f:	31 c0                	xor    %eax,%eax
c0101f11:	31 c9                	xor    %ecx,%ecx
c0101f13:	e9 69 fe ff ff       	jmp    c0101d81 <pmm_init+0x151>
c0101f18:	83 ec 0c             	sub    $0xc,%esp
c0101f1b:	68 0c a3 10 c0       	push   $0xc010a30c
c0101f20:	e8 bb fb ff ff       	call   c0101ae0 <panic>
c0101f25:	8d 76 00             	lea    0x0(%esi),%esi
c0101f28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101f2f:	00 

c0101f30 <pmm_alloc_frame>:
c0101f30:	83 ec 1c             	sub    $0x1c,%esp
c0101f33:	89 7c 24 14          	mov    %edi,0x14(%esp)
c0101f37:	8b 3d 54 2d 11 c0    	mov    0xc0112d54,%edi
c0101f3d:	89 74 24 10          	mov    %esi,0x10(%esp)
c0101f41:	89 6c 24 18          	mov    %ebp,0x18(%esp)
c0101f45:	85 ff                	test   %edi,%edi
c0101f47:	74 53                	je     c0101f9c <pmm_alloc_frame+0x6c>
c0101f49:	8b 35 58 2d 11 c0    	mov    0xc0112d58,%esi
c0101f4f:	31 c9                	xor    %ecx,%ecx
c0101f51:	eb 14                	jmp    c0101f67 <pmm_alloc_frame+0x37>
c0101f53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101f58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0101f5f:	00 
c0101f60:	83 c1 01             	add    $0x1,%ecx
c0101f63:	39 f9                	cmp    %edi,%ecx
c0101f65:	74 35                	je     c0101f9c <pmm_alloc_frame+0x6c>
c0101f67:	89 c8                	mov    %ecx,%eax
c0101f69:	bd 01 00 00 00       	mov    $0x1,%ebp
c0101f6e:	c1 e8 05             	shr    $0x5,%eax
c0101f71:	d3 e5                	shl    %cl,%ebp
c0101f73:	8d 14 86             	lea    (%esi,%eax,4),%edx
c0101f76:	8b 02                	mov    (%edx),%eax
c0101f78:	85 e8                	test   %ebp,%eax
c0101f7a:	75 e4                	jne    c0101f60 <pmm_alloc_frame+0x30>
c0101f7c:	09 e8                	or     %ebp,%eax
c0101f7e:	83 05 50 2d 11 c0 01 	addl   $0x1,0xc0112d50
c0101f85:	8b 74 24 10          	mov    0x10(%esp),%esi
c0101f89:	8b 7c 24 14          	mov    0x14(%esp),%edi
c0101f8d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
c0101f91:	89 02                	mov    %eax,(%edx)
c0101f93:	89 c8                	mov    %ecx,%eax
c0101f95:	c1 e0 0c             	shl    $0xc,%eax
c0101f98:	83 c4 1c             	add    $0x1c,%esp
c0101f9b:	c3                   	ret
c0101f9c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0101fa0:	83 ec 0c             	sub    $0xc,%esp
c0101fa3:	68 a4 76 10 c0       	push   $0xc01076a4
c0101fa8:	e8 33 fb ff ff       	call   c0101ae0 <panic>
c0101fad:	8d 76 00             	lea    0x0(%esi),%esi

c0101fb0 <pmm_free_frame>:
c0101fb0:	53                   	push   %ebx
c0101fb1:	8b 44 24 08          	mov    0x8(%esp),%eax
c0101fb5:	89 c1                	mov    %eax,%ecx
c0101fb7:	c1 e9 0c             	shr    $0xc,%ecx
c0101fba:	3b 0d 54 2d 11 c0    	cmp    0xc0112d54,%ecx
c0101fc0:	73 26                	jae    c0101fe8 <pmm_free_frame+0x38>
c0101fc2:	8b 15 58 2d 11 c0    	mov    0xc0112d58,%edx
c0101fc8:	c1 e8 11             	shr    $0x11,%eax
c0101fcb:	8d 14 82             	lea    (%edx,%eax,4),%edx
c0101fce:	b8 01 00 00 00       	mov    $0x1,%eax
c0101fd3:	8b 1a                	mov    (%edx),%ebx
c0101fd5:	d3 e0                	shl    %cl,%eax
c0101fd7:	85 c3                	test   %eax,%ebx
c0101fd9:	74 0d                	je     c0101fe8 <pmm_free_frame+0x38>
c0101fdb:	f7 d0                	not    %eax
c0101fdd:	83 2d 50 2d 11 c0 01 	subl   $0x1,0xc0112d50
c0101fe4:	21 d8                	and    %ebx,%eax
c0101fe6:	89 02                	mov    %eax,(%edx)
c0101fe8:	5b                   	pop    %ebx
c0101fe9:	c3                   	ret
c0101fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

c0101ff0 <pmm_alloc_contiguous>:
c0101ff0:	55                   	push   %ebp
c0101ff1:	57                   	push   %edi
c0101ff2:	56                   	push   %esi
c0101ff3:	53                   	push   %ebx
c0101ff4:	83 ec 1c             	sub    $0x1c,%esp
c0101ff7:	8b 2d 54 2d 11 c0    	mov    0xc0112d54,%ebp
c0101ffd:	85 ed                	test   %ebp,%ebp
c0101fff:	0f 84 a9 00 00 00    	je     c01020ae <pmm_alloc_contiguous+0xbe>
c0102005:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010200c:	00 
c010200d:	8b 35 58 2d 11 c0    	mov    0xc0112d58,%esi
c0102013:	31 c9                	xor    %ecx,%ecx
c0102015:	31 c0                	xor    %eax,%eax
c0102017:	eb 24                	jmp    c010203d <pmm_alloc_contiguous+0x4d>
c0102019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0102020:	8b 54 24 08          	mov    0x8(%esp),%edx
c0102024:	85 c0                	test   %eax,%eax
c0102026:	0f 44 d1             	cmove  %ecx,%edx
c0102029:	83 c0 01             	add    $0x1,%eax
c010202c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102030:	39 44 24 30          	cmp    %eax,0x30(%esp)
c0102034:	74 22                	je     c0102058 <pmm_alloc_contiguous+0x68>
c0102036:	83 c1 01             	add    $0x1,%ecx
c0102039:	39 e9                	cmp    %ebp,%ecx
c010203b:	74 71                	je     c01020ae <pmm_alloc_contiguous+0xbe>
c010203d:	89 ca                	mov    %ecx,%edx
c010203f:	bb 01 00 00 00       	mov    $0x1,%ebx
c0102044:	c1 ea 05             	shr    $0x5,%edx
c0102047:	d3 e3                	shl    %cl,%ebx
c0102049:	85 1c 96             	test   %ebx,(%esi,%edx,4)
c010204c:	74 d2                	je     c0102020 <pmm_alloc_contiguous+0x30>
c010204e:	31 c0                	xor    %eax,%eax
c0102050:	eb e4                	jmp    c0102036 <pmm_alloc_contiguous+0x46>
c0102052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0102058:	8d 3c 02             	lea    (%edx,%eax,1),%edi
c010205b:	89 d1                	mov    %edx,%ecx
c010205d:	39 fa                	cmp    %edi,%edx
c010205f:	73 3e                	jae    c010209f <pmm_alloc_contiguous+0xaf>
c0102061:	8b 1d 50 2d 11 c0    	mov    0xc0112d50,%ebx
c0102067:	bd 01 00 00 00       	mov    $0x1,%ebp
c010206c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0102070:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102077:	00 
c0102078:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010207f:	00 
c0102080:	89 ca                	mov    %ecx,%edx
c0102082:	89 eb                	mov    %ebp,%ebx
c0102084:	d3 e3                	shl    %cl,%ebx
c0102086:	c1 ea 05             	shr    $0x5,%edx
c0102089:	83 c1 01             	add    $0x1,%ecx
c010208c:	09 1c 96             	or     %ebx,(%esi,%edx,4)
c010208f:	39 f9                	cmp    %edi,%ecx
c0102091:	75 ed                	jne    c0102080 <pmm_alloc_contiguous+0x90>
c0102093:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
c0102097:	01 c3                	add    %eax,%ebx
c0102099:	89 1d 50 2d 11 c0    	mov    %ebx,0xc0112d50
c010209f:	8b 44 24 08          	mov    0x8(%esp),%eax
c01020a3:	83 c4 1c             	add    $0x1c,%esp
c01020a6:	5b                   	pop    %ebx
c01020a7:	5e                   	pop    %esi
c01020a8:	c1 e0 0c             	shl    $0xc,%eax
c01020ab:	5f                   	pop    %edi
c01020ac:	5d                   	pop    %ebp
c01020ad:	c3                   	ret
c01020ae:	83 ec 08             	sub    $0x8,%esp
c01020b1:	ff 74 24 38          	push   0x38(%esp)
c01020b5:	68 34 a3 10 c0       	push   $0xc010a334
c01020ba:	e8 21 fa ff ff       	call   c0101ae0 <panic>
c01020bf:	90                   	nop

c01020c0 <pmm_print_map>:
c01020c0:	83 ec 18             	sub    $0x18,%esp
c01020c3:	68 cf 76 10 c0       	push   $0xc01076cf
c01020c8:	e8 83 f9 ff ff       	call   c0101a50 <log_info>
c01020cd:	a1 5c 2d 11 c0       	mov    0xc0112d5c,%eax
c01020d2:	83 c4 10             	add    $0x10,%esp
c01020d5:	85 c0                	test   %eax,%eax
c01020d7:	74 53                	je     c010212c <pmm_print_map+0x6c>
c01020d9:	89 1c 24             	mov    %ebx,(%esp)
c01020dc:	bb 60 2d 11 c0       	mov    $0xc0112d60,%ebx
c01020e1:	89 74 24 04          	mov    %esi,0x4(%esp)
c01020e5:	31 f6                	xor    %esi,%esi
c01020e7:	89 7c 24 08          	mov    %edi,0x8(%esp)
c01020eb:	bf bc 76 10 c0       	mov    $0xc01076bc,%edi
c01020f0:	83 7b 10 01          	cmpl   $0x1,0x10(%ebx)
c01020f4:	ba c6 76 10 c0       	mov    $0xc01076c6,%edx
c01020f9:	8b 03                	mov    (%ebx),%eax
c01020fb:	0f 44 d7             	cmove  %edi,%edx
c01020fe:	83 c6 01             	add    $0x1,%esi
c0102101:	83 c3 14             	add    $0x14,%ebx
c0102104:	52                   	push   %edx
c0102105:	8b 53 f4             	mov    -0xc(%ebx),%edx
c0102108:	01 c2                	add    %eax,%edx
c010210a:	52                   	push   %edx
c010210b:	50                   	push   %eax
c010210c:	68 eb 76 10 c0       	push   $0xc01076eb
c0102111:	e8 3a f9 ff ff       	call   c0101a50 <log_info>
c0102116:	83 c4 10             	add    $0x10,%esp
c0102119:	3b 35 5c 2d 11 c0    	cmp    0xc0112d5c,%esi
c010211f:	72 cf                	jb     c01020f0 <pmm_print_map+0x30>
c0102121:	8b 1c 24             	mov    (%esp),%ebx
c0102124:	8b 74 24 04          	mov    0x4(%esp),%esi
c0102128:	8b 7c 24 08          	mov    0x8(%esp),%edi
c010212c:	83 c4 0c             	add    $0xc,%esp
c010212f:	c3                   	ret

c0102130 <pmm_print_stats>:
c0102130:	83 ec 18             	sub    $0x18,%esp
c0102133:	68 fa 76 10 c0       	push   $0xc01076fa
c0102138:	e8 13 f9 ff ff       	call   c0101a50 <log_info>
c010213d:	58                   	pop    %eax
c010213e:	5a                   	pop    %edx
c010213f:	ff 35 4c 2d 11 c0    	push   0xc0112d4c
c0102145:	68 14 77 10 c0       	push   $0xc0107714
c010214a:	e8 01 f9 ff ff       	call   c0101a50 <log_info>
c010214f:	59                   	pop    %ecx
c0102150:	58                   	pop    %eax
c0102151:	ff 35 48 2d 11 c0    	push   0xc0112d48
c0102157:	68 26 77 10 c0       	push   $0xc0107726
c010215c:	e8 ef f8 ff ff       	call   c0101a50 <log_info>
c0102161:	58                   	pop    %eax
c0102162:	5a                   	pop    %edx
c0102163:	ff 35 54 2d 11 c0    	push   0xc0112d54
c0102169:	68 38 77 10 c0       	push   $0xc0107738
c010216e:	e8 dd f8 ff ff       	call   c0101a50 <log_info>
c0102173:	59                   	pop    %ecx
c0102174:	58                   	pop    %eax
c0102175:	ff 35 50 2d 11 c0    	push   0xc0112d50
c010217b:	68 49 77 10 c0       	push   $0xc0107749
c0102180:	e8 cb f8 ff ff       	call   c0101a50 <log_info>
c0102185:	58                   	pop    %eax
c0102186:	a1 54 2d 11 c0       	mov    0xc0112d54,%eax
c010218b:	2b 05 50 2d 11 c0    	sub    0xc0112d50,%eax
c0102191:	5a                   	pop    %edx
c0102192:	50                   	push   %eax
c0102193:	68 5a 77 10 c0       	push   $0xc010775a
c0102198:	e8 b3 f8 ff ff       	call   c0101a50 <log_info>
c010219d:	59                   	pop    %ecx
c010219e:	58                   	pop    %eax
c010219f:	ff 35 40 2d 11 c0    	push   0xc0112d40
c01021a5:	68 6b 77 10 c0       	push   $0xc010776b
c01021aa:	e8 a1 f8 ff ff       	call   c0101a50 <log_info>
c01021af:	83 c4 0c             	add    $0xc,%esp
c01021b2:	68 f8 36 11 c0       	push   $0xc01136f8
c01021b7:	68 00 00 10 c0       	push   $0xc0100000
c01021bc:	68 7e 77 10 c0       	push   $0xc010777e
c01021c1:	e8 8a f8 ff ff       	call   c0101a50 <log_info>
c01021c6:	83 c4 1c             	add    $0x1c,%esp
c01021c9:	c3                   	ret
c01021ca:	66 90                	xchg   %ax,%ax
c01021cc:	66 90                	xchg   %ax,%ax
c01021ce:	66 90                	xchg   %ax,%ax

c01021d0 <page_fault_handler>:
c01021d0:	55                   	push   %ebp
c01021d1:	57                   	push   %edi
c01021d2:	56                   	push   %esi
c01021d3:	53                   	push   %ebx
c01021d4:	83 ec 18             	sub    $0x18,%esp
c01021d7:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
c01021db:	0f 20 d3             	mov    %cr2,%ebx
c01021de:	8b 75 28             	mov    0x28(%ebp),%esi
c01021e1:	68 60 a3 10 c0       	push   $0xc010a360
c01021e6:	bf 95 77 10 c0       	mov    $0xc0107795,%edi
c01021eb:	e8 c0 f8 ff ff       	call   c0101ab0 <log_error>
c01021f0:	58                   	pop    %eax
c01021f1:	5a                   	pop    %edx
c01021f2:	53                   	push   %ebx
c01021f3:	68 99 77 10 c0       	push   $0xc0107799
c01021f8:	e8 b3 f8 ff ff       	call   c0101ab0 <log_error>
c01021fd:	59                   	pop    %ecx
c01021fe:	5b                   	pop    %ebx
c01021ff:	bb 92 77 10 c0       	mov    $0xc0107792,%ebx
c0102204:	f7 c6 01 00 00 00    	test   $0x1,%esi
c010220a:	89 d8                	mov    %ebx,%eax
c010220c:	0f 45 c7             	cmovne %edi,%eax
c010220f:	50                   	push   %eax
c0102210:	68 b0 77 10 c0       	push   $0xc01077b0
c0102215:	e8 96 f8 ff ff       	call   c0101ab0 <log_error>
c010221a:	58                   	pop    %eax
c010221b:	f7 c6 02 00 00 00    	test   $0x2,%esi
c0102221:	89 f8                	mov    %edi,%eax
c0102223:	0f 44 c3             	cmove  %ebx,%eax
c0102226:	5a                   	pop    %edx
c0102227:	50                   	push   %eax
c0102228:	68 c5 77 10 c0       	push   $0xc01077c5
c010222d:	e8 7e f8 ff ff       	call   c0101ab0 <log_error>
c0102232:	59                   	pop    %ecx
c0102233:	f7 c6 04 00 00 00    	test   $0x4,%esi
c0102239:	58                   	pop    %eax
c010223a:	89 f8                	mov    %edi,%eax
c010223c:	0f 44 c3             	cmove  %ebx,%eax
c010223f:	50                   	push   %eax
c0102240:	68 da 77 10 c0       	push   $0xc01077da
c0102245:	e8 66 f8 ff ff       	call   c0101ab0 <log_error>
c010224a:	58                   	pop    %eax
c010224b:	f7 c6 08 00 00 00    	test   $0x8,%esi
c0102251:	89 f8                	mov    %edi,%eax
c0102253:	0f 44 c3             	cmove  %ebx,%eax
c0102256:	5a                   	pop    %edx
c0102257:	50                   	push   %eax
c0102258:	68 ef 77 10 c0       	push   $0xc01077ef
c010225d:	e8 4e f8 ff ff       	call   c0101ab0 <log_error>
c0102262:	f7 c6 10 00 00 00    	test   $0x10,%esi
c0102268:	59                   	pop    %ecx
c0102269:	58                   	pop    %eax
c010226a:	0f 45 df             	cmovne %edi,%ebx
c010226d:	53                   	push   %ebx
c010226e:	68 04 78 10 c0       	push   $0xc0107804
c0102273:	e8 38 f8 ff ff       	call   c0101ab0 <log_error>
c0102278:	58                   	pop    %eax
c0102279:	5a                   	pop    %edx
c010227a:	ff 75 2c             	push   0x2c(%ebp)
c010227d:	68 19 78 10 c0       	push   $0xc0107819
c0102282:	e8 29 f8 ff ff       	call   c0101ab0 <log_error>
c0102287:	c7 04 24 84 a3 10 c0 	movl   $0xc010a384,(%esp)
c010228e:	e8 1d f8 ff ff       	call   c0101ab0 <log_error>
c0102293:	83 c4 10             	add    $0x10,%esp
c0102296:	83 e6 04             	and    $0x4,%esi
c0102299:	74 19                	je     c01022b4 <page_fault_handler+0xe4>
c010229b:	83 ec 0c             	sub    $0xc,%esp
c010229e:	68 a8 a3 10 c0       	push   $0xc010a3a8
c01022a3:	e8 08 f8 ff ff       	call   c0101ab0 <log_error>
c01022a8:	83 c4 1c             	add    $0x1c,%esp
c01022ab:	5b                   	pop    %ebx
c01022ac:	5e                   	pop    %esi
c01022ad:	5f                   	pop    %edi
c01022ae:	5d                   	pop    %ebp
c01022af:	e9 1c 2c 00 00       	jmp    c0104ed0 <scheduler_exit_current>
c01022b4:	83 ec 0c             	sub    $0xc,%esp
c01022b7:	68 30 78 10 c0       	push   $0xc0107830
c01022bc:	e8 1f f8 ff ff       	call   c0101ae0 <panic>
c01022c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c01022c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01022cf:	00 

c01022d0 <vmm_init>:
c01022d0:	83 ec 14             	sub    $0x14,%esp
c01022d3:	68 d0 21 10 c0       	push   $0xc01021d0
c01022d8:	6a 0e                	push   $0xe
c01022da:	e8 c1 f5 ff ff       	call   c01018a0 <register_interrupt_handler>
c01022df:	31 c0                	xor    %eax,%eax
c01022e1:	c7 05 00 f0 ff ff 00 	movl   $0x0,0xfffff000
c01022e8:	00 00 00 
c01022eb:	0f 01 38             	invlpg (%eax)
c01022ee:	c7 04 24 d4 a3 10 c0 	movl   $0xc010a3d4,(%esp)
c01022f5:	e8 56 f7 ff ff       	call   c0101a50 <log_info>
c01022fa:	83 c4 1c             	add    $0x1c,%esp
c01022fd:	c3                   	ret
c01022fe:	66 90                	xchg   %ax,%ax

c0102300 <vmm_invalidate>:
c0102300:	8b 44 24 04          	mov    0x4(%esp),%eax
c0102304:	0f 01 38             	invlpg (%eax)
c0102307:	c3                   	ret
c0102308:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010230f:	00 

c0102310 <vmm_map>:
c0102310:	56                   	push   %esi
c0102311:	53                   	push   %ebx
c0102312:	83 ec 14             	sub    $0x14,%esp
c0102315:	8b 54 24 20          	mov    0x20(%esp),%edx
c0102319:	89 d6                	mov    %edx,%esi
c010231b:	89 d1                	mov    %edx,%ecx
c010231d:	c1 ee 16             	shr    $0x16,%esi
c0102320:	c1 e9 0c             	shr    $0xc,%ecx
c0102323:	8d 9e 00 fc 0f 00    	lea    0xffc00(%esi),%ebx
c0102329:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
c010232f:	c1 e3 0c             	shl    $0xc,%ebx
c0102332:	f6 04 b5 00 f0 ff ff 	testb  $0x1,-0x1000(,%esi,4)
c0102339:	01 
c010233a:	74 24                	je     c0102360 <vmm_map+0x50>
c010233c:	8b 44 24 24          	mov    0x24(%esp),%eax
c0102340:	8b 74 24 28          	mov    0x28(%esp),%esi
c0102344:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102349:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
c010234f:	09 f0                	or     %esi,%eax
c0102351:	83 c8 01             	or     $0x1,%eax
c0102354:	89 04 8b             	mov    %eax,(%ebx,%ecx,4)
c0102357:	0f 01 3a             	invlpg (%edx)
c010235a:	83 c4 14             	add    $0x14,%esp
c010235d:	5b                   	pop    %ebx
c010235e:	5e                   	pop    %esi
c010235f:	c3                   	ret
c0102360:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0102364:	e8 c7 fb ff ff       	call   c0101f30 <pmm_alloc_frame>
c0102369:	83 ec 04             	sub    $0x4,%esp
c010236c:	83 c8 07             	or     $0x7,%eax
c010236f:	89 04 b5 00 f0 ff ff 	mov    %eax,-0x1000(,%esi,4)
c0102376:	68 00 10 00 00       	push   $0x1000
c010237b:	6a 00                	push   $0x0
c010237d:	53                   	push   %ebx
c010237e:	e8 9d ed ff ff       	call   c0101120 <memset>
c0102383:	83 c4 10             	add    $0x10,%esp
c0102386:	8b 54 24 20          	mov    0x20(%esp),%edx
c010238a:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
c010238e:	eb ac                	jmp    c010233c <vmm_map+0x2c>

c0102390 <vmm_unmap>:
c0102390:	8b 54 24 04          	mov    0x4(%esp),%edx
c0102394:	89 d0                	mov    %edx,%eax
c0102396:	c1 e8 16             	shr    $0x16,%eax
c0102399:	f6 04 85 00 f0 ff ff 	testb  $0x1,-0x1000(,%eax,4)
c01023a0:	01 
c01023a1:	74 1c                	je     c01023bf <vmm_unmap+0x2f>
c01023a3:	89 d1                	mov    %edx,%ecx
c01023a5:	c1 e0 0c             	shl    $0xc,%eax
c01023a8:	c1 e9 0a             	shr    $0xa,%ecx
c01023ab:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
c01023b1:	c7 84 08 00 00 c0 ff 	movl   $0x0,-0x400000(%eax,%ecx,1)
c01023b8:	00 00 00 00 
c01023bc:	0f 01 3a             	invlpg (%edx)
c01023bf:	c3                   	ret

c01023c0 <vmm_translate>:
c01023c0:	8b 54 24 04          	mov    0x4(%esp),%edx
c01023c4:	89 d1                	mov    %edx,%ecx
c01023c6:	c1 e9 16             	shr    $0x16,%ecx
c01023c9:	8b 04 8d 00 f0 ff ff 	mov    -0x1000(,%ecx,4),%eax
c01023d0:	83 e0 01             	and    $0x1,%eax
c01023d3:	74 2a                	je     c01023ff <vmm_translate+0x3f>
c01023d5:	89 d0                	mov    %edx,%eax
c01023d7:	c1 e1 0c             	shl    $0xc,%ecx
c01023da:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
c01023e0:	c1 e8 0a             	shr    $0xa,%eax
c01023e3:	25 fc 0f 00 00       	and    $0xffc,%eax
c01023e8:	8b 84 01 00 00 c0 ff 	mov    -0x400000(%ecx,%eax,1),%eax
c01023ef:	89 c1                	mov    %eax,%ecx
c01023f1:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
c01023f7:	09 ca                	or     %ecx,%edx
c01023f9:	83 e0 01             	and    $0x1,%eax
c01023fc:	0f 45 c2             	cmovne %edx,%eax
c01023ff:	c3                   	ret

c0102400 <vmm_is_mapped>:
c0102400:	8b 54 24 04          	mov    0x4(%esp),%edx
c0102404:	31 c0                	xor    %eax,%eax
c0102406:	89 d1                	mov    %edx,%ecx
c0102408:	c1 e9 16             	shr    $0x16,%ecx
c010240b:	f6 04 8d 00 f0 ff ff 	testb  $0x1,-0x1000(,%ecx,4)
c0102412:	01 
c0102413:	74 16                	je     c010242b <vmm_is_mapped+0x2b>
c0102415:	c1 ea 0a             	shr    $0xa,%edx
c0102418:	c1 e1 0c             	shl    $0xc,%ecx
c010241b:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
c0102421:	8b 84 11 00 00 c0 ff 	mov    -0x400000(%ecx,%edx,1),%eax
c0102428:	83 e0 01             	and    $0x1,%eax
c010242b:	c3                   	ret
c010242c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

c0102430 <vmm_clone_directory>:
c0102430:	53                   	push   %ebx
c0102431:	83 ec 08             	sub    $0x8,%esp
c0102434:	e8 f7 fa ff ff       	call   c0101f30 <pmm_alloc_frame>
c0102439:	89 c3                	mov    %eax,%ebx
c010243b:	31 c0                	xor    %eax,%eax
c010243d:	85 db                	test   %ebx,%ebx
c010243f:	74 64                	je     c01024a5 <vmm_clone_directory+0x75>
c0102441:	f6 05 00 fe ff ff 01 	testb  $0x1,0xfffffe00
c0102448:	74 74                	je     c01024be <vmm_clone_directory+0x8e>
c010244a:	89 d8                	mov    %ebx,%eax
c010244c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102451:	83 c8 03             	or     $0x3,%eax
c0102454:	a3 00 00 f8 ff       	mov    %eax,0xfff80000
c0102459:	b8 00 00 00 e0       	mov    $0xe0000000,%eax
c010245e:	0f 01 38             	invlpg (%eax)
c0102461:	83 ec 04             	sub    $0x4,%esp
c0102464:	68 00 10 00 00       	push   $0x1000
c0102469:	6a 00                	push   $0x0
c010246b:	68 00 00 00 e0       	push   $0xe0000000
c0102470:	e8 ab ec ff ff       	call   c0101120 <memset>
c0102475:	83 c4 10             	add    $0x10,%esp
c0102478:	b8 00 fc ff ff       	mov    $0xfffffc00,%eax
c010247d:	8d 76 00             	lea    0x0(%esi),%esi
c0102480:	8b 10                	mov    (%eax),%edx
c0102482:	83 c0 04             	add    $0x4,%eax
c0102485:	89 90 fc 0f 00 e0    	mov    %edx,-0x1ffff004(%eax)
c010248b:	83 f8 fc             	cmp    $0xfffffffc,%eax
c010248e:	75 f0                	jne    c0102480 <vmm_clone_directory+0x50>
c0102490:	89 d8                	mov    %ebx,%eax
c0102492:	83 c8 03             	or     $0x3,%eax
c0102495:	a3 fc 0f 00 e0       	mov    %eax,0xe0000ffc
c010249a:	f6 05 00 fe ff ff 01 	testb  $0x1,0xfffffe00
c01024a1:	75 07                	jne    c01024aa <vmm_clone_directory+0x7a>
c01024a3:	89 d8                	mov    %ebx,%eax
c01024a5:	83 c4 08             	add    $0x8,%esp
c01024a8:	5b                   	pop    %ebx
c01024a9:	c3                   	ret
c01024aa:	c7 05 00 00 f8 ff 00 	movl   $0x0,0xfff80000
c01024b1:	00 00 00 
c01024b4:	b8 00 00 00 e0       	mov    $0xe0000000,%eax
c01024b9:	0f 01 38             	invlpg (%eax)
c01024bc:	eb e5                	jmp    c01024a3 <vmm_clone_directory+0x73>
c01024be:	e8 6d fa ff ff       	call   c0101f30 <pmm_alloc_frame>
c01024c3:	83 ec 04             	sub    $0x4,%esp
c01024c6:	83 c8 07             	or     $0x7,%eax
c01024c9:	a3 00 fe ff ff       	mov    %eax,0xfffffe00
c01024ce:	68 00 10 00 00       	push   $0x1000
c01024d3:	6a 00                	push   $0x0
c01024d5:	68 00 00 f8 ff       	push   $0xfff80000
c01024da:	e8 41 ec ff ff       	call   c0101120 <memset>
c01024df:	83 c4 10             	add    $0x10,%esp
c01024e2:	e9 63 ff ff ff       	jmp    c010244a <vmm_clone_directory+0x1a>
c01024e7:	90                   	nop
c01024e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01024ef:	00 

c01024f0 <vmm_switch_directory>:
c01024f0:	8b 44 24 04          	mov    0x4(%esp),%eax
c01024f4:	0f 22 d8             	mov    %eax,%cr3
c01024f7:	c3                   	ret
c01024f8:	66 90                	xchg   %ax,%ax
c01024fa:	66 90                	xchg   %ax,%ax
c01024fc:	66 90                	xchg   %ax,%ax
c01024fe:	66 90                	xchg   %ax,%ax

c0102500 <expand_heap>:
c0102500:	83 ec 1c             	sub    $0x1c,%esp
c0102503:	8b 15 f4 2f 11 c0    	mov    0xc0112ff4,%edx
c0102509:	89 7c 24 14          	mov    %edi,0x14(%esp)
c010250d:	85 d2                	test   %edx,%edx
c010250f:	0f 84 43 01 00 00    	je     c0102658 <expand_heap+0x158>
c0102515:	8d 76 00             	lea    0x0(%esi),%esi
c0102518:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010251f:	00 
c0102520:	89 d7                	mov    %edx,%edi
c0102522:	8b 52 10             	mov    0x10(%edx),%edx
c0102525:	85 d2                	test   %edx,%edx
c0102527:	75 f7                	jne    c0102520 <expand_heap+0x20>
c0102529:	0f b6 57 08          	movzbl 0x8(%edi),%edx
c010252d:	84 d2                	test   %dl,%dl
c010252f:	0f 85 9b 00 00 00    	jne    c01025d0 <expand_heap+0xd0>
c0102535:	89 74 24 10          	mov    %esi,0x10(%esp)
c0102539:	89 6c 24 18          	mov    %ebp,0x18(%esp)
c010253d:	83 c0 18             	add    $0x18,%eax
c0102540:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
c0102546:	a1 14 b0 10 c0       	mov    0xc010b014,%eax
c010254b:	89 f5                	mov    %esi,%ebp
c010254d:	81 e5 00 f0 ff ff    	and    $0xfffff000,%ebp
c0102553:	01 e8                	add    %ebp,%eax
c0102555:	3d 00 00 00 d0       	cmp    $0xd0000000,%eax
c010255a:	0f 87 30 01 00 00    	ja     c0102690 <expand_heap+0x190>
c0102560:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0102564:	31 db                	xor    %ebx,%ebx
c0102566:	c1 ee 0c             	shr    $0xc,%esi
c0102569:	75 31                	jne    c010259c <expand_heap+0x9c>
c010256b:	e9 80 00 00 00       	jmp    c01025f0 <expand_heap+0xf0>
c0102570:	83 ec 04             	sub    $0x4,%esp
c0102573:	83 c3 01             	add    $0x1,%ebx
c0102576:	6a 03                	push   $0x3
c0102578:	50                   	push   %eax
c0102579:	ff 35 14 b0 10 c0    	push   0xc010b014
c010257f:	e8 8c fd ff ff       	call   c0102310 <vmm_map>
c0102584:	83 05 f0 2f 11 c0 01 	addl   $0x1,0xc0112ff0
c010258b:	83 c4 10             	add    $0x10,%esp
c010258e:	81 05 14 b0 10 c0 00 	addl   $0x1000,0xc010b014
c0102595:	10 00 00 
c0102598:	39 de                	cmp    %ebx,%esi
c010259a:	74 54                	je     c01025f0 <expand_heap+0xf0>
c010259c:	e8 8f f9 ff ff       	call   c0101f30 <pmm_alloc_frame>
c01025a1:	85 c0                	test   %eax,%eax
c01025a3:	75 cb                	jne    c0102570 <expand_heap+0x70>
c01025a5:	83 ec 0c             	sub    $0xc,%esp
c01025a8:	68 2c a4 10 c0       	push   $0xc010a42c
c01025ad:	e8 fe f4 ff ff       	call   c0101ab0 <log_error>
c01025b2:	83 c4 10             	add    $0x10,%esp
c01025b5:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
c01025b9:	8b 74 24 10          	mov    0x10(%esp),%esi
c01025bd:	8b 6c 24 18          	mov    0x18(%esp),%ebp
c01025c1:	31 d2                	xor    %edx,%edx
c01025c3:	8b 7c 24 14          	mov    0x14(%esp),%edi
c01025c7:	89 d0                	mov    %edx,%eax
c01025c9:	83 c4 1c             	add    $0x1c,%esp
c01025cc:	c3                   	ret
c01025cd:	8d 76 00             	lea    0x0(%esi),%esi
c01025d0:	8b 4f 04             	mov    0x4(%edi),%ecx
c01025d3:	39 c1                	cmp    %eax,%ecx
c01025d5:	73 ec                	jae    c01025c3 <expand_heap+0xc3>
c01025d7:	89 74 24 10          	mov    %esi,0x10(%esp)
c01025db:	29 c8                	sub    %ecx,%eax
c01025dd:	89 6c 24 18          	mov    %ebp,0x18(%esp)
c01025e1:	e9 5a ff ff ff       	jmp    c0102540 <expand_heap+0x40>
c01025e6:	66 90                	xchg   %ax,%ax
c01025e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01025ef:	00 
c01025f0:	83 05 e0 2f 11 c0 01 	addl   $0x1,0xc0112fe0
c01025f7:	85 ff                	test   %edi,%edi
c01025f9:	0f 84 a9 00 00 00    	je     c01026a8 <expand_heap+0x1a8>
c01025ff:	0f b6 57 08          	movzbl 0x8(%edi),%edx
c0102603:	84 d2                	test   %dl,%dl
c0102605:	75 69                	jne    c0102670 <expand_heap+0x170>
c0102607:	a1 14 b0 10 c0       	mov    0xc010b014,%eax
c010260c:	29 e8                	sub    %ebp,%eax
c010260e:	83 ed 18             	sub    $0x18,%ebp
c0102611:	c7 00 fe 0f dc ba    	movl   $0xbadc0ffe,(%eax)
c0102617:	89 68 04             	mov    %ebp,0x4(%eax)
c010261a:	c6 40 08 01          	movb   $0x1,0x8(%eax)
c010261e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
c0102625:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
c010262c:	89 78 14             	mov    %edi,0x14(%eax)
c010262f:	89 47 10             	mov    %eax,0x10(%edi)
c0102632:	ba 01 00 00 00       	mov    $0x1,%edx
c0102637:	83 05 e8 2f 11 c0 01 	addl   $0x1,0xc0112fe8
c010263e:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
c0102642:	8b 74 24 10          	mov    0x10(%esp),%esi
c0102646:	8b 6c 24 18          	mov    0x18(%esp),%ebp
c010264a:	89 d0                	mov    %edx,%eax
c010264c:	8b 7c 24 14          	mov    0x14(%esp),%edi
c0102650:	83 c4 1c             	add    $0x1c,%esp
c0102653:	c3                   	ret
c0102654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0102658:	89 74 24 10          	mov    %esi,0x10(%esp)
c010265c:	31 ff                	xor    %edi,%edi
c010265e:	89 6c 24 18          	mov    %ebp,0x18(%esp)
c0102662:	e9 d6 fe ff ff       	jmp    c010253d <expand_heap+0x3d>
c0102667:	90                   	nop
c0102668:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010266f:	00 
c0102670:	01 6f 04             	add    %ebp,0x4(%edi)
c0102673:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
c0102677:	89 d0                	mov    %edx,%eax
c0102679:	8b 74 24 10          	mov    0x10(%esp),%esi
c010267d:	8b 6c 24 18          	mov    0x18(%esp),%ebp
c0102681:	8b 7c 24 14          	mov    0x14(%esp),%edi
c0102685:	83 c4 1c             	add    $0x1c,%esp
c0102688:	c3                   	ret
c0102689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0102690:	83 ec 0c             	sub    $0xc,%esp
c0102693:	68 fc a3 10 c0       	push   $0xc010a3fc
c0102698:	e8 13 f4 ff ff       	call   c0101ab0 <log_error>
c010269d:	83 c4 10             	add    $0x10,%esp
c01026a0:	e9 14 ff ff ff       	jmp    c01025b9 <expand_heap+0xb9>
c01026a5:	8d 76 00             	lea    0x0(%esi),%esi
c01026a8:	a1 14 b0 10 c0       	mov    0xc010b014,%eax
c01026ad:	29 e8                	sub    %ebp,%eax
c01026af:	83 ed 18             	sub    $0x18,%ebp
c01026b2:	c7 00 fe 0f dc ba    	movl   $0xbadc0ffe,(%eax)
c01026b8:	89 68 04             	mov    %ebp,0x4(%eax)
c01026bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
c01026bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
c01026c6:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
c01026cd:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
c01026d4:	a3 f4 2f 11 c0       	mov    %eax,0xc0112ff4
c01026d9:	e9 54 ff ff ff       	jmp    c0102632 <expand_heap+0x132>
c01026de:	66 90                	xchg   %ax,%ax

c01026e0 <heap_init>:
c01026e0:	83 ec 0c             	sub    $0xc,%esp
c01026e3:	b8 00 40 00 00       	mov    $0x4000,%eax
c01026e8:	e8 13 fe ff ff       	call   c0102500 <expand_heap>
c01026ed:	84 c0                	test   %al,%al
c01026ef:	74 16                	je     c0102707 <heap_init+0x27>
c01026f1:	83 ec 08             	sub    $0x8,%esp
c01026f4:	68 00 00 40 c0       	push   $0xc0400000
c01026f9:	68 5c a4 10 c0       	push   $0xc010a45c
c01026fe:	e8 4d f3 ff ff       	call   c0101a50 <log_info>
c0102703:	83 c4 1c             	add    $0x1c,%esp
c0102706:	c3                   	ret
c0102707:	83 ec 0c             	sub    $0xc,%esp
c010270a:	68 42 78 10 c0       	push   $0xc0107842
c010270f:	e8 cc f3 ff ff       	call   c0101ae0 <panic>
c0102714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0102718:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010271f:	00 

c0102720 <kmalloc>:
c0102720:	83 ec 0c             	sub    $0xc,%esp
c0102723:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102727:	8b 5c 24 10          	mov    0x10(%esp),%ebx
c010272b:	85 db                	test   %ebx,%ebx
c010272d:	74 48                	je     c0102777 <kmalloc+0x57>
c010272f:	89 d8                	mov    %ebx,%eax
c0102731:	83 e0 fc             	and    $0xfffffffc,%eax
c0102734:	83 c0 04             	add    $0x4,%eax
c0102737:	f6 c3 03             	test   $0x3,%bl
c010273a:	0f 45 d8             	cmovne %eax,%ebx
c010273d:	a1 f4 2f 11 c0       	mov    0xc0112ff4,%eax
c0102742:	85 c0                	test   %eax,%eax
c0102744:	74 1e                	je     c0102764 <kmalloc+0x44>
c0102746:	66 90                	xchg   %ax,%ax
c0102748:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010274f:	00 
c0102750:	80 78 08 00          	cmpb   $0x0,0x8(%eax)
c0102754:	74 07                	je     c010275d <kmalloc+0x3d>
c0102756:	8b 50 04             	mov    0x4(%eax),%edx
c0102759:	39 da                	cmp    %ebx,%edx
c010275b:	73 2b                	jae    c0102788 <kmalloc+0x68>
c010275d:	8b 40 10             	mov    0x10(%eax),%eax
c0102760:	85 c0                	test   %eax,%eax
c0102762:	75 ec                	jne    c0102750 <kmalloc+0x30>
c0102764:	89 d8                	mov    %ebx,%eax
c0102766:	e8 95 fd ff ff       	call   c0102500 <expand_heap>
c010276b:	84 c0                	test   %al,%al
c010276d:	0f 84 b1 00 00 00    	je     c0102824 <kmalloc+0x104>
c0102773:	85 db                	test   %ebx,%ebx
c0102775:	75 c6                	jne    c010273d <kmalloc+0x1d>
c0102777:	31 db                	xor    %ebx,%ebx
c0102779:	89 d8                	mov    %ebx,%eax
c010277b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c010277f:	83 c4 0c             	add    $0xc,%esp
c0102782:	c3                   	ret
c0102783:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102788:	8d 4b 1c             	lea    0x1c(%ebx),%ecx
c010278b:	89 74 24 08          	mov    %esi,0x8(%esp)
c010278f:	8b 35 e8 2f 11 c0    	mov    0xc0112fe8,%esi
c0102795:	39 d1                	cmp    %edx,%ecx
c0102797:	72 37                	jb     c01027d0 <kmalloc+0xb0>
c0102799:	83 ee 01             	sub    $0x1,%esi
c010279c:	8b 4c 24 14          	mov    0x14(%esp),%ecx
c01027a0:	c6 40 08 00          	movb   $0x0,0x8(%eax)
c01027a4:	8d 58 18             	lea    0x18(%eax),%ebx
c01027a7:	83 05 ec 2f 11 c0 01 	addl   $0x1,0xc0112fec
c01027ae:	89 48 0c             	mov    %ecx,0xc(%eax)
c01027b1:	83 e1 01             	and    $0x1,%ecx
c01027b4:	c7 00 ef be ad de    	movl   $0xdeadbeef,(%eax)
c01027ba:	89 35 e8 2f 11 c0    	mov    %esi,0xc0112fe8
c01027c0:	75 43                	jne    c0102805 <kmalloc+0xe5>
c01027c2:	89 d8                	mov    %ebx,%eax
c01027c4:	8b 74 24 08          	mov    0x8(%esp),%esi
c01027c8:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c01027cc:	83 c4 0c             	add    $0xc,%esp
c01027cf:	c3                   	ret
c01027d0:	29 da                	sub    %ebx,%edx
c01027d2:	8d 4c 18 18          	lea    0x18(%eax,%ebx,1),%ecx
c01027d6:	83 ea 18             	sub    $0x18,%edx
c01027d9:	c7 01 fe 0f dc ba    	movl   $0xbadc0ffe,(%ecx)
c01027df:	89 51 04             	mov    %edx,0x4(%ecx)
c01027e2:	8b 50 10             	mov    0x10(%eax),%edx
c01027e5:	c6 41 08 01          	movb   $0x1,0x8(%ecx)
c01027e9:	c7 41 0c 00 00 00 00 	movl   $0x0,0xc(%ecx)
c01027f0:	89 51 10             	mov    %edx,0x10(%ecx)
c01027f3:	89 41 14             	mov    %eax,0x14(%ecx)
c01027f6:	85 d2                	test   %edx,%edx
c01027f8:	74 03                	je     c01027fd <kmalloc+0xdd>
c01027fa:	89 4a 14             	mov    %ecx,0x14(%edx)
c01027fd:	89 48 10             	mov    %ecx,0x10(%eax)
c0102800:	89 58 04             	mov    %ebx,0x4(%eax)
c0102803:	eb 97                	jmp    c010279c <kmalloc+0x7c>
c0102805:	83 ec 04             	sub    $0x4,%esp
c0102808:	ff 70 04             	push   0x4(%eax)
c010280b:	6a 00                	push   $0x0
c010280d:	53                   	push   %ebx
c010280e:	e8 0d e9 ff ff       	call   c0101120 <memset>
c0102813:	83 c4 10             	add    $0x10,%esp
c0102816:	89 d8                	mov    %ebx,%eax
c0102818:	8b 74 24 08          	mov    0x8(%esp),%esi
c010281c:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c0102820:	83 c4 0c             	add    $0xc,%esp
c0102823:	c3                   	ret
c0102824:	83 05 e4 2f 11 c0 01 	addl   $0x1,0xc0112fe4
c010282b:	31 db                	xor    %ebx,%ebx
c010282d:	e9 47 ff ff ff       	jmp    c0102779 <kmalloc+0x59>
c0102832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0102838:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010283f:	00 

c0102840 <kfree>:
c0102840:	83 ec 0c             	sub    $0xc,%esp
c0102843:	8b 44 24 10          	mov    0x10(%esp),%eax
c0102847:	85 c0                	test   %eax,%eax
c0102849:	0f 84 b1 00 00 00    	je     c0102900 <kfree+0xc0>
c010284f:	8b 50 e8             	mov    -0x18(%eax),%edx
c0102852:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102856:	8d 58 e8             	lea    -0x18(%eax),%ebx
c0102859:	81 fa fe 0f dc ba    	cmp    $0xbadc0ffe,%edx
c010285f:	0f 84 ab 00 00 00    	je     c0102910 <kfree+0xd0>
c0102865:	81 fa ef be ad de    	cmp    $0xdeadbeef,%edx
c010286b:	0f 85 ac 00 00 00    	jne    c010291d <kfree+0xdd>
c0102871:	83 ec 04             	sub    $0x4,%esp
c0102874:	c6 43 08 01          	movb   $0x1,0x8(%ebx)
c0102878:	c7 40 e8 fe 0f dc ba 	movl   $0xbadc0ffe,-0x18(%eax)
c010287f:	ff 73 04             	push   0x4(%ebx)
c0102882:	68 cc 00 00 00       	push   $0xcc
c0102887:	50                   	push   %eax
c0102888:	83 2d ec 2f 11 c0 01 	subl   $0x1,0xc0112fec
c010288f:	83 05 e8 2f 11 c0 01 	addl   $0x1,0xc0112fe8
c0102896:	e8 85 e8 ff ff       	call   c0101120 <memset>
c010289b:	83 c4 10             	add    $0x10,%esp
c010289e:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
c01028a2:	74 64                	je     c0102908 <kfree+0xc8>
c01028a4:	8b 43 10             	mov    0x10(%ebx),%eax
c01028a7:	85 c0                	test   %eax,%eax
c01028a9:	74 27                	je     c01028d2 <kfree+0x92>
c01028ab:	80 78 08 00          	cmpb   $0x0,0x8(%eax)
c01028af:	74 21                	je     c01028d2 <kfree+0x92>
c01028b1:	8b 50 04             	mov    0x4(%eax),%edx
c01028b4:	8b 4b 04             	mov    0x4(%ebx),%ecx
c01028b7:	8b 40 10             	mov    0x10(%eax),%eax
c01028ba:	8d 54 11 18          	lea    0x18(%ecx,%edx,1),%edx
c01028be:	89 53 04             	mov    %edx,0x4(%ebx)
c01028c1:	89 43 10             	mov    %eax,0x10(%ebx)
c01028c4:	85 c0                	test   %eax,%eax
c01028c6:	74 03                	je     c01028cb <kfree+0x8b>
c01028c8:	89 58 14             	mov    %ebx,0x14(%eax)
c01028cb:	83 2d e8 2f 11 c0 01 	subl   $0x1,0xc0112fe8
c01028d2:	8b 43 14             	mov    0x14(%ebx),%eax
c01028d5:	85 c0                	test   %eax,%eax
c01028d7:	74 2f                	je     c0102908 <kfree+0xc8>
c01028d9:	80 78 08 00          	cmpb   $0x0,0x8(%eax)
c01028dd:	74 29                	je     c0102908 <kfree+0xc8>
c01028df:	8b 4b 04             	mov    0x4(%ebx),%ecx
c01028e2:	8d 51 18             	lea    0x18(%ecx),%edx
c01028e5:	01 50 04             	add    %edx,0x4(%eax)
c01028e8:	8b 53 10             	mov    0x10(%ebx),%edx
c01028eb:	89 50 10             	mov    %edx,0x10(%eax)
c01028ee:	85 d2                	test   %edx,%edx
c01028f0:	74 03                	je     c01028f5 <kfree+0xb5>
c01028f2:	89 42 14             	mov    %eax,0x14(%edx)
c01028f5:	83 2d e8 2f 11 c0 01 	subl   $0x1,0xc0112fe8
c01028fc:	8b 5c 24 08          	mov    0x8(%esp),%ebx
c0102900:	83 c4 0c             	add    $0xc,%esp
c0102903:	c3                   	ret
c0102904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0102908:	8b 5c 24 08          	mov    0x8(%esp),%ebx
c010290c:	83 c4 0c             	add    $0xc,%esp
c010290f:	c3                   	ret
c0102910:	52                   	push   %edx
c0102911:	52                   	push   %edx
c0102912:	53                   	push   %ebx
c0102913:	68 84 a4 10 c0       	push   $0xc010a484
c0102918:	e8 c3 f1 ff ff       	call   c0101ae0 <panic>
c010291d:	50                   	push   %eax
c010291e:	52                   	push   %edx
c010291f:	53                   	push   %ebx
c0102920:	68 a8 a4 10 c0       	push   $0xc010a4a8
c0102925:	e8 b6 f1 ff ff       	call   c0101ae0 <panic>
c010292a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

c0102930 <kcalloc>:
c0102930:	8b 44 24 08          	mov    0x8(%esp),%eax
c0102934:	0f af 44 24 04       	imul   0x4(%esp),%eax
c0102939:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0102940:	00 
c0102941:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102945:	e9 d6 fd ff ff       	jmp    c0102720 <kmalloc>
c010294a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

c0102950 <krealloc>:
c0102950:	83 ec 2c             	sub    $0x2c,%esp
c0102953:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
c0102957:	8b 5c 24 30          	mov    0x30(%esp),%ebx
c010295b:	89 74 24 20          	mov    %esi,0x20(%esp)
c010295f:	8b 44 24 34          	mov    0x34(%esp),%eax
c0102963:	8b 74 24 38          	mov    0x38(%esp),%esi
c0102967:	85 db                	test   %ebx,%ebx
c0102969:	0f 84 e9 00 00 00    	je     c0102a58 <krealloc+0x108>
c010296f:	85 c0                	test   %eax,%eax
c0102971:	0f 84 f9 00 00 00    	je     c0102a70 <krealloc+0x120>
c0102977:	8d 4b e8             	lea    -0x18(%ebx),%ecx
c010297a:	81 7b e8 ef be ad de 	cmpl   $0xdeadbeef,-0x18(%ebx)
c0102981:	0f 85 fc 00 00 00    	jne    c0102a83 <krealloc+0x133>
c0102987:	89 c2                	mov    %eax,%edx
c0102989:	83 e2 fc             	and    $0xfffffffc,%edx
c010298c:	83 c2 04             	add    $0x4,%edx
c010298f:	a8 03                	test   $0x3,%al
c0102991:	0f 45 c2             	cmovne %edx,%eax
c0102994:	8b 51 04             	mov    0x4(%ecx),%edx
c0102997:	39 c2                	cmp    %eax,%edx
c0102999:	0f 83 90 00 00 00    	jae    c0102a2f <krealloc+0xdf>
c010299f:	89 7c 24 24          	mov    %edi,0x24(%esp)
c01029a3:	8b 79 10             	mov    0x10(%ecx),%edi
c01029a6:	85 ff                	test   %edi,%edi
c01029a8:	74 19                	je     c01029c3 <krealloc+0x73>
c01029aa:	80 7f 08 00          	cmpb   $0x0,0x8(%edi)
c01029ae:	74 13                	je     c01029c3 <krealloc+0x73>
c01029b0:	89 6c 24 28          	mov    %ebp,0x28(%esp)
c01029b4:	8b 6f 04             	mov    0x4(%edi),%ebp
c01029b7:	8d 54 2a 18          	lea    0x18(%edx,%ebp,1),%edx
c01029bb:	39 c2                	cmp    %eax,%edx
c01029bd:	73 51                	jae    c0102a10 <krealloc+0xc0>
c01029bf:	8b 6c 24 28          	mov    0x28(%esp),%ebp
c01029c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01029c7:	83 ec 08             	sub    $0x8,%esp
c01029ca:	56                   	push   %esi
c01029cb:	50                   	push   %eax
c01029cc:	e8 4f fd ff ff       	call   c0102720 <kmalloc>
c01029d1:	83 c4 10             	add    $0x10,%esp
c01029d4:	89 c6                	mov    %eax,%esi
c01029d6:	85 c0                	test   %eax,%eax
c01029d8:	74 66                	je     c0102a40 <krealloc+0xf0>
c01029da:	83 ec 04             	sub    $0x4,%esp
c01029dd:	8b 4c 24 10          	mov    0x10(%esp),%ecx
c01029e1:	ff 71 04             	push   0x4(%ecx)
c01029e4:	53                   	push   %ebx
c01029e5:	50                   	push   %eax
c01029e6:	e8 f5 e6 ff ff       	call   c01010e0 <memcpy>
c01029eb:	89 1c 24             	mov    %ebx,(%esp)
c01029ee:	e8 4d fe ff ff       	call   c0102840 <kfree>
c01029f3:	83 c4 10             	add    $0x10,%esp
c01029f6:	8b 7c 24 24          	mov    0x24(%esp),%edi
c01029fa:	89 f0                	mov    %esi,%eax
c01029fc:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
c0102a00:	8b 74 24 20          	mov    0x20(%esp),%esi
c0102a04:	83 c4 2c             	add    $0x2c,%esp
c0102a07:	c3                   	ret
c0102a08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102a0f:	00 
c0102a10:	8b 47 10             	mov    0x10(%edi),%eax
c0102a13:	89 51 04             	mov    %edx,0x4(%ecx)
c0102a16:	89 41 10             	mov    %eax,0x10(%ecx)
c0102a19:	85 c0                	test   %eax,%eax
c0102a1b:	74 03                	je     c0102a20 <krealloc+0xd0>
c0102a1d:	89 48 14             	mov    %ecx,0x14(%eax)
c0102a20:	83 2d e8 2f 11 c0 01 	subl   $0x1,0xc0112fe8
c0102a27:	8b 7c 24 24          	mov    0x24(%esp),%edi
c0102a2b:	8b 6c 24 28          	mov    0x28(%esp),%ebp
c0102a2f:	89 de                	mov    %ebx,%esi
c0102a31:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
c0102a35:	89 f0                	mov    %esi,%eax
c0102a37:	8b 74 24 20          	mov    0x20(%esp),%esi
c0102a3b:	83 c4 2c             	add    $0x2c,%esp
c0102a3e:	c3                   	ret
c0102a3f:	90                   	nop
c0102a40:	89 f0                	mov    %esi,%eax
c0102a42:	8b 7c 24 24          	mov    0x24(%esp),%edi
c0102a46:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
c0102a4a:	8b 74 24 20          	mov    0x20(%esp),%esi
c0102a4e:	83 c4 2c             	add    $0x2c,%esp
c0102a51:	c3                   	ret
c0102a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0102a58:	89 74 24 34          	mov    %esi,0x34(%esp)
c0102a5c:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
c0102a60:	8b 74 24 20          	mov    0x20(%esp),%esi
c0102a64:	89 44 24 30          	mov    %eax,0x30(%esp)
c0102a68:	83 c4 2c             	add    $0x2c,%esp
c0102a6b:	e9 b0 fc ff ff       	jmp    c0102720 <kmalloc>
c0102a70:	83 ec 0c             	sub    $0xc,%esp
c0102a73:	31 f6                	xor    %esi,%esi
c0102a75:	53                   	push   %ebx
c0102a76:	e8 c5 fd ff ff       	call   c0102840 <kfree>
c0102a7b:	83 c4 10             	add    $0x10,%esp
c0102a7e:	e9 77 ff ff ff       	jmp    c01029fa <krealloc+0xaa>
c0102a83:	89 7c 24 24          	mov    %edi,0x24(%esp)
c0102a87:	89 6c 24 28          	mov    %ebp,0x28(%esp)
c0102a8b:	50                   	push   %eax
c0102a8c:	50                   	push   %eax
c0102a8d:	51                   	push   %ecx
c0102a8e:	68 e8 a4 10 c0       	push   $0xc010a4e8
c0102a93:	e8 48 f0 ff ff       	call   c0101ae0 <panic>
c0102a98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102a9f:	00 

c0102aa0 <heap_dump>:
c0102aa0:	57                   	push   %edi
c0102aa1:	56                   	push   %esi
c0102aa2:	53                   	push   %ebx
c0102aa3:	83 ec 0c             	sub    $0xc,%esp
c0102aa6:	68 14 a5 10 c0       	push   $0xc010a514
c0102aab:	e8 a0 ef ff ff       	call   c0101a50 <log_info>
c0102ab0:	59                   	pop    %ecx
c0102ab1:	5b                   	pop    %ebx
c0102ab2:	ff 35 f0 2f 11 c0    	push   0xc0112ff0
c0102ab8:	68 5c 78 10 c0       	push   $0xc010785c
c0102abd:	e8 8e ef ff ff       	call   c0101a50 <log_info>
c0102ac2:	5e                   	pop    %esi
c0102ac3:	5f                   	pop    %edi
c0102ac4:	ff 35 e0 2f 11 c0    	push   0xc0112fe0
c0102aca:	68 76 78 10 c0       	push   $0xc0107876
c0102acf:	e8 7c ef ff ff       	call   c0101a50 <log_info>
c0102ad4:	58                   	pop    %eax
c0102ad5:	5a                   	pop    %edx
c0102ad6:	ff 35 ec 2f 11 c0    	push   0xc0112fec
c0102adc:	68 90 78 10 c0       	push   $0xc0107890
c0102ae1:	e8 6a ef ff ff       	call   c0101a50 <log_info>
c0102ae6:	59                   	pop    %ecx
c0102ae7:	5b                   	pop    %ebx
c0102ae8:	ff 35 e8 2f 11 c0    	push   0xc0112fe8
c0102aee:	68 aa 78 10 c0       	push   $0xc01078aa
c0102af3:	e8 58 ef ff ff       	call   c0101a50 <log_info>
c0102af8:	5e                   	pop    %esi
c0102af9:	5f                   	pop    %edi
c0102afa:	ff 35 e4 2f 11 c0    	push   0xc0112fe4
c0102b00:	68 c4 78 10 c0       	push   $0xc01078c4
c0102b05:	e8 46 ef ff ff       	call   c0101a50 <log_info>
c0102b0a:	a1 f4 2f 11 c0       	mov    0xc0112ff4,%eax
c0102b0f:	83 c4 10             	add    $0x10,%esp
c0102b12:	85 c0                	test   %eax,%eax
c0102b14:	0f 84 9e 00 00 00    	je     c0102bb8 <heap_dump+0x118>
c0102b1a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
c0102b1f:	31 f6                	xor    %esi,%esi
c0102b21:	31 c9                	xor    %ecx,%ecx
c0102b23:	31 ff                	xor    %edi,%edi
c0102b25:	eb 2c                	jmp    c0102b53 <heap_dump+0xb3>
c0102b27:	eb 17                	jmp    c0102b40 <heap_dump+0xa0>
c0102b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0102b30:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102b37:	00 
c0102b38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102b3f:	00 
c0102b40:	01 d7                	add    %edx,%edi
c0102b42:	8b 40 10             	mov    0x10(%eax),%eax
c0102b45:	39 d6                	cmp    %edx,%esi
c0102b47:	0f 42 f2             	cmovb  %edx,%esi
c0102b4a:	39 d3                	cmp    %edx,%ebx
c0102b4c:	0f 47 da             	cmova  %edx,%ebx
c0102b4f:	85 c0                	test   %eax,%eax
c0102b51:	74 12                	je     c0102b65 <heap_dump+0xc5>
c0102b53:	8b 50 04             	mov    0x4(%eax),%edx
c0102b56:	80 78 08 00          	cmpb   $0x0,0x8(%eax)
c0102b5a:	75 e4                	jne    c0102b40 <heap_dump+0xa0>
c0102b5c:	8b 40 10             	mov    0x10(%eax),%eax
c0102b5f:	01 d1                	add    %edx,%ecx
c0102b61:	85 c0                	test   %eax,%eax
c0102b63:	75 ee                	jne    c0102b53 <heap_dump+0xb3>
c0102b65:	83 fb ff             	cmp    $0xffffffff,%ebx
c0102b68:	0f 44 d8             	cmove  %eax,%ebx
c0102b6b:	83 ec 08             	sub    $0x8,%esp
c0102b6e:	51                   	push   %ecx
c0102b6f:	68 de 78 10 c0       	push   $0xc01078de
c0102b74:	e8 d7 ee ff ff       	call   c0101a50 <log_info>
c0102b79:	58                   	pop    %eax
c0102b7a:	5a                   	pop    %edx
c0102b7b:	57                   	push   %edi
c0102b7c:	68 f8 78 10 c0       	push   $0xc01078f8
c0102b81:	e8 ca ee ff ff       	call   c0101a50 <log_info>
c0102b86:	59                   	pop    %ecx
c0102b87:	5f                   	pop    %edi
c0102b88:	56                   	push   %esi
c0102b89:	68 12 79 10 c0       	push   $0xc0107912
c0102b8e:	e8 bd ee ff ff       	call   c0101a50 <log_info>
c0102b93:	58                   	pop    %eax
c0102b94:	5a                   	pop    %edx
c0102b95:	53                   	push   %ebx
c0102b96:	68 2c 79 10 c0       	push   $0xc010792c
c0102b9b:	e8 b0 ee ff ff       	call   c0101a50 <log_info>
c0102ba0:	c7 04 24 3c a5 10 c0 	movl   $0xc010a53c,(%esp)
c0102ba7:	e8 a4 ee ff ff       	call   c0101a50 <log_info>
c0102bac:	83 c4 10             	add    $0x10,%esp
c0102baf:	5b                   	pop    %ebx
c0102bb0:	5e                   	pop    %esi
c0102bb1:	5f                   	pop    %edi
c0102bb2:	c3                   	ret
c0102bb3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102bb8:	31 f6                	xor    %esi,%esi
c0102bba:	31 c9                	xor    %ecx,%ecx
c0102bbc:	31 ff                	xor    %edi,%edi
c0102bbe:	31 db                	xor    %ebx,%ebx
c0102bc0:	eb a9                	jmp    c0102b6b <heap_dump+0xcb>
c0102bc2:	66 90                	xchg   %ax,%ax
c0102bc4:	66 90                	xchg   %ax,%ax
c0102bc6:	66 90                	xchg   %ax,%ax
c0102bc8:	66 90                	xchg   %ax,%ax
c0102bca:	66 90                	xchg   %ax,%ax
c0102bcc:	66 90                	xchg   %ax,%ax
c0102bce:	66 90                	xchg   %ax,%ax

c0102bd0 <spin_lock>:
c0102bd0:	8b 54 24 04          	mov    0x4(%esp),%edx
c0102bd4:	b8 01 00 00 00       	mov    $0x1,%eax
c0102bd9:	87 02                	xchg   %eax,(%edx)
c0102bdb:	83 f8 01             	cmp    $0x1,%eax
c0102bde:	75 0e                	jne    c0102bee <spin_lock+0x1e>
c0102be0:	f3 90                	pause
c0102be2:	b8 01 00 00 00       	mov    $0x1,%eax
c0102be7:	87 02                	xchg   %eax,(%edx)
c0102be9:	83 f8 01             	cmp    $0x1,%eax
c0102bec:	74 f2                	je     c0102be0 <spin_lock+0x10>
c0102bee:	c3                   	ret
c0102bef:	90                   	nop

c0102bf0 <spin_unlock>:
c0102bf0:	8b 44 24 04          	mov    0x4(%esp),%eax
c0102bf4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
c0102bfa:	c3                   	ret
c0102bfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

c0102c00 <spin_lock_irqsave>:
c0102c00:	53                   	push   %ebx
c0102c01:	83 ec 08             	sub    $0x8,%esp
c0102c04:	8b 5c 24 10          	mov    0x10(%esp),%ebx
c0102c08:	e8 43 ed ff ff       	call   c0101950 <irq_save>
c0102c0d:	8b 54 24 14          	mov    0x14(%esp),%edx
c0102c11:	89 02                	mov    %eax,(%edx)
c0102c13:	b8 01 00 00 00       	mov    $0x1,%eax
c0102c18:	87 03                	xchg   %eax,(%ebx)
c0102c1a:	83 f8 01             	cmp    $0x1,%eax
c0102c1d:	75 0f                	jne    c0102c2e <spin_lock_irqsave+0x2e>
c0102c1f:	90                   	nop
c0102c20:	f3 90                	pause
c0102c22:	b8 01 00 00 00       	mov    $0x1,%eax
c0102c27:	87 03                	xchg   %eax,(%ebx)
c0102c29:	83 f8 01             	cmp    $0x1,%eax
c0102c2c:	74 f2                	je     c0102c20 <spin_lock_irqsave+0x20>
c0102c2e:	83 c4 08             	add    $0x8,%esp
c0102c31:	5b                   	pop    %ebx
c0102c32:	c3                   	ret
c0102c33:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102c38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102c3f:	00 

c0102c40 <spin_unlock_irqrestore>:
c0102c40:	8b 44 24 04          	mov    0x4(%esp),%eax
c0102c44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
c0102c4a:	8b 44 24 08          	mov    0x8(%esp),%eax
c0102c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102c52:	e9 09 ed ff ff       	jmp    c0101960 <irq_restore>
c0102c57:	66 90                	xchg   %ax,%ax
c0102c59:	66 90                	xchg   %ax,%ax
c0102c5b:	66 90                	xchg   %ax,%ax
c0102c5d:	66 90                	xchg   %ax,%ax
c0102c5f:	90                   	nop

c0102c60 <mutex_init>:
c0102c60:	8b 44 24 04          	mov    0x4(%esp),%eax
c0102c64:	85 c0                	test   %eax,%eax
c0102c66:	74 28                	je     c0102c90 <mutex_init+0x30>
c0102c68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
c0102c6e:	83 c0 0c             	add    $0xc,%eax
c0102c71:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
c0102c78:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
c0102c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102c83:	e9 88 01 00 00       	jmp    c0102e10 <waitqueue_init>
c0102c88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102c8f:	00 
c0102c90:	c3                   	ret
c0102c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0102c98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102c9f:	00 

c0102ca0 <mutex_acquire>:
c0102ca0:	83 ec 2c             	sub    $0x2c,%esp
c0102ca3:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
c0102ca7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
c0102cab:	85 db                	test   %ebx,%ebx
c0102cad:	0f 84 86 00 00 00    	je     c0102d39 <mutex_acquire+0x99>
c0102cb3:	89 7c 24 24          	mov    %edi,0x24(%esp)
c0102cb7:	89 74 24 20          	mov    %esi,0x20(%esp)
c0102cbb:	89 6c 24 28          	mov    %ebp,0x28(%esp)
c0102cbf:	83 ec 08             	sub    $0x8,%esp
c0102cc2:	8d 7c 24 14          	lea    0x14(%esp),%edi
c0102cc6:	57                   	push   %edi
c0102cc7:	53                   	push   %ebx
c0102cc8:	e8 33 ff ff ff       	call   c0102c00 <spin_lock_irqsave>
c0102ccd:	8b 53 04             	mov    0x4(%ebx),%edx
c0102cd0:	a1 80 35 11 c0       	mov    0xc0113580,%eax
c0102cd5:	83 c4 10             	add    $0x10,%esp
c0102cd8:	39 c2                	cmp    %eax,%edx
c0102cda:	74 65                	je     c0102d41 <mutex_acquire+0xa1>
c0102cdc:	8b 74 24 0c          	mov    0xc(%esp),%esi
c0102ce0:	8d 6b 0c             	lea    0xc(%ebx),%ebp
c0102ce3:	85 d2                	test   %edx,%edx
c0102ce5:	74 2f                	je     c0102d16 <mutex_acquire+0x76>
c0102ce7:	90                   	nop
c0102ce8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102cef:	00 
c0102cf0:	83 ec 08             	sub    $0x8,%esp
c0102cf3:	53                   	push   %ebx
c0102cf4:	55                   	push   %ebp
c0102cf5:	e8 36 01 00 00       	call   c0102e30 <waitqueue_sleep>
c0102cfa:	58                   	pop    %eax
c0102cfb:	5a                   	pop    %edx
c0102cfc:	57                   	push   %edi
c0102cfd:	53                   	push   %ebx
c0102cfe:	e8 fd fe ff ff       	call   c0102c00 <spin_lock_irqsave>
c0102d03:	8b 4b 04             	mov    0x4(%ebx),%ecx
c0102d06:	89 74 24 1c          	mov    %esi,0x1c(%esp)
c0102d0a:	83 c4 10             	add    $0x10,%esp
c0102d0d:	85 c9                	test   %ecx,%ecx
c0102d0f:	75 df                	jne    c0102cf0 <mutex_acquire+0x50>
c0102d11:	a1 80 35 11 c0       	mov    0xc0113580,%eax
c0102d16:	83 ec 08             	sub    $0x8,%esp
c0102d19:	89 43 04             	mov    %eax,0x4(%ebx)
c0102d1c:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
c0102d23:	56                   	push   %esi
c0102d24:	53                   	push   %ebx
c0102d25:	e8 16 ff ff ff       	call   c0102c40 <spin_unlock_irqrestore>
c0102d2a:	83 c4 10             	add    $0x10,%esp
c0102d2d:	8b 74 24 20          	mov    0x20(%esp),%esi
c0102d31:	8b 7c 24 24          	mov    0x24(%esp),%edi
c0102d35:	8b 6c 24 28          	mov    0x28(%esp),%ebp
c0102d39:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
c0102d3d:	83 c4 2c             	add    $0x2c,%esp
c0102d40:	c3                   	ret
c0102d41:	53                   	push   %ebx
c0102d42:	53                   	push   %ebx
c0102d43:	ff 32                	push   (%edx)
c0102d45:	68 64 a5 10 c0       	push   $0xc010a564
c0102d4a:	e8 91 ed ff ff       	call   c0101ae0 <panic>
c0102d4f:	90                   	nop

c0102d50 <mutex_release>:
c0102d50:	53                   	push   %ebx
c0102d51:	83 ec 18             	sub    $0x18,%esp
c0102d54:	8b 5c 24 20          	mov    0x20(%esp),%ebx
c0102d58:	85 db                	test   %ebx,%ebx
c0102d5a:	74 44                	je     c0102da0 <mutex_release+0x50>
c0102d5c:	83 ec 08             	sub    $0x8,%esp
c0102d5f:	8d 44 24 14          	lea    0x14(%esp),%eax
c0102d63:	50                   	push   %eax
c0102d64:	53                   	push   %ebx
c0102d65:	e8 96 fe ff ff       	call   c0102c00 <spin_lock_irqsave>
c0102d6a:	a1 80 35 11 c0       	mov    0xc0113580,%eax
c0102d6f:	83 c4 10             	add    $0x10,%esp
c0102d72:	39 43 04             	cmp    %eax,0x4(%ebx)
c0102d75:	75 2e                	jne    c0102da5 <mutex_release+0x55>
c0102d77:	83 ec 0c             	sub    $0xc,%esp
c0102d7a:	8d 43 0c             	lea    0xc(%ebx),%eax
c0102d7d:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
c0102d84:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
c0102d8b:	50                   	push   %eax
c0102d8c:	e8 1f 01 00 00       	call   c0102eb0 <waitqueue_wake_one>
c0102d91:	58                   	pop    %eax
c0102d92:	5a                   	pop    %edx
c0102d93:	ff 74 24 14          	push   0x14(%esp)
c0102d97:	53                   	push   %ebx
c0102d98:	e8 a3 fe ff ff       	call   c0102c40 <spin_unlock_irqrestore>
c0102d9d:	83 c4 10             	add    $0x10,%esp
c0102da0:	83 c4 18             	add    $0x18,%esp
c0102da3:	5b                   	pop    %ebx
c0102da4:	c3                   	ret
c0102da5:	51                   	push   %ecx
c0102da6:	51                   	push   %ecx
c0102da7:	ff 30                	push   (%eax)
c0102da9:	68 90 a5 10 c0       	push   $0xc010a590
c0102dae:	e8 2d ed ff ff       	call   c0101ae0 <panic>
c0102db3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102db8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102dbf:	00 

c0102dc0 <mutex_destroy>:
c0102dc0:	53                   	push   %ebx
c0102dc1:	83 ec 18             	sub    $0x18,%esp
c0102dc4:	8b 5c 24 20          	mov    0x20(%esp),%ebx
c0102dc8:	85 db                	test   %ebx,%ebx
c0102dca:	74 28                	je     c0102df4 <mutex_destroy+0x34>
c0102dcc:	83 ec 08             	sub    $0x8,%esp
c0102dcf:	8d 44 24 14          	lea    0x14(%esp),%eax
c0102dd3:	50                   	push   %eax
c0102dd4:	53                   	push   %ebx
c0102dd5:	e8 26 fe ff ff       	call   c0102c00 <spin_lock_irqsave>
c0102dda:	8b 43 04             	mov    0x4(%ebx),%eax
c0102ddd:	83 c4 10             	add    $0x10,%esp
c0102de0:	85 c0                	test   %eax,%eax
c0102de2:	75 15                	jne    c0102df9 <mutex_destroy+0x39>
c0102de4:	83 ec 08             	sub    $0x8,%esp
c0102de7:	ff 74 24 14          	push   0x14(%esp)
c0102deb:	53                   	push   %ebx
c0102dec:	e8 4f fe ff ff       	call   c0102c40 <spin_unlock_irqrestore>
c0102df1:	83 c4 10             	add    $0x10,%esp
c0102df4:	83 c4 18             	add    $0x18,%esp
c0102df7:	5b                   	pop    %ebx
c0102df8:	c3                   	ret
c0102df9:	83 ec 0c             	sub    $0xc,%esp
c0102dfc:	68 b4 a5 10 c0       	push   $0xc010a5b4
c0102e01:	e8 da ec ff ff       	call   c0101ae0 <panic>
c0102e06:	66 90                	xchg   %ax,%ax
c0102e08:	66 90                	xchg   %ax,%ax
c0102e0a:	66 90                	xchg   %ax,%ax
c0102e0c:	66 90                	xchg   %ax,%ax
c0102e0e:	66 90                	xchg   %ax,%ax

c0102e10 <waitqueue_init>:
c0102e10:	83 ec 18             	sub    $0x18,%esp
c0102e13:	ff 74 24 1c          	push   0x1c(%esp)
c0102e17:	e8 34 e8 ff ff       	call   c0101650 <list_init>
c0102e1c:	8b 44 24 20          	mov    0x20(%esp),%eax
c0102e20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
c0102e27:	83 c4 1c             	add    $0x1c,%esp
c0102e2a:	c3                   	ret
c0102e2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

c0102e30 <waitqueue_sleep>:
c0102e30:	55                   	push   %ebp
c0102e31:	57                   	push   %edi
c0102e32:	56                   	push   %esi
c0102e33:	53                   	push   %ebx
c0102e34:	83 ec 0c             	sub    $0xc,%esp
c0102e37:	8b 74 24 20          	mov    0x20(%esp),%esi
c0102e3b:	8b 6c 24 24          	mov    0x24(%esp),%ebp
c0102e3f:	e8 0c eb ff ff       	call   c0101950 <irq_save>
c0102e44:	83 ec 0c             	sub    $0xc,%esp
c0102e47:	8d 5e 0c             	lea    0xc(%esi),%ebx
c0102e4a:	89 c7                	mov    %eax,%edi
c0102e4c:	53                   	push   %ebx
c0102e4d:	e8 7e fd ff ff       	call   c0102bd0 <spin_lock>
c0102e52:	a1 80 35 11 c0       	mov    0xc0113580,%eax
c0102e57:	c7 40 30 02 00 00 00 	movl   $0x2,0x30(%eax)
c0102e5e:	5a                   	pop    %edx
c0102e5f:	59                   	pop    %ecx
c0102e60:	50                   	push   %eax
c0102e61:	56                   	push   %esi
c0102e62:	e8 09 e8 ff ff       	call   c0101670 <list_push_back>
c0102e67:	89 1c 24             	mov    %ebx,(%esp)
c0102e6a:	e8 81 fd ff ff       	call   c0102bf0 <spin_unlock>
c0102e6f:	83 c4 10             	add    $0x10,%esp
c0102e72:	85 ed                	test   %ebp,%ebp
c0102e74:	74 0c                	je     c0102e82 <waitqueue_sleep+0x52>
c0102e76:	83 ec 0c             	sub    $0xc,%esp
c0102e79:	55                   	push   %ebp
c0102e7a:	e8 71 fd ff ff       	call   c0102bf0 <spin_unlock>
c0102e7f:	83 c4 10             	add    $0x10,%esp
c0102e82:	83 ec 0c             	sub    $0xc,%esp
c0102e85:	ff 35 80 35 11 c0    	push   0xc0113580
c0102e8b:	e8 20 1e 00 00       	call   c0104cb0 <scheduler_dequeue>
c0102e90:	e8 2b 20 00 00       	call   c0104ec0 <scheduler_yield>
c0102e95:	89 7c 24 30          	mov    %edi,0x30(%esp)
c0102e99:	83 c4 1c             	add    $0x1c,%esp
c0102e9c:	5b                   	pop    %ebx
c0102e9d:	5e                   	pop    %esi
c0102e9e:	5f                   	pop    %edi
c0102e9f:	5d                   	pop    %ebp
c0102ea0:	e9 bb ea ff ff       	jmp    c0101960 <irq_restore>
c0102ea5:	8d 76 00             	lea    0x0(%esi),%esi
c0102ea8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102eaf:	00 

c0102eb0 <waitqueue_wake_one>:
c0102eb0:	57                   	push   %edi
c0102eb1:	56                   	push   %esi
c0102eb2:	53                   	push   %ebx
c0102eb3:	8b 5c 24 10          	mov    0x10(%esp),%ebx
c0102eb7:	8d 73 0c             	lea    0xc(%ebx),%esi
c0102eba:	e8 91 ea ff ff       	call   c0101950 <irq_save>
c0102ebf:	83 ec 0c             	sub    $0xc,%esp
c0102ec2:	56                   	push   %esi
c0102ec3:	89 c7                	mov    %eax,%edi
c0102ec5:	e8 06 fd ff ff       	call   c0102bd0 <spin_lock>
c0102eca:	89 1c 24             	mov    %ebx,(%esp)
c0102ecd:	e8 ee e7 ff ff       	call   c01016c0 <list_pop_front>
c0102ed2:	89 34 24             	mov    %esi,(%esp)
c0102ed5:	89 c3                	mov    %eax,%ebx
c0102ed7:	e8 14 fd ff ff       	call   c0102bf0 <spin_unlock>
c0102edc:	83 c4 10             	add    $0x10,%esp
c0102edf:	85 db                	test   %ebx,%ebx
c0102ee1:	74 0c                	je     c0102eef <waitqueue_wake_one+0x3f>
c0102ee3:	83 ec 0c             	sub    $0xc,%esp
c0102ee6:	53                   	push   %ebx
c0102ee7:	e8 54 20 00 00       	call   c0104f40 <scheduler_make_ready>
c0102eec:	83 c4 10             	add    $0x10,%esp
c0102eef:	89 7c 24 10          	mov    %edi,0x10(%esp)
c0102ef3:	5b                   	pop    %ebx
c0102ef4:	5e                   	pop    %esi
c0102ef5:	5f                   	pop    %edi
c0102ef6:	e9 65 ea ff ff       	jmp    c0101960 <irq_restore>
c0102efb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

c0102f00 <waitqueue_wake_all>:
c0102f00:	57                   	push   %edi
c0102f01:	56                   	push   %esi
c0102f02:	53                   	push   %ebx
c0102f03:	8b 5c 24 10          	mov    0x10(%esp),%ebx
c0102f07:	8d 73 0c             	lea    0xc(%ebx),%esi
c0102f0a:	e8 41 ea ff ff       	call   c0101950 <irq_save>
c0102f0f:	83 ec 0c             	sub    $0xc,%esp
c0102f12:	56                   	push   %esi
c0102f13:	89 c7                	mov    %eax,%edi
c0102f15:	e8 b6 fc ff ff       	call   c0102bd0 <spin_lock>
c0102f1a:	83 c4 10             	add    $0x10,%esp
c0102f1d:	eb 0d                	jmp    c0102f2c <waitqueue_wake_all+0x2c>
c0102f1f:	90                   	nop
c0102f20:	83 ec 0c             	sub    $0xc,%esp
c0102f23:	50                   	push   %eax
c0102f24:	e8 17 20 00 00       	call   c0104f40 <scheduler_make_ready>
c0102f29:	83 c4 10             	add    $0x10,%esp
c0102f2c:	83 ec 0c             	sub    $0xc,%esp
c0102f2f:	53                   	push   %ebx
c0102f30:	e8 8b e7 ff ff       	call   c01016c0 <list_pop_front>
c0102f35:	83 c4 10             	add    $0x10,%esp
c0102f38:	85 c0                	test   %eax,%eax
c0102f3a:	75 e4                	jne    c0102f20 <waitqueue_wake_all+0x20>
c0102f3c:	83 ec 0c             	sub    $0xc,%esp
c0102f3f:	56                   	push   %esi
c0102f40:	e8 ab fc ff ff       	call   c0102bf0 <spin_unlock>
c0102f45:	83 c4 10             	add    $0x10,%esp
c0102f48:	89 7c 24 10          	mov    %edi,0x10(%esp)
c0102f4c:	5b                   	pop    %ebx
c0102f4d:	5e                   	pop    %esi
c0102f4e:	5f                   	pop    %edi
c0102f4f:	e9 0c ea ff ff       	jmp    c0101960 <irq_restore>
c0102f54:	66 90                	xchg   %ax,%ax
c0102f56:	66 90                	xchg   %ax,%ax
c0102f58:	66 90                	xchg   %ax,%ax
c0102f5a:	66 90                	xchg   %ax,%ax
c0102f5c:	66 90                	xchg   %ax,%ax
c0102f5e:	66 90                	xchg   %ax,%ax

c0102f60 <sys_ioctl>:
c0102f60:	83 ec 0c             	sub    $0xc,%esp
c0102f63:	8b 44 24 10          	mov    0x10(%esp),%eax
c0102f67:	8b 50 14             	mov    0x14(%eax),%edx
c0102f6a:	83 fa 1f             	cmp    $0x1f,%edx
c0102f6d:	77 31                	ja     c0102fa0 <sys_ioctl+0x40>
c0102f6f:	8b 0d 80 35 11 c0    	mov    0xc0113580,%ecx
c0102f75:	8b 49 40             	mov    0x40(%ecx),%ecx
c0102f78:	8b 54 91 2c          	mov    0x2c(%ecx,%edx,4),%edx
c0102f7c:	85 d2                	test   %edx,%edx
c0102f7e:	74 20                	je     c0102fa0 <sys_ioctl+0x40>
c0102f80:	83 ec 04             	sub    $0x4,%esp
c0102f83:	ff 70 18             	push   0x18(%eax)
c0102f86:	ff 70 1c             	push   0x1c(%eax)
c0102f89:	52                   	push   %edx
c0102f8a:	e8 c1 09 00 00       	call   c0103950 <vfs_ioctl>
c0102f8f:	83 c4 10             	add    $0x10,%esp
c0102f92:	83 c4 0c             	add    $0xc,%esp
c0102f95:	c3                   	ret
c0102f96:	66 90                	xchg   %ax,%ax
c0102f98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102f9f:	00 
c0102fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0102fa5:	eb eb                	jmp    c0102f92 <sys_ioctl+0x32>
c0102fa7:	90                   	nop
c0102fa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0102faf:	00 

c0102fb0 <sys_close>:
c0102fb0:	83 ec 0c             	sub    $0xc,%esp
c0102fb3:	8b 44 24 10          	mov    0x10(%esp),%eax
c0102fb7:	8b 40 14             	mov    0x14(%eax),%eax
c0102fba:	83 f8 1f             	cmp    $0x1f,%eax
c0102fbd:	77 42                	ja     c0103001 <sys_close+0x51>
c0102fbf:	8b 15 80 35 11 c0    	mov    0xc0113580,%edx
c0102fc5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102fc9:	8d 58 08             	lea    0x8(%eax),%ebx
c0102fcc:	8b 52 40             	mov    0x40(%edx),%edx
c0102fcf:	8b 44 9a 0c          	mov    0xc(%edx,%ebx,4),%eax
c0102fd3:	85 c0                	test   %eax,%eax
c0102fd5:	74 26                	je     c0102ffd <sys_close+0x4d>
c0102fd7:	83 ec 0c             	sub    $0xc,%esp
c0102fda:	50                   	push   %eax
c0102fdb:	e8 20 09 00 00       	call   c0103900 <vfs_close>
c0102fe0:	a1 80 35 11 c0       	mov    0xc0113580,%eax
c0102fe5:	83 c4 10             	add    $0x10,%esp
c0102fe8:	8b 40 40             	mov    0x40(%eax),%eax
c0102feb:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
c0102ff2:	00 
c0102ff3:	8b 5c 24 08          	mov    0x8(%esp),%ebx
c0102ff7:	31 c0                	xor    %eax,%eax
c0102ff9:	83 c4 0c             	add    $0xc,%esp
c0102ffc:	c3                   	ret
c0102ffd:	8b 5c 24 08          	mov    0x8(%esp),%ebx
c0103001:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0103006:	eb f1                	jmp    c0102ff9 <sys_close+0x49>
c0103008:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010300f:	00 

c0103010 <sys_read>:
c0103010:	83 ec 0c             	sub    $0xc,%esp
c0103013:	8b 44 24 10          	mov    0x10(%esp),%eax
c0103017:	89 1c 24             	mov    %ebx,(%esp)
c010301a:	8b 58 14             	mov    0x14(%eax),%ebx
c010301d:	83 fb 1f             	cmp    $0x1f,%ebx
c0103020:	77 56                	ja     c0103078 <sys_read+0x68>
c0103022:	89 74 24 04          	mov    %esi,0x4(%esp)
c0103026:	8b 70 1c             	mov    0x1c(%eax),%esi
c0103029:	89 7c 24 08          	mov    %edi,0x8(%esp)
c010302d:	8b 78 18             	mov    0x18(%eax),%edi
c0103030:	83 ec 08             	sub    $0x8,%esp
c0103033:	57                   	push   %edi
c0103034:	56                   	push   %esi
c0103035:	e8 76 02 00 00       	call   c01032b0 <user_ptr_valid>
c010303a:	83 c4 10             	add    $0x10,%esp
c010303d:	84 c0                	test   %al,%al
c010303f:	74 2f                	je     c0103070 <sys_read+0x60>
c0103041:	a1 80 35 11 c0       	mov    0xc0113580,%eax
c0103046:	8b 40 40             	mov    0x40(%eax),%eax
c0103049:	8b 44 98 2c          	mov    0x2c(%eax,%ebx,4),%eax
c010304d:	85 c0                	test   %eax,%eax
c010304f:	74 1f                	je     c0103070 <sys_read+0x60>
c0103051:	83 ec 04             	sub    $0x4,%esp
c0103054:	57                   	push   %edi
c0103055:	56                   	push   %esi
c0103056:	50                   	push   %eax
c0103057:	e8 04 08 00 00       	call   c0103860 <vfs_read>
c010305c:	83 c4 10             	add    $0x10,%esp
c010305f:	8b 74 24 04          	mov    0x4(%esp),%esi
c0103063:	8b 7c 24 08          	mov    0x8(%esp),%edi
c0103067:	8b 1c 24             	mov    (%esp),%ebx
c010306a:	83 c4 0c             	add    $0xc,%esp
c010306d:	c3                   	ret
c010306e:	66 90                	xchg   %ax,%ax
c0103070:	8b 74 24 04          	mov    0x4(%esp),%esi
c0103074:	8b 7c 24 08          	mov    0x8(%esp),%edi
c0103078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010307d:	eb e8                	jmp    c0103067 <sys_read+0x57>
c010307f:	90                   	nop

c0103080 <sys_open>:
c0103080:	56                   	push   %esi
c0103081:	53                   	push   %ebx
c0103082:	83 ec 0c             	sub    $0xc,%esp
c0103085:	8b 44 24 18          	mov    0x18(%esp),%eax
c0103089:	8b 58 14             	mov    0x14(%eax),%ebx
c010308c:	8b 70 1c             	mov    0x1c(%eax),%esi
c010308f:	6a 01                	push   $0x1
c0103091:	53                   	push   %ebx
c0103092:	e8 19 02 00 00       	call   c01032b0 <user_ptr_valid>
c0103097:	83 c4 10             	add    $0x10,%esp
c010309a:	84 c0                	test   %al,%al
c010309c:	74 4e                	je     c01030ec <sys_open+0x6c>
c010309e:	83 ec 08             	sub    $0x8,%esp
c01030a1:	56                   	push   %esi
c01030a2:	53                   	push   %ebx
c01030a3:	e8 08 07 00 00       	call   c01037b0 <vfs_open>
c01030a8:	83 c4 10             	add    $0x10,%esp
c01030ab:	89 c1                	mov    %eax,%ecx
c01030ad:	85 c0                	test   %eax,%eax
c01030af:	74 3b                	je     c01030ec <sys_open+0x6c>
c01030b1:	a1 80 35 11 c0       	mov    0xc0113580,%eax
c01030b6:	8b 50 40             	mov    0x40(%eax),%edx
c01030b9:	31 c0                	xor    %eax,%eax
c01030bb:	eb 0b                	jmp    c01030c8 <sys_open+0x48>
c01030bd:	8d 76 00             	lea    0x0(%esi),%esi
c01030c0:	83 c0 01             	add    $0x1,%eax
c01030c3:	83 f8 20             	cmp    $0x20,%eax
c01030c6:	74 18                	je     c01030e0 <sys_open+0x60>
c01030c8:	8b 5c 82 2c          	mov    0x2c(%edx,%eax,4),%ebx
c01030cc:	85 db                	test   %ebx,%ebx
c01030ce:	75 f0                	jne    c01030c0 <sys_open+0x40>
c01030d0:	89 4c 82 2c          	mov    %ecx,0x2c(%edx,%eax,4)
c01030d4:	83 c4 04             	add    $0x4,%esp
c01030d7:	5b                   	pop    %ebx
c01030d8:	5e                   	pop    %esi
c01030d9:	c3                   	ret
c01030da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c01030e0:	83 ec 0c             	sub    $0xc,%esp
c01030e3:	51                   	push   %ecx
c01030e4:	e8 17 08 00 00       	call   c0103900 <vfs_close>
c01030e9:	83 c4 10             	add    $0x10,%esp
c01030ec:	83 c4 04             	add    $0x4,%esp
c01030ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01030f4:	5b                   	pop    %ebx
c01030f5:	5e                   	pop    %esi
c01030f6:	c3                   	ret
c01030f7:	90                   	nop
c01030f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01030ff:	00 

c0103100 <sys_yield>:
c0103100:	83 ec 0c             	sub    $0xc,%esp
c0103103:	e8 b8 1d 00 00       	call   c0104ec0 <scheduler_yield>
c0103108:	31 c0                	xor    %eax,%eax
c010310a:	83 c4 0c             	add    $0xc,%esp
c010310d:	c3                   	ret
c010310e:	66 90                	xchg   %ax,%ax

c0103110 <sys_write>:
c0103110:	83 ec 0c             	sub    $0xc,%esp
c0103113:	8b 44 24 10          	mov    0x10(%esp),%eax
c0103117:	89 1c 24             	mov    %ebx,(%esp)
c010311a:	8b 58 14             	mov    0x14(%eax),%ebx
c010311d:	83 fb 1f             	cmp    $0x1f,%ebx
c0103120:	77 56                	ja     c0103178 <sys_write+0x68>
c0103122:	89 74 24 04          	mov    %esi,0x4(%esp)
c0103126:	8b 70 1c             	mov    0x1c(%eax),%esi
c0103129:	89 7c 24 08          	mov    %edi,0x8(%esp)
c010312d:	8b 78 18             	mov    0x18(%eax),%edi
c0103130:	83 ec 08             	sub    $0x8,%esp
c0103133:	57                   	push   %edi
c0103134:	56                   	push   %esi
c0103135:	e8 76 01 00 00       	call   c01032b0 <user_ptr_valid>
c010313a:	83 c4 10             	add    $0x10,%esp
c010313d:	84 c0                	test   %al,%al
c010313f:	74 2f                	je     c0103170 <sys_write+0x60>
c0103141:	a1 80 35 11 c0       	mov    0xc0113580,%eax
c0103146:	8b 40 40             	mov    0x40(%eax),%eax
c0103149:	8b 44 98 2c          	mov    0x2c(%eax,%ebx,4),%eax
c010314d:	85 c0                	test   %eax,%eax
c010314f:	74 1f                	je     c0103170 <sys_write+0x60>
c0103151:	83 ec 04             	sub    $0x4,%esp
c0103154:	57                   	push   %edi
c0103155:	56                   	push   %esi
c0103156:	50                   	push   %eax
c0103157:	e8 54 07 00 00       	call   c01038b0 <vfs_write>
c010315c:	83 c4 10             	add    $0x10,%esp
c010315f:	8b 74 24 04          	mov    0x4(%esp),%esi
c0103163:	8b 7c 24 08          	mov    0x8(%esp),%edi
c0103167:	8b 1c 24             	mov    (%esp),%ebx
c010316a:	83 c4 0c             	add    $0xc,%esp
c010316d:	c3                   	ret
c010316e:	66 90                	xchg   %ax,%ax
c0103170:	8b 74 24 04          	mov    0x4(%esp),%esi
c0103174:	8b 7c 24 08          	mov    0x8(%esp),%edi
c0103178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010317d:	eb e8                	jmp    c0103167 <sys_write+0x57>
c010317f:	90                   	nop

c0103180 <sys_exit>:
c0103180:	83 ec 18             	sub    $0x18,%esp
c0103183:	8b 44 24 1c          	mov    0x1c(%esp),%eax
c0103187:	ff 70 14             	push   0x14(%eax)
c010318a:	e8 b1 16 00 00       	call   c0104840 <process_exit>
c010318f:	31 c0                	xor    %eax,%eax
c0103191:	83 c4 1c             	add    $0x1c,%esp
c0103194:	c3                   	ret
c0103195:	8d 76 00             	lea    0x0(%esi),%esi
c0103198:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010319f:	00 

c01031a0 <syscall_handler>:
c01031a0:	53                   	push   %ebx
c01031a1:	83 ec 08             	sub    $0x8,%esp
c01031a4:	8b 5c 24 10          	mov    0x10(%esp),%ebx
c01031a8:	8b 43 20             	mov    0x20(%ebx),%eax
c01031ab:	3d ff 00 00 00       	cmp    $0xff,%eax
c01031b0:	77 1e                	ja     c01031d0 <syscall_handler+0x30>
c01031b2:	8b 14 85 00 30 11 c0 	mov    -0x3feed000(,%eax,4),%edx
c01031b9:	85 d2                	test   %edx,%edx
c01031bb:	74 13                	je     c01031d0 <syscall_handler+0x30>
c01031bd:	83 ec 0c             	sub    $0xc,%esp
c01031c0:	53                   	push   %ebx
c01031c1:	ff d2                	call   *%edx
c01031c3:	83 c4 10             	add    $0x10,%esp
c01031c6:	89 43 20             	mov    %eax,0x20(%ebx)
c01031c9:	83 c4 08             	add    $0x8,%esp
c01031cc:	5b                   	pop    %ebx
c01031cd:	c3                   	ret
c01031ce:	66 90                	xchg   %ax,%ax
c01031d0:	83 ec 08             	sub    $0x8,%esp
c01031d3:	50                   	push   %eax
c01031d4:	68 46 79 10 c0       	push   $0xc0107946
c01031d9:	e8 d2 e8 ff ff       	call   c0101ab0 <log_error>
c01031de:	83 c4 10             	add    $0x10,%esp
c01031e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01031e6:	89 43 20             	mov    %eax,0x20(%ebx)
c01031e9:	83 c4 08             	add    $0x8,%esp
c01031ec:	5b                   	pop    %ebx
c01031ed:	c3                   	ret
c01031ee:	66 90                	xchg   %ax,%ax

c01031f0 <register_syscall>:
c01031f0:	8b 44 24 04          	mov    0x4(%esp),%eax
c01031f4:	3d ff 00 00 00       	cmp    $0xff,%eax
c01031f9:	77 0b                	ja     c0103206 <register_syscall+0x16>
c01031fb:	8b 54 24 08          	mov    0x8(%esp),%edx
c01031ff:	89 14 85 00 30 11 c0 	mov    %edx,-0x3feed000(,%eax,4)
c0103206:	c3                   	ret
c0103207:	90                   	nop
c0103208:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010320f:	00 

c0103210 <syscall_init>:
c0103210:	83 ec 0c             	sub    $0xc,%esp
c0103213:	31 c0                	xor    %eax,%eax
c0103215:	8d 76 00             	lea    0x0(%esi),%esi
c0103218:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010321f:	00 
c0103220:	c7 04 85 00 30 11 c0 	movl   $0x0,-0x3feed000(,%eax,4)
c0103227:	00 00 00 00 
c010322b:	c7 04 85 04 30 11 c0 	movl   $0x0,-0x3feecffc(,%eax,4)
c0103232:	00 00 00 00 
c0103236:	83 c0 02             	add    $0x2,%eax
c0103239:	3d 00 01 00 00       	cmp    $0x100,%eax
c010323e:	75 e0                	jne    c0103220 <syscall_init+0x10>
c0103240:	83 ec 08             	sub    $0x8,%esp
c0103243:	68 a0 31 10 c0       	push   $0xc01031a0
c0103248:	68 80 00 00 00       	push   $0x80
c010324d:	e8 4e e6 ff ff       	call   c01018a0 <register_interrupt_handler>
c0103252:	c7 04 24 5a 79 10 c0 	movl   $0xc010795a,(%esp)
c0103259:	c7 05 00 30 11 c0 80 	movl   $0xc0103180,0xc0113000
c0103260:	31 10 c0 
c0103263:	c7 05 04 30 11 c0 10 	movl   $0xc0103110,0xc0113004
c010326a:	31 10 c0 
c010326d:	c7 05 08 30 11 c0 00 	movl   $0xc0103100,0xc0113008
c0103274:	31 10 c0 
c0103277:	c7 05 0c 30 11 c0 80 	movl   $0xc0103080,0xc011300c
c010327e:	30 10 c0 
c0103281:	c7 05 10 30 11 c0 10 	movl   $0xc0103010,0xc0113010
c0103288:	30 10 c0 
c010328b:	c7 05 14 30 11 c0 b0 	movl   $0xc0102fb0,0xc0113014
c0103292:	2f 10 c0 
c0103295:	c7 05 18 30 11 c0 60 	movl   $0xc0102f60,0xc0113018
c010329c:	2f 10 c0 
c010329f:	e8 ac e7 ff ff       	call   c0101a50 <log_info>
c01032a4:	83 c4 1c             	add    $0x1c,%esp
c01032a7:	c3                   	ret
c01032a8:	66 90                	xchg   %ax,%ax
c01032aa:	66 90                	xchg   %ax,%ax
c01032ac:	66 90                	xchg   %ax,%ax
c01032ae:	66 90                	xchg   %ax,%ax

c01032b0 <user_ptr_valid>:
c01032b0:	8b 44 24 08          	mov    0x8(%esp),%eax
c01032b4:	31 d2                	xor    %edx,%edx
c01032b6:	03 44 24 04          	add    0x4(%esp),%eax
c01032ba:	0f 92 c2             	setb   %dl
c01032bd:	3d 00 00 00 c0       	cmp    $0xc0000000,%eax
c01032c2:	0f 97 c0             	seta   %al
c01032c5:	09 d0                	or     %edx,%eax
c01032c7:	83 f0 01             	xor    $0x1,%eax
c01032ca:	c3                   	ret
c01032cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

c01032d0 <copy_from_user>:
c01032d0:	53                   	push   %ebx
c01032d1:	83 ec 08             	sub    $0x8,%esp
c01032d4:	8b 44 24 18          	mov    0x18(%esp),%eax
c01032d8:	8b 54 24 14          	mov    0x14(%esp),%edx
c01032dc:	89 c1                	mov    %eax,%ecx
c01032de:	01 d1                	add    %edx,%ecx
c01032e0:	0f 92 c3             	setb   %bl
c01032e3:	81 f9 00 00 00 c0    	cmp    $0xc0000000,%ecx
c01032e9:	77 25                	ja     c0103310 <copy_from_user+0x40>
c01032eb:	0f b6 db             	movzbl %bl,%ebx
c01032ee:	85 db                	test   %ebx,%ebx
c01032f0:	75 1e                	jne    c0103310 <copy_from_user+0x40>
c01032f2:	83 ec 04             	sub    $0x4,%esp
c01032f5:	50                   	push   %eax
c01032f6:	52                   	push   %edx
c01032f7:	ff 74 24 1c          	push   0x1c(%esp)
c01032fb:	e8 e0 dd ff ff       	call   c01010e0 <memcpy>
c0103300:	83 c4 10             	add    $0x10,%esp
c0103303:	31 c0                	xor    %eax,%eax
c0103305:	83 c4 08             	add    $0x8,%esp
c0103308:	5b                   	pop    %ebx
c0103309:	c3                   	ret
c010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0103310:	83 c4 08             	add    $0x8,%esp
c0103313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0103318:	5b                   	pop    %ebx
c0103319:	c3                   	ret
c010331a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

c0103320 <copy_to_user>:
c0103320:	53                   	push   %ebx
c0103321:	83 ec 08             	sub    $0x8,%esp
c0103324:	8b 44 24 18          	mov    0x18(%esp),%eax
c0103328:	8b 54 24 10          	mov    0x10(%esp),%edx
c010332c:	89 c1                	mov    %eax,%ecx
c010332e:	01 d1                	add    %edx,%ecx
c0103330:	0f 92 c3             	setb   %bl
c0103333:	81 f9 00 00 00 c0    	cmp    $0xc0000000,%ecx
c0103339:	77 25                	ja     c0103360 <copy_to_user+0x40>
c010333b:	0f b6 db             	movzbl %bl,%ebx
c010333e:	85 db                	test   %ebx,%ebx
c0103340:	75 1e                	jne    c0103360 <copy_to_user+0x40>
c0103342:	83 ec 04             	sub    $0x4,%esp
c0103345:	50                   	push   %eax
c0103346:	ff 74 24 1c          	push   0x1c(%esp)
c010334a:	52                   	push   %edx
c010334b:	e8 90 dd ff ff       	call   c01010e0 <memcpy>
c0103350:	83 c4 10             	add    $0x10,%esp
c0103353:	31 c0                	xor    %eax,%eax
c0103355:	83 c4 08             	add    $0x8,%esp
c0103358:	5b                   	pop    %ebx
c0103359:	c3                   	ret
c010335a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0103360:	83 c4 08             	add    $0x8,%esp
c0103363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0103368:	5b                   	pop    %ebx
c0103369:	c3                   	ret
c010336a:	66 90                	xchg   %ax,%ax
c010336c:	66 90                	xchg   %ax,%ax
c010336e:	66 90                	xchg   %ax,%ax

c0103370 <vfs_init>:
c0103370:	83 ec 18             	sub    $0x18,%esp
c0103373:	c7 05 60 34 11 c0 00 	movl   $0x0,0xc0113460
c010337a:	00 00 00 
c010337d:	68 74 79 10 c0       	push   $0xc0107974
c0103382:	c7 05 00 34 11 c0 00 	movl   $0x0,0xc0113400
c0103389:	00 00 00 
c010338c:	e8 bf e6 ff ff       	call   c0101a50 <log_info>
c0103391:	83 c4 1c             	add    $0x1c,%esp
c0103394:	c3                   	ret
c0103395:	8d 76 00             	lea    0x0(%esi),%esi
c0103398:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010339f:	00 

c01033a0 <vfs_register_fs>:
c01033a0:	a1 00 34 11 c0       	mov    0xc0113400,%eax
c01033a5:	83 f8 0f             	cmp    $0xf,%eax
c01033a8:	7e 06                	jle    c01033b0 <vfs_register_fs+0x10>
c01033aa:	c3                   	ret
c01033ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c01033b0:	83 ec 14             	sub    $0x14,%esp
c01033b3:	8d 50 01             	lea    0x1(%eax),%edx
c01033b6:	8b 4c 24 18          	mov    0x18(%esp),%ecx
c01033ba:	89 15 00 34 11 c0    	mov    %edx,0xc0113400
c01033c0:	89 0c 85 20 34 11 c0 	mov    %ecx,-0x3feecbe0(,%eax,4)
c01033c7:	51                   	push   %ecx
c01033c8:	68 85 79 10 c0       	push   $0xc0107985
c01033cd:	e8 7e e6 ff ff       	call   c0101a50 <log_info>
c01033d2:	83 c4 1c             	add    $0x1c,%esp
c01033d5:	c3                   	ret
c01033d6:	66 90                	xchg   %ax,%ax
c01033d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01033df:	00 

c01033e0 <vfs_mount>:
c01033e0:	83 ec 1c             	sub    $0x1c,%esp
c01033e3:	a1 00 34 11 c0       	mov    0xc0113400,%eax
c01033e8:	89 7c 24 14          	mov    %edi,0x14(%esp)
c01033ec:	8b 7c 24 24          	mov    0x24(%esp),%edi
c01033f0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01033f4:	85 c0                	test   %eax,%eax
c01033f6:	0f 8e c8 00 00 00    	jle    c01034c4 <vfs_mount+0xe4>
c01033fc:	89 74 24 10          	mov    %esi,0x10(%esp)
c0103400:	31 f6                	xor    %esi,%esi
c0103402:	eb 13                	jmp    c0103417 <vfs_mount+0x37>
c0103404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0103408:	83 c6 01             	add    $0x1,%esi
c010340b:	3b 35 00 34 11 c0    	cmp    0xc0113400,%esi
c0103411:	0f 8d a9 00 00 00    	jge    c01034c0 <vfs_mount+0xe0>
c0103417:	83 ec 08             	sub    $0x8,%esp
c010341a:	57                   	push   %edi
c010341b:	ff 34 b5 20 34 11 c0 	push   -0x3feecbe0(,%esi,4)
c0103422:	e8 09 dc ff ff       	call   c0101030 <strcmp>
c0103427:	83 c4 10             	add    $0x10,%esp
c010342a:	89 c3                	mov    %eax,%ebx
c010342c:	85 c0                	test   %eax,%eax
c010342e:	75 d8                	jne    c0103408 <vfs_mount+0x28>
c0103430:	8b 04 b5 20 34 11 c0 	mov    -0x3feecbe0(,%esi,4),%eax
c0103437:	89 6c 24 18          	mov    %ebp,0x18(%esp)
c010343b:	85 c0                	test   %eax,%eax
c010343d:	0f 84 b8 00 00 00    	je     c01034fb <vfs_mount+0x11b>
c0103443:	83 ec 0c             	sub    $0xc,%esp
c0103446:	ff 74 24 34          	push   0x34(%esp)
c010344a:	ff 50 20             	call   *0x20(%eax)
c010344d:	89 c5                	mov    %eax,%ebp
c010344f:	83 c4 10             	add    $0x10,%esp
c0103452:	85 c0                	test   %eax,%eax
c0103454:	0f 84 82 00 00 00    	je     c01034dc <vfs_mount+0xfc>
c010345a:	83 ec 08             	sub    $0x8,%esp
c010345d:	6a 00                	push   $0x0
c010345f:	68 88 00 00 00       	push   $0x88
c0103464:	e8 b7 f2 ff ff       	call   c0102720 <kmalloc>
c0103469:	83 c4 0c             	add    $0xc,%esp
c010346c:	6a 7f                	push   $0x7f
c010346e:	89 c6                	mov    %eax,%esi
c0103470:	ff 74 24 28          	push   0x28(%esp)
c0103474:	50                   	push   %eax
c0103475:	e8 46 db ff ff       	call   c0100fc0 <strncpy>
c010347a:	a1 60 34 11 c0       	mov    0xc0113460,%eax
c010347f:	83 c4 0c             	add    $0xc,%esp
c0103482:	c6 46 7f 00          	movb   $0x0,0x7f(%esi)
c0103486:	89 ae 80 00 00 00    	mov    %ebp,0x80(%esi)
c010348c:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
c0103492:	ff 74 24 24          	push   0x24(%esp)
c0103496:	57                   	push   %edi
c0103497:	68 d0 79 10 c0       	push   $0xc01079d0
c010349c:	89 35 60 34 11 c0    	mov    %esi,0xc0113460
c01034a2:	e8 a9 e5 ff ff       	call   c0101a50 <log_info>
c01034a7:	83 c4 10             	add    $0x10,%esp
c01034aa:	8b 74 24 10          	mov    0x10(%esp),%esi
c01034ae:	8b 6c 24 18          	mov    0x18(%esp),%ebp
c01034b2:	89 d8                	mov    %ebx,%eax
c01034b4:	8b 7c 24 14          	mov    0x14(%esp),%edi
c01034b8:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
c01034bc:	83 c4 1c             	add    $0x1c,%esp
c01034bf:	c3                   	ret
c01034c0:	8b 74 24 10          	mov    0x10(%esp),%esi
c01034c4:	83 ec 08             	sub    $0x8,%esp
c01034c7:	57                   	push   %edi
c01034c8:	68 9f 79 10 c0       	push   $0xc010799f
c01034cd:	e8 de e5 ff ff       	call   c0101ab0 <log_error>
c01034d2:	83 c4 10             	add    $0x10,%esp
c01034d5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
c01034da:	eb d6                	jmp    c01034b2 <vfs_mount+0xd2>
c01034dc:	83 ec 04             	sub    $0x4,%esp
c01034df:	ff 74 24 24          	push   0x24(%esp)
c01034e3:	57                   	push   %edi
c01034e4:	68 b7 79 10 c0       	push   $0xc01079b7
c01034e9:	e8 c2 e5 ff ff       	call   c0101ab0 <log_error>
c01034ee:	83 c4 10             	add    $0x10,%esp
c01034f1:	8b 74 24 10          	mov    0x10(%esp),%esi
c01034f5:	8b 6c 24 18          	mov    0x18(%esp),%ebp
c01034f9:	eb da                	jmp    c01034d5 <vfs_mount+0xf5>
c01034fb:	8b 74 24 10          	mov    0x10(%esp),%esi
c01034ff:	8b 6c 24 18          	mov    0x18(%esp),%ebp
c0103503:	eb bf                	jmp    c01034c4 <vfs_mount+0xe4>
c0103505:	8d 76 00             	lea    0x0(%esi),%esi
c0103508:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010350f:	00 

c0103510 <vfs_lookup>:
c0103510:	81 ec ac 01 00 00    	sub    $0x1ac,%esp
c0103516:	89 9c 24 9c 01 00 00 	mov    %ebx,0x19c(%esp)
c010351d:	8b 9c 24 b0 01 00 00 	mov    0x1b0(%esp),%ebx
c0103524:	89 b4 24 a0 01 00 00 	mov    %esi,0x1a0(%esp)
c010352b:	0f b6 03             	movzbl (%ebx),%eax
c010352e:	3c 2f                	cmp    $0x2f,%al
c0103530:	75 19                	jne    c010354b <vfs_lookup+0x3b>
c0103532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0103538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010353f:	00 
c0103540:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
c0103544:	83 c3 01             	add    $0x1,%ebx
c0103547:	3c 2f                	cmp    $0x2f,%al
c0103549:	74 f5                	je     c0103540 <vfs_lookup+0x30>
c010354b:	84 c0                	test   %al,%al
c010354d:	75 51                	jne    c01035a0 <vfs_lookup+0x90>
c010354f:	8b 35 60 34 11 c0    	mov    0xc0113460,%esi
c0103555:	85 f6                	test   %esi,%esi
c0103557:	75 11                	jne    c010356a <vfs_lookup+0x5a>
c0103559:	eb 2a                	jmp    c0103585 <vfs_lookup+0x75>
c010355b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0103560:	8b b6 84 00 00 00    	mov    0x84(%esi),%esi
c0103566:	85 f6                	test   %esi,%esi
c0103568:	74 1b                	je     c0103585 <vfs_lookup+0x75>
c010356a:	83 ec 08             	sub    $0x8,%esp
c010356d:	68 e1 79 10 c0       	push   $0xc01079e1
c0103572:	56                   	push   %esi
c0103573:	e8 b8 da ff ff       	call   c0101030 <strcmp>
c0103578:	83 c4 10             	add    $0x10,%esp
c010357b:	85 c0                	test   %eax,%eax
c010357d:	75 e1                	jne    c0103560 <vfs_lookup+0x50>
c010357f:	8b b6 80 00 00 00    	mov    0x80(%esi),%esi
c0103585:	89 f0                	mov    %esi,%eax
c0103587:	8b 9c 24 9c 01 00 00 	mov    0x19c(%esp),%ebx
c010358e:	8b b4 24 a0 01 00 00 	mov    0x1a0(%esp),%esi
c0103595:	81 c4 ac 01 00 00    	add    $0x1ac,%esp
c010359b:	c3                   	ret
c010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c01035a0:	c6 84 24 90 00 00 00 	movb   $0x2f,0x90(%esp)
c01035a7:	2f 
c01035a8:	89 ac 24 a8 01 00 00 	mov    %ebp,0x1a8(%esp)
c01035af:	83 ec 04             	sub    $0x4,%esp
c01035b2:	68 fe 00 00 00       	push   $0xfe
c01035b7:	53                   	push   %ebx
c01035b8:	8d 84 24 9d 00 00 00 	lea    0x9d(%esp),%eax
c01035bf:	50                   	push   %eax
c01035c0:	e8 fb d9 ff ff       	call   c0100fc0 <strncpy>
c01035c5:	8b 2d 60 34 11 c0    	mov    0xc0113460,%ebp
c01035cb:	c6 84 24 9f 01 00 00 	movb   $0x0,0x19f(%esp)
c01035d2:	00 
c01035d3:	83 c4 10             	add    $0x10,%esp
c01035d6:	85 ed                	test   %ebp,%ebp
c01035d8:	0f 84 bb 01 00 00    	je     c0103799 <vfs_lookup+0x289>
c01035de:	89 bc 24 a4 01 00 00 	mov    %edi,0x1a4(%esp)
c01035e5:	31 f6                	xor    %esi,%esi
c01035e7:	31 ff                	xor    %edi,%edi
c01035e9:	89 9c 24 b0 01 00 00 	mov    %ebx,0x1b0(%esp)
c01035f0:	eb 2e                	jmp    c0103620 <vfs_lookup+0x110>
c01035f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c01035f8:	39 df                	cmp    %ebx,%edi
c01035fa:	8d 84 24 91 00 00 00 	lea    0x91(%esp),%eax
c0103601:	0f 43 84 24 b0 01 00 	cmovae 0x1b0(%esp),%eax
c0103608:	00 
c0103609:	0f 42 fb             	cmovb  %ebx,%edi
c010360c:	0f 42 f5             	cmovb  %ebp,%esi
c010360f:	89 84 24 b0 01 00 00 	mov    %eax,0x1b0(%esp)
c0103616:	8b ad 84 00 00 00    	mov    0x84(%ebp),%ebp
c010361c:	85 ed                	test   %ebp,%ebp
c010361e:	74 70                	je     c0103690 <vfs_lookup+0x180>
c0103620:	83 ec 0c             	sub    $0xc,%esp
c0103623:	55                   	push   %ebp
c0103624:	e8 37 d9 ff ff       	call   c0100f60 <strlen>
c0103629:	89 c3                	mov    %eax,%ebx
c010362b:	58                   	pop    %eax
c010362c:	5a                   	pop    %edx
c010362d:	68 e1 79 10 c0       	push   $0xc01079e1
c0103632:	55                   	push   %ebp
c0103633:	e8 f8 d9 ff ff       	call   c0101030 <strcmp>
c0103638:	83 c4 10             	add    $0x10,%esp
c010363b:	85 c0                	test   %eax,%eax
c010363d:	74 b9                	je     c01035f8 <vfs_lookup+0xe8>
c010363f:	83 ec 04             	sub    $0x4,%esp
c0103642:	53                   	push   %ebx
c0103643:	55                   	push   %ebp
c0103644:	8d 84 24 9c 00 00 00 	lea    0x9c(%esp),%eax
c010364b:	50                   	push   %eax
c010364c:	e8 3f da ff ff       	call   c0101090 <strncmp>
c0103651:	83 c4 10             	add    $0x10,%esp
c0103654:	85 c0                	test   %eax,%eax
c0103656:	75 be                	jne    c0103616 <vfs_lookup+0x106>
c0103658:	8d 94 1c 90 00 00 00 	lea    0x90(%esp,%ebx,1),%edx
c010365f:	0f b6 0a             	movzbl (%edx),%ecx
c0103662:	80 f9 2f             	cmp    $0x2f,%cl
c0103665:	0f 94 44 24 0f       	sete   0xf(%esp)
c010366a:	84 c9                	test   %cl,%cl
c010366c:	0f 94 c0             	sete   %al
c010366f:	0a 44 24 0f          	or     0xf(%esp),%al
c0103673:	74 a1                	je     c0103616 <vfs_lookup+0x106>
c0103675:	39 df                	cmp    %ebx,%edi
c0103677:	73 9d                	jae    c0103616 <vfs_lookup+0x106>
c0103679:	80 f9 2f             	cmp    $0x2f,%cl
c010367c:	0f 84 00 01 00 00    	je     c0103782 <vfs_lookup+0x272>
c0103682:	89 94 24 b0 01 00 00 	mov    %edx,0x1b0(%esp)
c0103689:	89 df                	mov    %ebx,%edi
c010368b:	89 ee                	mov    %ebp,%esi
c010368d:	eb 87                	jmp    c0103616 <vfs_lookup+0x106>
c010368f:	90                   	nop
c0103690:	8b 9c 24 b0 01 00 00 	mov    0x1b0(%esp),%ebx
c0103697:	85 f6                	test   %esi,%esi
c0103699:	0f 84 d0 00 00 00    	je     c010376f <vfs_lookup+0x25f>
c010369f:	0f b6 03             	movzbl (%ebx),%eax
c01036a2:	8b ae 80 00 00 00    	mov    0x80(%esi),%ebp
c01036a8:	84 c0                	test   %al,%al
c01036aa:	0f 84 95 00 00 00    	je     c0103745 <vfs_lookup+0x235>
c01036b0:	89 df                	mov    %ebx,%edi
c01036b2:	31 f6                	xor    %esi,%esi
c01036b4:	3c 2f                	cmp    $0x2f,%al
c01036b6:	74 30                	je     c01036e8 <vfs_lookup+0x1d8>
c01036b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01036bf:	00 
c01036c0:	89 df                	mov    %ebx,%edi
c01036c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c01036c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01036cf:	00 
c01036d0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
c01036d4:	83 c7 01             	add    $0x1,%edi
c01036d7:	84 c0                	test   %al,%al
c01036d9:	74 04                	je     c01036df <vfs_lookup+0x1cf>
c01036db:	3c 2f                	cmp    $0x2f,%al
c01036dd:	75 f1                	jne    c01036d0 <vfs_lookup+0x1c0>
c01036df:	89 fe                	mov    %edi,%esi
c01036e1:	29 de                	sub    %ebx,%esi
c01036e3:	83 fe 7f             	cmp    $0x7f,%esi
c01036e6:	77 72                	ja     c010375a <vfs_lookup+0x24a>
c01036e8:	83 ec 04             	sub    $0x4,%esp
c01036eb:	56                   	push   %esi
c01036ec:	53                   	push   %ebx
c01036ed:	8d 5c 24 1c          	lea    0x1c(%esp),%ebx
c01036f1:	53                   	push   %ebx
c01036f2:	e8 e9 d9 ff ff       	call   c01010e0 <memcpy>
c01036f7:	c6 44 34 20 00       	movb   $0x0,0x20(%esp,%esi,1)
c01036fc:	8b b5 9c 00 00 00    	mov    0x9c(%ebp),%esi
c0103702:	83 c4 10             	add    $0x10,%esp
c0103705:	85 f6                	test   %esi,%esi
c0103707:	74 66                	je     c010376f <vfs_lookup+0x25f>
c0103709:	8b 46 14             	mov    0x14(%esi),%eax
c010370c:	85 c0                	test   %eax,%eax
c010370e:	74 4a                	je     c010375a <vfs_lookup+0x24a>
c0103710:	83 ec 08             	sub    $0x8,%esp
c0103713:	53                   	push   %ebx
c0103714:	55                   	push   %ebp
c0103715:	ff d0                	call   *%eax
c0103717:	89 c5                	mov    %eax,%ebp
c0103719:	83 c4 10             	add    $0x10,%esp
c010371c:	85 c0                	test   %eax,%eax
c010371e:	74 25                	je     c0103745 <vfs_lookup+0x235>
c0103720:	0f b6 07             	movzbl (%edi),%eax
c0103723:	3c 2f                	cmp    $0x2f,%al
c0103725:	75 14                	jne    c010373b <vfs_lookup+0x22b>
c0103727:	90                   	nop
c0103728:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010372f:	00 
c0103730:	0f b6 47 01          	movzbl 0x1(%edi),%eax
c0103734:	83 c7 01             	add    $0x1,%edi
c0103737:	3c 2f                	cmp    $0x2f,%al
c0103739:	74 f5                	je     c0103730 <vfs_lookup+0x220>
c010373b:	89 fb                	mov    %edi,%ebx
c010373d:	84 c0                	test   %al,%al
c010373f:	0f 85 7b ff ff ff    	jne    c01036c0 <vfs_lookup+0x1b0>
c0103745:	89 ee                	mov    %ebp,%esi
c0103747:	8b bc 24 a4 01 00 00 	mov    0x1a4(%esp),%edi
c010374e:	8b ac 24 a8 01 00 00 	mov    0x1a8(%esp),%ebp
c0103755:	e9 2b fe ff ff       	jmp    c0103585 <vfs_lookup+0x75>
c010375a:	8b bc 24 a4 01 00 00 	mov    0x1a4(%esp),%edi
c0103761:	8b ac 24 a8 01 00 00 	mov    0x1a8(%esp),%ebp
c0103768:	31 f6                	xor    %esi,%esi
c010376a:	e9 16 fe ff ff       	jmp    c0103585 <vfs_lookup+0x75>
c010376f:	8b bc 24 a4 01 00 00 	mov    0x1a4(%esp),%edi
c0103776:	8b ac 24 a8 01 00 00 	mov    0x1a8(%esp),%ebp
c010377d:	e9 03 fe ff ff       	jmp    c0103585 <vfs_lookup+0x75>
c0103782:	8d 84 1c 91 00 00 00 	lea    0x91(%esp,%ebx,1),%eax
c0103789:	89 df                	mov    %ebx,%edi
c010378b:	89 ee                	mov    %ebp,%esi
c010378d:	89 84 24 b0 01 00 00 	mov    %eax,0x1b0(%esp)
c0103794:	e9 7d fe ff ff       	jmp    c0103616 <vfs_lookup+0x106>
c0103799:	8b ac 24 a8 01 00 00 	mov    0x1a8(%esp),%ebp
c01037a0:	31 f6                	xor    %esi,%esi
c01037a2:	e9 de fd ff ff       	jmp    c0103585 <vfs_lookup+0x75>
c01037a7:	90                   	nop
c01037a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01037af:	00 

c01037b0 <vfs_open>:
c01037b0:	83 ec 28             	sub    $0x28,%esp
c01037b3:	ff 74 24 2c          	push   0x2c(%esp)
c01037b7:	e8 54 fd ff ff       	call   c0103510 <vfs_lookup>
c01037bc:	83 c4 10             	add    $0x10,%esp
c01037bf:	85 c0                	test   %eax,%eax
c01037c1:	74 6d                	je     c0103830 <vfs_open+0x80>
c01037c3:	89 5c 24 18          	mov    %ebx,0x18(%esp)
c01037c7:	83 ec 08             	sub    $0x8,%esp
c01037ca:	89 c3                	mov    %eax,%ebx
c01037cc:	6a 00                	push   $0x0
c01037ce:	6a 10                	push   $0x10
c01037d0:	e8 4b ef ff ff       	call   c0102720 <kmalloc>
c01037d5:	83 c4 10             	add    $0x10,%esp
c01037d8:	89 c2                	mov    %eax,%edx
c01037da:	85 c0                	test   %eax,%eax
c01037dc:	74 3e                	je     c010381c <vfs_open+0x6c>
c01037de:	89 18                	mov    %ebx,(%eax)
c01037e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
c01037e7:	8b 44 24 24          	mov    0x24(%esp),%eax
c01037eb:	c7 42 0c 01 00 00 00 	movl   $0x1,0xc(%edx)
c01037f2:	89 42 08             	mov    %eax,0x8(%edx)
c01037f5:	8b 83 9c 00 00 00    	mov    0x9c(%ebx),%eax
c01037fb:	85 c0                	test   %eax,%eax
c01037fd:	74 1d                	je     c010381c <vfs_open+0x6c>
c01037ff:	8b 40 08             	mov    0x8(%eax),%eax
c0103802:	85 c0                	test   %eax,%eax
c0103804:	74 16                	je     c010381c <vfs_open+0x6c>
c0103806:	83 ec 08             	sub    $0x8,%esp
c0103809:	52                   	push   %edx
c010380a:	89 54 24 18          	mov    %edx,0x18(%esp)
c010380e:	53                   	push   %ebx
c010380f:	ff d0                	call   *%eax
c0103811:	8b 54 24 1c          	mov    0x1c(%esp),%edx
c0103815:	83 c4 10             	add    $0x10,%esp
c0103818:	85 c0                	test   %eax,%eax
c010381a:	75 24                	jne    c0103840 <vfs_open+0x90>
c010381c:	8b 5c 24 18          	mov    0x18(%esp),%ebx
c0103820:	89 d0                	mov    %edx,%eax
c0103822:	83 c4 1c             	add    $0x1c,%esp
c0103825:	c3                   	ret
c0103826:	66 90                	xchg   %ax,%ax
c0103828:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010382f:	00 
c0103830:	31 d2                	xor    %edx,%edx
c0103832:	83 c4 1c             	add    $0x1c,%esp
c0103835:	89 d0                	mov    %edx,%eax
c0103837:	c3                   	ret
c0103838:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010383f:	00 
c0103840:	83 ec 0c             	sub    $0xc,%esp
c0103843:	52                   	push   %edx
c0103844:	e8 f7 ef ff ff       	call   c0102840 <kfree>
c0103849:	83 c4 10             	add    $0x10,%esp
c010384c:	31 d2                	xor    %edx,%edx
c010384e:	8b 5c 24 18          	mov    0x18(%esp),%ebx
c0103852:	eb cc                	jmp    c0103820 <vfs_open+0x70>
c0103854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0103858:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010385f:	00 

c0103860 <vfs_read>:
c0103860:	53                   	push   %ebx
c0103861:	83 ec 08             	sub    $0x8,%esp
c0103864:	8b 5c 24 10          	mov    0x10(%esp),%ebx
c0103868:	85 db                	test   %ebx,%ebx
c010386a:	74 34                	je     c01038a0 <vfs_read+0x40>
c010386c:	8b 03                	mov    (%ebx),%eax
c010386e:	85 c0                	test   %eax,%eax
c0103870:	74 2e                	je     c01038a0 <vfs_read+0x40>
c0103872:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
c0103878:	85 c0                	test   %eax,%eax
c010387a:	74 24                	je     c01038a0 <vfs_read+0x40>
c010387c:	8b 00                	mov    (%eax),%eax
c010387e:	85 c0                	test   %eax,%eax
c0103880:	74 1e                	je     c01038a0 <vfs_read+0x40>
c0103882:	ff 73 04             	push   0x4(%ebx)
c0103885:	ff 74 24 1c          	push   0x1c(%esp)
c0103889:	ff 74 24 1c          	push   0x1c(%esp)
c010388d:	53                   	push   %ebx
c010388e:	ff d0                	call   *%eax
c0103890:	83 c4 10             	add    $0x10,%esp
c0103893:	85 c0                	test   %eax,%eax
c0103895:	7e 03                	jle    c010389a <vfs_read+0x3a>
c0103897:	01 43 04             	add    %eax,0x4(%ebx)
c010389a:	83 c4 08             	add    $0x8,%esp
c010389d:	5b                   	pop    %ebx
c010389e:	c3                   	ret
c010389f:	90                   	nop
c01038a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01038a5:	eb f3                	jmp    c010389a <vfs_read+0x3a>
c01038a7:	90                   	nop
c01038a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01038af:	00 

c01038b0 <vfs_write>:
c01038b0:	53                   	push   %ebx
c01038b1:	83 ec 08             	sub    $0x8,%esp
c01038b4:	8b 5c 24 10          	mov    0x10(%esp),%ebx
c01038b8:	85 db                	test   %ebx,%ebx
c01038ba:	74 34                	je     c01038f0 <vfs_write+0x40>
c01038bc:	8b 03                	mov    (%ebx),%eax
c01038be:	85 c0                	test   %eax,%eax
c01038c0:	74 2e                	je     c01038f0 <vfs_write+0x40>
c01038c2:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
c01038c8:	85 c0                	test   %eax,%eax
c01038ca:	74 24                	je     c01038f0 <vfs_write+0x40>
c01038cc:	8b 40 04             	mov    0x4(%eax),%eax
c01038cf:	85 c0                	test   %eax,%eax
c01038d1:	74 1d                	je     c01038f0 <vfs_write+0x40>
c01038d3:	ff 73 04             	push   0x4(%ebx)
c01038d6:	ff 74 24 1c          	push   0x1c(%esp)
c01038da:	ff 74 24 1c          	push   0x1c(%esp)
c01038de:	53                   	push   %ebx
c01038df:	ff d0                	call   *%eax
c01038e1:	83 c4 10             	add    $0x10,%esp
c01038e4:	85 c0                	test   %eax,%eax
c01038e6:	7e 03                	jle    c01038eb <vfs_write+0x3b>
c01038e8:	01 43 04             	add    %eax,0x4(%ebx)
c01038eb:	83 c4 08             	add    $0x8,%esp
c01038ee:	5b                   	pop    %ebx
c01038ef:	c3                   	ret
c01038f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01038f5:	eb f4                	jmp    c01038eb <vfs_write+0x3b>
c01038f7:	90                   	nop
c01038f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01038ff:	00 

c0103900 <vfs_close>:
c0103900:	83 ec 1c             	sub    $0x1c,%esp
c0103903:	8b 44 24 20          	mov    0x20(%esp),%eax
c0103907:	85 c0                	test   %eax,%eax
c0103909:	74 3d                	je     c0103948 <vfs_close+0x48>
c010390b:	83 68 0c 01          	subl   $0x1,0xc(%eax)
c010390f:	75 37                	jne    c0103948 <vfs_close+0x48>
c0103911:	8b 10                	mov    (%eax),%edx
c0103913:	85 d2                	test   %edx,%edx
c0103915:	74 22                	je     c0103939 <vfs_close+0x39>
c0103917:	8b 92 9c 00 00 00    	mov    0x9c(%edx),%edx
c010391d:	85 d2                	test   %edx,%edx
c010391f:	74 18                	je     c0103939 <vfs_close+0x39>
c0103921:	8b 52 0c             	mov    0xc(%edx),%edx
c0103924:	85 d2                	test   %edx,%edx
c0103926:	74 11                	je     c0103939 <vfs_close+0x39>
c0103928:	83 ec 0c             	sub    $0xc,%esp
c010392b:	50                   	push   %eax
c010392c:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103930:	ff d2                	call   *%edx
c0103932:	8b 44 24 1c          	mov    0x1c(%esp),%eax
c0103936:	83 c4 10             	add    $0x10,%esp
c0103939:	89 44 24 20          	mov    %eax,0x20(%esp)
c010393d:	83 c4 1c             	add    $0x1c,%esp
c0103940:	e9 fb ee ff ff       	jmp    c0102840 <kfree>
c0103945:	8d 76 00             	lea    0x0(%esi),%esi
c0103948:	83 c4 1c             	add    $0x1c,%esp
c010394b:	c3                   	ret
c010394c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

c0103950 <vfs_ioctl>:
c0103950:	8b 44 24 04          	mov    0x4(%esp),%eax
c0103954:	85 c0                	test   %eax,%eax
c0103956:	74 20                	je     c0103978 <vfs_ioctl+0x28>
c0103958:	8b 00                	mov    (%eax),%eax
c010395a:	85 c0                	test   %eax,%eax
c010395c:	74 1a                	je     c0103978 <vfs_ioctl+0x28>
c010395e:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
c0103964:	85 d2                	test   %edx,%edx
c0103966:	74 10                	je     c0103978 <vfs_ioctl+0x28>
c0103968:	8b 52 18             	mov    0x18(%edx),%edx
c010396b:	85 d2                	test   %edx,%edx
c010396d:	74 09                	je     c0103978 <vfs_ioctl+0x28>
c010396f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103973:	ff e2                	jmp    *%edx
c0103975:	8d 76 00             	lea    0x0(%esi),%esi
c0103978:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010397d:	c3                   	ret
c010397e:	66 90                	xchg   %ax,%ax

c0103980 <ramfs_mount_cb>:
c0103980:	a1 80 34 11 c0       	mov    0xc0113480,%eax
c0103985:	85 c0                	test   %eax,%eax
c0103987:	74 07                	je     c0103990 <ramfs_mount_cb+0x10>
c0103989:	c3                   	ret
c010398a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0103990:	83 ec 24             	sub    $0x24,%esp
c0103993:	6a 00                	push   $0x0
c0103995:	68 a0 00 00 00       	push   $0xa0
c010399a:	e8 81 ed ff ff       	call   c0102720 <kmalloc>
c010399f:	83 c4 0c             	add    $0xc,%esp
c01039a2:	68 a0 00 00 00       	push   $0xa0
c01039a7:	6a 00                	push   $0x0
c01039a9:	50                   	push   %eax
c01039aa:	a3 80 34 11 c0       	mov    %eax,0xc0113480
c01039af:	e8 6c d7 ff ff       	call   c0101120 <memset>
c01039b4:	58                   	pop    %eax
c01039b5:	5a                   	pop    %edx
c01039b6:	68 e1 79 10 c0       	push   $0xc01079e1
c01039bb:	ff 35 80 34 11 c0    	push   0xc0113480
c01039c1:	e8 ca d5 ff ff       	call   c0100f90 <strcpy>
c01039c6:	8b 15 18 b0 10 c0    	mov    0xc010b018,%edx
c01039cc:	a1 80 34 11 c0       	mov    0xc0113480,%eax
c01039d1:	8d 4a 01             	lea    0x1(%edx),%ecx
c01039d4:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
c01039da:	c7 80 8c 00 00 00 02 	movl   $0x2,0x8c(%eax)
c01039e1:	00 00 00 
c01039e4:	c7 80 9c 00 00 00 c4 	movl   $0xc01134c4,0x9c(%eax)
c01039eb:	34 11 c0 
c01039ee:	89 0d 18 b0 10 c0    	mov    %ecx,0xc010b018
c01039f4:	59                   	pop    %ecx
c01039f5:	58                   	pop    %eax
c01039f6:	6a 00                	push   $0x0
c01039f8:	6a 0c                	push   $0xc
c01039fa:	e8 21 ed ff ff       	call   c0102720 <kmalloc>
c01039ff:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103a03:	58                   	pop    %eax
c0103a04:	5a                   	pop    %edx
c0103a05:	6a 00                	push   $0x0
c0103a07:	6a 40                	push   $0x40
c0103a09:	e8 12 ed ff ff       	call   c0102720 <kmalloc>
c0103a0e:	8b 54 24 1c          	mov    0x1c(%esp),%edx
c0103a12:	89 02                	mov    %eax,(%edx)
c0103a14:	a1 80 34 11 c0       	mov    0xc0113480,%eax
c0103a19:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
c0103a20:	c7 42 08 10 00 00 00 	movl   $0x10,0x8(%edx)
c0103a27:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
c0103a2d:	83 c4 2c             	add    $0x2c,%esp
c0103a30:	c3                   	ret
c0103a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0103a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0103a3f:	00 

c0103a40 <ramfs_read>:
c0103a40:	83 ec 0c             	sub    $0xc,%esp
c0103a43:	8b 44 24 10          	mov    0x10(%esp),%eax
c0103a47:	8b 54 24 1c          	mov    0x1c(%esp),%edx
c0103a4b:	89 1c 24             	mov    %ebx,(%esp)
c0103a4e:	89 74 24 04          	mov    %esi,0x4(%esp)
c0103a52:	8b 5c 24 18          	mov    0x18(%esp),%ebx
c0103a56:	85 c0                	test   %eax,%eax
c0103a58:	74 65                	je     c0103abf <ramfs_read+0x7f>
c0103a5a:	8b 00                	mov    (%eax),%eax
c0103a5c:	85 c0                	test   %eax,%eax
c0103a5e:	74 5f                	je     c0103abf <ramfs_read+0x7f>
c0103a60:	83 b8 8c 00 00 00 01 	cmpl   $0x1,0x8c(%eax)
c0103a67:	75 56                	jne    c0103abf <ramfs_read+0x7f>
c0103a69:	8b 88 94 00 00 00    	mov    0x94(%eax),%ecx
c0103a6f:	31 f6                	xor    %esi,%esi
c0103a71:	39 ca                	cmp    %ecx,%edx
c0103a73:	73 39                	jae    c0103aae <ramfs_read+0x6e>
c0103a75:	89 7c 24 08          	mov    %edi,0x8(%esp)
c0103a79:	89 ce                	mov    %ecx,%esi
c0103a7b:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
c0103a7e:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
c0103a84:	29 d6                	sub    %edx,%esi
c0103a86:	39 f9                	cmp    %edi,%ecx
c0103a88:	0f 42 de             	cmovb  %esi,%ebx
c0103a8b:	85 c0                	test   %eax,%eax
c0103a8d:	74 2c                	je     c0103abb <ramfs_read+0x7b>
c0103a8f:	8b 00                	mov    (%eax),%eax
c0103a91:	85 c0                	test   %eax,%eax
c0103a93:	74 26                	je     c0103abb <ramfs_read+0x7b>
c0103a95:	83 ec 04             	sub    $0x4,%esp
c0103a98:	01 d0                	add    %edx,%eax
c0103a9a:	89 de                	mov    %ebx,%esi
c0103a9c:	53                   	push   %ebx
c0103a9d:	50                   	push   %eax
c0103a9e:	ff 74 24 20          	push   0x20(%esp)
c0103aa2:	e8 39 d6 ff ff       	call   c01010e0 <memcpy>
c0103aa7:	83 c4 10             	add    $0x10,%esp
c0103aaa:	8b 7c 24 08          	mov    0x8(%esp),%edi
c0103aae:	89 f0                	mov    %esi,%eax
c0103ab0:	8b 1c 24             	mov    (%esp),%ebx
c0103ab3:	8b 74 24 04          	mov    0x4(%esp),%esi
c0103ab7:	83 c4 0c             	add    $0xc,%esp
c0103aba:	c3                   	ret
c0103abb:	8b 7c 24 08          	mov    0x8(%esp),%edi
c0103abf:	be ff ff ff ff       	mov    $0xffffffff,%esi
c0103ac4:	eb e8                	jmp    c0103aae <ramfs_read+0x6e>
c0103ac6:	66 90                	xchg   %ax,%ax
c0103ac8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0103acf:	00 

c0103ad0 <ramfs_finddir.part.0.isra.0>:
c0103ad0:	85 c0                	test   %eax,%eax
c0103ad2:	74 52                	je     c0103b26 <ramfs_finddir.part.0.isra.0+0x56>
c0103ad4:	57                   	push   %edi
c0103ad5:	89 d7                	mov    %edx,%edi
c0103ad7:	56                   	push   %esi
c0103ad8:	89 c6                	mov    %eax,%esi
c0103ada:	53                   	push   %ebx
c0103adb:	8b 40 04             	mov    0x4(%eax),%eax
c0103ade:	31 db                	xor    %ebx,%ebx
c0103ae0:	85 c0                	test   %eax,%eax
c0103ae2:	75 14                	jne    c0103af8 <ramfs_finddir.part.0.isra.0+0x28>
c0103ae4:	eb 3a                	jmp    c0103b20 <ramfs_finddir.part.0.isra.0+0x50>
c0103ae6:	66 90                	xchg   %ax,%ax
c0103ae8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0103aef:	00 
c0103af0:	83 c3 01             	add    $0x1,%ebx
c0103af3:	3b 5e 04             	cmp    0x4(%esi),%ebx
c0103af6:	73 28                	jae    c0103b20 <ramfs_finddir.part.0.isra.0+0x50>
c0103af8:	8b 06                	mov    (%esi),%eax
c0103afa:	83 ec 08             	sub    $0x8,%esp
c0103afd:	57                   	push   %edi
c0103afe:	ff 34 98             	push   (%eax,%ebx,4)
c0103b01:	e8 2a d5 ff ff       	call   c0101030 <strcmp>
c0103b06:	83 c4 10             	add    $0x10,%esp
c0103b09:	85 c0                	test   %eax,%eax
c0103b0b:	75 e3                	jne    c0103af0 <ramfs_finddir.part.0.isra.0+0x20>
c0103b0d:	8b 06                	mov    (%esi),%eax
c0103b0f:	8b 04 98             	mov    (%eax,%ebx,4),%eax
c0103b12:	5b                   	pop    %ebx
c0103b13:	5e                   	pop    %esi
c0103b14:	5f                   	pop    %edi
c0103b15:	c3                   	ret
c0103b16:	66 90                	xchg   %ax,%ax
c0103b18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0103b1f:	00 
c0103b20:	5b                   	pop    %ebx
c0103b21:	31 c0                	xor    %eax,%eax
c0103b23:	5e                   	pop    %esi
c0103b24:	5f                   	pop    %edi
c0103b25:	c3                   	ret
c0103b26:	31 c0                	xor    %eax,%eax
c0103b28:	c3                   	ret
c0103b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

c0103b30 <ramfs_finddir>:
c0103b30:	8b 44 24 04          	mov    0x4(%esp),%eax
c0103b34:	8b 54 24 08          	mov    0x8(%esp),%edx
c0103b38:	85 c0                	test   %eax,%eax
c0103b3a:	74 14                	je     c0103b50 <ramfs_finddir+0x20>
c0103b3c:	83 b8 8c 00 00 00 02 	cmpl   $0x2,0x8c(%eax)
c0103b43:	75 0b                	jne    c0103b50 <ramfs_finddir+0x20>
c0103b45:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
c0103b4b:	eb 83                	jmp    c0103ad0 <ramfs_finddir.part.0.isra.0>
c0103b4d:	8d 76 00             	lea    0x0(%esi),%esi
c0103b50:	31 c0                	xor    %eax,%eax
c0103b52:	c3                   	ret
c0103b53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0103b58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0103b5f:	00 

c0103b60 <ramfs_init>:
c0103b60:	83 ec 10             	sub    $0x10,%esp
c0103b63:	6a 1c                	push   $0x1c
c0103b65:	6a 00                	push   $0x0
c0103b67:	68 e0 34 11 c0       	push   $0xc01134e0
c0103b6c:	e8 af d5 ff ff       	call   c0101120 <memset>
c0103b71:	83 c4 0c             	add    $0xc,%esp
c0103b74:	c7 05 e0 34 11 c0 40 	movl   $0xc0103a40,0xc01134e0
c0103b7b:	3a 10 c0 
c0103b7e:	6a 1c                	push   $0x1c
c0103b80:	6a 00                	push   $0x0
c0103b82:	68 c4 34 11 c0       	push   $0xc01134c4
c0103b87:	e8 94 d5 ff ff       	call   c0101120 <memset>
c0103b8c:	58                   	pop    %eax
c0103b8d:	5a                   	pop    %edx
c0103b8e:	68 e3 79 10 c0       	push   $0xc01079e3
c0103b93:	68 a0 34 11 c0       	push   $0xc01134a0
c0103b98:	c7 05 d8 34 11 c0 30 	movl   $0xc0103b30,0xc01134d8
c0103b9f:	3b 10 c0 
c0103ba2:	e8 e9 d3 ff ff       	call   c0100f90 <strcpy>
c0103ba7:	c7 04 24 a0 34 11 c0 	movl   $0xc01134a0,(%esp)
c0103bae:	c7 05 c0 34 11 c0 80 	movl   $0xc0103980,0xc01134c0
c0103bb5:	39 10 c0 
c0103bb8:	e8 e3 f7 ff ff       	call   c01033a0 <vfs_register_fs>
c0103bbd:	83 c4 1c             	add    $0x1c,%esp
c0103bc0:	c3                   	ret
c0103bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0103bc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0103bcf:	00 

c0103bd0 <ramfs_add_file>:
c0103bd0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
c0103bd6:	89 bc 24 94 00 00 00 	mov    %edi,0x94(%esp)
c0103bdd:	8b 3d 80 34 11 c0    	mov    0xc0113480,%edi
c0103be3:	89 9c 24 8c 00 00 00 	mov    %ebx,0x8c(%esp)
c0103bea:	8b 9c 24 a0 00 00 00 	mov    0xa0(%esp),%ebx
c0103bf1:	85 ff                	test   %edi,%edi
c0103bf3:	0f 84 b5 01 00 00    	je     c0103dae <ramfs_add_file+0x1de>
c0103bf9:	89 b4 24 90 00 00 00 	mov    %esi,0x90(%esp)
c0103c00:	0f b6 03             	movzbl (%ebx),%eax
c0103c03:	3c 2f                	cmp    $0x2f,%al
c0103c05:	75 14                	jne    c0103c1b <ramfs_add_file+0x4b>
c0103c07:	90                   	nop
c0103c08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0103c0f:	00 
c0103c10:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
c0103c14:	83 c3 01             	add    $0x1,%ebx
c0103c17:	3c 2f                	cmp    $0x2f,%al
c0103c19:	74 f5                	je     c0103c10 <ramfs_add_file+0x40>
c0103c1b:	89 e6                	mov    %esp,%esi
c0103c1d:	84 c0                	test   %al,%al
c0103c1f:	0f 84 90 00 00 00    	je     c0103cb5 <ramfs_add_file+0xe5>
c0103c25:	89 ac 24 98 00 00 00 	mov    %ebp,0x98(%esp)
c0103c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0103c30:	89 da                	mov    %ebx,%edx
c0103c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0103c38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0103c3f:	00 
c0103c40:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
c0103c44:	83 c3 01             	add    $0x1,%ebx
c0103c47:	84 c0                	test   %al,%al
c0103c49:	74 04                	je     c0103c4f <ramfs_add_file+0x7f>
c0103c4b:	3c 2f                	cmp    $0x2f,%al
c0103c4d:	75 f1                	jne    c0103c40 <ramfs_add_file+0x70>
c0103c4f:	89 dd                	mov    %ebx,%ebp
c0103c51:	29 d5                	sub    %edx,%ebp
c0103c53:	83 fd 7f             	cmp    $0x7f,%ebp
c0103c56:	0f 87 44 01 00 00    	ja     c0103da0 <ramfs_add_file+0x1d0>
c0103c5c:	83 ec 04             	sub    $0x4,%esp
c0103c5f:	55                   	push   %ebp
c0103c60:	52                   	push   %edx
c0103c61:	56                   	push   %esi
c0103c62:	e8 79 d4 ff ff       	call   c01010e0 <memcpy>
c0103c67:	c6 44 2c 10 00       	movb   $0x0,0x10(%esp,%ebp,1)
c0103c6c:	83 c4 10             	add    $0x10,%esp
c0103c6f:	80 3b 00             	cmpb   $0x0,(%ebx)
c0103c72:	74 3a                	je     c0103cae <ramfs_add_file+0xde>
c0103c74:	83 bf 8c 00 00 00 02 	cmpl   $0x2,0x8c(%edi)
c0103c7b:	0f 85 1f 01 00 00    	jne    c0103da0 <ramfs_add_file+0x1d0>
c0103c81:	8b 87 98 00 00 00    	mov    0x98(%edi),%eax
c0103c87:	89 f2                	mov    %esi,%edx
c0103c89:	e8 42 fe ff ff       	call   c0103ad0 <ramfs_finddir.part.0.isra.0>
c0103c8e:	89 c7                	mov    %eax,%edi
c0103c90:	85 c0                	test   %eax,%eax
c0103c92:	75 0f                	jne    c0103ca3 <ramfs_add_file+0xd3>
c0103c94:	e9 07 01 00 00       	jmp    c0103da0 <ramfs_add_file+0x1d0>
c0103c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0103ca0:	83 c3 01             	add    $0x1,%ebx
c0103ca3:	0f b6 03             	movzbl (%ebx),%eax
c0103ca6:	3c 2f                	cmp    $0x2f,%al
c0103ca8:	74 f6                	je     c0103ca0 <ramfs_add_file+0xd0>
c0103caa:	84 c0                	test   %al,%al
c0103cac:	75 82                	jne    c0103c30 <ramfs_add_file+0x60>
c0103cae:	8b ac 24 98 00 00 00 	mov    0x98(%esp),%ebp
c0103cb5:	83 bf 8c 00 00 00 02 	cmpl   $0x2,0x8c(%edi)
c0103cbc:	75 15                	jne    c0103cd3 <ramfs_add_file+0x103>
c0103cbe:	8b 87 98 00 00 00    	mov    0x98(%edi),%eax
c0103cc4:	89 e2                	mov    %esp,%edx
c0103cc6:	e8 05 fe ff ff       	call   c0103ad0 <ramfs_finddir.part.0.isra.0>
c0103ccb:	85 c0                	test   %eax,%eax
c0103ccd:	0f 85 f5 00 00 00    	jne    c0103dc8 <ramfs_add_file+0x1f8>
c0103cd3:	8b b7 98 00 00 00    	mov    0x98(%edi),%esi
c0103cd9:	8b 46 08             	mov    0x8(%esi),%eax
c0103cdc:	39 46 04             	cmp    %eax,0x4(%esi)
c0103cdf:	0f 83 e3 00 00 00    	jae    c0103dc8 <ramfs_add_file+0x1f8>
c0103ce5:	83 ec 08             	sub    $0x8,%esp
c0103ce8:	6a 00                	push   $0x0
c0103cea:	68 a0 00 00 00       	push   $0xa0
c0103cef:	e8 2c ea ff ff       	call   c0102720 <kmalloc>
c0103cf4:	83 c4 0c             	add    $0xc,%esp
c0103cf7:	68 a0 00 00 00       	push   $0xa0
c0103cfc:	89 c3                	mov    %eax,%ebx
c0103cfe:	6a 00                	push   $0x0
c0103d00:	50                   	push   %eax
c0103d01:	e8 1a d4 ff ff       	call   c0101120 <memset>
c0103d06:	58                   	pop    %eax
c0103d07:	5a                   	pop    %edx
c0103d08:	8d 44 24 08          	lea    0x8(%esp),%eax
c0103d0c:	50                   	push   %eax
c0103d0d:	53                   	push   %ebx
c0103d0e:	e8 7d d2 ff ff       	call   c0100f90 <strcpy>
c0103d13:	a1 18 b0 10 c0       	mov    0xc010b018,%eax
c0103d18:	c7 83 8c 00 00 00 01 	movl   $0x1,0x8c(%ebx)
c0103d1f:	00 00 00 
c0103d22:	c7 83 9c 00 00 00 e0 	movl   $0xc01134e0,0x9c(%ebx)
c0103d29:	34 11 c0 
c0103d2c:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
c0103d32:	8d 50 01             	lea    0x1(%eax),%edx
c0103d35:	8b 84 24 b8 00 00 00 	mov    0xb8(%esp),%eax
c0103d3c:	89 15 18 b0 10 c0    	mov    %edx,0xc010b018
c0103d42:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
c0103d48:	59                   	pop    %ecx
c0103d49:	5f                   	pop    %edi
c0103d4a:	6a 00                	push   $0x0
c0103d4c:	6a 04                	push   $0x4
c0103d4e:	e8 cd e9 ff ff       	call   c0102720 <kmalloc>
c0103d53:	89 c7                	mov    %eax,%edi
c0103d55:	58                   	pop    %eax
c0103d56:	5a                   	pop    %edx
c0103d57:	6a 00                	push   $0x0
c0103d59:	ff b4 24 b4 00 00 00 	push   0xb4(%esp)
c0103d60:	e8 bb e9 ff ff       	call   c0102720 <kmalloc>
c0103d65:	83 c4 0c             	add    $0xc,%esp
c0103d68:	89 07                	mov    %eax,(%edi)
c0103d6a:	ff b4 24 ac 00 00 00 	push   0xac(%esp)
c0103d71:	ff b4 24 ac 00 00 00 	push   0xac(%esp)
c0103d78:	50                   	push   %eax
c0103d79:	e8 62 d3 ff ff       	call   c01010e0 <memcpy>
c0103d7e:	8b 46 04             	mov    0x4(%esi),%eax
c0103d81:	89 bb 98 00 00 00    	mov    %edi,0x98(%ebx)
c0103d87:	83 c4 10             	add    $0x10,%esp
c0103d8a:	8b 16                	mov    (%esi),%edx
c0103d8c:	8d 48 01             	lea    0x1(%eax),%ecx
c0103d8f:	89 4e 04             	mov    %ecx,0x4(%esi)
c0103d92:	8b b4 24 90 00 00 00 	mov    0x90(%esp),%esi
c0103d99:	89 1c 82             	mov    %ebx,(%edx,%eax,4)
c0103d9c:	31 c0                	xor    %eax,%eax
c0103d9e:	eb 13                	jmp    c0103db3 <ramfs_add_file+0x1e3>
c0103da0:	8b b4 24 90 00 00 00 	mov    0x90(%esp),%esi
c0103da7:	8b ac 24 98 00 00 00 	mov    0x98(%esp),%ebp
c0103dae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0103db3:	8b 9c 24 8c 00 00 00 	mov    0x8c(%esp),%ebx
c0103dba:	8b bc 24 94 00 00 00 	mov    0x94(%esp),%edi
c0103dc1:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103dc7:	c3                   	ret
c0103dc8:	8b b4 24 90 00 00 00 	mov    0x90(%esp),%esi
c0103dcf:	eb dd                	jmp    c0103dae <ramfs_add_file+0x1de>
c0103dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0103dd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0103ddf:	00 

c0103de0 <ramfs_add_dir>:
c0103de0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
c0103de6:	89 bc 24 94 00 00 00 	mov    %edi,0x94(%esp)
c0103ded:	8b 3d 80 34 11 c0    	mov    0xc0113480,%edi
c0103df3:	89 9c 24 8c 00 00 00 	mov    %ebx,0x8c(%esp)
c0103dfa:	8b 9c 24 a0 00 00 00 	mov    0xa0(%esp),%ebx
c0103e01:	85 ff                	test   %edi,%edi
c0103e03:	0f 84 9d 01 00 00    	je     c0103fa6 <ramfs_add_dir+0x1c6>
c0103e09:	89 b4 24 90 00 00 00 	mov    %esi,0x90(%esp)
c0103e10:	0f b6 03             	movzbl (%ebx),%eax
c0103e13:	3c 2f                	cmp    $0x2f,%al
c0103e15:	75 14                	jne    c0103e2b <ramfs_add_dir+0x4b>
c0103e17:	90                   	nop
c0103e18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0103e1f:	00 
c0103e20:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
c0103e24:	83 c3 01             	add    $0x1,%ebx
c0103e27:	3c 2f                	cmp    $0x2f,%al
c0103e29:	74 f5                	je     c0103e20 <ramfs_add_dir+0x40>
c0103e2b:	89 e6                	mov    %esp,%esi
c0103e2d:	84 c0                	test   %al,%al
c0103e2f:	0f 84 90 00 00 00    	je     c0103ec5 <ramfs_add_dir+0xe5>
c0103e35:	89 ac 24 98 00 00 00 	mov    %ebp,0x98(%esp)
c0103e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0103e40:	89 da                	mov    %ebx,%edx
c0103e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0103e48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0103e4f:	00 
c0103e50:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
c0103e54:	83 c3 01             	add    $0x1,%ebx
c0103e57:	84 c0                	test   %al,%al
c0103e59:	74 04                	je     c0103e5f <ramfs_add_dir+0x7f>
c0103e5b:	3c 2f                	cmp    $0x2f,%al
c0103e5d:	75 f1                	jne    c0103e50 <ramfs_add_dir+0x70>
c0103e5f:	89 dd                	mov    %ebx,%ebp
c0103e61:	29 d5                	sub    %edx,%ebp
c0103e63:	83 fd 7f             	cmp    $0x7f,%ebp
c0103e66:	0f 87 2c 01 00 00    	ja     c0103f98 <ramfs_add_dir+0x1b8>
c0103e6c:	83 ec 04             	sub    $0x4,%esp
c0103e6f:	55                   	push   %ebp
c0103e70:	52                   	push   %edx
c0103e71:	56                   	push   %esi
c0103e72:	e8 69 d2 ff ff       	call   c01010e0 <memcpy>
c0103e77:	c6 44 2c 10 00       	movb   $0x0,0x10(%esp,%ebp,1)
c0103e7c:	83 c4 10             	add    $0x10,%esp
c0103e7f:	80 3b 00             	cmpb   $0x0,(%ebx)
c0103e82:	74 3a                	je     c0103ebe <ramfs_add_dir+0xde>
c0103e84:	83 bf 8c 00 00 00 02 	cmpl   $0x2,0x8c(%edi)
c0103e8b:	0f 85 07 01 00 00    	jne    c0103f98 <ramfs_add_dir+0x1b8>
c0103e91:	8b 87 98 00 00 00    	mov    0x98(%edi),%eax
c0103e97:	89 f2                	mov    %esi,%edx
c0103e99:	e8 32 fc ff ff       	call   c0103ad0 <ramfs_finddir.part.0.isra.0>
c0103e9e:	89 c7                	mov    %eax,%edi
c0103ea0:	85 c0                	test   %eax,%eax
c0103ea2:	75 0f                	jne    c0103eb3 <ramfs_add_dir+0xd3>
c0103ea4:	e9 ef 00 00 00       	jmp    c0103f98 <ramfs_add_dir+0x1b8>
c0103ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0103eb0:	83 c3 01             	add    $0x1,%ebx
c0103eb3:	0f b6 03             	movzbl (%ebx),%eax
c0103eb6:	3c 2f                	cmp    $0x2f,%al
c0103eb8:	74 f6                	je     c0103eb0 <ramfs_add_dir+0xd0>
c0103eba:	84 c0                	test   %al,%al
c0103ebc:	75 82                	jne    c0103e40 <ramfs_add_dir+0x60>
c0103ebe:	8b ac 24 98 00 00 00 	mov    0x98(%esp),%ebp
c0103ec5:	83 bf 8c 00 00 00 02 	cmpl   $0x2,0x8c(%edi)
c0103ecc:	75 15                	jne    c0103ee3 <ramfs_add_dir+0x103>
c0103ece:	8b 87 98 00 00 00    	mov    0x98(%edi),%eax
c0103ed4:	89 e2                	mov    %esp,%edx
c0103ed6:	e8 f5 fb ff ff       	call   c0103ad0 <ramfs_finddir.part.0.isra.0>
c0103edb:	85 c0                	test   %eax,%eax
c0103edd:	0f 85 dd 00 00 00    	jne    c0103fc0 <ramfs_add_dir+0x1e0>
c0103ee3:	8b b7 98 00 00 00    	mov    0x98(%edi),%esi
c0103ee9:	8b 46 08             	mov    0x8(%esi),%eax
c0103eec:	39 46 04             	cmp    %eax,0x4(%esi)
c0103eef:	0f 83 cb 00 00 00    	jae    c0103fc0 <ramfs_add_dir+0x1e0>
c0103ef5:	83 ec 08             	sub    $0x8,%esp
c0103ef8:	6a 00                	push   $0x0
c0103efa:	68 a0 00 00 00       	push   $0xa0
c0103eff:	e8 1c e8 ff ff       	call   c0102720 <kmalloc>
c0103f04:	83 c4 0c             	add    $0xc,%esp
c0103f07:	68 a0 00 00 00       	push   $0xa0
c0103f0c:	89 c3                	mov    %eax,%ebx
c0103f0e:	6a 00                	push   $0x0
c0103f10:	50                   	push   %eax
c0103f11:	e8 0a d2 ff ff       	call   c0101120 <memset>
c0103f16:	58                   	pop    %eax
c0103f17:	5a                   	pop    %edx
c0103f18:	8d 44 24 08          	lea    0x8(%esp),%eax
c0103f1c:	50                   	push   %eax
c0103f1d:	53                   	push   %ebx
c0103f1e:	e8 6d d0 ff ff       	call   c0100f90 <strcpy>
c0103f23:	a1 18 b0 10 c0       	mov    0xc010b018,%eax
c0103f28:	c7 83 8c 00 00 00 02 	movl   $0x2,0x8c(%ebx)
c0103f2f:	00 00 00 
c0103f32:	c7 83 9c 00 00 00 c4 	movl   $0xc01134c4,0x9c(%ebx)
c0103f39:	34 11 c0 
c0103f3c:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
c0103f42:	59                   	pop    %ecx
c0103f43:	8d 50 01             	lea    0x1(%eax),%edx
c0103f46:	5f                   	pop    %edi
c0103f47:	6a 00                	push   $0x0
c0103f49:	6a 0c                	push   $0xc
c0103f4b:	89 15 18 b0 10 c0    	mov    %edx,0xc010b018
c0103f51:	e8 ca e7 ff ff       	call   c0102720 <kmalloc>
c0103f56:	89 c7                	mov    %eax,%edi
c0103f58:	58                   	pop    %eax
c0103f59:	5a                   	pop    %edx
c0103f5a:	6a 00                	push   $0x0
c0103f5c:	6a 40                	push   $0x40
c0103f5e:	e8 bd e7 ff ff       	call   c0102720 <kmalloc>
c0103f63:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
c0103f6a:	83 c4 10             	add    $0x10,%esp
c0103f6d:	89 07                	mov    %eax,(%edi)
c0103f6f:	8b 46 04             	mov    0x4(%esi),%eax
c0103f72:	c7 47 08 10 00 00 00 	movl   $0x10,0x8(%edi)
c0103f79:	89 bb 98 00 00 00    	mov    %edi,0x98(%ebx)
c0103f7f:	8b 16                	mov    (%esi),%edx
c0103f81:	8d 48 01             	lea    0x1(%eax),%ecx
c0103f84:	89 4e 04             	mov    %ecx,0x4(%esi)
c0103f87:	8b b4 24 90 00 00 00 	mov    0x90(%esp),%esi
c0103f8e:	89 1c 82             	mov    %ebx,(%edx,%eax,4)
c0103f91:	31 c0                	xor    %eax,%eax
c0103f93:	eb 16                	jmp    c0103fab <ramfs_add_dir+0x1cb>
c0103f95:	8d 76 00             	lea    0x0(%esi),%esi
c0103f98:	8b b4 24 90 00 00 00 	mov    0x90(%esp),%esi
c0103f9f:	8b ac 24 98 00 00 00 	mov    0x98(%esp),%ebp
c0103fa6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0103fab:	8b 9c 24 8c 00 00 00 	mov    0x8c(%esp),%ebx
c0103fb2:	8b bc 24 94 00 00 00 	mov    0x94(%esp),%edi
c0103fb9:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103fbf:	c3                   	ret
c0103fc0:	8b b4 24 90 00 00 00 	mov    0x90(%esp),%esi
c0103fc7:	eb dd                	jmp    c0103fa6 <ramfs_add_dir+0x1c6>
c0103fc9:	66 90                	xchg   %ax,%ax
c0103fcb:	66 90                	xchg   %ax,%ax
c0103fcd:	66 90                	xchg   %ax,%ax
c0103fcf:	90                   	nop

c0103fd0 <devfs_open>:
c0103fd0:	8b 44 24 04          	mov    0x4(%esp),%eax
c0103fd4:	8b 4c 24 08          	mov    0x8(%esp),%ecx
c0103fd8:	85 c0                	test   %eax,%eax
c0103fda:	74 27                	je     c0104003 <devfs_open+0x33>
c0103fdc:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
c0103fe2:	85 c0                	test   %eax,%eax
c0103fe4:	74 1d                	je     c0104003 <devfs_open+0x33>
c0103fe6:	8b 50 24             	mov    0x24(%eax),%edx
c0103fe9:	85 d2                	test   %edx,%edx
c0103feb:	74 13                	je     c0104000 <devfs_open+0x30>
c0103fed:	8b 12                	mov    (%edx),%edx
c0103fef:	85 d2                	test   %edx,%edx
c0103ff1:	74 0d                	je     c0104000 <devfs_open+0x30>
c0103ff3:	8b 49 08             	mov    0x8(%ecx),%ecx
c0103ff6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103ffa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0103ffe:	ff e2                	jmp    *%edx
c0104000:	31 c0                	xor    %eax,%eax
c0104002:	c3                   	ret
c0104003:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0104008:	c3                   	ret
c0104009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

c0104010 <devfs_close>:
c0104010:	8b 44 24 04          	mov    0x4(%esp),%eax
c0104014:	85 c0                	test   %eax,%eax
c0104016:	74 28                	je     c0104040 <devfs_close+0x30>
c0104018:	8b 00                	mov    (%eax),%eax
c010401a:	85 c0                	test   %eax,%eax
c010401c:	74 22                	je     c0104040 <devfs_close+0x30>
c010401e:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
c0104024:	85 c0                	test   %eax,%eax
c0104026:	74 18                	je     c0104040 <devfs_close+0x30>
c0104028:	8b 50 24             	mov    0x24(%eax),%edx
c010402b:	85 d2                	test   %edx,%edx
c010402d:	74 11                	je     c0104040 <devfs_close+0x30>
c010402f:	8b 52 04             	mov    0x4(%edx),%edx
c0104032:	85 d2                	test   %edx,%edx
c0104034:	74 0a                	je     c0104040 <devfs_close+0x30>
c0104036:	89 44 24 04          	mov    %eax,0x4(%esp)
c010403a:	ff e2                	jmp    *%edx
c010403c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0104040:	c3                   	ret
c0104041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0104048:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010404f:	00 

c0104050 <devfs_read>:
c0104050:	53                   	push   %ebx
c0104051:	8b 44 24 08          	mov    0x8(%esp),%eax
c0104055:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
c0104059:	85 c0                	test   %eax,%eax
c010405b:	74 33                	je     c0104090 <devfs_read+0x40>
c010405d:	8b 00                	mov    (%eax),%eax
c010405f:	85 c0                	test   %eax,%eax
c0104061:	74 2d                	je     c0104090 <devfs_read+0x40>
c0104063:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
c0104069:	85 c0                	test   %eax,%eax
c010406b:	74 23                	je     c0104090 <devfs_read+0x40>
c010406d:	8b 50 24             	mov    0x24(%eax),%edx
c0104070:	85 d2                	test   %edx,%edx
c0104072:	74 1c                	je     c0104090 <devfs_read+0x40>
c0104074:	8b 52 08             	mov    0x8(%edx),%edx
c0104077:	85 d2                	test   %edx,%edx
c0104079:	74 15                	je     c0104090 <devfs_read+0x40>
c010407b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010407f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104083:	5b                   	pop    %ebx
c0104084:	ff e2                	jmp    *%edx
c0104086:	66 90                	xchg   %ax,%ax
c0104088:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010408f:	00 
c0104090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0104095:	5b                   	pop    %ebx
c0104096:	c3                   	ret
c0104097:	90                   	nop
c0104098:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010409f:	00 

c01040a0 <devfs_write>:
c01040a0:	53                   	push   %ebx
c01040a1:	8b 44 24 08          	mov    0x8(%esp),%eax
c01040a5:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
c01040a9:	85 c0                	test   %eax,%eax
c01040ab:	74 33                	je     c01040e0 <devfs_write+0x40>
c01040ad:	8b 00                	mov    (%eax),%eax
c01040af:	85 c0                	test   %eax,%eax
c01040b1:	74 2d                	je     c01040e0 <devfs_write+0x40>
c01040b3:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
c01040b9:	85 c0                	test   %eax,%eax
c01040bb:	74 23                	je     c01040e0 <devfs_write+0x40>
c01040bd:	8b 50 24             	mov    0x24(%eax),%edx
c01040c0:	85 d2                	test   %edx,%edx
c01040c2:	74 1c                	je     c01040e0 <devfs_write+0x40>
c01040c4:	8b 52 0c             	mov    0xc(%edx),%edx
c01040c7:	85 d2                	test   %edx,%edx
c01040c9:	74 15                	je     c01040e0 <devfs_write+0x40>
c01040cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01040cf:	89 44 24 08          	mov    %eax,0x8(%esp)
c01040d3:	5b                   	pop    %ebx
c01040d4:	ff e2                	jmp    *%edx
c01040d6:	66 90                	xchg   %ax,%ax
c01040d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01040df:	00 
c01040e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01040e5:	5b                   	pop    %ebx
c01040e6:	c3                   	ret
c01040e7:	90                   	nop
c01040e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01040ef:	00 

c01040f0 <devfs_ioctl>:
c01040f0:	8b 44 24 04          	mov    0x4(%esp),%eax
c01040f4:	85 c0                	test   %eax,%eax
c01040f6:	74 28                	je     c0104120 <devfs_ioctl+0x30>
c01040f8:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
c01040fe:	85 c0                	test   %eax,%eax
c0104100:	74 1e                	je     c0104120 <devfs_ioctl+0x30>
c0104102:	8b 50 24             	mov    0x24(%eax),%edx
c0104105:	85 d2                	test   %edx,%edx
c0104107:	74 17                	je     c0104120 <devfs_ioctl+0x30>
c0104109:	8b 52 10             	mov    0x10(%edx),%edx
c010410c:	85 d2                	test   %edx,%edx
c010410e:	74 10                	je     c0104120 <devfs_ioctl+0x30>
c0104110:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104114:	ff e2                	jmp    *%edx
c0104116:	66 90                	xchg   %ax,%ax
c0104118:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010411f:	00 
c0104120:	b8 a1 ff ff ff       	mov    $0xffffffa1,%eax
c0104125:	c3                   	ret
c0104126:	66 90                	xchg   %ax,%ax
c0104128:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010412f:	00 

c0104130 <devfs_mount_cb>:
c0104130:	a1 00 35 11 c0       	mov    0xc0113500,%eax
c0104135:	85 c0                	test   %eax,%eax
c0104137:	74 07                	je     c0104140 <devfs_mount_cb+0x10>
c0104139:	c3                   	ret
c010413a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0104140:	83 ec 14             	sub    $0x14,%esp
c0104143:	6a 01                	push   $0x1
c0104145:	68 a0 00 00 00       	push   $0xa0
c010414a:	e8 d1 e5 ff ff       	call   c0102720 <kmalloc>
c010414f:	5a                   	pop    %edx
c0104150:	59                   	pop    %ecx
c0104151:	68 ea 7b 10 c0       	push   $0xc0107bea
c0104156:	50                   	push   %eax
c0104157:	a3 00 35 11 c0       	mov    %eax,0xc0113500
c010415c:	e8 2f ce ff ff       	call   c0100f90 <strcpy>
c0104161:	a1 00 35 11 c0       	mov    0xc0113500,%eax
c0104166:	c7 80 8c 00 00 00 02 	movl   $0x2,0x8c(%eax)
c010416d:	00 00 00 
c0104170:	c7 80 9c 00 00 00 44 	movl   $0xc0113544,0x9c(%eax)
c0104177:	35 11 c0 
c010417a:	83 c4 1c             	add    $0x1c,%esp
c010417d:	c3                   	ret
c010417e:	66 90                	xchg   %ax,%ax

c0104180 <devfs_finddir>:
c0104180:	83 ec 0c             	sub    $0xc,%esp
c0104183:	8b 44 24 10          	mov    0x10(%esp),%eax
c0104187:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010418b:	31 db                	xor    %ebx,%ebx
c010418d:	85 c0                	test   %eax,%eax
c010418f:	74 6c                	je     c01041fd <devfs_finddir+0x7d>
c0104191:	39 05 00 35 11 c0    	cmp    %eax,0xc0113500
c0104197:	75 64                	jne    c01041fd <devfs_finddir+0x7d>
c0104199:	89 74 24 08          	mov    %esi,0x8(%esp)
c010419d:	83 ec 0c             	sub    $0xc,%esp
c01041a0:	ff 74 24 20          	push   0x20(%esp)
c01041a4:	e8 87 05 00 00       	call   c0104730 <device_find>
c01041a9:	83 c4 10             	add    $0x10,%esp
c01041ac:	89 c6                	mov    %eax,%esi
c01041ae:	85 c0                	test   %eax,%eax
c01041b0:	74 6e                	je     c0104220 <devfs_finddir+0xa0>
c01041b2:	83 ec 08             	sub    $0x8,%esp
c01041b5:	6a 01                	push   $0x1
c01041b7:	68 a0 00 00 00       	push   $0xa0
c01041bc:	e8 5f e5 ff ff       	call   c0102720 <kmalloc>
c01041c1:	83 c4 10             	add    $0x10,%esp
c01041c4:	89 c3                	mov    %eax,%ebx
c01041c6:	85 c0                	test   %eax,%eax
c01041c8:	74 56                	je     c0104220 <devfs_finddir+0xa0>
c01041ca:	83 ec 08             	sub    $0x8,%esp
c01041cd:	56                   	push   %esi
c01041ce:	50                   	push   %eax
c01041cf:	e8 bc cd ff ff       	call   c0100f90 <strcpy>
c01041d4:	8b 56 20             	mov    0x20(%esi),%edx
c01041d7:	83 c4 10             	add    $0x10,%esp
c01041da:	b8 03 00 00 00       	mov    $0x3,%eax
c01041df:	85 d2                	test   %edx,%edx
c01041e1:	75 2d                	jne    c0104210 <devfs_finddir+0x90>
c01041e3:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
c01041e9:	c7 83 9c 00 00 00 60 	movl   $0xc0113560,0x9c(%ebx)
c01041f0:	35 11 c0 
c01041f3:	89 b3 98 00 00 00    	mov    %esi,0x98(%ebx)
c01041f9:	8b 74 24 08          	mov    0x8(%esp),%esi
c01041fd:	89 d8                	mov    %ebx,%eax
c01041ff:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c0104203:	83 c4 0c             	add    $0xc,%esp
c0104206:	c3                   	ret
c0104207:	90                   	nop
c0104208:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010420f:	00 
c0104210:	31 c0                	xor    %eax,%eax
c0104212:	83 fa 01             	cmp    $0x1,%edx
c0104215:	0f 94 c0             	sete   %al
c0104218:	8d 44 40 01          	lea    0x1(%eax,%eax,2),%eax
c010421c:	eb c5                	jmp    c01041e3 <devfs_finddir+0x63>
c010421e:	66 90                	xchg   %ax,%ax
c0104220:	89 d8                	mov    %ebx,%eax
c0104222:	8b 74 24 08          	mov    0x8(%esp),%esi
c0104226:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c010422a:	83 c4 0c             	add    $0xc,%esp
c010422d:	c3                   	ret
c010422e:	66 90                	xchg   %ax,%ax

c0104230 <devfs_init>:
c0104230:	83 ec 10             	sub    $0x10,%esp
c0104233:	6a 1c                	push   $0x1c
c0104235:	6a 00                	push   $0x0
c0104237:	68 60 35 11 c0       	push   $0xc0113560
c010423c:	e8 df ce ff ff       	call   c0101120 <memset>
c0104241:	83 c4 0c             	add    $0xc,%esp
c0104244:	c7 05 68 35 11 c0 d0 	movl   $0xc0103fd0,0xc0113568
c010424b:	3f 10 c0 
c010424e:	6a 1c                	push   $0x1c
c0104250:	6a 00                	push   $0x0
c0104252:	68 44 35 11 c0       	push   $0xc0113544
c0104257:	c7 05 6c 35 11 c0 10 	movl   $0xc0104010,0xc011356c
c010425e:	40 10 c0 
c0104261:	c7 05 60 35 11 c0 50 	movl   $0xc0104050,0xc0113560
c0104268:	40 10 c0 
c010426b:	c7 05 64 35 11 c0 a0 	movl   $0xc01040a0,0xc0113564
c0104272:	40 10 c0 
c0104275:	c7 05 78 35 11 c0 f0 	movl   $0xc01040f0,0xc0113578
c010427c:	40 10 c0 
c010427f:	e8 9c ce ff ff       	call   c0101120 <memset>
c0104284:	58                   	pop    %eax
c0104285:	5a                   	pop    %edx
c0104286:	68 e9 79 10 c0       	push   $0xc01079e9
c010428b:	68 20 35 11 c0       	push   $0xc0113520
c0104290:	c7 05 58 35 11 c0 80 	movl   $0xc0104180,0xc0113558
c0104297:	41 10 c0 
c010429a:	e8 f1 cc ff ff       	call   c0100f90 <strcpy>
c010429f:	c7 04 24 20 35 11 c0 	movl   $0xc0113520,(%esp)
c01042a6:	c7 05 40 35 11 c0 30 	movl   $0xc0104130,0xc0113540
c01042ad:	41 10 c0 
c01042b0:	e8 eb f0 ff ff       	call   c01033a0 <vfs_register_fs>
c01042b5:	83 c4 1c             	add    $0x1c,%esp
c01042b8:	c3                   	ret
c01042b9:	66 90                	xchg   %ax,%ax
c01042bb:	66 90                	xchg   %ax,%ax
c01042bd:	66 90                	xchg   %ax,%ax
c01042bf:	90                   	nop

c01042c0 <exec_load>:
c01042c0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
c01042c6:	89 bc 24 84 00 00 00 	mov    %edi,0x84(%esp)
c01042cd:	8b bc 24 94 00 00 00 	mov    0x94(%esp),%edi
c01042d4:	85 ff                	test   %edi,%edi
c01042d6:	0f 84 eb 02 00 00    	je     c01045c7 <exec_load+0x307>
c01042dc:	89 b4 24 80 00 00 00 	mov    %esi,0x80(%esp)
c01042e3:	83 ec 08             	sub    $0x8,%esp
c01042e6:	6a 00                	push   $0x0
c01042e8:	ff b4 24 9c 00 00 00 	push   0x9c(%esp)
c01042ef:	e8 bc f4 ff ff       	call   c01037b0 <vfs_open>
c01042f4:	83 c4 10             	add    $0x10,%esp
c01042f7:	89 c6                	mov    %eax,%esi
c01042f9:	85 c0                	test   %eax,%eax
c01042fb:	0f 84 51 03 00 00    	je     c0104652 <exec_load+0x392>
c0104301:	83 ec 04             	sub    $0x4,%esp
c0104304:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
c010430b:	6a 34                	push   $0x34
c010430d:	8d 44 24 44          	lea    0x44(%esp),%eax
c0104311:	50                   	push   %eax
c0104312:	56                   	push   %esi
c0104313:	e8 48 f5 ff ff       	call   c0103860 <vfs_read>
c0104318:	83 c4 10             	add    $0x10,%esp
c010431b:	83 f8 34             	cmp    $0x34,%eax
c010431e:	0f 85 c6 02 00 00    	jne    c01045ea <exec_load+0x32a>
c0104324:	80 7c 24 3c 7f       	cmpb   $0x7f,0x3c(%esp)
c0104329:	0f 85 ab 02 00 00    	jne    c01045da <exec_load+0x31a>
c010432f:	80 7c 24 3d 45       	cmpb   $0x45,0x3d(%esp)
c0104334:	0f 85 a0 02 00 00    	jne    c01045da <exec_load+0x31a>
c010433a:	80 7c 24 3e 4c       	cmpb   $0x4c,0x3e(%esp)
c010433f:	0f 85 95 02 00 00    	jne    c01045da <exec_load+0x31a>
c0104345:	80 7c 24 3f 46       	cmpb   $0x46,0x3f(%esp)
c010434a:	0f 85 8a 02 00 00    	jne    c01045da <exec_load+0x31a>
c0104350:	80 7c 24 40 01       	cmpb   $0x1,0x40(%esp)
c0104355:	0f 85 c8 02 00 00    	jne    c0104623 <exec_load+0x363>
c010435b:	80 7c 24 41 01       	cmpb   $0x1,0x41(%esp)
c0104360:	0f 85 ab 02 00 00    	jne    c0104611 <exec_load+0x351>
c0104366:	66 83 7c 24 4c 02    	cmpw   $0x2,0x4c(%esp)
c010436c:	0f 85 8d 02 00 00    	jne    c01045ff <exec_load+0x33f>
c0104372:	89 5c 24 7c          	mov    %ebx,0x7c(%esp)
c0104376:	89 ac 24 88 00 00 00 	mov    %ebp,0x88(%esp)
c010437d:	66 83 7c 24 4e 03    	cmpw   $0x3,0x4e(%esp)
c0104383:	0f 85 ac 02 00 00    	jne    c0104635 <exec_load+0x375>
c0104389:	e8 f2 04 00 00       	call   c0104880 <address_space_create>
c010438e:	89 c3                	mov    %eax,%ebx
c0104390:	85 c0                	test   %eax,%eax
c0104392:	0f 84 dd 02 00 00    	je     c0104675 <exec_load+0x3b5>
c0104398:	83 ec 0c             	sub    $0xc,%esp
c010439b:	50                   	push   %eax
c010439c:	e8 4f 06 00 00       	call   c01049f0 <switch_address_space>
c01043a1:	83 c4 10             	add    $0x10,%esp
c01043a4:	66 83 7c 24 68 00    	cmpw   $0x0,0x68(%esp)
c01043aa:	0f 84 0b 01 00 00    	je     c01044bb <exec_load+0x1fb>
c01043b0:	31 ed                	xor    %ebp,%ebp
c01043b2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01043b6:	89 bc 24 94 00 00 00 	mov    %edi,0x94(%esp)
c01043bd:	89 eb                	mov    %ebp,%ebx
c01043bf:	eb 17                	jmp    c01043d8 <exec_load+0x118>
c01043c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c01043c8:	0f b7 44 24 68       	movzwl 0x68(%esp),%eax
c01043cd:	83 c3 01             	add    $0x1,%ebx
c01043d0:	39 c3                	cmp    %eax,%ebx
c01043d2:	0f 8d d8 00 00 00    	jge    c01044b0 <exec_load+0x1f0>
c01043d8:	0f b7 44 24 66       	movzwl 0x66(%esp),%eax
c01043dd:	83 ec 04             	sub    $0x4,%esp
c01043e0:	0f af c3             	imul   %ebx,%eax
c01043e3:	03 44 24 5c          	add    0x5c(%esp),%eax
c01043e7:	89 46 04             	mov    %eax,0x4(%esi)
c01043ea:	6a 20                	push   $0x20
c01043ec:	8d 44 24 24          	lea    0x24(%esp),%eax
c01043f0:	50                   	push   %eax
c01043f1:	56                   	push   %esi
c01043f2:	e8 69 f4 ff ff       	call   c0103860 <vfs_read>
c01043f7:	83 c4 10             	add    $0x10,%esp
c01043fa:	83 f8 20             	cmp    $0x20,%eax
c01043fd:	0f 85 8d 01 00 00    	jne    c0104590 <exec_load+0x2d0>
c0104403:	83 7c 24 1c 01       	cmpl   $0x1,0x1c(%esp)
c0104408:	75 be                	jne    c01043c8 <exec_load+0x108>
c010440a:	8b 7c 24 24          	mov    0x24(%esp),%edi
c010440e:	8b 4c 24 30          	mov    0x30(%esp),%ecx
c0104412:	89 f8                	mov    %edi,%eax
c0104414:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104419:	8d ac 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%ebp
c0104420:	8b 44 24 34          	mov    0x34(%esp),%eax
c0104424:	83 e0 02             	and    $0x2,%eax
c0104427:	83 f8 01             	cmp    $0x1,%eax
c010442a:	19 c9                	sbb    %ecx,%ecx
c010442c:	83 e1 fe             	and    $0xfffffffe,%ecx
c010442f:	c1 ed 0c             	shr    $0xc,%ebp
c0104432:	74 3d                	je     c0104471 <exec_load+0x1b1>
c0104434:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010443a:	c1 e5 0c             	shl    $0xc,%ebp
c010443d:	89 74 24 08          	mov    %esi,0x8(%esp)
c0104441:	8d 71 07             	lea    0x7(%ecx),%esi
c0104444:	01 fd                	add    %edi,%ebp
c0104446:	66 90                	xchg   %ax,%ax
c0104448:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010444f:	00 
c0104450:	e8 db da ff ff       	call   c0101f30 <pmm_alloc_frame>
c0104455:	83 ec 04             	sub    $0x4,%esp
c0104458:	56                   	push   %esi
c0104459:	50                   	push   %eax
c010445a:	57                   	push   %edi
c010445b:	81 c7 00 10 00 00    	add    $0x1000,%edi
c0104461:	e8 aa de ff ff       	call   c0102310 <vmm_map>
c0104466:	83 c4 10             	add    $0x10,%esp
c0104469:	39 ef                	cmp    %ebp,%edi
c010446b:	75 e3                	jne    c0104450 <exec_load+0x190>
c010446d:	8b 74 24 08          	mov    0x8(%esp),%esi
c0104471:	8b 44 24 2c          	mov    0x2c(%esp),%eax
c0104475:	85 c0                	test   %eax,%eax
c0104477:	0f 85 cb 00 00 00    	jne    c0104548 <exec_load+0x288>
c010447d:	8b 4c 24 30          	mov    0x30(%esp),%ecx
c0104481:	39 c8                	cmp    %ecx,%eax
c0104483:	0f 83 3f ff ff ff    	jae    c01043c8 <exec_load+0x108>
c0104489:	83 ec 04             	sub    $0x4,%esp
c010448c:	29 c1                	sub    %eax,%ecx
c010448e:	83 c3 01             	add    $0x1,%ebx
c0104491:	51                   	push   %ecx
c0104492:	6a 00                	push   $0x0
c0104494:	03 44 24 30          	add    0x30(%esp),%eax
c0104498:	50                   	push   %eax
c0104499:	e8 82 cc ff ff       	call   c0101120 <memset>
c010449e:	0f b7 44 24 78       	movzwl 0x78(%esp),%eax
c01044a3:	83 c4 10             	add    $0x10,%esp
c01044a6:	39 c3                	cmp    %eax,%ebx
c01044a8:	0f 8c 2a ff ff ff    	jl     c01043d8 <exec_load+0x118>
c01044ae:	66 90                	xchg   %ax,%ax
c01044b0:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
c01044b4:	8b bc 24 94 00 00 00 	mov    0x94(%esp),%edi
c01044bb:	83 ec 0c             	sub    $0xc,%esp
c01044be:	6a 00                	push   $0x0
c01044c0:	e8 2b 05 00 00       	call   c01049f0 <switch_address_space>
c01044c5:	89 1c 24             	mov    %ebx,(%esp)
c01044c8:	e8 23 05 00 00       	call   c01049f0 <switch_address_space>
c01044cd:	8b 43 14             	mov    0x14(%ebx),%eax
c01044d0:	8d a8 00 f0 ff ff    	lea    -0x1000(%eax),%ebp
c01044d6:	e8 55 da ff ff       	call   c0101f30 <pmm_alloc_frame>
c01044db:	83 c4 0c             	add    $0xc,%esp
c01044de:	6a 07                	push   $0x7
c01044e0:	50                   	push   %eax
c01044e1:	55                   	push   %ebp
c01044e2:	e8 29 de ff ff       	call   c0102310 <vmm_map>
c01044e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01044ee:	e8 fd 04 00 00       	call   c01049f0 <switch_address_space>
c01044f3:	8b 44 24 64          	mov    0x64(%esp),%eax
c01044f7:	89 5f 08             	mov    %ebx,0x8(%edi)
c01044fa:	89 07                	mov    %eax,(%edi)
c01044fc:	8b 43 14             	mov    0x14(%ebx),%eax
c01044ff:	89 47 04             	mov    %eax,0x4(%edi)
c0104502:	89 34 24             	mov    %esi,(%esp)
c0104505:	e8 f6 f3 ff ff       	call   c0103900 <vfs_close>
c010450a:	58                   	pop    %eax
c010450b:	5a                   	pop    %edx
c010450c:	ff b4 24 98 00 00 00 	push   0x98(%esp)
c0104513:	68 7d 7a 10 c0       	push   $0xc0107a7d
c0104518:	e8 33 d5 ff ff       	call   c0101a50 <log_info>
c010451d:	83 c4 10             	add    $0x10,%esp
c0104520:	31 c0                	xor    %eax,%eax
c0104522:	8b bc 24 84 00 00 00 	mov    0x84(%esp),%edi
c0104529:	8b 5c 24 7c          	mov    0x7c(%esp),%ebx
c010452d:	8b b4 24 80 00 00 00 	mov    0x80(%esp),%esi
c0104534:	8b ac 24 88 00 00 00 	mov    0x88(%esp),%ebp
c010453b:	81 c4 8c 00 00 00    	add    $0x8c,%esp
c0104541:	c3                   	ret
c0104542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0104548:	8b 4c 24 20          	mov    0x20(%esp),%ecx
c010454c:	83 ec 04             	sub    $0x4,%esp
c010454f:	89 4e 04             	mov    %ecx,0x4(%esi)
c0104552:	50                   	push   %eax
c0104553:	ff 74 24 2c          	push   0x2c(%esp)
c0104557:	56                   	push   %esi
c0104558:	e8 03 f3 ff ff       	call   c0103860 <vfs_read>
c010455d:	83 c4 10             	add    $0x10,%esp
c0104560:	85 c0                	test   %eax,%eax
c0104562:	78 0a                	js     c010456e <exec_load+0x2ae>
c0104564:	39 44 24 2c          	cmp    %eax,0x2c(%esp)
c0104568:	0f 84 0f ff ff ff    	je     c010447d <exec_load+0x1bd>
c010456e:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
c0104572:	83 ec 0c             	sub    $0xc,%esp
c0104575:	68 fc a5 10 c0       	push   $0xc010a5fc
c010457a:	e8 31 d5 ff ff       	call   c0101ab0 <log_error>
c010457f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104586:	e8 65 04 00 00       	call   c01049f0 <switch_address_space>
c010458b:	83 c4 10             	add    $0x10,%esp
c010458e:	eb 11                	jmp    c01045a1 <exec_load+0x2e1>
c0104590:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
c0104594:	83 ec 0c             	sub    $0xc,%esp
c0104597:	6a 00                	push   $0x0
c0104599:	e8 52 04 00 00       	call   c01049f0 <switch_address_space>
c010459e:	83 c4 10             	add    $0x10,%esp
c01045a1:	83 ec 0c             	sub    $0xc,%esp
c01045a4:	53                   	push   %ebx
c01045a5:	e8 26 04 00 00       	call   c01049d0 <address_space_destroy>
c01045aa:	89 34 24             	mov    %esi,(%esp)
c01045ad:	e8 4e f3 ff ff       	call   c0103900 <vfs_close>
c01045b2:	83 c4 10             	add    $0x10,%esp
c01045b5:	8b 5c 24 7c          	mov    0x7c(%esp),%ebx
c01045b9:	8b b4 24 80 00 00 00 	mov    0x80(%esp),%esi
c01045c0:	8b ac 24 88 00 00 00 	mov    0x88(%esp),%ebp
c01045c7:	8b bc 24 84 00 00 00 	mov    0x84(%esp),%edi
c01045ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01045d3:	81 c4 8c 00 00 00    	add    $0x8c,%esp
c01045d9:	c3                   	ret
c01045da:	83 ec 0c             	sub    $0xc,%esp
c01045dd:	68 0c 7a 10 c0       	push   $0xc0107a0c
c01045e2:	e8 c9 d4 ff ff       	call   c0101ab0 <log_error>
c01045e7:	83 c4 10             	add    $0x10,%esp
c01045ea:	83 ec 0c             	sub    $0xc,%esp
c01045ed:	56                   	push   %esi
c01045ee:	e8 0d f3 ff ff       	call   c0103900 <vfs_close>
c01045f3:	83 c4 10             	add    $0x10,%esp
c01045f6:	8b b4 24 80 00 00 00 	mov    0x80(%esp),%esi
c01045fd:	eb c8                	jmp    c01045c7 <exec_load+0x307>
c01045ff:	83 ec 0c             	sub    $0xc,%esp
c0104602:	68 60 7a 10 c0       	push   $0xc0107a60
c0104607:	e8 a4 d4 ff ff       	call   c0101ab0 <log_error>
c010460c:	83 c4 10             	add    $0x10,%esp
c010460f:	eb d9                	jmp    c01045ea <exec_load+0x32a>
c0104611:	83 ec 0c             	sub    $0xc,%esp
c0104614:	68 43 7a 10 c0       	push   $0xc0107a43
c0104619:	e8 92 d4 ff ff       	call   c0101ab0 <log_error>
c010461e:	83 c4 10             	add    $0x10,%esp
c0104621:	eb c7                	jmp    c01045ea <exec_load+0x32a>
c0104623:	83 ec 0c             	sub    $0xc,%esp
c0104626:	68 27 7a 10 c0       	push   $0xc0107a27
c010462b:	e8 80 d4 ff ff       	call   c0101ab0 <log_error>
c0104630:	83 c4 10             	add    $0x10,%esp
c0104633:	eb b5                	jmp    c01045ea <exec_load+0x32a>
c0104635:	83 ec 0c             	sub    $0xc,%esp
c0104638:	68 d8 a5 10 c0       	push   $0xc010a5d8
c010463d:	e8 6e d4 ff ff       	call   c0101ab0 <log_error>
c0104642:	83 c4 10             	add    $0x10,%esp
c0104645:	8b 5c 24 7c          	mov    0x7c(%esp),%ebx
c0104649:	8b ac 24 88 00 00 00 	mov    0x88(%esp),%ebp
c0104650:	eb 98                	jmp    c01045ea <exec_load+0x32a>
c0104652:	83 ec 08             	sub    $0x8,%esp
c0104655:	ff b4 24 98 00 00 00 	push   0x98(%esp)
c010465c:	68 ef 79 10 c0       	push   $0xc01079ef
c0104661:	e8 4a d4 ff ff       	call   c0101ab0 <log_error>
c0104666:	83 c4 10             	add    $0x10,%esp
c0104669:	8b b4 24 80 00 00 00 	mov    0x80(%esp),%esi
c0104670:	e9 52 ff ff ff       	jmp    c01045c7 <exec_load+0x307>
c0104675:	83 ec 0c             	sub    $0xc,%esp
c0104678:	56                   	push   %esi
c0104679:	e9 2f ff ff ff       	jmp    c01045ad <exec_load+0x2ed>
c010467e:	66 90                	xchg   %ax,%ax

c0104680 <device_manager_init>:
c0104680:	83 ec 18             	sub    $0x18,%esp
c0104683:	c7 05 7c 35 11 c0 00 	movl   $0x0,0xc011357c
c010468a:	00 00 00 
c010468d:	68 96 7a 10 c0       	push   $0xc0107a96
c0104692:	e8 b9 d3 ff ff       	call   c0101a50 <log_info>
c0104697:	83 c4 1c             	add    $0x1c,%esp
c010469a:	c3                   	ret
c010469b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

c01046a0 <device_register>:
c01046a0:	83 ec 0c             	sub    $0xc,%esp
c01046a3:	89 74 24 08          	mov    %esi,0x8(%esp)
c01046a7:	8b 74 24 10          	mov    0x10(%esp),%esi
c01046ab:	85 f6                	test   %esi,%esi
c01046ad:	74 3e                	je     c01046ed <device_register+0x4d>
c01046af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01046b3:	8b 1d 7c 35 11 c0    	mov    0xc011357c,%ebx
c01046b9:	85 db                	test   %ebx,%ebx
c01046bb:	75 0a                	jne    c01046c7 <device_register+0x27>
c01046bd:	eb 3f                	jmp    c01046fe <device_register+0x5e>
c01046bf:	90                   	nop
c01046c0:	8b 5b 2c             	mov    0x2c(%ebx),%ebx
c01046c3:	85 db                	test   %ebx,%ebx
c01046c5:	74 31                	je     c01046f8 <device_register+0x58>
c01046c7:	83 ec 08             	sub    $0x8,%esp
c01046ca:	56                   	push   %esi
c01046cb:	53                   	push   %ebx
c01046cc:	e8 5f c9 ff ff       	call   c0101030 <strcmp>
c01046d1:	83 c4 10             	add    $0x10,%esp
c01046d4:	85 c0                	test   %eax,%eax
c01046d6:	75 e8                	jne    c01046c0 <device_register+0x20>
c01046d8:	83 ec 08             	sub    $0x8,%esp
c01046db:	56                   	push   %esi
c01046dc:	68 24 a6 10 c0       	push   $0xc010a624
c01046e1:	e8 ca d3 ff ff       	call   c0101ab0 <log_error>
c01046e6:	83 c4 10             	add    $0x10,%esp
c01046e9:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c01046ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01046f2:	eb 2a                	jmp    c010471e <device_register+0x7e>
c01046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c01046f8:	8b 1d 7c 35 11 c0    	mov    0xc011357c,%ebx
c01046fe:	83 ec 08             	sub    $0x8,%esp
c0104701:	89 5e 2c             	mov    %ebx,0x2c(%esi)
c0104704:	56                   	push   %esi
c0104705:	68 b2 7a 10 c0       	push   $0xc0107ab2
c010470a:	89 35 7c 35 11 c0    	mov    %esi,0xc011357c
c0104710:	e8 3b d3 ff ff       	call   c0101a50 <log_info>
c0104715:	83 c4 10             	add    $0x10,%esp
c0104718:	31 c0                	xor    %eax,%eax
c010471a:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c010471e:	8b 74 24 08          	mov    0x8(%esp),%esi
c0104722:	83 c4 0c             	add    $0xc,%esp
c0104725:	c3                   	ret
c0104726:	66 90                	xchg   %ax,%ax
c0104728:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010472f:	00 

c0104730 <device_find>:
c0104730:	56                   	push   %esi
c0104731:	53                   	push   %ebx
c0104732:	83 ec 04             	sub    $0x4,%esp
c0104735:	8b 74 24 10          	mov    0x10(%esp),%esi
c0104739:	85 f6                	test   %esi,%esi
c010473b:	74 33                	je     c0104770 <device_find+0x40>
c010473d:	8b 1d 7c 35 11 c0    	mov    0xc011357c,%ebx
c0104743:	85 db                	test   %ebx,%ebx
c0104745:	75 10                	jne    c0104757 <device_find+0x27>
c0104747:	eb 1f                	jmp    c0104768 <device_find+0x38>
c0104749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0104750:	8b 5b 2c             	mov    0x2c(%ebx),%ebx
c0104753:	85 db                	test   %ebx,%ebx
c0104755:	74 11                	je     c0104768 <device_find+0x38>
c0104757:	83 ec 08             	sub    $0x8,%esp
c010475a:	56                   	push   %esi
c010475b:	53                   	push   %ebx
c010475c:	e8 cf c8 ff ff       	call   c0101030 <strcmp>
c0104761:	83 c4 10             	add    $0x10,%esp
c0104764:	85 c0                	test   %eax,%eax
c0104766:	75 e8                	jne    c0104750 <device_find+0x20>
c0104768:	83 c4 04             	add    $0x4,%esp
c010476b:	89 d8                	mov    %ebx,%eax
c010476d:	5b                   	pop    %ebx
c010476e:	5e                   	pop    %esi
c010476f:	c3                   	ret
c0104770:	31 db                	xor    %ebx,%ebx
c0104772:	eb f4                	jmp    c0104768 <device_find+0x38>
c0104774:	66 90                	xchg   %ax,%ax
c0104776:	66 90                	xchg   %ax,%ax
c0104778:	66 90                	xchg   %ax,%ax
c010477a:	66 90                	xchg   %ax,%ax
c010477c:	66 90                	xchg   %ax,%ax
c010477e:	66 90                	xchg   %ax,%ax

c0104780 <process_destroy>:
c0104780:	83 ec 0c             	sub    $0xc,%esp
c0104783:	89 74 24 04          	mov    %esi,0x4(%esp)
c0104787:	8b 74 24 10          	mov    0x10(%esp),%esi
c010478b:	85 f6                	test   %esi,%esi
c010478d:	0f 84 9d 00 00 00    	je     c0104830 <process_destroy+0xb0>
c0104793:	89 1c 24             	mov    %ebx,(%esp)
c0104796:	8d 46 04             	lea    0x4(%esi),%eax
c0104799:	8d 5e 2c             	lea    0x2c(%esi),%ebx
c010479c:	89 7c 24 08          	mov    %edi,0x8(%esp)
c01047a0:	83 ec 04             	sub    $0x4,%esp
c01047a3:	8d be ac 00 00 00    	lea    0xac(%esi),%edi
c01047a9:	50                   	push   %eax
c01047aa:	ff 36                	push   (%esi)
c01047ac:	68 54 a6 10 c0       	push   $0xc010a654
c01047b1:	e8 9a d2 ff ff       	call   c0101a50 <log_info>
c01047b6:	83 c4 10             	add    $0x10,%esp
c01047b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c01047c0:	8b 03                	mov    (%ebx),%eax
c01047c2:	85 c0                	test   %eax,%eax
c01047c4:	74 12                	je     c01047d8 <process_destroy+0x58>
c01047c6:	83 ec 0c             	sub    $0xc,%esp
c01047c9:	50                   	push   %eax
c01047ca:	e8 31 f1 ff ff       	call   c0103900 <vfs_close>
c01047cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
c01047d5:	83 c4 10             	add    $0x10,%esp
c01047d8:	83 c3 04             	add    $0x4,%ebx
c01047db:	39 fb                	cmp    %edi,%ebx
c01047dd:	75 e1                	jne    c01047c0 <process_destroy+0x40>
c01047df:	8b 46 24             	mov    0x24(%esi),%eax
c01047e2:	85 c0                	test   %eax,%eax
c01047e4:	74 0c                	je     c01047f2 <process_destroy+0x72>
c01047e6:	83 ec 0c             	sub    $0xc,%esp
c01047e9:	50                   	push   %eax
c01047ea:	e8 51 e0 ff ff       	call   c0102840 <kfree>
c01047ef:	83 c4 10             	add    $0x10,%esp
c01047f2:	8b 5e 28             	mov    0x28(%esi),%ebx
c01047f5:	85 db                	test   %ebx,%ebx
c01047f7:	74 1c                	je     c0104815 <process_destroy+0x95>
c01047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0104800:	89 d8                	mov    %ebx,%eax
c0104802:	83 ec 0c             	sub    $0xc,%esp
c0104805:	8b 5b 0c             	mov    0xc(%ebx),%ebx
c0104808:	50                   	push   %eax
c0104809:	e8 32 e0 ff ff       	call   c0102840 <kfree>
c010480e:	83 c4 10             	add    $0x10,%esp
c0104811:	85 db                	test   %ebx,%ebx
c0104813:	75 eb                	jne    c0104800 <process_destroy+0x80>
c0104815:	8b 1c 24             	mov    (%esp),%ebx
c0104818:	8b 7c 24 08          	mov    0x8(%esp),%edi
c010481c:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104820:	8b 74 24 04          	mov    0x4(%esp),%esi
c0104824:	83 c4 0c             	add    $0xc,%esp
c0104827:	e9 14 e0 ff ff       	jmp    c0102840 <kfree>
c010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0104830:	8b 74 24 04          	mov    0x4(%esp),%esi
c0104834:	83 c4 0c             	add    $0xc,%esp
c0104837:	c3                   	ret
c0104838:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010483f:	00 

c0104840 <process_exit>:
c0104840:	83 ec 0c             	sub    $0xc,%esp
c0104843:	a1 80 35 11 c0       	mov    0xc0113580,%eax
c0104848:	8b 54 24 10          	mov    0x10(%esp),%edx
c010484c:	85 c0                	test   %eax,%eax
c010484e:	74 1a                	je     c010486a <process_exit+0x2a>
c0104850:	8b 40 40             	mov    0x40(%eax),%eax
c0104853:	85 c0                	test   %eax,%eax
c0104855:	74 13                	je     c010486a <process_exit+0x2a>
c0104857:	83 ec 04             	sub    $0x4,%esp
c010485a:	52                   	push   %edx
c010485b:	ff 30                	push   (%eax)
c010485d:	68 74 a6 10 c0       	push   $0xc010a674
c0104862:	e8 e9 d1 ff ff       	call   c0101a50 <log_info>
c0104867:	83 c4 10             	add    $0x10,%esp
c010486a:	83 c4 0c             	add    $0xc,%esp
c010486d:	e9 5e 06 00 00       	jmp    c0104ed0 <scheduler_exit_current>
c0104872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0104878:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010487f:	00 

c0104880 <address_space_create>:
c0104880:	53                   	push   %ebx
c0104881:	83 ec 10             	sub    $0x10,%esp
c0104884:	6a 01                	push   $0x1
c0104886:	6a 18                	push   $0x18
c0104888:	e8 93 de ff ff       	call   c0102720 <kmalloc>
c010488d:	83 c4 10             	add    $0x10,%esp
c0104890:	89 c3                	mov    %eax,%ebx
c0104892:	85 c0                	test   %eax,%eax
c0104894:	74 2e                	je     c01048c4 <address_space_create+0x44>
c0104896:	e8 95 db ff ff       	call   c0102430 <vmm_clone_directory>
c010489b:	89 03                	mov    %eax,(%ebx)
c010489d:	85 c0                	test   %eax,%eax
c010489f:	74 2f                	je     c01048d0 <address_space_create+0x50>
c01048a1:	c7 43 04 00 00 40 00 	movl   $0x400000,0x4(%ebx)
c01048a8:	c7 43 08 00 00 40 00 	movl   $0x400000,0x8(%ebx)
c01048af:	c7 43 0c 00 00 00 08 	movl   $0x8000000,0xc(%ebx)
c01048b6:	c7 43 10 00 00 00 08 	movl   $0x8000000,0x10(%ebx)
c01048bd:	c7 43 14 00 f0 ff bf 	movl   $0xbffff000,0x14(%ebx)
c01048c4:	83 c4 08             	add    $0x8,%esp
c01048c7:	89 d8                	mov    %ebx,%eax
c01048c9:	5b                   	pop    %ebx
c01048ca:	c3                   	ret
c01048cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c01048d0:	83 ec 0c             	sub    $0xc,%esp
c01048d3:	53                   	push   %ebx
c01048d4:	31 db                	xor    %ebx,%ebx
c01048d6:	e8 65 df ff ff       	call   c0102840 <kfree>
c01048db:	83 c4 10             	add    $0x10,%esp
c01048de:	eb e4                	jmp    c01048c4 <address_space_create+0x44>

c01048e0 <process_create>:
c01048e0:	83 ec 14             	sub    $0x14,%esp
c01048e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01048e7:	8b 5c 24 18          	mov    0x18(%esp),%ebx
c01048eb:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01048ef:	6a 01                	push   $0x1
c01048f1:	68 b8 00 00 00       	push   $0xb8
c01048f6:	e8 25 de ff ff       	call   c0102720 <kmalloc>
c01048fb:	83 c4 10             	add    $0x10,%esp
c01048fe:	89 c6                	mov    %eax,%esi
c0104900:	85 c0                	test   %eax,%eax
c0104902:	0f 84 90 00 00 00    	je     c0104998 <process_create+0xb8>
c0104908:	a1 1c b0 10 c0       	mov    0xc010b01c,%eax
c010490d:	89 7c 24 08          	mov    %edi,0x8(%esp)
c0104911:	83 ec 04             	sub    $0x4,%esp
c0104914:	8d 7e 04             	lea    0x4(%esi),%edi
c0104917:	89 06                	mov    %eax,(%esi)
c0104919:	8d 50 01             	lea    0x1(%eax),%edx
c010491c:	6a 1f                	push   $0x1f
c010491e:	53                   	push   %ebx
c010491f:	57                   	push   %edi
c0104920:	89 15 1c b0 10 c0    	mov    %edx,0xc010b01c
c0104926:	e8 95 c6 ff ff       	call   c0100fc0 <strncpy>
c010492b:	c6 46 23 00          	movb   $0x0,0x23(%esi)
c010492f:	e8 4c ff ff ff       	call   c0104880 <address_space_create>
c0104934:	83 c4 10             	add    $0x10,%esp
c0104937:	89 46 24             	mov    %eax,0x24(%esi)
c010493a:	85 c0                	test   %eax,%eax
c010493c:	74 6d                	je     c01049ab <process_create+0xcb>
c010493e:	83 ec 0c             	sub    $0xc,%esp
c0104941:	8d 9e ac 00 00 00    	lea    0xac(%esi),%ebx
c0104947:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%esi)
c010494e:	53                   	push   %ebx
c010494f:	e8 fc cc ff ff       	call   c0101650 <list_init>
c0104954:	8d 46 2c             	lea    0x2c(%esi),%eax
c0104957:	83 c4 10             	add    $0x10,%esp
c010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0104960:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
c0104966:	83 c0 08             	add    $0x8,%eax
c0104969:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
c0104970:	39 d8                	cmp    %ebx,%eax
c0104972:	75 ec                	jne    c0104960 <process_create+0x80>
c0104974:	83 ec 04             	sub    $0x4,%esp
c0104977:	57                   	push   %edi
c0104978:	ff 36                	push   (%esi)
c010497a:	68 c8 7a 10 c0       	push   $0xc0107ac8
c010497f:	e8 cc d0 ff ff       	call   c0101a50 <log_info>
c0104984:	83 c4 10             	add    $0x10,%esp
c0104987:	8b 7c 24 08          	mov    0x8(%esp),%edi
c010498b:	89 f0                	mov    %esi,%eax
c010498d:	8b 1c 24             	mov    (%esp),%ebx
c0104990:	8b 74 24 04          	mov    0x4(%esp),%esi
c0104994:	83 c4 0c             	add    $0xc,%esp
c0104997:	c3                   	ret
c0104998:	83 ec 08             	sub    $0x8,%esp
c010499b:	53                   	push   %ebx
c010499c:	68 98 a6 10 c0       	push   $0xc010a698
c01049a1:	e8 0a d1 ff ff       	call   c0101ab0 <log_error>
c01049a6:	83 c4 10             	add    $0x10,%esp
c01049a9:	eb e0                	jmp    c010498b <process_create+0xab>
c01049ab:	83 ec 08             	sub    $0x8,%esp
c01049ae:	53                   	push   %ebx
c01049af:	68 c4 a6 10 c0       	push   $0xc010a6c4
c01049b4:	e8 f7 d0 ff ff       	call   c0101ab0 <log_error>
c01049b9:	89 34 24             	mov    %esi,(%esp)
c01049bc:	31 f6                	xor    %esi,%esi
c01049be:	e8 7d de ff ff       	call   c0102840 <kfree>
c01049c3:	83 c4 10             	add    $0x10,%esp
c01049c6:	8b 7c 24 08          	mov    0x8(%esp),%edi
c01049ca:	eb bf                	jmp    c010498b <process_create+0xab>
c01049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

c01049d0 <address_space_destroy>:
c01049d0:	8b 44 24 04          	mov    0x4(%esp),%eax
c01049d4:	85 c0                	test   %eax,%eax
c01049d6:	74 08                	je     c01049e0 <address_space_destroy+0x10>
c01049d8:	e9 63 de ff ff       	jmp    c0102840 <kfree>
c01049dd:	8d 76 00             	lea    0x0(%esi),%esi
c01049e0:	c3                   	ret
c01049e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c01049e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01049ef:	00 

c01049f0 <switch_address_space>:
c01049f0:	8b 44 24 04          	mov    0x4(%esp),%eax
c01049f4:	85 c0                	test   %eax,%eax
c01049f6:	74 18                	je     c0104a10 <switch_address_space+0x20>
c01049f8:	8b 00                	mov    (%eax),%eax
c01049fa:	85 c0                	test   %eax,%eax
c01049fc:	74 12                	je     c0104a10 <switch_address_space+0x20>
c01049fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104a02:	e9 e9 da ff ff       	jmp    c01024f0 <vmm_switch_directory>
c0104a07:	90                   	nop
c0104a08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104a0f:	00 
c0104a10:	c3                   	ret
c0104a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0104a18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104a1f:	00 

c0104a20 <process_exec>:
c0104a20:	83 ec 0c             	sub    $0xc,%esp
c0104a23:	8b 4c 24 10          	mov    0x10(%esp),%ecx
c0104a27:	8b 44 24 14          	mov    0x14(%esp),%eax
c0104a2b:	85 c9                	test   %ecx,%ecx
c0104a2d:	74 41                	je     c0104a70 <process_exec+0x50>
c0104a2f:	85 c0                	test   %eax,%eax
c0104a31:	74 3d                	je     c0104a70 <process_exec+0x50>
c0104a33:	8b 50 08             	mov    0x8(%eax),%edx
c0104a36:	85 d2                	test   %edx,%edx
c0104a38:	74 36                	je     c0104a70 <process_exec+0x50>
c0104a3a:	89 51 24             	mov    %edx,0x24(%ecx)
c0104a3d:	8b 12                	mov    (%edx),%edx
c0104a3f:	85 d2                	test   %edx,%edx
c0104a41:	74 14                	je     c0104a57 <process_exec+0x37>
c0104a43:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104a47:	83 ec 0c             	sub    $0xc,%esp
c0104a4a:	52                   	push   %edx
c0104a4b:	e8 a0 da ff ff       	call   c01024f0 <vmm_switch_directory>
c0104a50:	8b 44 24 24          	mov    0x24(%esp),%eax
c0104a54:	83 c4 10             	add    $0x10,%esp
c0104a57:	83 ec 08             	sub    $0x8,%esp
c0104a5a:	ff 70 04             	push   0x4(%eax)
c0104a5d:	ff 30                	push   (%eax)
c0104a5f:	e8 28 b8 ff ff       	call   c010028c <jump_to_usermode>
c0104a64:	83 c4 10             	add    $0x10,%esp
c0104a67:	31 c0                	xor    %eax,%eax
c0104a69:	83 c4 0c             	add    $0xc,%esp
c0104a6c:	c3                   	ret
c0104a6d:	8d 76 00             	lea    0x0(%esi),%esi
c0104a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0104a75:	eb f2                	jmp    c0104a69 <process_exec+0x49>
c0104a77:	66 90                	xchg   %ax,%ax
c0104a79:	66 90                	xchg   %ax,%ax
c0104a7b:	66 90                	xchg   %ax,%ax
c0104a7d:	66 90                	xchg   %ax,%ax
c0104a7f:	90                   	nop

c0104a80 <thread_create>:
c0104a80:	83 ec 14             	sub    $0x14,%esp
c0104a83:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104a87:	6a 01                	push   $0x1
c0104a89:	6a 44                	push   $0x44
c0104a8b:	e8 90 dc ff ff       	call   c0102720 <kmalloc>
c0104a90:	83 c4 10             	add    $0x10,%esp
c0104a93:	89 c3                	mov    %eax,%ebx
c0104a95:	85 c0                	test   %eax,%eax
c0104a97:	0f 84 bb 00 00 00    	je     c0104b58 <thread_create+0xd8>
c0104a9d:	a1 84 35 11 c0       	mov    0xc0113584,%eax
c0104aa2:	89 74 24 08          	mov    %esi,0x8(%esp)
c0104aa6:	83 ec 04             	sub    $0x4,%esp
c0104aa9:	8d 73 04             	lea    0x4(%ebx),%esi
c0104aac:	89 03                	mov    %eax,(%ebx)
c0104aae:	8d 50 01             	lea    0x1(%eax),%edx
c0104ab1:	6a 1f                	push   $0x1f
c0104ab3:	ff 74 24 18          	push   0x18(%esp)
c0104ab7:	56                   	push   %esi
c0104ab8:	89 15 84 35 11 c0    	mov    %edx,0xc0113584
c0104abe:	e8 fd c4 ff ff       	call   c0100fc0 <strncpy>
c0104ac3:	c6 43 23 00          	movb   $0x0,0x23(%ebx)
c0104ac7:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
c0104ace:	c7 43 2c 00 10 00 00 	movl   $0x1000,0x2c(%ebx)
c0104ad5:	58                   	pop    %eax
c0104ad6:	5a                   	pop    %edx
c0104ad7:	6a 01                	push   $0x1
c0104ad9:	68 00 10 00 00       	push   $0x1000
c0104ade:	e8 3d dc ff ff       	call   c0102720 <kmalloc>
c0104ae3:	83 c4 10             	add    $0x10,%esp
c0104ae6:	89 43 28             	mov    %eax,0x28(%ebx)
c0104ae9:	85 c0                	test   %eax,%eax
c0104aeb:	0f 84 7f 00 00 00    	je     c0104b70 <thread_create+0xf0>
c0104af1:	8b 54 24 14          	mov    0x14(%esp),%edx
c0104af5:	05 e8 0f 00 00       	add    $0xfe8,%eax
c0104afa:	83 ec 04             	sub    $0x4,%esp
c0104afd:	89 53 38             	mov    %edx,0x38(%ebx)
c0104b00:	8b 54 24 1c          	mov    0x1c(%esp),%edx
c0104b04:	89 53 3c             	mov    %edx,0x3c(%ebx)
c0104b07:	c7 40 14 d0 51 10 c0 	movl   $0xc01051d0,0x14(%eax)
c0104b0e:	c7 40 10 02 02 00 00 	movl   $0x202,0x10(%eax)
c0104b15:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
c0104b1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104b23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
c0104b2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
c0104b30:	89 43 24             	mov    %eax,0x24(%ebx)
c0104b33:	56                   	push   %esi
c0104b34:	ff 33                	push   (%ebx)
c0104b36:	68 e5 7a 10 c0       	push   $0xc0107ae5
c0104b3b:	e8 10 cf ff ff       	call   c0101a50 <log_info>
c0104b40:	83 c4 10             	add    $0x10,%esp
c0104b43:	8b 74 24 08          	mov    0x8(%esp),%esi
c0104b47:	89 d8                	mov    %ebx,%eax
c0104b49:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c0104b4d:	83 c4 0c             	add    $0xc,%esp
c0104b50:	c3                   	ret
c0104b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0104b58:	83 ec 08             	sub    $0x8,%esp
c0104b5b:	ff 74 24 18          	push   0x18(%esp)
c0104b5f:	68 f4 a6 10 c0       	push   $0xc010a6f4
c0104b64:	e8 47 cf ff ff       	call   c0101ab0 <log_error>
c0104b69:	83 c4 10             	add    $0x10,%esp
c0104b6c:	eb d9                	jmp    c0104b47 <thread_create+0xc7>
c0104b6e:	66 90                	xchg   %ax,%ax
c0104b70:	83 ec 08             	sub    $0x8,%esp
c0104b73:	ff 74 24 18          	push   0x18(%esp)
c0104b77:	68 20 a7 10 c0       	push   $0xc010a720
c0104b7c:	e8 2f cf ff ff       	call   c0101ab0 <log_error>
c0104b81:	89 1c 24             	mov    %ebx,(%esp)
c0104b84:	31 db                	xor    %ebx,%ebx
c0104b86:	e8 b5 dc ff ff       	call   c0102840 <kfree>
c0104b8b:	83 c4 10             	add    $0x10,%esp
c0104b8e:	8b 74 24 08          	mov    0x8(%esp),%esi
c0104b92:	eb b3                	jmp    c0104b47 <thread_create+0xc7>
c0104b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0104b98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104b9f:	00 

c0104ba0 <thread_destroy>:
c0104ba0:	53                   	push   %ebx
c0104ba1:	83 ec 08             	sub    $0x8,%esp
c0104ba4:	8b 5c 24 10          	mov    0x10(%esp),%ebx
c0104ba8:	85 db                	test   %ebx,%ebx
c0104baa:	74 44                	je     c0104bf0 <thread_destroy+0x50>
c0104bac:	83 ec 04             	sub    $0x4,%esp
c0104baf:	8d 43 04             	lea    0x4(%ebx),%eax
c0104bb2:	50                   	push   %eax
c0104bb3:	ff 33                	push   (%ebx)
c0104bb5:	68 ff 7a 10 c0       	push   $0xc0107aff
c0104bba:	e8 91 ce ff ff       	call   c0101a50 <log_info>
c0104bbf:	8b 43 28             	mov    0x28(%ebx),%eax
c0104bc2:	c7 43 30 04 00 00 00 	movl   $0x4,0x30(%ebx)
c0104bc9:	83 c4 10             	add    $0x10,%esp
c0104bcc:	85 c0                	test   %eax,%eax
c0104bce:	74 0c                	je     c0104bdc <thread_destroy+0x3c>
c0104bd0:	83 ec 0c             	sub    $0xc,%esp
c0104bd3:	50                   	push   %eax
c0104bd4:	e8 67 dc ff ff       	call   c0102840 <kfree>
c0104bd9:	83 c4 10             	add    $0x10,%esp
c0104bdc:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0104be0:	83 c4 08             	add    $0x8,%esp
c0104be3:	5b                   	pop    %ebx
c0104be4:	e9 57 dc ff ff       	jmp    c0102840 <kfree>
c0104be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0104bf0:	83 c4 08             	add    $0x8,%esp
c0104bf3:	5b                   	pop    %ebx
c0104bf4:	c3                   	ret
c0104bf5:	66 90                	xchg   %ax,%ax
c0104bf7:	66 90                	xchg   %ax,%ax
c0104bf9:	66 90                	xchg   %ax,%ax
c0104bfb:	66 90                	xchg   %ax,%ax
c0104bfd:	66 90                	xchg   %ax,%ax
c0104bff:	90                   	nop

c0104c00 <idle_entry>:
c0104c00:	f4                   	hlt
c0104c01:	eb fd                	jmp    c0104c00 <idle_entry>
c0104c03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104c08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104c0f:	00 

c0104c10 <scheduler_init>:
c0104c10:	83 ec 0c             	sub    $0xc,%esp
c0104c13:	e8 f8 04 00 00       	call   c0105110 <scheduler_sleep_init>
c0104c18:	83 ec 04             	sub    $0x4,%esp
c0104c1b:	6a 00                	push   $0x0
c0104c1d:	68 00 4c 10 c0       	push   $0xc0104c00
c0104c22:	68 1b 7b 10 c0       	push   $0xc0107b1b
c0104c27:	e8 54 fe ff ff       	call   c0104a80 <thread_create>
c0104c2c:	83 c4 10             	add    $0x10,%esp
c0104c2f:	a3 ac 35 11 c0       	mov    %eax,0xc01135ac
c0104c34:	85 c0                	test   %eax,%eax
c0104c36:	74 26                	je     c0104c5e <scheduler_init+0x4e>
c0104c38:	83 ec 08             	sub    $0x8,%esp
c0104c3b:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
c0104c42:	ff 30                	push   (%eax)
c0104c44:	68 4c a7 10 c0       	push   $0xc010a74c
c0104c49:	83 05 a0 35 11 c0 01 	addl   $0x1,0xc01135a0
c0104c50:	a3 80 35 11 c0       	mov    %eax,0xc0113580
c0104c55:	e8 f6 cd ff ff       	call   c0101a50 <log_info>
c0104c5a:	83 c4 1c             	add    $0x1c,%esp
c0104c5d:	c3                   	ret
c0104c5e:	83 ec 0c             	sub    $0xc,%esp
c0104c61:	68 20 7b 10 c0       	push   $0xc0107b20
c0104c66:	e8 75 ce ff ff       	call   c0101ae0 <panic>
c0104c6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

c0104c70 <scheduler_enqueue>:
c0104c70:	a1 b4 35 11 c0       	mov    0xc01135b4,%eax
c0104c75:	8b 54 24 04          	mov    0x4(%esp),%edx
c0104c79:	83 f8 3f             	cmp    $0x3f,%eax
c0104c7c:	77 22                	ja     c0104ca0 <scheduler_enqueue+0x30>
c0104c7e:	8d 48 01             	lea    0x1(%eax),%ecx
c0104c81:	83 05 a0 35 11 c0 01 	addl   $0x1,0xc01135a0
c0104c88:	c7 42 30 00 00 00 00 	movl   $0x0,0x30(%edx)
c0104c8f:	89 0d b4 35 11 c0    	mov    %ecx,0xc01135b4
c0104c95:	89 14 85 c0 35 11 c0 	mov    %edx,-0x3feeca40(,%eax,4)
c0104c9c:	c3                   	ret
c0104c9d:	8d 76 00             	lea    0x0(%esi),%esi
c0104ca0:	c7 44 24 04 3d 7b 10 	movl   $0xc0107b3d,0x4(%esp)
c0104ca7:	c0 
c0104ca8:	e9 03 ce ff ff       	jmp    c0101ab0 <log_error>
c0104cad:	8d 76 00             	lea    0x0(%esi),%esi

c0104cb0 <scheduler_dequeue>:
c0104cb0:	8b 15 b4 35 11 c0    	mov    0xc01135b4,%edx
c0104cb6:	53                   	push   %ebx
c0104cb7:	8b 4c 24 08          	mov    0x8(%esp),%ecx
c0104cbb:	85 d2                	test   %edx,%edx
c0104cbd:	74 67                	je     c0104d26 <scheduler_dequeue+0x76>
c0104cbf:	31 c0                	xor    %eax,%eax
c0104cc1:	eb 14                	jmp    c0104cd7 <scheduler_dequeue+0x27>
c0104cc3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104cc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104ccf:	00 
c0104cd0:	83 c0 01             	add    $0x1,%eax
c0104cd3:	39 d0                	cmp    %edx,%eax
c0104cd5:	74 4f                	je     c0104d26 <scheduler_dequeue+0x76>
c0104cd7:	39 0c 85 c0 35 11 c0 	cmp    %ecx,-0x3feeca40(,%eax,4)
c0104cde:	75 f0                	jne    c0104cd0 <scheduler_dequeue+0x20>
c0104ce0:	8d 5a ff             	lea    -0x1(%edx),%ebx
c0104ce3:	39 d8                	cmp    %ebx,%eax
c0104ce5:	73 2e                	jae    c0104d15 <scheduler_dequeue+0x65>
c0104ce7:	eb 17                	jmp    c0104d00 <scheduler_dequeue+0x50>
c0104ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0104cf0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104cf7:	00 
c0104cf8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104cff:	00 
c0104d00:	83 c0 01             	add    $0x1,%eax
c0104d03:	8b 0c 85 c0 35 11 c0 	mov    -0x3feeca40(,%eax,4),%ecx
c0104d0a:	89 0c 85 bc 35 11 c0 	mov    %ecx,-0x3feeca44(,%eax,4)
c0104d11:	39 d8                	cmp    %ebx,%eax
c0104d13:	75 eb                	jne    c0104d00 <scheduler_dequeue+0x50>
c0104d15:	89 1d b4 35 11 c0    	mov    %ebx,0xc01135b4
c0104d1b:	83 ea 02             	sub    $0x2,%edx
c0104d1e:	3b 15 b0 35 11 c0    	cmp    0xc01135b0,%edx
c0104d24:	72 0a                	jb     c0104d30 <scheduler_dequeue+0x80>
c0104d26:	5b                   	pop    %ebx
c0104d27:	c3                   	ret
c0104d28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104d2f:	00 
c0104d30:	c7 05 b0 35 11 c0 00 	movl   $0x0,0xc01135b0
c0104d37:	00 00 00 
c0104d3a:	5b                   	pop    %ebx
c0104d3b:	c3                   	ret
c0104d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

c0104d40 <scheduler_pick_next>:
c0104d40:	57                   	push   %edi
c0104d41:	8b 0d b0 35 11 c0    	mov    0xc01135b0,%ecx
c0104d47:	56                   	push   %esi
c0104d48:	53                   	push   %ebx
c0104d49:	8b 1d b4 35 11 c0    	mov    0xc01135b4,%ebx
c0104d4f:	8d 3c 0b             	lea    (%ebx,%ecx,1),%edi
c0104d52:	85 db                	test   %ebx,%ebx
c0104d54:	74 25                	je     c0104d7b <scheduler_pick_next+0x3b>
c0104d56:	66 90                	xchg   %ax,%ax
c0104d58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104d5f:	00 
c0104d60:	89 c8                	mov    %ecx,%eax
c0104d62:	31 d2                	xor    %edx,%edx
c0104d64:	f7 f3                	div    %ebx
c0104d66:	8b 34 95 c0 35 11 c0 	mov    -0x3feeca40(,%edx,4),%esi
c0104d6d:	8b 46 30             	mov    0x30(%esi),%eax
c0104d70:	85 c0                	test   %eax,%eax
c0104d72:	74 1c                	je     c0104d90 <scheduler_pick_next+0x50>
c0104d74:	83 c1 01             	add    $0x1,%ecx
c0104d77:	39 cf                	cmp    %ecx,%edi
c0104d79:	75 e5                	jne    c0104d60 <scheduler_pick_next+0x20>
c0104d7b:	8b 35 ac 35 11 c0    	mov    0xc01135ac,%esi
c0104d81:	5b                   	pop    %ebx
c0104d82:	89 f0                	mov    %esi,%eax
c0104d84:	5e                   	pop    %esi
c0104d85:	5f                   	pop    %edi
c0104d86:	c3                   	ret
c0104d87:	90                   	nop
c0104d88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104d8f:	00 
c0104d90:	8d 42 01             	lea    0x1(%edx),%eax
c0104d93:	31 d2                	xor    %edx,%edx
c0104d95:	f7 f3                	div    %ebx
c0104d97:	89 f0                	mov    %esi,%eax
c0104d99:	5b                   	pop    %ebx
c0104d9a:	5e                   	pop    %esi
c0104d9b:	5f                   	pop    %edi
c0104d9c:	89 15 b0 35 11 c0    	mov    %edx,0xc01135b0
c0104da2:	c3                   	ret
c0104da3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104da8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104daf:	00 

c0104db0 <scheduler_tick>:
c0104db0:	8b 0d 80 35 11 c0    	mov    0xc0113580,%ecx
c0104db6:	85 c9                	test   %ecx,%ecx
c0104db8:	0f 84 c2 00 00 00    	je     c0104e80 <scheduler_tick+0xd0>
c0104dbe:	83 ec 1c             	sub    $0x1c,%esp
c0104dc1:	e8 aa 03 00 00       	call   c0105170 <scheduler_wake_sleeping>
c0104dc6:	a1 20 b0 10 c0       	mov    0xc010b020,%eax
c0104dcb:	83 e8 01             	sub    $0x1,%eax
c0104dce:	74 10                	je     c0104de0 <scheduler_tick+0x30>
c0104dd0:	a3 20 b0 10 c0       	mov    %eax,0xc010b020
c0104dd5:	83 c4 1c             	add    $0x1c,%esp
c0104dd8:	c3                   	ret
c0104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0104de0:	c7 05 20 b0 10 c0 0a 	movl   $0xa,0xc010b020
c0104de7:	00 00 00 
c0104dea:	e8 51 ff ff ff       	call   c0104d40 <scheduler_pick_next>
c0104def:	8b 15 80 35 11 c0    	mov    0xc0113580,%edx
c0104df5:	8b 0d ac 35 11 c0    	mov    0xc01135ac,%ecx
c0104dfb:	39 c2                	cmp    %eax,%edx
c0104dfd:	0f 84 a5 00 00 00    	je     c0104ea8 <scheduler_tick+0xf8>
c0104e03:	83 7a 30 01          	cmpl   $0x1,0x30(%edx)
c0104e07:	74 7f                	je     c0104e88 <scheduler_tick+0xd8>
c0104e09:	83 05 a8 35 11 c0 01 	addl   $0x1,0xc01135a8
c0104e10:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
c0104e17:	a3 80 35 11 c0       	mov    %eax,0xc0113580
c0104e1c:	39 ca                	cmp    %ecx,%edx
c0104e1e:	74 78                	je     c0104e98 <scheduler_tick+0xe8>
c0104e20:	8b 48 40             	mov    0x40(%eax),%ecx
c0104e23:	39 4a 40             	cmp    %ecx,0x40(%edx)
c0104e26:	74 27                	je     c0104e4f <scheduler_tick+0x9f>
c0104e28:	85 c9                	test   %ecx,%ecx
c0104e2a:	74 23                	je     c0104e4f <scheduler_tick+0x9f>
c0104e2c:	8b 49 24             	mov    0x24(%ecx),%ecx
c0104e2f:	85 c9                	test   %ecx,%ecx
c0104e31:	74 1c                	je     c0104e4f <scheduler_tick+0x9f>
c0104e33:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e37:	83 ec 0c             	sub    $0xc,%esp
c0104e3a:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104e3e:	51                   	push   %ecx
c0104e3f:	e8 ac fb ff ff       	call   c01049f0 <switch_address_space>
c0104e44:	8b 44 24 1c          	mov    0x1c(%esp),%eax
c0104e48:	8b 54 24 18          	mov    0x18(%esp),%edx
c0104e4c:	83 c4 10             	add    $0x10,%esp
c0104e4f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0104e53:	83 ec 0c             	sub    $0xc,%esp
c0104e56:	50                   	push   %eax
c0104e57:	89 44 24 18          	mov    %eax,0x18(%esp)
c0104e5b:	e8 70 b5 ff ff       	call   c01003d0 <tss_prepare>
c0104e60:	58                   	pop    %eax
c0104e61:	5a                   	pop    %edx
c0104e62:	8b 44 24 10          	mov    0x10(%esp),%eax
c0104e66:	50                   	push   %eax
c0104e67:	8b 54 24 18          	mov    0x18(%esp),%edx
c0104e6b:	52                   	push   %edx
c0104e6c:	e8 02 b4 ff ff       	call   c0100273 <context_switch>
c0104e71:	83 c4 10             	add    $0x10,%esp
c0104e74:	83 c4 1c             	add    $0x1c,%esp
c0104e77:	c3                   	ret
c0104e78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104e7f:	00 
c0104e80:	c3                   	ret
c0104e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0104e88:	c7 42 30 00 00 00 00 	movl   $0x0,0x30(%edx)
c0104e8f:	e9 75 ff ff ff       	jmp    c0104e09 <scheduler_tick+0x59>
c0104e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0104e98:	83 05 a4 35 11 c0 0a 	addl   $0xa,0xc01135a4
c0104e9f:	e9 7c ff ff ff       	jmp    c0104e20 <scheduler_tick+0x70>
c0104ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0104ea8:	39 ca                	cmp    %ecx,%edx
c0104eaa:	0f 85 25 ff ff ff    	jne    c0104dd5 <scheduler_tick+0x25>
c0104eb0:	83 05 a4 35 11 c0 0a 	addl   $0xa,0xc01135a4
c0104eb7:	e9 19 ff ff ff       	jmp    c0104dd5 <scheduler_tick+0x25>
c0104ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

c0104ec0 <scheduler_yield>:
c0104ec0:	cd 20                	int    $0x20
c0104ec2:	c3                   	ret
c0104ec3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104ec8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104ecf:	00 

c0104ed0 <scheduler_exit_current>:
c0104ed0:	56                   	push   %esi
c0104ed1:	53                   	push   %ebx
c0104ed2:	83 ec 04             	sub    $0x4,%esp
c0104ed5:	a1 80 35 11 c0       	mov    0xc0113580,%eax
c0104eda:	c7 40 30 04 00 00 00 	movl   $0x4,0x30(%eax)
c0104ee1:	50                   	push   %eax
c0104ee2:	e8 c9 fd ff ff       	call   c0104cb0 <scheduler_dequeue>
c0104ee7:	e8 54 fe ff ff       	call   c0104d40 <scheduler_pick_next>
c0104eec:	8b 35 80 35 11 c0    	mov    0xc0113580,%esi
c0104ef2:	83 05 a8 35 11 c0 01 	addl   $0x1,0xc01135a8
c0104ef9:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
c0104f00:	89 c3                	mov    %eax,%ebx
c0104f02:	59                   	pop    %ecx
c0104f03:	a3 80 35 11 c0       	mov    %eax,0xc0113580
c0104f08:	8b 40 40             	mov    0x40(%eax),%eax
c0104f0b:	39 46 40             	cmp    %eax,0x40(%esi)
c0104f0e:	74 17                	je     c0104f27 <scheduler_exit_current+0x57>
c0104f10:	85 c0                	test   %eax,%eax
c0104f12:	74 13                	je     c0104f27 <scheduler_exit_current+0x57>
c0104f14:	8b 40 24             	mov    0x24(%eax),%eax
c0104f17:	85 c0                	test   %eax,%eax
c0104f19:	74 0c                	je     c0104f27 <scheduler_exit_current+0x57>
c0104f1b:	83 ec 0c             	sub    $0xc,%esp
c0104f1e:	50                   	push   %eax
c0104f1f:	e8 cc fa ff ff       	call   c01049f0 <switch_address_space>
c0104f24:	83 c4 10             	add    $0x10,%esp
c0104f27:	83 ec 0c             	sub    $0xc,%esp
c0104f2a:	53                   	push   %ebx
c0104f2b:	e8 a0 b4 ff ff       	call   c01003d0 <tss_prepare>
c0104f30:	58                   	pop    %eax
c0104f31:	5a                   	pop    %edx
c0104f32:	53                   	push   %ebx
c0104f33:	56                   	push   %esi
c0104f34:	e8 3a b3 ff ff       	call   c0100273 <context_switch>
c0104f39:	83 c4 14             	add    $0x14,%esp
c0104f3c:	5b                   	pop    %ebx
c0104f3d:	5e                   	pop    %esi
c0104f3e:	c3                   	ret
c0104f3f:	90                   	nop

c0104f40 <scheduler_make_ready>:
c0104f40:	8b 44 24 04          	mov    0x4(%esp),%eax
c0104f44:	85 c0                	test   %eax,%eax
c0104f46:	74 29                	je     c0104f71 <scheduler_make_ready+0x31>
c0104f48:	8b 15 b4 35 11 c0    	mov    0xc01135b4,%edx
c0104f4e:	83 fa 3f             	cmp    $0x3f,%edx
c0104f51:	77 25                	ja     c0104f78 <scheduler_make_ready+0x38>
c0104f53:	8d 4a 01             	lea    0x1(%edx),%ecx
c0104f56:	83 05 a0 35 11 c0 01 	addl   $0x1,0xc01135a0
c0104f5d:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
c0104f64:	89 0d b4 35 11 c0    	mov    %ecx,0xc01135b4
c0104f6a:	89 04 95 c0 35 11 c0 	mov    %eax,-0x3feeca40(,%edx,4)
c0104f71:	c3                   	ret
c0104f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0104f78:	c7 44 24 04 3d 7b 10 	movl   $0xc0107b3d,0x4(%esp)
c0104f7f:	c0 
c0104f80:	e9 2b cb ff ff       	jmp    c0101ab0 <log_error>
c0104f85:	8d 76 00             	lea    0x0(%esi),%esi
c0104f88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104f8f:	00 

c0104f90 <switch_thread>:
c0104f90:	56                   	push   %esi
c0104f91:	53                   	push   %ebx
c0104f92:	83 ec 04             	sub    $0x4,%esp
c0104f95:	8b 5c 24 14          	mov    0x14(%esp),%ebx
c0104f99:	8b 74 24 10          	mov    0x10(%esp),%esi
c0104f9d:	8b 43 40             	mov    0x40(%ebx),%eax
c0104fa0:	39 46 40             	cmp    %eax,0x40(%esi)
c0104fa3:	74 17                	je     c0104fbc <switch_thread+0x2c>
c0104fa5:	85 c0                	test   %eax,%eax
c0104fa7:	74 13                	je     c0104fbc <switch_thread+0x2c>
c0104fa9:	8b 40 24             	mov    0x24(%eax),%eax
c0104fac:	85 c0                	test   %eax,%eax
c0104fae:	74 0c                	je     c0104fbc <switch_thread+0x2c>
c0104fb0:	83 ec 0c             	sub    $0xc,%esp
c0104fb3:	50                   	push   %eax
c0104fb4:	e8 37 fa ff ff       	call   c01049f0 <switch_address_space>
c0104fb9:	83 c4 10             	add    $0x10,%esp
c0104fbc:	83 ec 0c             	sub    $0xc,%esp
c0104fbf:	53                   	push   %ebx
c0104fc0:	e8 0b b4 ff ff       	call   c01003d0 <tss_prepare>
c0104fc5:	89 5c 24 24          	mov    %ebx,0x24(%esp)
c0104fc9:	89 74 24 20          	mov    %esi,0x20(%esp)
c0104fcd:	83 c4 14             	add    $0x14,%esp
c0104fd0:	5b                   	pop    %ebx
c0104fd1:	5e                   	pop    %esi
c0104fd2:	e9 9c b2 ff ff       	jmp    c0100273 <context_switch>
c0104fd7:	90                   	nop
c0104fd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c0104fdf:	00 

c0104fe0 <scheduler_stats>:
c0104fe0:	53                   	push   %ebx
c0104fe1:	83 ec 08             	sub    $0x8,%esp
c0104fe4:	e8 67 bf ff ff       	call   c0100f50 <timer_get_ticks>
c0104fe9:	83 ec 0c             	sub    $0xc,%esp
c0104fec:	68 78 a7 10 c0       	push   $0xc010a778
c0104ff1:	89 c3                	mov    %eax,%ebx
c0104ff3:	e8 58 ca ff ff       	call   c0101a50 <log_info>
c0104ff8:	58                   	pop    %eax
c0104ff9:	5a                   	pop    %edx
c0104ffa:	53                   	push   %ebx
c0104ffb:	68 4f 7b 10 c0       	push   $0xc0107b4f
c0105000:	e8 4b ca ff ff       	call   c0101a50 <log_info>
c0105005:	59                   	pop    %ecx
c0105006:	5b                   	pop    %ebx
c0105007:	ff 35 a8 35 11 c0    	push   0xc01135a8
c010500d:	68 66 7b 10 c0       	push   $0xc0107b66
c0105012:	e8 39 ca ff ff       	call   c0101a50 <log_info>
c0105017:	58                   	pop    %eax
c0105018:	5a                   	pop    %edx
c0105019:	ff 35 a0 35 11 c0    	push   0xc01135a0
c010501f:	68 7d 7b 10 c0       	push   $0xc0107b7d
c0105024:	e8 27 ca ff ff       	call   c0101a50 <log_info>
c0105029:	59                   	pop    %ecx
c010502a:	5b                   	pop    %ebx
c010502b:	ff 35 b4 35 11 c0    	push   0xc01135b4
c0105031:	68 94 7b 10 c0       	push   $0xc0107b94
c0105036:	e8 15 ca ff ff       	call   c0101a50 <log_info>
c010503b:	58                   	pop    %eax
c010503c:	5a                   	pop    %edx
c010503d:	ff 35 a4 35 11 c0    	push   0xc01135a4
c0105043:	68 ab 7b 10 c0       	push   $0xc0107bab
c0105048:	e8 03 ca ff ff       	call   c0101a50 <log_info>
c010504d:	83 c4 0c             	add    $0xc,%esp
c0105050:	6a 64                	push   $0x64
c0105052:	6a 0a                	push   $0xa
c0105054:	68 a4 a7 10 c0       	push   $0xc010a7a4
c0105059:	e8 f2 c9 ff ff       	call   c0101a50 <log_info>
c010505e:	c7 04 24 cc a7 10 c0 	movl   $0xc010a7cc,(%esp)
c0105065:	e8 e6 c9 ff ff       	call   c0101a50 <log_info>
c010506a:	83 c4 18             	add    $0x18,%esp
c010506d:	5b                   	pop    %ebx
c010506e:	c3                   	ret
c010506f:	90                   	nop

c0105070 <compare_wakeup_tick>:
c0105070:	8b 54 24 04          	mov    0x4(%esp),%edx
c0105074:	8b 44 24 08          	mov    0x8(%esp),%eax
c0105078:	8b 40 34             	mov    0x34(%eax),%eax
c010507b:	39 42 34             	cmp    %eax,0x34(%edx)
c010507e:	0f 92 c0             	setb   %al
c0105081:	c3                   	ret
c0105082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0105088:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010508f:	00 

c0105090 <scheduler_sleep_ticks.part.0>:
c0105090:	56                   	push   %esi
c0105091:	89 c6                	mov    %eax,%esi
c0105093:	53                   	push   %ebx
c0105094:	83 ec 04             	sub    $0x4,%esp
c0105097:	e8 b4 c8 ff ff       	call   c0101950 <irq_save>
c010509c:	89 c3                	mov    %eax,%ebx
c010509e:	e8 ad be ff ff       	call   c0100f50 <timer_get_ticks>
c01050a3:	8b 15 80 35 11 c0    	mov    0xc0113580,%edx
c01050a9:	83 ec 0c             	sub    $0xc,%esp
c01050ac:	01 f0                	add    %esi,%eax
c01050ae:	89 42 34             	mov    %eax,0x34(%edx)
c01050b1:	c7 42 30 03 00 00 00 	movl   $0x3,0x30(%edx)
c01050b8:	52                   	push   %edx
c01050b9:	e8 f2 fb ff ff       	call   c0104cb0 <scheduler_dequeue>
c01050be:	83 c4 0c             	add    $0xc,%esp
c01050c1:	68 70 50 10 c0       	push   $0xc0105070
c01050c6:	ff 35 80 35 11 c0    	push   0xc0113580
c01050cc:	68 c0 36 11 c0       	push   $0xc01136c0
c01050d1:	e8 ea c6 ff ff       	call   c01017c0 <list_insert_sorted>
c01050d6:	e8 65 fc ff ff       	call   c0104d40 <scheduler_pick_next>
c01050db:	8b 15 80 35 11 c0    	mov    0xc0113580,%edx
c01050e1:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
c01050e8:	59                   	pop    %ecx
c01050e9:	5e                   	pop    %esi
c01050ea:	50                   	push   %eax
c01050eb:	52                   	push   %edx
c01050ec:	a3 80 35 11 c0       	mov    %eax,0xc0113580
c01050f1:	e8 7d b1 ff ff       	call   c0100273 <context_switch>
c01050f6:	89 1c 24             	mov    %ebx,(%esp)
c01050f9:	e8 62 c8 ff ff       	call   c0101960 <irq_restore>
c01050fe:	83 c4 14             	add    $0x14,%esp
c0105101:	5b                   	pop    %ebx
c0105102:	5e                   	pop    %esi
c0105103:	c3                   	ret
c0105104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
c0105108:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010510f:	00 

c0105110 <scheduler_sleep_init>:
c0105110:	83 ec 18             	sub    $0x18,%esp
c0105113:	68 c0 36 11 c0       	push   $0xc01136c0
c0105118:	e8 33 c5 ff ff       	call   c0101650 <list_init>
c010511d:	83 c4 1c             	add    $0x1c,%esp
c0105120:	c3                   	ret
c0105121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0105128:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010512f:	00 

c0105130 <scheduler_sleep_ticks>:
c0105130:	8b 44 24 04          	mov    0x4(%esp),%eax
c0105134:	85 c0                	test   %eax,%eax
c0105136:	75 08                	jne    c0105140 <scheduler_sleep_ticks+0x10>
c0105138:	c3                   	ret
c0105139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
c0105140:	e9 4b ff ff ff       	jmp    c0105090 <scheduler_sleep_ticks.part.0>
c0105145:	8d 76 00             	lea    0x0(%esi),%esi
c0105148:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010514f:	00 

c0105150 <scheduler_sleep_ms>:
c0105150:	8b 4c 24 04          	mov    0x4(%esp),%ecx
c0105154:	b8 01 00 00 00       	mov    $0x1,%eax
c0105159:	83 f9 09             	cmp    $0x9,%ecx
c010515c:	76 0c                	jbe    c010516a <scheduler_sleep_ms+0x1a>
c010515e:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
c0105163:	f7 e1                	mul    %ecx
c0105165:	89 d0                	mov    %edx,%eax
c0105167:	c1 e8 03             	shr    $0x3,%eax
c010516a:	e9 21 ff ff ff       	jmp    c0105090 <scheduler_sleep_ticks.part.0>
c010516f:	90                   	nop

c0105170 <scheduler_wake_sleeping>:
c0105170:	83 ec 0c             	sub    $0xc,%esp
c0105173:	89 74 24 08          	mov    %esi,0x8(%esp)
c0105177:	e8 d4 bd ff ff       	call   c0100f50 <timer_get_ticks>
c010517c:	89 c6                	mov    %eax,%esi
c010517e:	a1 c0 36 11 c0       	mov    0xc01136c0,%eax
c0105183:	85 c0                	test   %eax,%eax
c0105185:	74 36                	je     c01051bd <scheduler_wake_sleeping+0x4d>
c0105187:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010518b:	eb 24                	jmp    c01051b1 <scheduler_wake_sleeping+0x41>
c010518d:	8d 76 00             	lea    0x0(%esi),%esi
c0105190:	83 ec 0c             	sub    $0xc,%esp
c0105193:	68 c0 36 11 c0       	push   $0xc01136c0
c0105198:	e8 23 c5 ff ff       	call   c01016c0 <list_pop_front>
c010519d:	89 1c 24             	mov    %ebx,(%esp)
c01051a0:	e8 cb fa ff ff       	call   c0104c70 <scheduler_enqueue>
c01051a5:	a1 c0 36 11 c0       	mov    0xc01136c0,%eax
c01051aa:	83 c4 10             	add    $0x10,%esp
c01051ad:	85 c0                	test   %eax,%eax
c01051af:	74 08                	je     c01051b9 <scheduler_wake_sleeping+0x49>
c01051b1:	8b 58 08             	mov    0x8(%eax),%ebx
c01051b4:	3b 73 34             	cmp    0x34(%ebx),%esi
c01051b7:	73 d7                	jae    c0105190 <scheduler_wake_sleeping+0x20>
c01051b9:	8b 5c 24 04          	mov    0x4(%esp),%ebx
c01051bd:	8b 74 24 08          	mov    0x8(%esp),%esi
c01051c1:	83 c4 0c             	add    $0xc,%esp
c01051c4:	c3                   	ret
c01051c5:	66 90                	xchg   %ax,%ax
c01051c7:	66 90                	xchg   %ax,%ax
c01051c9:	66 90                	xchg   %ax,%ax
c01051cb:	66 90                	xchg   %ax,%ax
c01051cd:	66 90                	xchg   %ax,%ax
c01051cf:	90                   	nop

c01051d0 <thread_trampoline>:
c01051d0:	83 ec 18             	sub    $0x18,%esp
c01051d3:	a1 80 35 11 c0       	mov    0xc0113580,%eax
c01051d8:	ff 70 3c             	push   0x3c(%eax)
c01051db:	ff 50 38             	call   *0x38(%eax)
c01051de:	e8 ed fc ff ff       	call   c0104ed0 <scheduler_exit_current>
c01051e3:	83 c4 10             	add    $0x10,%esp
c01051e6:	66 90                	xchg   %ax,%ax
c01051e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01051ef:	00 
c01051f0:	f4                   	hlt
c01051f1:	eb fd                	jmp    c01051f0 <thread_trampoline+0x20>
c01051f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c01051f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01051ff:	00 

c0105200 <kthread_create>:
c0105200:	83 ec 20             	sub    $0x20,%esp
c0105203:	ff 74 24 2c          	push   0x2c(%esp)
c0105207:	ff 74 24 2c          	push   0x2c(%esp)
c010520b:	ff 74 24 2c          	push   0x2c(%esp)
c010520f:	e8 6c f8 ff ff       	call   c0104a80 <thread_create>
c0105214:	83 c4 10             	add    $0x10,%esp
c0105217:	85 c0                	test   %eax,%eax
c0105219:	74 14                	je     c010522f <kthread_create+0x2f>
c010521b:	83 ec 0c             	sub    $0xc,%esp
c010521e:	50                   	push   %eax
c010521f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0105223:	e8 48 fa ff ff       	call   c0104c70 <scheduler_enqueue>
c0105228:	8b 44 24 1c          	mov    0x1c(%esp),%eax
c010522c:	83 c4 10             	add    $0x10,%esp
c010522f:	83 c4 1c             	add    $0x1c,%esp
c0105232:	c3                   	ret
c0105233:	66 90                	xchg   %ax,%ax
c0105235:	66 90                	xchg   %ax,%ax
c0105237:	66 90                	xchg   %ax,%ax
c0105239:	66 90                	xchg   %ax,%ax
c010523b:	66 90                	xchg   %ax,%ax
c010523d:	66 90                	xchg   %ax,%ax
c010523f:	90                   	nop

c0105240 <user_init_thread>:
c0105240:	83 ec 18             	sub    $0x18,%esp
c0105243:	68 c2 7b 10 c0       	push   $0xc0107bc2
c0105248:	e8 03 c8 ff ff       	call   c0101a50 <log_info>
c010524d:	58                   	pop    %eax
c010524e:	5a                   	pop    %edx
c010524f:	68 e8 36 11 c0       	push   $0xc01136e8
c0105254:	ff 35 f4 36 11 c0    	push   0xc01136f4
c010525a:	e8 c1 f7 ff ff       	call   c0104a20 <process_exec>
c010525f:	83 c4 1c             	add    $0x1c,%esp
c0105262:	c3                   	ret
c0105263:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
c0105268:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010526f:	00 

c0105270 <mutex_test_thread>:
c0105270:	56                   	push   %esi
c0105271:	be 03 00 00 00       	mov    $0x3,%esi
c0105276:	53                   	push   %ebx
c0105277:	83 ec 04             	sub    $0x4,%esp
c010527a:	8b 5c 24 10          	mov    0x10(%esp),%ebx
c010527e:	83 ec 08             	sub    $0x8,%esp
c0105281:	53                   	push   %ebx
c0105282:	68 f8 a7 10 c0       	push   $0xc010a7f8
c0105287:	e8 c4 c7 ff ff       	call   c0101a50 <log_info>
c010528c:	c7 04 24 cc 36 11 c0 	movl   $0xc01136cc,(%esp)
c0105293:	e8 08 da ff ff       	call   c0102ca0 <mutex_acquire>
c0105298:	58                   	pop    %eax
c0105299:	5a                   	pop    %edx
c010529a:	53                   	push   %ebx
c010529b:	68 1c a8 10 c0       	push   $0xc010a81c
c01052a0:	e8 ab c7 ff ff       	call   c0101a50 <log_info>
c01052a5:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
c01052ac:	e8 9f fe ff ff       	call   c0105150 <scheduler_sleep_ms>
c01052b1:	59                   	pop    %ecx
c01052b2:	58                   	pop    %eax
c01052b3:	53                   	push   %ebx
c01052b4:	68 4c a8 10 c0       	push   $0xc010a84c
c01052b9:	e8 92 c7 ff ff       	call   c0101a50 <log_info>
c01052be:	c7 04 24 cc 36 11 c0 	movl   $0xc01136cc,(%esp)
c01052c5:	e8 86 da ff ff       	call   c0102d50 <mutex_release>
c01052ca:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
c01052d1:	e8 7a fe ff ff       	call   c0105150 <scheduler_sleep_ms>
c01052d6:	83 c4 10             	add    $0x10,%esp
c01052d9:	83 ee 01             	sub    $0x1,%esi
c01052dc:	75 a0                	jne    c010527e <mutex_test_thread+0xe>
c01052de:	83 ec 08             	sub    $0x8,%esp
c01052e1:	53                   	push   %ebx
c01052e2:	68 da 7b 10 c0       	push   $0xc0107bda
c01052e7:	e8 64 c7 ff ff       	call   c0101a50 <log_info>
c01052ec:	83 c4 14             	add    $0x14,%esp
c01052ef:	5b                   	pop    %ebx
c01052f0:	5e                   	pop    %esi
c01052f1:	c3                   	ret
c01052f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c01052f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c01052ff:	00 

c0105300 <kernel_main>:
c0105300:	57                   	push   %edi
c0105301:	56                   	push   %esi
c0105302:	53                   	push   %ebx
c0105303:	81 ec 90 15 00 00    	sub    $0x1590,%esp
c0105309:	e8 a2 b7 ff ff       	call   c0100ab0 <console_init>
c010530e:	83 ec 0c             	sub    $0xc,%esp
c0105311:	68 78 a8 10 c0       	push   $0xc010a878
c0105316:	e8 35 c7 ff ff       	call   c0101a50 <log_info>
c010531b:	e8 90 af ff ff       	call   c01002b0 <gdt_init>
c0105320:	e8 cb b0 ff ff       	call   c01003f0 <idt_init>
c0105325:	c7 04 24 b0 a8 10 c0 	movl   $0xc010a8b0,(%esp)
c010532c:	e8 1f c7 ff ff       	call   c0101a50 <log_info>
c0105331:	5e                   	pop    %esi
c0105332:	ff b4 24 ac 15 00 00 	push   0x15ac(%esp)
c0105339:	e8 f2 c8 ff ff       	call   c0101c30 <pmm_init>
c010533e:	e8 8d cf ff ff       	call   c01022d0 <vmm_init>
c0105343:	e8 98 d3 ff ff       	call   c01026e0 <heap_init>
c0105348:	e8 c3 f8 ff ff       	call   c0104c10 <scheduler_init>
c010534d:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
c0105354:	e8 a7 bb ff ff       	call   c0100f00 <timer_init>
c0105359:	e8 b2 de ff ff       	call   c0103210 <syscall_init>
c010535e:	e8 0d e0 ff ff       	call   c0103370 <vfs_init>
c0105363:	e8 f8 e7 ff ff       	call   c0103b60 <ramfs_init>
c0105368:	e8 13 f3 ff ff       	call   c0104680 <device_manager_init>
c010536d:	e8 5e ba ff ff       	call   c0100dd0 <console_dev_init>
c0105372:	e8 b9 ee ff ff       	call   c0104230 <devfs_init>
c0105377:	83 c4 0c             	add    $0xc,%esp
c010537a:	6a 00                	push   $0x0
c010537c:	68 e3 79 10 c0       	push   $0xc01079e3
c0105381:	68 e1 79 10 c0       	push   $0xc01079e1
c0105386:	e8 55 e0 ff ff       	call   c01033e0 <vfs_mount>
c010538b:	83 c4 0c             	add    $0xc,%esp
c010538e:	6a 00                	push   $0x0
c0105390:	68 e9 79 10 c0       	push   $0xc01079e9
c0105395:	68 e9 7b 10 c0       	push   $0xc0107be9
c010539a:	e8 41 e0 ff ff       	call   c01033e0 <vfs_mount>
c010539f:	c7 04 24 ee 7b 10 c0 	movl   $0xc0107bee,(%esp)
c01053a6:	e8 a5 c6 ff ff       	call   c0101a50 <log_info>
c01053ab:	c7 04 24 0b 7c 10 c0 	movl   $0xc0107c0b,(%esp)
c01053b2:	e8 29 f5 ff ff       	call   c01048e0 <process_create>
c01053b7:	c7 04 24 12 7c 10 c0 	movl   $0xc0107c12,(%esp)
c01053be:	89 c3                	mov    %eax,%ebx
c01053c0:	e8 1b f5 ff ff       	call   c01048e0 <process_create>
c01053c5:	5f                   	pop    %edi
c01053c6:	ff 73 24             	push   0x24(%ebx)
c01053c9:	89 c6                	mov    %eax,%esi
c01053cb:	e8 20 f6 ff ff       	call   c01049f0 <switch_address_space>
c01053d0:	e8 5b cb ff ff       	call   c0101f30 <pmm_alloc_frame>
c01053d5:	83 c4 0c             	add    $0xc,%esp
c01053d8:	6a 07                	push   $0x7
c01053da:	50                   	push   %eax
c01053db:	68 00 00 40 00       	push   $0x400000
c01053e0:	e8 2b cf ff ff       	call   c0102310 <vmm_map>
c01053e5:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
c01053ec:	00 00 00 
c01053ef:	58                   	pop    %eax
c01053f0:	ff 76 24             	push   0x24(%esi)
c01053f3:	e8 f8 f5 ff ff       	call   c01049f0 <switch_address_space>
c01053f8:	e8 33 cb ff ff       	call   c0101f30 <pmm_alloc_frame>
c01053fd:	83 c4 0c             	add    $0xc,%esp
c0105400:	6a 07                	push   $0x7
c0105402:	50                   	push   %eax
c0105403:	68 00 00 40 00       	push   $0x400000
c0105408:	e8 03 cf ff ff       	call   c0102310 <vmm_map>
c010540d:	c7 05 00 00 40 00 63 	movl   $0x63,0x400000
c0105414:	00 00 00 
c0105417:	58                   	pop    %eax
c0105418:	ff 73 24             	push   0x24(%ebx)
c010541b:	e8 d0 f5 ff ff       	call   c01049f0 <switch_address_space>
c0105420:	83 c4 10             	add    $0x10,%esp
c0105423:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
c010542a:	0f 84 35 01 00 00    	je     c0105565 <kernel_main+0x265>
c0105430:	53                   	push   %ebx
c0105431:	53                   	push   %ebx
c0105432:	ff 35 00 00 40 00    	push   0x400000
c0105438:	68 fc a8 10 c0       	push   $0xc010a8fc
c010543d:	e8 6e c6 ff ff       	call   c0101ab0 <log_error>
c0105442:	83 c4 10             	add    $0x10,%esp
c0105445:	83 ec 0c             	sub    $0xc,%esp
c0105448:	68 28 a9 10 c0       	push   $0xc010a928
c010544d:	e8 fe c5 ff ff       	call   c0101a50 <log_info>
c0105452:	c7 04 24 54 a9 10 c0 	movl   $0xc010a954,(%esp)
c0105459:	8d 7c 24 14          	lea    0x14(%esp),%edi
c010545d:	e8 ee c5 ff ff       	call   c0101a50 <log_info>
c0105462:	83 c4 0c             	add    $0xc,%esp
c0105465:	68 8c 15 00 00       	push   $0x158c
c010546a:	68 60 60 10 c0       	push   $0xc0106060
c010546f:	57                   	push   %edi
c0105470:	e8 6b bc ff ff       	call   c01010e0 <memcpy>
c0105475:	c7 04 24 cc 36 11 c0 	movl   $0xc01136cc,(%esp)
c010547c:	e8 df d7 ff ff       	call   c0102c60 <mutex_init>
c0105481:	83 c4 0c             	add    $0xc,%esp
c0105484:	68 19 7c 10 c0       	push   $0xc0107c19
c0105489:	68 70 52 10 c0       	push   $0xc0105270
c010548e:	68 22 7c 10 c0       	push   $0xc0107c22
c0105493:	e8 e8 f5 ff ff       	call   c0104a80 <thread_create>
c0105498:	83 c4 0c             	add    $0xc,%esp
c010549b:	68 2d 7c 10 c0       	push   $0xc0107c2d
c01054a0:	89 c6                	mov    %eax,%esi
c01054a2:	68 70 52 10 c0       	push   $0xc0105270
c01054a7:	68 36 7c 10 c0       	push   $0xc0107c36
c01054ac:	e8 cf f5 ff ff       	call   c0104a80 <thread_create>
c01054b1:	89 34 24             	mov    %esi,(%esp)
c01054b4:	89 c3                	mov    %eax,%ebx
c01054b6:	e8 b5 f7 ff ff       	call   c0104c70 <scheduler_enqueue>
c01054bb:	89 1c 24             	mov    %ebx,(%esp)
c01054be:	e8 ad f7 ff ff       	call   c0104c70 <scheduler_enqueue>
c01054c3:	c7 04 24 41 7c 10 c0 	movl   $0xc0107c41,(%esp)
c01054ca:	e8 11 e9 ff ff       	call   c0103de0 <ramfs_add_dir>
c01054cf:	83 c4 0c             	add    $0xc,%esp
c01054d2:	68 8c 15 00 00       	push   $0x158c
c01054d7:	57                   	push   %edi
c01054d8:	68 69 7c 10 c0       	push   $0xc0107c69
c01054dd:	e8 ee e6 ff ff       	call   c0103bd0 <ramfs_add_file>
c01054e2:	c7 04 24 46 7c 10 c0 	movl   $0xc0107c46,(%esp)
c01054e9:	e8 f2 f3 ff ff       	call   c01048e0 <process_create>
c01054ee:	5a                   	pop    %edx
c01054ef:	59                   	pop    %ecx
c01054f0:	68 e8 36 11 c0       	push   $0xc01136e8
c01054f5:	68 69 7c 10 c0       	push   $0xc0107c69
c01054fa:	a3 f4 36 11 c0       	mov    %eax,0xc01136f4
c01054ff:	e8 bc ed ff ff       	call   c01042c0 <exec_load>
c0105504:	83 c4 10             	add    $0x10,%esp
c0105507:	85 c0                	test   %eax,%eax
c0105509:	75 48                	jne    c0105553 <kernel_main+0x253>
c010550b:	50                   	push   %eax
c010550c:	6a 00                	push   $0x0
c010550e:	68 40 52 10 c0       	push   $0xc0105240
c0105513:	68 50 7c 10 c0       	push   $0xc0107c50
c0105518:	e8 63 f5 ff ff       	call   c0104a80 <thread_create>
c010551d:	8b 15 f4 36 11 c0    	mov    0xc01136f4,%edx
c0105523:	89 50 40             	mov    %edx,0x40(%eax)
c0105526:	89 04 24             	mov    %eax,(%esp)
c0105529:	e8 42 f7 ff ff       	call   c0104c70 <scheduler_enqueue>
c010552e:	83 c4 10             	add    $0x10,%esp
c0105531:	83 ec 0c             	sub    $0xc,%esp
c0105534:	68 7c a9 10 c0       	push   $0xc010a97c
c0105539:	e8 12 c5 ff ff       	call   c0101a50 <log_info>
c010553e:	fb                   	sti
c010553f:	83 c4 10             	add    $0x10,%esp
c0105542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c0105548:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
c010554f:	00 
c0105550:	f4                   	hlt
c0105551:	eb fd                	jmp    c0105550 <kernel_main+0x250>
c0105553:	83 ec 0c             	sub    $0xc,%esp
c0105556:	68 5a 7c 10 c0       	push   $0xc0107c5a
c010555b:	e8 50 c5 ff ff       	call   c0101ab0 <log_error>
c0105560:	83 c4 10             	add    $0x10,%esp
c0105563:	eb cc                	jmp    c0105531 <kernel_main+0x231>
c0105565:	83 ec 0c             	sub    $0xc,%esp
c0105568:	68 d0 a8 10 c0       	push   $0xc010a8d0
c010556d:	e8 de c4 ff ff       	call   c0101a50 <log_info>
c0105572:	83 c4 10             	add    $0x10,%esp
c0105575:	e9 cb fe ff ff       	jmp    c0105445 <kernel_main+0x145>
