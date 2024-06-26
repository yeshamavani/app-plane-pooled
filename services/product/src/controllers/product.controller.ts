import {
  Count,
  CountSchema,
  Filter,
  repository,
  Where,
} from '@loopback/repository';
import {
  post,
  param,
  get,
  getModelSchemaRef,
  requestBody,
  response,
} from '@loopback/rest';
import {Product} from '../models';
import {ProductRepository} from '../repositories';
import {authenticate, STRATEGY} from 'loopback4-authentication';
import {authorize} from 'loopback4-authorization';
import {
  CONTENT_TYPE,
  OPERATION_SECURITY_SPEC,
  STATUS_CODE,
} from '@sourceloop/core';

export class ProductController {
  constructor(
    @repository(ProductRepository)
    public productRepository: ProductRepository,
  ) {}

  @authenticate(STRATEGY.BEARER, {
    passReqToCallback: true,
  })
  @authorize({
    permissions: ['*'],
  })
  @post('/products', {
    security: OPERATION_SECURITY_SPEC,
    responses: {
      [STATUS_CODE.OK]: {
        description: 'Client model instance',
        content: {
          [CONTENT_TYPE.JSON]: {schema: getModelSchemaRef(Product)},
        },
      },
    },
  })
  @response(200, {
    description: 'Product model instance',
    content: {'application/json': {schema: getModelSchemaRef(Product)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Product, {
            title: 'NewProduct',
            exclude: ['id'],
          }),
        },
      },
    })
    product: Omit<Product, 'id'>,
  ): Promise<Product> {
    return this.productRepository.create(product);
  }

  @authenticate(STRATEGY.BEARER, {
    passReqToCallback: true,
  })
  @authorize({
    permissions: ['*'],
  })
  @get('/products/count', {
    security: OPERATION_SECURITY_SPEC,
    responses: {
      [STATUS_CODE.OK]: {
        description: 'TODO model count',
        content: {[CONTENT_TYPE.JSON]: {schema: CountSchema}},
      },
    },
  })
  @response(200, {
    description: 'Product model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(@param.where(Product) where?: Where<Product>): Promise<Count> {
    return this.productRepository.count(where);
  }

  @authenticate(STRATEGY.BEARER, {
    passReqToCallback: true,
  })
  @authorize({
    permissions: ['*'],
  })
  @get('/products', {
    security: OPERATION_SECURITY_SPEC,
    responses: {
      '200': {
        description: 'Array of Contract model instances',
        content: {
          'application/json': {
            schema: {
              type: 'array',
              items: getModelSchemaRef(Product, {includeRelations: true}),
            },
          },
        },
      },
    },
  })
  @response(200, {
    description: 'Array of Product model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(Product, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(Product) filter?: Filter<Product>,
  ): Promise<Product[]> {
    return this.productRepository.find(filter);
  }

  //   @authenticate(STRATEGY.BEARER, {
  //     passReqToCallback: true,
  //   })
  //   @authorize({
  //     permissions: ['*'],
  //   })
  //   @patch('/products')
  //   @response(200, {
  //     description: 'Product PATCH success count',
  //     content: {'application/json': {schema: CountSchema}},
  //   })
  //   async updateAll(
  //     @requestBody({
  //       content: {
  //         'application/json': {
  //           schema: getModelSchemaRef(Product, {partial: true}),
  //         },
  //       },
  //     })
  //     product: Product,
  //     @param.where(Product) where?: Where<Product>,
  //   ): Promise<Count> {
  //     return this.productRepository.updateAll(product, where);
  //   }

  //   @authenticate(STRATEGY.BEARER, {
  //     passReqToCallback: true,
  //   })
  //   @authorize({
  //     permissions: ['*'],
  //   })
  //   @get('/products/{id}')
  //   @response(200, {
  //     description: 'Product model instance',
  //     content: {
  //       'application/json': {
  //         schema: getModelSchemaRef(Product, {includeRelations: true}),
  //       },
  //     },
  //   })
  //   async findById(
  //     @param.path.string('id') id: string,
  //     @param.filter(Product, {exclude: 'where'})
  //     filter?: FilterExcludingWhere<Product>,
  //   ): Promise<Product> {
  //     return this.productRepository.findById(id, filter);
  //   }

  //   @authenticate(STRATEGY.BEARER, {
  //     passReqToCallback: true,
  //   })
  //   @authorize({
  //     permissions: ['*'],
  //   })
  //   @patch('/products/{id}')
  //   @response(204, {
  //     description: 'Product PATCH success',
  //   })
  //   async updateById(
  //     @param.path.string('id') id: string,
  //     @requestBody({
  //       content: {
  //         'application/json': {
  //           schema: getModelSchemaRef(Product, {partial: true}),
  //         },
  //       },
  //     })
  //     product: Product,
  //   ): Promise<void> {
  //     await this.productRepository.updateById(id, product);
  //   }

  //   @authenticate(STRATEGY.BEARER, {
  //     passReqToCallback: true,
  //   })
  //   @authorize({
  //     permissions: ['*'],
  //   })
  //   @put('/products/{id}')
  //   @response(204, {
  //     description: 'Product PUT success',
  //   })
  //   async replaceById(
  //     @param.path.string('id') id: string,
  //     @requestBody() product: Product,
  //   ): Promise<void> {
  //     await this.productRepository.replaceById(id, product);
  //   }

  //   @authenticate(STRATEGY.BEARER, {
  //     passReqToCallback: true,
  //   })
  //   @authorize({
  //     permissions: ['*'],
  //   })
  //   @del('/products/{id}')
  //   @response(204, {
  //     description: 'Product DELETE success',
  //   })
  //   async deleteById(@param.path.string('id') id: string): Promise<void> {
  //     await this.productRepository.deleteById(id);
  //   }
}
